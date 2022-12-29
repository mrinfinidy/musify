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
    
    int _selectedTabIndex = 0;

    static const List<Widget> _widgetOptionsBody = <Widget>[
        Text(
            'Home'
        ),
        Text(
            'Library'
        ),
    ];

    void _onNavItemTapped(int tabIndex) {
        setState(() {
            _selectedTabIndex = tabIndex;
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
                    child: _widgetOptionsBody.elementAt(_selectedTabIndex),
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
                    currentIndex: _selectedTabIndex,
                    onTap: _onNavItemTapped,
                ),
            ),
        );
    }
}
