
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musify/Audio/AudioPlayerManager.dart';
import 'package:musify/settings/settingsPage.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
    @override
    State<HomePage> createState() => _HomePageState(); 
}

class _HomePageState extends State <HomePage> {
    FlutterBlue flutterBlue = FlutterBlue.instance;
    bool isPlaying = false;
    Color statusColor = Colors.black;
    AudioPlayerManager audioPlayerManager = AudioPlayerManager();
    // ESense
    String _deviceStatus = 'unknown';
    int _offsetX = 0;
    int _offsetY = 0;
    int _offsetZ = 0;
    double _voltage = -1;
    String _event = 'eSense sensor values';
    String _accel = 'unknown';
    String _gyro = 'unknown';
    bool sampling = false;
    bool eSenseConnected = false; // use for testing beacuse no earable hw

    static const String eSenseDeviceName = 'eSense-0678';
    ESenseManager eSenseManager = ESenseManager(eSenseDeviceName);

    @override
    void initState() {
        super.initState();
        _listenToESense();
    }

    Future<void> _askForPermissions() async {
        if (!(await Permission.bluetooth.request().isGranted)) {
            print('WARNING - No Bluetooth permission');
        }
        if (!(await Permission.locationWhenInUse.request().isGranted)) {
            print('WARNING - No location permission');
        }
    }

    Future<void> _listenToESense() async {
        if (Platform.isAndroid) await _askForPermissions();

        eSenseManager.connectionEvents.listen((event) {
            if (event.type == ConnectionType.connected) _listenToESenseEvents();

            setState(() {
                eSenseConnected = false;
                switch (event.type) {
                    case ConnectionType.connected:
                        _deviceStatus = 'connected';
                        eSenseConnected = true;
                        break;
                    case ConnectionType.unknown:
                        _deviceStatus = 'unknown';
                        break;
                    case ConnectionType.disconnected:
                        _deviceStatus = 'disconnected';
                        break;
                    case ConnectionType.device_found:
                        _deviceStatus = 'device_found';
                        break;
                    case ConnectionType.device_not_found:
                        _deviceStatus = 'device_not_found';
                        break;
                }
            });
        });
    }
    
    Future<void> _connectToEsense() async {     
        if (!eSenseConnected) {
            eSenseConnected = await eSenseManager.connect();
            setState(() {
                _deviceStatus = eSenseConnected ? 'connecting...' : 'connction failed';
            });
        }
    }

    void _listenToESenseEvents() async {
        eSenseManager.eSenseEvents.listen((event) {
            setState(() {
                switch (event.runtimeType) {
                    case BatteryRead:
                        _voltage = (event as BatteryRead).voltage ?? -1;
                        break;
                    case AccelerometerOffsetRead:
                        _offsetX = (event as AccelerometerOffsetRead).offsetX ?? 0;
                        _offsetY = (event as AccelerometerOffsetRead).offsetY ?? 0;
                        _offsetZ = (event as AccelerometerOffsetRead).offsetZ ?? 0;
                        break;
                }
            });
        });

        _getEsenseProperties();
    }

    //
    void _decreaseVolume5Sec() {
        audioPlayerManager.setVolume(0.2);
        Timer(
            const Duration(seconds: 5),
            () => audioPlayerManager.setVolume(1),
        );
    }

    void _getEsenseProperties() async {
        // Get battery level every 10 sec
        Timer.periodic(
            const Duration(seconds: 10), 
            (timer) async => (eSenseConnected) ? await eSenseManager.getBatteryVoltage() : null,
        );

        // Wait 2 sec before getting offset -> BLE interface compatability
        Timer(
            const Duration(seconds: 2),
            () async => await eSenseManager.getAccelerometerOffset()
        );
    }

    StreamSubscription? subscription;
    void _startListenToSensorEvents() async {
        await eSenseManager.setSamplingRate(10);

        subscription = eSenseManager.sensorEvents.listen((event) {
            setState(() {
                // _event = event.toString();
                _accel = event.accel.toString();
                _gyro = event.gyro.toString();
                if ((event.gyro![0] > 1000 || event.gyro![0] < -1000) && event.accel![1] < 10000 ) {
                    _decreaseVolume5Sec();
                }
            });
        });
        setState(() {
            sampling = true;
        }); 
    }

    void _pauseListenToSensorEvents() async {
        subscription?.cancel();
        setState(() {
            sampling = false;
        });
    }

    Future<void> _disconnectFromEsense() async {
        await eSenseManager.disconnect();
    }
    
    @override
    void dispose() {
        _pauseListenToSensorEvents();
        eSenseManager.disconnect();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Center(
                    child: const Text('Musify - Home'),
                ),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                actions: <Widget>[
                    IconButton(
                        onPressed: (() => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => SettingsPage(text: 'Settings page',))
                        )),
                        icon: Icon(Icons.settings),
                    ),
                ],
            ),
            body: Center( 
                child:
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                            Column(
                                children: <Widget>[
                                    Text('eSense Device Status: $_deviceStatus'),
                                    Text('eSense Battery Level: $_voltage'),
                                    // Text(_event),
                                    Text('Accelerometer: $_accel'),
                                    Text('Gyroscope: $_gyro'),
                                    const SizedBox(height: 10),
                                    CircleAvatar(
                                        radius: 20,
                                        backgroundColor: eSenseConnected ? Colors.pink : Colors.black,
                                        child: IconButton(
                                            icon: const Icon(Icons.bluetooth_outlined),
                                            color: eSenseConnected ? Colors.black : Colors.white,
                                            // color: Colors.pink,
                                            onPressed: () async {
                                                if (await flutterBlue.isOn && await Permission.locationWhenInUse.serviceStatus.isEnabled) {
                                                    eSenseConnected ? _disconnectFromEsense() : _connectToEsense();
                                                } else {
                                                    showDialog(
                                                        context: context,
                                                        barrierDismissible: false,
                                                        builder: (BuildContext context) {
                                                            return AlertDialog(
                                                                title: const Text('Bluetooth and GPS'),
                                                                content: const SingleChildScrollView(
                                                                    child: Text('Please enable Bluetooth and Location service (GPS) to connect to eSense'),  
                                                                ),
                                                                actions: <Widget>[
                                                                    TextButton(
                                                                        child: const Text('Ok'),
                                                                        onPressed: () {
                                                                            Navigator.of(context).pop();
                                                                        },
                                                                        style: TextButton.styleFrom(foregroundColor: Colors.black),
                                                                    ),
                                                                ],
                                                            );
                                                        }
                                                    );
                                                }
                                            },
                                            splashColor: Colors.pink,
                                        ), 
                                    ),
                                    const SizedBox(height: 10),
                                    FloatingActionButton.extended(
                                        onPressed: (!eSenseManager.connected)
                                            ? null
                                            : (!sampling)
                                                ? _startListenToSensorEvents
                                                : _pauseListenToSensorEvents,
                                        // onPressed: sensorControl,
                                        tooltip: 'Listen to eSense sensors',
                                        icon: (!sampling) ? const Icon(Icons.play_arrow) : const Icon(Icons.pause),
                                        label: (!sampling) ? const Text('Start Sensors') : const Text('Stop Sensors'),
                                        backgroundColor: (!sampling) ? Colors.black : Colors.pink,
                                        foregroundColor: (!sampling) ? Colors.white : Colors.black,
                                        splashColor: Colors.pink,
                                    ),
                                ],
                            ), 
                            CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.black,
                                child: IconButton(
                                    icon: Icon(
                                        isPlaying ? Icons.pause_circle : Icons.play_circle, 
                                    ),
                                    iconSize: 50,
                                    color: isPlaying ? Colors.pink : Colors.white,
                                    splashColor: Colors.pink,
                                    onPressed: () async {
                                        if (isPlaying) {
                                            audioPlayerManager.pauseAudioPlayer();
                                            setState(() {
                                                isPlaying = false;
                                            });
                                        } else {
                                            if (audioPlayerManager.getAudioSource() == null) {
                                                audioPlayerManager.setAudioSource();                      
                                            }
                                            audioPlayerManager.playAudioPlayer();
                                            setState(() {
                                                isPlaying = true;
                                            });
                                        }
                                    },
                                ),
                            ),                      
                        ],
                ),
            ),
        );
    }
}
