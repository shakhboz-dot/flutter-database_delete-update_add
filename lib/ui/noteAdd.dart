import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter44/database/database_helper.dart';
import 'package:flutter44/model/category.dart';
import 'package:flutter44/model/note.dart';
import 'package:flutter44/ui/home.dart';
import 'package:flutter44/ui/notePage.dart';

class NoteDetail extends StatefulWidget {
  String? title;
  NoteDetail({this.title, Key? key}) : super(key: key);

  @override
  _NoteDetailState createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  DataBaseHelper? dataBaseHelper;
  List<Category>? allCategories;
  var formKey = GlobalKey<FormState>();
  var categoryID;
  List _topList = ["Important", "Not important", "Very important"];
  var _topValue;
  String? noteTitle, noteContent;

  @override
  void initState() {
    super.initState();
    allCategories = <Category>[];
    dataBaseHelper = DataBaseHelper();
    dataBaseHelper!.kategoriyalarniOlibKel().then((mobileData) {
      for (var readData in mobileData) {
        allCategories!.add(Category.fromMap(readData));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          widget.title.toString(),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            Center(
              child: allCategories!.length <= 0
                  ? CupertinoActivityIndicator()
                  : DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text("Category"),
                        items: categoryList(),
                        value: categoryID,
                        onChanged: (selectedCategory) {
                          setState(() {
                            categoryID = selectedCategory;
                          });
                        },
                      ),
                    ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextFormField(
                validator: (text) {
                  if (text!.length < 4) {
                    return "Must be at least 4 sign";
                  }
                },
                onSaved: (text) {
                  noteTitle = text;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  hintText: "Input note title ",
                  labelText: "Title",
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextFormField(
                validator: (text) {
                  if (text!.length < 4) {
                    return "Must be at least 4 sign";
                  }
                },
                onSaved: (text) {
                  noteContent = text;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  hintText: "Input note content ",
                  labelText: "Content",
                ),
                maxLines: 3,
              ),
            ),
            Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: _topValue,
                  onChanged: (selectedTop) {
                    setState(() {
                      _topValue = selectedTop;
                    });
                  },
                  items: _topList.map((e) {
                    return DropdownMenuItem(
                      child: Text(e),
                      value: _topList.indexOf(e),
                    );
                  }).toList(),
                ),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate() &&
                        categoryID != null) {
                      formKey.currentState!.save();
                      dataBaseHelper!
                          .noteAdd(Note(categoryID, noteTitle, noteContent,
                              DateTime.now().toString(), _topValue))
                          .then((value) {
                        if (value != 0) {
                          print(noteTitle! + "\t" + noteContent.toString());
                          Navigator.of(context).pop();
                        }
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            title: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://www.freeiconspng.com/uploads/error-icon-33.png"),
                                  radius: 50.0,
                                  backgroundColor: Colors.white,
                                ),
                                SizedBox(height: 10.0),
                                Text("You have to SELECT category !!!"),
                                SizedBox(height: 10.0),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("OK"),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.green),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: Text(" Add "),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.greenAccent,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(" Cancel "),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<int>> categoryList() {
    return allCategories!.map((k) {
      return DropdownMenuItem(
        child: Text(k.categoryTitle.toString()),
        value: k.categoryID,
      );
    }).toList();
  }
}
