class Model {
  final String question;
  final String answer;
  final List options;
  Model(this.question, this.answer, this.options); 

  Map<String, dynamic> toMap() {
    return {
      'question': _checkString(question),
      'answer' : _checkString(answer),
      'options' : _checkList(options),
    };
  }

  String _checkString(String input) {
    String rawInput = input; 
    RegExp iReg = RegExp(r'&');
    int matchLength = iReg.allMatches(rawInput).length;
    for (var i = 0; i < matchLength; i++) {
      if((rawInput.contains('&') && rawInput.contains(';'))) {
        int index1 = rawInput.indexOf('&');
        int index2 = rawInput.indexOf(';');
         rawInput = rawInput.replaceRange(index1, (index2+1), '');
      }
    }
    return rawInput;
  }

  List<String> _checkList(List listInput) {
    List<String> checkedList = listInput.map((input) {
      return _checkString(input);
    }).toList();
    return checkedList;
  }
}