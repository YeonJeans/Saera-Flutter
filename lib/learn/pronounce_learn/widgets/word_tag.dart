import 'package:flutter/cupertino.dart';

String WordTip(int idx){
  //구개음화
  if(idx == 9){
    return "‘ㄷ’, ‘ㅌ’ 뒤에 ‘ㅣ’가 올 때 ‘ㅈ’, ‘ㅊ’로 발음하도록 신경써야\n 합니다.";
  }
  //두음법칙
  else if(idx == 10){
    return "단어 말머리의 ‘ㄴ’, ‘ㄹ’이 다른 소리로 바뀝니다.";
  }
  //치조마찰음화
  else if(idx == 11){
    return "‘ㅅ’와 ‘ㅆ’의 올바른 발음을 연습합니다.";
  }
  //ㄴ첨가
  else if(idx == 12){
    return "복합어에서 ‘ㄴ’을 추가해 발음하도록 신경써야 합니다.";
  }
  //ㄹ첨가
  else if(idx == 13){
    return "받침 'ㄹ'뒤에 '이,야,여,요,유'가 오는 경우, 'ㄹ'을 첨가하여 \n발음해야 합니다.";
  }
  // 여=>애
  else if(idx == 14){
    return "'ㅕ' 발음을 'ㅐ' 처럼 발음하지 않도록 신경써야 합니다.";
  }
  //단모음화
  else if(idx == 15){
    return "이중모음을 단모음처럼 발음하지 않도록 신경써야 합니다.";
  }
  //으=>우
  else if(idx == 16){
    return "'ㅡ' 발음을 'ㅜ' 처럼 발음하지 않도록 신경써야 합니다.";
  }
  //어=>오
  else if(idx == 17){
    return "‘ㅓ' 발음을 ‘ㅗ' 처럼 발음하지 않도록 신경써야 합니다.";
  }
  //오=>어
  else if(idx == 18){
    return "‘ㅗ' 발음을 ‘ㅓ' 처럼 발음하지 않도록 신경써야 합니다.";
  }
  //모음조화
  else if(idx == 19){
    return "양성 모음은 양성 모음끼리, 음성 모음은 음성 모음끼리 어울리도록\n 발음합니다.";
  }
  return "";
}
