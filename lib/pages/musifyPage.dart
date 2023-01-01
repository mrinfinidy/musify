import 'package:flutter/material.dart';
import 'package:musify/settings/settingsPage.dart';

class MusifyPage extends StatefulWidget {
    final String text;
    const MusifyPage({super.key, required this.text});

    @override
    State<MusifyPage> createState() => _MusifyState();
}

class _MusifyState extends State<MusifyPage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Center(
                    child: const Text('Musify'),
                ),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                actions: <Widget>[
                    IconButton(
                        onPressed: (() => Navigator.push(context, 
                                MaterialPageRoute(builder: (_) => SettingsPage(text: widget.text))
                            )
                        ),
                        icon: Icon(Icons.settings),
                    )   
                ],
            ),
            body: Center(
                child: TextButton(
                    onPressed: (() => Navigator.push(context, 
                        MaterialPageRoute(builder: (_) => HomeTab(
                            text: widget.text
                        )),
                    )),
                    child: Text(
                        widget.text,
                    ),
                ),
            ),
        );
    }
}

class HomeTab extends StatefulWidget {
    final String text;
    const HomeTab({super.key, required this.text});

    @override
    State<HomeTab> createState() => _HomeTabeState();
}

class _HomeTabeState extends State<HomeTab> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Musify'),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
            ),
            body: Center(
                child: Text('Inside' + widget.text),
            ),
        );
    }
}
