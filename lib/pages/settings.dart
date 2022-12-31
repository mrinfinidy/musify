import 'package:flutter/material.dart';
import 'package:musify/appBar/appBar.dart';
import 'package:musify/bottomNavigation/bottomNavigation.dart';

class Settings {
    static Widget getSettings() {
        return ListView(
            children: <Widget>[
                ListTile(
                     title: Text('item 1'), 
                ),
                ListTile( 
                    title: Text('item 2'), 
                ),
                ListTile( 
                    title: Text('item 3'), 
                ),
             ],
        );
    }
}
