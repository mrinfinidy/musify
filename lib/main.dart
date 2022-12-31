import 'package:flutter/material.dart';

import 'pages/pages.dart';
import 'appBar/appBar.dart';
import 'bottomNavigation/bottomNavigation.dart';


void main() {
    runApp( const Musify() );
}

class Musify extends StatefulWidget {
    const Musify({ Key? key }) : super(key: key);

    @override
    State<Musify> createState() => _MusifyState();
}

class _MusifyState extends State<Musify> {
    int currentPageIndex = 0;
    int currentNavIndex = 0;
    String pageTitle = 'Musify - Home';

    void setCurrentNavIndex(navIndex) {
        setState(() {
            currentNavIndex = navIndex;
            currentPageIndex = currentNavIndex;
        });
    }

    void setCurrentPageIndex(pageIndex) {
        setState(() {
            currentPageIndex = pageIndex;
        });
    }


    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: Builder(
                builder: (context) => Scaffold(
                    appBar: AppBarComponent.getAppBarComponent(currentPageIndex, setCurrentPageIndex),
                    body: PageComponent.getPageComponent(currentPageIndex),
                    bottomNavigationBar: BottomNavigation.getBottomNavigation(currentNavIndex, setCurrentNavIndex),
                ),
            ),
        );
    }
}

