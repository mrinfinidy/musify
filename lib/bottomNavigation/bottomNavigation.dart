import 'package:flutter/material.dart';

// Persistent bottom navigation bar that is always visible
class BottomNavigation extends StatefulWidget {
    final List<BottomNavigationTab> items;

    const BottomNavigation({
        Key? key,
        required this.items
    }) : super(key: key);

    @override
    _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
    int _selectedTab = 0;

    @override
    Widget build(BuildContext context) {
        return WillPopScope(
            onWillPop: () async {
                if (widget.items[_selectedTab].navigatorKey?.currentState?.canPop() ?? false) {
                    widget.items[_selectedTab].navigatorKey?.currentState?.pop();
                    return false;
                } else {
                    return true;
                }
            },
            child: Scaffold(
                body: IndexedStack(
                    index: _selectedTab,
                    children: widget.items.map((page) => Navigator(
                        key: page.navigatorKey,
                        onGenerateInitialRoutes: ((navigator, initialRoute) {
                            return [ MaterialPageRoute(builder: (context) => page.tab) ];
                        }),
                    )).toList(),
                ), 
                bottomNavigationBar: BottomNavigationBar(
                    backgroundColor: Colors.black,
                    currentIndex: _selectedTab,
                    onTap: (tabIndex) {
                        if (tabIndex != _selectedTab) {
                            setState(() {
                                _selectedTab = tabIndex;
                            });
                        }
                        // Always return to root when bottom nav is tapped
                        widget.items[tabIndex].navigatorKey?.currentState?.popUntil((route) => route.isFirst);
                    },
                    selectedItemColor: Colors.pink,
                    unselectedItemColor: Colors.white,
                    items: widget.items.map((bottomNavItem) => BottomNavigationBarItem(
                        icon: Icon(bottomNavItem.icon),
                        label: bottomNavItem.title,
                    )).toList(),
                ),
            ),
        );
    }
}

class BottomNavigationTab {
    final Widget tab;
    final GlobalKey<NavigatorState>? navigatorKey;
    final String title;
    final IconData icon;

    BottomNavigationTab({
        required this.tab,
        this.navigatorKey,
        required this.title,
        required this.icon,
    });
}
