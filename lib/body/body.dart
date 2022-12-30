import 'package:flutter/widgets.dart';
import 'home.dart';
import 'library.dart';

class BodyComponent {
    static Widget getBodyWidget(selectedPageIndex) {
        List<Widget> widgetOptions = <Widget>[
            HomeWidget.getHomeWidget(),
            LibraryWidget.getLibraryWidget(),
            const Text('Settings'),
        ];

        return widgetOptions.elementAt(selectedPageIndex);
    }
}
