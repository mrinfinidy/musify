import 'package:flutter/material.dart';

import 'pages/pages.dart';
import 'pages/pageTitle.dart';
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
    // Use for any page change
    void setCurrentPage(pageIndex) {
        setState(() {
            currentPageIndex = pageIndex;
            pageTitle = PageTitle.getPageTitle(currentPageIndex); 
        });
    }

    // Only use for bottom navigation page change
    void setCurrentNav(navIndex) {
        setState(() {
            currentNavIndex = navIndex;
            currentPageIndex = currentNavIndex;
            pageTitle = PageTitle.getPageTitle(currentPageIndex);
        });
    }

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: Scaffold(
                appBar: AppBar(
                    backgroundColor: Colors.black,
                    title: Center(
                        child: Text(pageTitle),
                    ),
                    actions: <Widget>[
                        IconButton(
                            icon: Icon(Icons.settings),
                            onPressed: () {
                                setCurrentPage(2);
                            },
                        ),
                    ], 
                ),
                body: PageComponent.getPageComponent(currentPageIndex),
                bottomNavigationBar: BottomNavigatoin.getBottomNavigation(currentNavIndex, setCurrentNav),
            ),
        );
    }
}
