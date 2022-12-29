import 'package:flutter/material.dart';
import 'body.dart';

void main() {
    runApp( Musify() );
}

class Musify extends StatefulWidget {
    const Musify({ Key? key }) : super(key: key);

    @override
    State<Musify> createState() => _MusifyState();
}

class _MusifyState extends State<Musify> {
    int selectedTabIndex = 0;

    void _onNavItemTapped(int tabIndex) {
        setState(() {
            selectedTabIndex = tabIndex;
        });
    }

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: Scaffold(
                appBar: AppBar(
                    backgroundColor: Colors.green,
                    title: const Text('Musify'),
                ),
                body: Center(
                    child: BodyComponent.getBodyWidget(selectedTabIndex),
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
                    currentIndex: selectedTabIndex,
                    onTap: _onNavItemTapped,
                ),
            ),
        );
    }
}
