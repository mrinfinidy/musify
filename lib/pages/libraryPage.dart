import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:musify/settings/settingsPage.dart';
import 'package:path_provider_ex/path_provider_ex.dart';

class LibraryPage extends StatefulWidget {
    @override 
    State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State <LibraryPage> {
    var files;

    void _getFiles() async {
        List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
        var root = storageInfo[0].rootDir; // Get root directory, use storageInfo[1] for SD
        var fileManager = FileManager(root: Directory(root));
        files = await fileManager.filesTree(
            //excludedPaths: ["/storage/emulated/0/Android"],
            extensions: ["mp3"]
        );
        setState(() {}); // Update UI
    }

    @override
    void initState() {
        _getFiles();
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Center(
                    child: const Text('Musify - Library'),
                ),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                actions: <Widget>[
                    IconButton(
                        onPressed: (() => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => SettingsPage(text: 'Settings page',))
                        )),
                        icon: const Icon(Icons.settings),
                    )
                ],
            ),
            body: files == null? const Text('Searching Files...') :
                ListView.builder(
                    itemCount: files?.length ?? 0,
                    itemBuilder: ((context, index) {
                        return Card(
                            child: ListTile(
                                title: Text(files[index].path.split('/').last),
                                leading: const Icon(Icons.audiotrack_outlined),
                                trailing: const Icon(Icons.play_arrow),
                                onTap: () {
                                     
                                },
                            ),
                        );
                    })
                ), 
        ); 
    }
}
