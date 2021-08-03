import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter44/database/database_helper.dart';
import 'package:flutter44/model/note.dart';

class IndexNote extends StatefulWidget {
  int? index;
  String? categoryTitle;

  IndexNote(this.index, this.categoryTitle);
  @override
  State<StatefulWidget> createState() {
    return IndexNoteState();
  }
}

class IndexNoteState extends State<IndexNote> {
  DataBaseHelper? dataBaseHelper;
  List<Note>? allNotes;
  List<Note>? selectedNotes;
  int? lengthNotes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allNotes = <Note>[];
    selectedNotes = <Note>[];
    dataBaseHelper = DataBaseHelper();
    dataBaseHelper!.noteniOlibKel().then((value) {
      for (var item in value) {
        allNotes!.add(Note.fromMap(item));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < allNotes!.length; i++) {
      if (widget.index == allNotes![i].categoryID) {
        selectedNotes!.add(allNotes![i]);
        lengthNotes = selectedNotes!.length;
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryTitle!),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: lengthNotes == null
          ? Center(
              child: Text("You don't have Notes"),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          child:
                              Text(selectedNotes![index].categoryID.toString()),
                          radius: 20,
                        ),
                        SizedBox(height: 10.0),
                        Text(selectedNotes![index].noteTitle!),
                        SizedBox(height: 5.0),
                        Text(selectedNotes![index].noteContent!),
                        SizedBox(height: 5.0),
                        Text(selectedNotes![index].noteDate!),
                      ],
                    ),
                  ),
                );
              },
              itemCount: lengthNotes,
            ),
    );
  }

  // Widget _notesFunc(BuildContext context) {
  //   return
  // }
}
