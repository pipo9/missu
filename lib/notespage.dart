import 'package:sqflite/sqflite.dart';
import 'manote.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'notes.dart';
import 'utils/database_helper.dart';

class Notespage extends StatefulWidget {
  Notespage({Key key}) : super(key: key);



  @override
  _Notespage createState() => _Notespage();
}

class _Notespage extends State<Notespage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;
  Icon actionIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text("MissU");
  String name="";
  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/yeah.png"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: new AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xff021126),
            centerTitle: true,
            title: appBarTitle,
            actions: <Widget>[
              new IconButton(
                icon: actionIcon,
                onPressed: () {
                  setState(() {
                    if (this.actionIcon.icon == Icons.search) {
                      this.actionIcon = new Icon(Icons.close);
                      this.appBarTitle = new TextField(
                        style: new TextStyle(
                          color: Colors.white,
                        ),
                        onChanged:(value){
                          setState(() {
                            name=value;
                          });
                        },
                        decoration: new InputDecoration(
                            prefixIcon:
                            new Icon(Icons.search, color: Colors.white),
                            hintText: "Search...",
                            hintStyle: new TextStyle(color: Colors.white)),
                      );
                    } else {
                      this.actionIcon = new Icon(Icons.search);
                      this.appBarTitle = new Text("MissU");
                      setState(() {
                        name="";
                      });
                    }
                  });
                },
              ),
            ]),
        body:GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
          children:getNoteListView(name),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            navigateToDetail(Note(null, '', '', ''));
          },
          child: Icon(
            Icons.add,
            color: Color(0xff021126),
          ),
        ),
      ),
    );
  }

  List<Widget> getNoteListView(String name) {
  List<Widget> list=[];
  for(Note note in noteList) {
     if(note.title!=null)
       if( note.title.contains(name))
          list.add(Mycard(note));
  }
    return list;

  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  void navigateToDetail(Note note) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Notes(note: note);
    }));

    if (result == true) {
      updateListView();
    }
  }

  Widget Mycard(Note note) {
    String text2,
        subtext = '';
    if (note.text != null) {
      text2 = note.text.replaceAll('\n', ' ');
      if (text2.length > 10) {
        subtext = text2.substring(0, 10) + '...';
      }
      else {
        subtext = text2 + '...';
      }
    }
    return Card(
      color: Color(0xff021126),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
         navigateToDetail(note);
        },
        child: Container(
          width: 300,
          height: 100,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  note.title,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: Text(subtext,
                        style: TextStyle(color: Colors.white)))
              ]),
        ),
      ),
    );
  }
}


