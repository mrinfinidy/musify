import 'package:flutter/material.dart';

void main() {
    runApp( Musify() );
}

class Musify extends StatefulWidget {
    const Musify({ Key? key }) : super(key: key);

    @override
    State<Musify> createState() => _MusifyState();
}

class _MusifyState extends State<Musify> {

    String bodyText = 'Musify';

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: Scaffold(
                appBar: AppBar(
                    backgroundColor: Colors.green,
                    title: const Text('Musify'),
                ),
                body: Center(
                    child: Text(bodyText),
                ),
                bottomNavigationBar: BottomNavigationBar(
                    items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                            icon: Icon(Icons.home),
                            label: 'Home',

                        ),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.my_library_music_outlined),
                            label: 'Library',
                        )
                    ],
                    onTap: (tab) {
                        setState(() {
                            if (tab == 0) {
                                bodyText = 'Home';
                            } else {
                                bodyText = 'Library';
                            }
                        });
                    },
                ),
            ),
        );
    }
}
