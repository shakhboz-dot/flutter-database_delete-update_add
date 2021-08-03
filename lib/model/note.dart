class Note {
  int? noteID;
  int? categoryID;
  String? noteTitle;
  String? noteContent;
  String? noteDate;
  int? noteTop;

  Note(this.categoryID, this.noteTitle, this.noteContent, this.noteDate,
      this.noteTop);
  Note.withID(this.noteID, this.categoryID, this.noteTitle, this.noteContent,
      this.noteDate, this.noteTop);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['noteID'] = noteID;
    map['categoryID'] = categoryID;
    map['noteTitle'] = noteTitle;
    map['noteContent'] = noteContent;
    map['noteDate'] = noteDate;
    map['noteTop'] = noteTop;
    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    this.noteID = map['noteID'];
    this.categoryID = map['categoryID'];
    this.noteTitle = map['noteTitle'];
    this.noteContent = map['noteContent'];
    this.noteDate = map['noteDate'];
    this.noteTop = map['noteTop'];
  }

  @override
  String toString() {
    return "${this.noteID},${this.categoryID}, ${this.noteTitle},${this.noteContent}, ${this.noteDate}, ${this.noteTop}";
  }
}
