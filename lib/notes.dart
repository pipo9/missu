import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:missu/notespage.dart';
import 'manote.dart';
import 'package:image_picker/image_picker.dart';
import 'utils/database_helper.dart';

class Notes extends StatefulWidget {
  Notes({this.note});
  final Note note;
  @override
  _NotesState createState() => _NotesState(note: note);
}

class _NotesState extends State<Notes> {
  _NotesState({this.note});
  DatabaseHelper helper = DatabaseHelper();
  Note note;
  final namecontroller = TextEditingController();
  final textcontroller = TextEditingController();
  File _image;
  String path;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      path = pickedFile.path;
      _image = File(path);
    });
  }
@override
  void initState() {
  if (note.image != '' && note.image != null) _image = File(note.image);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    namecontroller.text = note.title;
    textcontroller.text = note.text;
    if (note.date == '')
      note.date = DateFormat.yMMMd().format(DateTime.now());
    else
      note.date;
    return Scaffold(
      backgroundColor: Color(0xff021126),
      appBar: AppBar(
        backgroundColor: Color(0xff021126),
        iconTheme:
            IconThemeData(color: Color(0xff91C7ED), opacity: 100, size: 60),
        actions: <Widget>[
          IconButton(
            disabledColor: Color(0xff91C7ED),
            icon: Icon(Icons.done_all),
            tooltip: 'Save',
            onPressed: () {
              if (path != null) updateImage();
              _save();
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.transparent),
        child: Column(children: <Widget>[
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(note.date, style: TextStyle(color: Colors.white)),
                      SizedBox(
                        width: 10,
                      )
                    ]),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                          height: 100,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: namecontroller,
                            maxLength: 20,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "name",
                                hintStyle: TextStyle(color: Colors.blueGrey)),
                            onChanged: (value) {
                              updateTitle();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(children: <Widget>[
                  SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: textcontroller,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'text',
                          hintStyle: TextStyle(color: Colors.blueGrey)),
                      cursorColor: Color(0xff91C7ED),
                      onChanged: (value) {
                        updateDescription();
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                ]),
                Expanded(
                  child:Container(
                    height: 300,
                    width: 200,
                    child:_image != null
                    ?  Align(
                            alignment: Alignment.center,
                            child: Image.file(_image))
                    : SizedBox(width: 0),
                    )
                )
              ],
            ),
          ),
        ]),
      ),
      floatingActionButton:SpeedDial(
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
        SpeedDialChild(
          child:  Icon(
            Icons.image,
            color: Color(0xffC4C8CD),
            size: 30,
          ),
          onTap: () {
            getImage();
          },
          backgroundColor: Color(0xff021126),
        ),
          SpeedDialChild(
          child:  Icon(
            Icons.delete_sweep,
            color: Color(0xffC4C8CD),
            size: 30,
          ),
            onTap: () {
              Dialog delet_dialog = Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  elevation: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blueGrey,
                    ),
                    height: 150.0,
                    width: 300.0,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child:
                            Text("do you want to remove this Note?"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                              padding: EdgeInsets.all(10)
                                  .copyWith(right: 20, left: 20),
                              child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: <Widget>[
                                    FloatingActionButton.extended(
                                      onPressed: () {
                                        moveToLastScreen();
                                      },
                                      label: Text("cancel"),
                                      backgroundColor: Color(0xff021126),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    FloatingActionButton.extended(
                                      onPressed: () {
                                        _delete();
                                      },
                                      label: Text("delet"),
                                      backgroundColor: Color(0xff021126),
                                    ),
                                  ]))
                        ]),
                  ));
              showDialog(
                  context: context,
                  builder: (BuildContext context) => delet_dialog);
            },
          backgroundColor: Color(0xff021126),
        ),
        ],
      ),
    );
  }

  // Update the name of Note object
  void updateTitle() {
    note.title = namecontroller.text;
  }

  // Update the imagefile of Note object
  void updateImage() {
    note.image = path;
  }

  // Update the text of Note object
  void updateDescription() {
    note.text = textcontroller.text;
  }

  // Save data to database
  void _save() async {
    moveToMainScreen();
    int result;
    if (note.id != null) {
      // Case 1: Update operation
      result = await helper.updateNote(note);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Note Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Problem Saving Note');
    }
  }

  void _delete() async {
    moveToMainScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlertDialog('No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Note Deleted Successfully');
    } else {
      _showAlertDialog('Error Occured while Deleting Note');
    }
  }

  void _showAlertDialog(String s) {
    Fluttertoast.showToast(
      msg: s,
      textColor:Colors.blueGrey ,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void moveToMainScreen() {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Notespage()), (route) => false);
  }
}
