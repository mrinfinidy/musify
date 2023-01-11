import 'package:flutter/material.dart';
import 'package:musify/bottomNavigation/bottomNavigation.dart';
import 'package:musify/pages/libraryPage.dart';
import 'package:musify/pages/musifyPage.dart';
import 'package:musify/pages/homePage.dart';

void main() {
    runApp( Musify() );
}

class Musify extends StatefulWidget {
    const Musify({ Key? key }) : super(key: key);

    @override
    State<Musify> createState() => _MusifyState();
}

class _MusifyState extends State<Musify> {
    final int _index = 0;

    final List<Widget> _body = [
        HomePage(),
        LibraryPage(),
        /*
        const MusifyPage(
            text: 'Tab2',
        ), 
        */
    ];

    final _homeNavigatorKey = GlobalKey<NavigatorState>();
    final _libraryNavigatorKey = GlobalKey<NavigatorState>();

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: Scaffold( 
                bottomNavigationBar: BottomNavigation(
                    items:[
                        BottomNavigationTab(
                            tab: _body[0],
                            icon: Icons.home,
                            title: 'Home',
                            navigatorKey: _homeNavigatorKey,
                        ),
                        BottomNavigationTab(
                            tab: _body[1], 
                            title: 'Library', 
                            icon: Icons.my_library_music_outlined,
                            navigatorKey: _libraryNavigatorKey,
                        )
                    ] 
                ),
            ),
        );
    }
}

