import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingsPage extends StatefulWidget {
    final String text;

    const SettingsPage({super.key, required this.text});

    @override
    State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Musify - Settings'),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
            ),
            body: Center(
                child: Text('Settings' + widget.text),
            ),
        );
    }
}
