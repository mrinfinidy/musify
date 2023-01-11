
import 'dart:async';
import 'dart:io';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musify/settings/settingsPage.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
    @override
    State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State <HomePage> {
    bool isPlaying = false;
    Color statusColor = Colors.black;
    final audioPlayer = AudioPlayer();
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
        audioPlayer.setLoopMode(LoopMode.all);
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
            print('connect CONNECTION event: $event');
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
            print('connecting');
            eSenseConnected = await eSenseManager.connect();
            setState(() {
                _deviceStatus = eSenseConnected ? 'connecting...' : 'connction failed';
            });
        }
    }

    void _listenToESenseEvents() async {
        eSenseManager.eSenseEvents.listen((event) {
            print('listen ESENSE event: $event');
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
        audioPlayer.setVolume(0.2);
        Timer(
            const Duration(seconds: 5),
            () => audioPlayer.setVolume(1),
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
        print('setting sampling frequency');
        await eSenseManager.setSamplingRate(10);

        subscription = eSenseManager.sensorEvents.listen((event) {
            print('subscribe SENSOR event: $event');
            setState(() {
                // _event = event.toString();
                _accel = event.accel.toString();
                _gyro = event.gyro.toString();
                if (event.gyro![1] > 2200 || event.gyro![1] < -2200) {
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

    setAudioSource() async {
        await audioPlayer.setUrl('https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_500KB_MP3.mp3');
    }
    
    @override
    void dispose() {
        audioPlayer.dispose();
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
                                    IconButton(
                                        icon: const Icon(Icons.bluetooth_outlined),
                                        // color: statusColor,
                                        color: eSenseConnected ? Colors.pink : Colors.black,
                                        onPressed: () {
                                            eSenseConnected ? _disconnectFromEsense() : _connectToEsense();
                                        },
                                        splashColor: Colors.pink,
                                    ), 
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
                                    color: Colors.pink,
                                    splashColor: Colors.pink,
                                    onPressed: () async {
                                        if (isPlaying) {
                                            audioPlayer.pause();
                                            setState(() {
                                                isPlaying = false;
                                            });
                                        } else {
                                            if (audioPlayer.audioSource == null) {
                                                setAudioSource();
                                            } 
                                            audioPlayer.play();
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
