import 'package:flutter/cupertino.dart';
late double height;
late double width;

void getSize(BuildContext context){
  height= MediaQuery.of(context).size.height;
  width= MediaQuery.of(context).size.width;
}

const height20 = SizedBox(height: 20,);
const height10 = SizedBox(height: 10,);
const width20 = SizedBox(width: 20,);
const width10 = SizedBox(width: 10,);
final padding = width * 0.04;