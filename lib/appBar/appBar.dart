import 'package:flutter/material.dart';
import 'package:musify/pages/settings.dart';

class AppBarComponent {
    static getAppBarComponent(int currentPageIndex, Function(void) setCurrenPageIndex) {
        String _pageTitle = '';

        switch (currentPageIndex) {
            case 0:
                _pageTitle = 'Musify - Home';
                break;
            case 1:
                _pageTitle = 'Musify - Library';
                break;
            case 2:
                _pageTitle = 'Musify - Settings';
                break;
          default:
                _pageTitle = 'Musify';
        }

        return AppBar(
            backgroundColor: Colors.black,
            title: Center(
                child: Text(_pageTitle),
            ),
            actions: <Widget>[
                IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                        /*
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Settings()),
                        );
                        */
                        setCurrenPageIndex(2);
                    },
                ),
            ],
        );
    }
}
