import 'package:flutter/material.dart';
import 'package:musify/settings/settingsPage.dart';

class HomePage extends StatefulWidget {
    @override
    State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State <HomePage> {
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
                child: Text('home'),
            ),
        );
    }
}
