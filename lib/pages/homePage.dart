
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
    final audioPlayer = AudioPlayer();
    bool earableConnected = false; // use for testing beacuse no earable hw
    Color statusColor = Colors.black;

    static const String eSenseDeviceName = 'eSense-0678';
    ESenseManager eSenseManager = ESenseManager(eSenseDeviceName);

    /*
    Future<void> _askForPermissions() async {
        if (!(await Permission.bluetooth.request().isGranted)) {
            print('WARNING - No Bluetooth permission');
        }
        if (!(await Permission.locationWhenInUse.request().isGranted)) {
            print('WARNING - No location permission');
        }
    }
    */
    
    Future<void> _connectToEsense() async {     
        // await _askForPermissions();
        await eSenseManager.disconnect();
        await eSenseManager.connect();
        // use for testing
        /*
        setState(() {
            earableConnected = !earableConnected; 
        });
        */
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
                                    StreamBuilder<ConnectionEvent>(
                                        stream: eSenseManager.connectionEvents,
                                        builder: ((context, snapshot) {
                                            if (snapshot.hasData) {
                                                switch (snapshot.data!.type) {
                                                    case ConnectionType.connected:
                                                        return const Text('connected');
                                                        break;
                                                    case ConnectionType.device_found:
                                                        return const Text('device found');
                                                        break;
                                                    case ConnectionType.device_not_found:
                                                        return const Text('device not found');
                                                        break;
                                                    case ConnectionType.disconnected:
                                                        return const Text('disconnected');
                                                        break;
                                                    default:
                                                        return const Text('unknown');
                                                }
                                            } else { 
                                                return const Text('no data');
                                                // use for testing
                                                // return earableConnected ? Text('connected') : Text('disconnected');
                                            }
                                        })
                                    ),
                                    // Text(earableConnected ? 'connected' : 'disconnected'),
                                    IconButton(
                                        icon: Icon(Icons.bluetooth_outlined),
                                        // color: statusColor,
                                        color: earableConnected ? Colors.pink : Colors.black,
                                        onPressed: () {

                                            _connectToEsense();
                                        },
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
