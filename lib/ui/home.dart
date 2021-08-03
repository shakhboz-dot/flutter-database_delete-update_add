import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter44/database/database_helper.dart';
import 'package:flutter44/model/category.dart';
import 'package:flutter44/model/note.dart';
import 'package:flutter44/ui/notePage.dart';
import 'indexNote.dart';
import 'noteAdd.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  var formKey = GlobalKey<FormState>();
  var formKeyListTile = GlobalKey<FormState>();
  String? title;
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  List<Category>? allCategory;
  String? categoryTitle;

  @override
  void initState() {
    super.initState();
    allCategory = <Category>[];
    dataBaseHelper.kategoriyalarniOlibKel().then((value) {
      for (var item in value) {
        allCategory!.add(Category.fromMap(item));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Category",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NotePage()),
              );
            },
            icon: Icon(
              Icons.arrow_forward,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: categories(context),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add category",
        onPressed: categoryAddFunc,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  categoryAddFunc() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("To add category"),
            children: [
              Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Input new category...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  validator: (validating) {
                    if (validating!.length < 4) {
                      return "Must be at least 4 sign!!!";
                    }
                  },
                  onSaved: (saving) {
                    setState(() {
                      title = saving;
                    });
                  },
                ),
              ),
              ButtonBar(
                children: [
                  ElevatedButton(
                    child: Text("Cancel"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  ElevatedButton(
                    child: Text("Add data"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightGreenAccent,
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        dataBaseHelper
                            .categoryAdd(Category(title))
                            .then((ctgID) {
                          if (ctgID > 0) {
                            print("Added category ID : $ctgID");
                          }
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Added category : $title"),
                          ),
                        );
                        Navigator.of(context).pop();
                        print("Android database : " +
                            dataBaseHelper.kategoriyalarniOlibKel().toString());
                      }
                    },
                  ),
                ],
              ),
            ],
          );
        }).then((value) {
      allCategory!.clear();
      dataBaseHelper.kategoriyalarniOlibKel().then((value) {
        for (var item in value) {
          allCategory!.add(Category.fromMap(item));
        }
        setState(() {});
      });
    });
  }

  categories(BuildContext context) {
    return allCategory!.length <= 0
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
                          title: Text("Your Categories"),
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
                                        categoryTitle = text;
                                      },
                                      initialValue:
                                          allCategory![index].categoryTitle,
                                      decoration: InputDecoration(
                                        labelText: "Title",
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
                                                .categoryUpdate(
                                              Category.withID(
                                                allCategory![index].categoryID,
                                                categoryTitle,
                                              ),
                                            )
                                                .then((value) {
                                              if (value != 0) {
                                                print(
                                                    "Category update ishladi --->" +
                                                        allCategory.toString());
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
                                                .categoryDelete(
                                                    allCategory![index]
                                                        .categoryID!)
                                                .then((value) {
                                              print(
                                                  "Category delete ishladi ---->" +
                                                      allCategory.toString());
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
                    allCategory!.clear();
                    dataBaseHelper.kategoriyalarniOlibKel().then((value) {
                      for (var item in value) {
                        allCategory!.add(Category.fromMap(item));
                      }
                      setState(() {});
                    });
                  });
                },
                title: Text(allCategory![index].categoryTitle.toString()),
                subtitle: Text(allCategory![index].categoryTitle.toString()),
                leading: CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Text(allCategory![index].categoryID.toString()),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => IndexNote(
                            allCategory![index].categoryID,
                            allCategory![index].categoryTitle),
                      ),
                    );
                  },
                  icon: Icon(Icons.arrow_forward_ios),
                ),
              );
            },
            itemCount: allCategory!.length,
          );
  }
}
