import 'package:flutter/material.dart';

class BottomNavigation {
    static BottomNavigationBar getBottomNavigation(int currentNavIndex,Function(void) setCurrentNavIndex) {
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
            onTap: setCurrentNavIndex,
        );
    }
}
