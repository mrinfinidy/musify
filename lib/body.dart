import 'package:flutter/widgets.dart';

class BodyComponent {
    static Widget getBodyWidget(selectedTabIndex) {
        List<Widget> widgetOptions = <Widget>[
            const Text('Home'),
            const Text('Library'),
        ];

        return widgetOptions.elementAt(selectedTabIndex);
    }
}
