import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:musify/settings/settingsPage.dart';

class LibraryPage extends StatefulWidget {
    @override 
    State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State <LibraryPage> {
    final FlutterAudioQuery audioQuery = FlutterAudioQuery();
    List<SongInfo> songs = [];

    void getSongs() async {
        songs = await audioQuery.getSongs();
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
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                        FloatingActionButton.extended(
                            onPressed: () {
                                setState(() {
                                    getSongs();
                                });
                            },
                            icon: Icon(Icons.music_note),
                            label: Text('Load songs from device storage'), 
                        ), 
                        Text(songs.toString()),
                    ], 
                ),
            ),
        ); 
    }
}
