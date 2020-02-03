import 'package:treevia_app/home.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final marks;
  ResultPage({Key key, @required this.marks}) : super(key: key);
  @override
  _ResultPageState createState() => _ResultPageState(marks);
}

class _ResultPageState extends State<ResultPage> {
  int marks = 0;
  List<String> images = [
    'images/success.png',
    'images/good.png',
    'images/bad.png',
  ];

  String message;
  String image;

  @override
  void initState() {
    if(marks < 4) {
      image = images[2];
      message = "You can try harder..\n" + "You got $marks questions correctly";
    } else if(marks <7) {
      image = images[1];
      message = "You can do better..\n" + "You got $marks questions correctly";
    } else {
      image = images[0];
      message = "You did very well!\n" + "You got $marks questions correctly";
    }
    super.initState();
  }

  _ResultPageState(this.marks);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Material(
              elevation: 10.0,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Material(
                      child: Container(
                        width: 300.0,
                        height: 300.0,
                        child: ClipRect(
                          child: Image(
                            image: AssetImage(image),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 15.0,
                      ),
                      child: Center(
                        child: Text(message, style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: "Quando",
                        ),),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlineButton(
                  onPressed: (){
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      )
                    );
                  },
                  child: Text("Continue", style: TextStyle(
                    fontSize: 18.0,
                  ),),
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0,
                  ),
                  borderSide: BorderSide(width: 3.0, color: Colors.indigo),
                  splashColor: Colors.indigoAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}