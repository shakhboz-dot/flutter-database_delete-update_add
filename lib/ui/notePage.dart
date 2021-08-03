import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter44/database/database_helper.dart';
import 'package:flutter44/model/note.dart';
import 'package:flutter44/ui/noteAdd.dart';

class NotePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotePageState();
  }
}

class NotePageState extends State<NotePage> {
  var formKey = GlobalKey<FormState>();
  var formKeyListTile = GlobalKey<FormState>();
  String? title;
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  List<Note>? allNotes;
  String? noteTitle, noteContent;

  @override
  void initState() {
    super.initState();
    allNotes = <Note>[];
    dataBaseHelper.noteniOlibKel().then((value) {
      for (var item in value) {
        allNotes!.add(Note.fromMap(item));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Notes",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: notes(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openNoteDetailPage(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  notes(BuildContext context) {
    return allNotes!.length <= 0
        ? Center(
            child: CupertinoActivityIndicator(
            radius: 15.0,
          ))
        : ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          title: Text("Your Notes"),
                          children: [
                            Form(
                              key: formKeyListTile,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: TextFormField(
                                      validator: (text) {
                                        if (text!.length < 4) {
                                          return "Must be at least 4 sign";
                                        }
                                      },
                                      onSaved: (text) {
                                        noteTitle = text;
                                      },
                                      initialValue: allNotes![index].noteTitle,
                                      decoration: InputDecoration(
                                        labelText: "Title",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: TextFormField(
                                      validator: (text) {
                                        if (text!.length < 4) {
                                          return "Must be at least 4 sign";
                                        }
                                      },
                                      onSaved: (text) {
                                        noteContent = text;
                                      },
                                      initialValue:
                                          allNotes![index].noteContent,
                                      decoration: InputDecoration(
                                        labelText: "Context",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ButtonBar(
                                    alignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          if (formKeyListTile.currentState!
                                              .validate()) {
                                            formKeyListTile.currentState!
                                                .save();
                                            dataBaseHelper
                                                .noteUpdate(Note.withID(
                                                    allNotes![index].noteID,
                                                    allNotes![index].categoryID,
                                                    noteTitle,
                                                    noteContent,
                                                    allNotes![index].noteDate,
                                                    allNotes![index].noteTop))
                                                .then((value) {
                                              if (value != 0) {
                                                print(allNotes);
                                                Navigator.pop(context);
                                              }
                                            });
                                          }
                                        },
                                        child: Text("Update"),
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.greenAccent),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            dataBaseHelper
                                                .noteDelete(
                                                    allNotes![index].noteID!)
                                                .then((value) {
                                              print(allNotes);
                                              Navigator.pop(context);
                                            });
                                          });
                                        },
                                        child: Text("Delete"),
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.redAccent),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Cancel"),
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.amberAccent),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      }).then((value) {
                    allNotes!.clear();
                    dataBaseHelper.noteniOlibKel().then((value) {
                      for (var item in value) {
                        allNotes!.add(Note.fromMap(item));
                      }
                      setState(() {});
                    });
                  });
                },
                title: Text(allNotes![index].noteTitle.toString()),
                subtitle: Text(allNotes![index].noteDate.toString()),
                leading: CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Text(allNotes![index].noteID.toString()),
                ),
                trailing: Text(allNotes![index].categoryID.toString()),
              );
            },
            itemCount: allNotes!.length,
          );
  }

  _openNoteDetailPage(BuildContext context) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => NoteDetail(title: "Note Page"),
      ),
    )
        .then((value) {
      allNotes!.clear();
      dataBaseHelper.noteniOlibKel().then((value) {
        for (var item in value) {
          allNotes!.add(Note.fromMap(item));
        }
        setState(() {});
      });
    });
  }
}
