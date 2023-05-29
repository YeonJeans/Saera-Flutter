import 'package:get/get.dart';

class UserInfoController extends GetxController {
  Rx<int> exp = 0.obs;
  Rx<String> userName = "".obs;
  Rx<String> profileImage = "".obs;

  void saveExp(int ex){
    exp.value = ex;
  }

  void saveUserName(String name){
    userName.value = name;
  }

  void saveImage(String image){
    profileImage.value = image;
  }

  int getExp(){
    return exp.value;
  }

  String getImage(){
    return profileImage.value;
  }

  String getUserName(){
    return userName.value;
  }
}