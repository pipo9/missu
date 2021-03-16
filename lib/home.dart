import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:missu/notespage.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  @override
  Widget build(BuildContext context) {
    return Container (
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/back.png"),
              fit: BoxFit.cover)
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
         body: Column(
           mainAxisAlignment: MainAxisAlignment.end,
           children: <Widget>[
             Row(
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 FloatingActionButton.extended(
                   label: Text("i miss you",style: TextStyle(fontStyle:FontStyle.italic),),
                   onPressed: (){
                     Navigator.push(context,MaterialPageRoute(builder: (context) => Notespage()));
                   },
                   backgroundColor:Color(0xff071B33),
                   elevation: 0.5,
                 ),
                 SizedBox(height:200,)
               ],
             )
           ],
         ),
      ),
    );
  }
}
