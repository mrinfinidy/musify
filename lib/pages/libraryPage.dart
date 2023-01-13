import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musify/Audio/AudioPlayerManager.dart';
import 'package:musify/pages/homePage.dart';
import 'package:musify/settings/settingsPage.dart';

class LibraryPage extends StatefulWidget {
    @override 
    State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State <LibraryPage> {
    final FlutterAudioQuery audioQuery = FlutterAudioQuery();
    List<SongInfo> songs = [];
    final AudioPlayerManager audioPlayerManager = AudioPlayerManager();

    Future<void> getSongs() async {
        songs = await audioQuery.getSongs();
    }

    @override
    void initState() {
        getSongs().then((_) {
            setState(() {
              
            });
        });
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Center(
                    child: const Text('Musify - Library'),
                ),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                actions: <Widget>[
                    IconButton(
                        onPressed: (() => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => SettingsPage(text: 'Settings page',))
                        )),
                        icon: const Icon(Icons.settings),
                    )
                ],
            ),
            body: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        iconColor: Colors.black,
                        textColor: Colors.black,
                        leading: const Icon(Icons.music_note),
                        trailing: const Icon(Icons.play_arrow),
                        title: Text(songs[index].title),
                        onTap: () {
                            audioPlayerManager.playAudio(index);
                        },
                    );
                },
            ),
        ); 
    }
}
