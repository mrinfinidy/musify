import 'package:flutter/material.dart';

class BottomNavigatoin {
    static Widget getBottomNavigation(int currentNavIndex,Function(void) setCurrentNav) {
        return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.my_library_music_outlined),
                    label: 'Library',
                ),
            ],
            currentIndex: currentNavIndex,
            onTap: setCurrentNav,
        );
    }
}
