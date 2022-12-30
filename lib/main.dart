import 'package:flutter/material.dart';
import 'body/body.dart';

void main() {
    runApp( const Musify() );
}

class Musify extends StatefulWidget {
    const Musify({ Key? key }) : super(key: key);

    @override
    State<Musify> createState() => _MusifyState();
}

class _MusifyState extends State<Musify> {
    int selectedPageIndex = 0;
    int _selectedTabIndex = 0;

    void _onNavItemTapped(int tabIndex) {
        setState(() {
            _selectedTabIndex = tabIndex;
            selectedPageIndex = _selectedTabIndex;
        });
    }

    void _onSettingsTapped(int pageIndex) {
        setState(() {
            selectedPageIndex = pageIndex;
        });
    }

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: Scaffold(
                appBar: AppBar(
                    backgroundColor: Colors.green,
                    title: Center(
                        child: const Text('Musify')
                    ),
                    actions: <Widget>[
                        IconButton(
                            icon: const Icon(Icons.settings),
                            onPressed: () {
                                _onSettingsTapped(2);
                            },
                        ),
                    ],
                ),
                body: Center(
                    child: BodyComponent.getBodyWidget(selectedPageIndex),
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
