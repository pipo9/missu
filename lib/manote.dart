
class Note {

  int _id;
  String _title;
  String _text;
  String _date;
  String _image;


  Note(this._id,this._title, this._date,this._image,[this._text]);

  Note.withId(this._id, this._title, this._date,this._image, [this._text]);

  int get id => _id;

  String get image => _image;

  String get title => _title;

  String get text => _text;


  String get date => _date;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set text(String newDescription) {
    if (newDescription.length <= 255) {
      this._text = newDescription;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }
  set image(String newimage) {
    this._image = newimage;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _text;
    map['date'] = _date;
    map['image'] = _image;

    return map;
  }

  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._text = map['description'];
    this._date = map['date'];
    this._image = map['image'];
  }
}