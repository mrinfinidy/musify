import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musify/settings/settingsPage.dart';

class LibraryPage extends StatefulWidget {
    @override 
    State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State <LibraryPage> {
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
            body: Text('Library'),
        ); 
    }
}
