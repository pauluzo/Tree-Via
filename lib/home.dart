import 'dart:convert';

import 'package:treevia_app/model.dart';
import 'package:flutter/material.dart';
import 'package:treevia_app/quizpage.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, String>> _categories = [
    {'display': 'General Knowledge', 'value': '9'},
    {'display': 'Movies', 'value': '11'},
    {'display': 'Music', 'value': '12'},
    {'display': 'Celebrities', 'value': '26'},
    {'display': 'Vehicles', 'value': '28'},
    {'display': 'Books', 'value': '16'},
    {'display': 'Animals', 'value': '27'},
    {'display': 'Sports', 'value': '21'},
    {'display': 'Cartoon & Anime', 'value': '32'},
    {'display': 'Japanese Anime', 'value': '31'},
    {'display': 'Science & Nature', 'value': '17'},
  ];
  final List<Map<String, String>> _level = [
    {'display': 'Easy', 'value': '0'},
    {'display': 'Medium', 'value': '1'},
    {'display': 'Difficult', 'value': '2'},
  ];
  int _btnValue1 = 9;
  int _btnValue2 = 0;
  bool _showProgress = false;

  _saveForm(BuildContext context) {
    FormState form = _formKey.currentState;
    if(form.validate()) {
      form.save();
      fetchQuestions(context);
    }
  }

  void _handleResponse(List response, BuildContext context) {
    List<String> questions = <String>[];
    List<String> answers = <String>[];
    List options = [];
    List<Model> modelList = [];

    List incorrectAnswers = [];

    response.forEach((item) {
      questions.add(item['question']);
      answers.add(item['correct_answer']);
      incorrectAnswers = item['incorrect_answers'];
      incorrectAnswers.add(item['correct_answer']);
      incorrectAnswers.shuffle();
      options.add(incorrectAnswers);
    });
    
    for (var i = 0; i < questions.length; i++) {
      Model modelItem = Model(questions[i], answers[i], options[i]);
      modelList.add(modelItem);
    }

    if(modelList.length > 0) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => QuizPage(modelList: modelList,)
      ));
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Icon(Icons.warning, size: 50.0, color: Colors.blueGrey.shade400,),
            ),
            content: Text(
              'There are no questions for this category yet. Please select another category. ',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK', style: TextStyle(fontSize: 20.0),),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
      );
    }
  }

  void fetchQuestions(BuildContext context) async {
    String difficulty;
    if(_btnValue2 == 1) {
      difficulty = 'medium';
    } else if(_btnValue2 == 2) {
      difficulty = 'hard';
    } else {
      difficulty = 'easy';
    }
    String httpRequest = 'https://opentdb.com/api.php?amount=10&category=' + 
    _btnValue1.toString() + '&difficulty=' + difficulty + '&type=multiple';

    try {
      final response = await http.get(httpRequest);
      var decodedResponse;
      if(response.statusCode == 200) {
        decodedResponse = jsonDecode(response.body);
        _handleResponse(decodedResponse['results'], context);
      } else {
        print('');
      }
    } catch (e) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SizedBox(
            height: 400.0,
            child: AlertDialog(
              title: Center(
                child: Icon(Icons.warning, size: 50.0, color: Colors.blueGrey.shade300,),
              ),
              content: Text(
                'Aww, the network connection failed. Please check your network settings.',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK', style: TextStyle(fontSize: 20.0, color: Colors.blue.shade500),),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        }
      );
    }
    setState(() {
      _showProgress = false;
    });
  }

  DropdownButtonFormField<int> createDropDown(String labelText, int btnValue, List optionsList, bool isBtn1) {
    bool firstButton = isBtn1 ? true : false;
    List<DropdownMenuItem<int>> _itemList = optionsList.map((item) {
      return DropdownMenuItem(
        value: int.parse(item['value']),
        child: Text(item['display']),
      );
    }).toList();

    return DropdownButtonFormField(
      isDense: true,
      value: btnValue,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: 20.0,
          fontStyle: FontStyle.italic,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
      ),
      onChanged: (value) {
        if(firstButton) {
          setState(() {
            _btnValue1 = value;
          });
        } else {
          setState(() {
            _btnValue2 = value;
          });
        }
      },
      onSaved: (value) {
        if(firstButton) {
          if(_btnValue1 != value) {
            setState(() {
              _btnValue1 = value;
            });
          }
        } else {
          if(_btnValue2 != value) {
            setState(() {
              _btnValue2 = value;
            });
          }
        }
      },
      items: _itemList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: Text(
              'Tree-Via',
              style: TextStyle(
                color: Colors.blue.shade700,
                fontFamily: 'Satisfy',
                fontSize: 70.0,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: Form(
              key: _formKey,
              child: LimitedBox(
                maxHeight: 300.0,
                child: Container(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      createDropDown('Select Category', _btnValue1, _categories, true),
                      createDropDown('Select Difficulty', _btnValue2, _level, false),
                      Container(
                        width: 200.0,
                        child: MaterialButton(
                          key: Key('buttonId'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          minWidth: 200.0,
                          height: 45.0,
                          elevation: 7.0,
                          color: Colors.blue.shade800,
                          highlightColor: Colors.blue.shade900,
                          splashColor: Colors.blue.shade900,
                          onPressed: () {
                            if(_showProgress == false) {
                               _saveForm(context);
                            }
                            setState(() {
                              _showProgress = true;
                            });
                          },
                          child: Center(
                            child: _showProgress != true ?
                              Text('START QUIZ', style: TextStyle(
                              fontFamily: 'Quando',
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),) : 
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 5.0,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}