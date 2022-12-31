import 'package:flutter/widgets.dart';
import 'home.dart';
import 'library.dart';
import 'settings.dart';

class PageComponent {
    static Widget getPageComponent(selectedPageIndex) {
        List<Widget> widgetOptions = <Widget>[
            HomeWidget.getHomeWidget(),
            LibraryWidget.getLibraryWidget(),
            Settings.getSettings(),
        ];

        return widgetOptions.elementAt(selectedPageIndex);
    }
}
