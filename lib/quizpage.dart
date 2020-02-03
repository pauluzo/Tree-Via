 import 'dart:async';

import 'package:flutter/material.dart';
import 'package:treevia_app/model.dart';
import 'package:treevia_app/results.dart';

class QuizPage extends StatefulWidget {
  QuizPage({Key key, @required this.modelList}) : super(key : key);
  final List<Model> modelList ;
  @override
  _QuizPageState createState() => _QuizPageState(modelList: modelList);
}

class _QuizPageState extends State<QuizPage> {
  _QuizPageState({Key key, @required this.modelList});
  final List<Model> modelList ;
  List _scoreTrack = [null, null, null, null, null, null, null, null, null, null, ];
  int _counter = 0;
  int _timer = 20;
  int _correctAnswers = 0;
  String _timerDisplay = '15';
  bool cancelTimer = false;
  bool isClicked = false;
  List<Color> _btnColors = <Color>[
    Colors.blueGrey.shade500, Colors.blueGrey.shade500, Colors.blueGrey.shade500, 
    Colors.blueGrey.shade500,
  ];
  // For managing the score board's color state
  Color scoreBtnColor = Colors.blueGrey.shade500;
  Color btnRight = Colors.green;
  Color btnWrong = Colors.red;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void startTimer() async {
    const Duration oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer t) {
      if(_timer < 1) {
          t.cancel();
          _nextQuestion();
        } else if(cancelTimer == true) {
          t.cancel();
        } 
        else {
          _timer -= 1;
          _timerDisplay = _timer.toString();
        }
      setState(() {
        
      });
    });
  }

  void _checkAnswer(int chosenOption) {
    isClicked = true;
    if(modelList[_counter].answer == modelList[_counter].options[chosenOption]) {
      _correctAnswers += 1;
      scoreBtnColor = btnRight;
      _btnColors[chosenOption] = Colors.green;
      _scoreTrack.replaceRange(_counter, (_counter + 1), [true]);
    } else {
      scoreBtnColor = btnWrong;
      _btnColors[chosenOption] = Colors.red;
      _scoreTrack.replaceRange(_counter, (_counter + 1), [false]);
    }
    setState(() {
      cancelTimer = true;
    });

    Timer(Duration(milliseconds: 1000), _nextQuestion);
  } 

  void _nextQuestion() {
    isClicked = false;
    _timer = 20; 
    if(_counter < 9) {
      _counter++;
      setState(() {
        cancelTimer = false;
      _btnColors = _btnColors.map((btnColor) {
        return Colors.blueGrey.shade500;
      }).toList();
      startTimer();
    });
    } else {
      setState(() {
        cancelTimer = true;
        _btnColors = _btnColors.map((btnColor) {
          return Colors.blueGrey.shade500;
        }).toList();
      });
      Timer(Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ResultPage(marks: _correctAnswers,),
        ));
      });
    }
  }

  Widget _createButton(double width, int option) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 400.0,
        minWidth: 300.0
      ),
      width: 0.9 * width,
      child: FlatButton(
        color: _btnColors[option],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        onPressed: isClicked ? () {} : () => _checkAnswer(option),
        child: Text(
          modelList[_counter].toMap()['options'][option],
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  List<Widget> _optionButtons(double width) {
    List<Widget> buttonList = [];
    for (var i = 0; i < 4; i++) {
      buttonList.add(_createButton(width, i));
    }
    return buttonList;
  }

  List<Widget> _scoreButtons() {
    List<Widget> scorebuttons = _scoreTrack.map((btnValue) {
      Color btnColor;
      if(btnValue == null) {
        btnColor = Colors.grey.shade300;
      } else if ( btnValue == true) {
        btnColor = Colors.green;
      } else if (btnValue == false) {
        btnColor = Colors.red;
      }
      return Material(
        elevation: 3.0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ClipOval(
          child: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(
                color: Colors.black45,
              ),
              color: btnColor,
            ),
          ),
        ),
      );
    }).toList();
    return scorebuttons;
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Center(child: Icon(Icons.warning, size: 50.0, color: Colors.blueGrey.shade400,),),
            content: Text('Aww, unfortunately, you can not go back at this stage. Meanwhile, your timer is still running, so please head back quickly. Cheers!'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      },
      child: Container(
        color: Colors.white,
          child: Column(
        children: <Widget>[
        Expanded(
          flex: 6,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.bottomCenter,
                color: Colors.indigo.shade800,
                height: 80.0,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _scoreButtons(),
                ),
              ),
              Expanded(
                flex: 1,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: 35.0,
                      left: 0,
                      right: 0,
                      top: 0,
                      child: Container(
                        color: Colors.indigo.shade800,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 50.0),
                            child: Material(
                              color: Colors.indigoAccent.shade400,
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                child: Center(
                                  child: Text(
                                    modelList[_counter].toMap()['question'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Material(
                            color: Colors.transparent,
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                            child: ClipOval(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(35.0),
                                  border: Border.all(
                                    color: Colors.blueGrey.shade400,
                                    width: 4.0,
                                  ),
                                ),
                                width: 70.0,
                                height: 70.0,
                                child: Center(
                                  child: Text(
                                    _timerDisplay,
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontFamily: 'Satisfy',
                                      color: Colors.blueGrey.shade500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(35.0),
                            elevation: 5.0,
                            child: ClipOval(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(35.0),
                                  border: Border.all(
                                    color: Colors.blueGrey.shade400,
                                    width: 4.0,
                                  ),
                                ),
                                width: 70.0,
                                height: 70.0,
                                child: Center(
                                  child: Text(
                                    '${_counter + 1} / 10',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: 'Satisfy',
                                      color: Colors.blueGrey.shade500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _optionButtons(phoneWidth),
          ),
        ),
      ],
          ),
        ),
    );
  }
}