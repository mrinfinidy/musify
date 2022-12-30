import 'package:flutter/widgets.dart';

class BodyComponent {
    static Widget getBodyWidget(selectedPageIndex) {
        List<Widget> widgetOptions = <Widget>[
            const Text('Home'),
            const Text('Library'),
            const Text('Settings'),
        ];

        return widgetOptions.elementAt(selectedPageIndex);
    }
}
