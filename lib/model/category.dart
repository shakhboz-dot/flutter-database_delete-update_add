class Category {
  int? categoryID;
  String? categoryTitle;

  Category(this.categoryTitle);

  Category.withID(this.categoryID, this.categoryTitle);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['categoryID'] = categoryID;
    map['categoryTitle'] = categoryTitle;
    return map;
  }

  Category.fromMap(Map<String, dynamic> map) {
    categoryID = map['categoryID'];
    categoryTitle = map['categoryTitle'];
  }

  @override
  String toString() {
    return "Category : -----> categoryID : $categoryID, categoryTitle : $categoryTitle";
  }
}
