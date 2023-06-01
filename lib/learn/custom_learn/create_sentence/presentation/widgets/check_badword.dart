import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<String> getData() async {
  try {
    return await rootBundle.loadString('assets/fword_list.txt');
  } catch (e) {
    throw (e.toString());
  }
}

Future<bool> isBadWord(String str) async {
  var contents = "";
  var badwords = List.empty(growable : true);

  contents = await getData();

  final rows = await contents.split('\n');

  for(var row in rows){
    badwords.add(row);
  }

  for(int i = 0; i < badwords.length; i++){
    if(str.contains(badwords[i])){
      return true;
    }
  }

  return false;
}