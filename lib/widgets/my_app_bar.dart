import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zabaner/widgets/colored_text.dart';

class MyAppBar extends StatelessWidget {
  static double height = 90;
  static Color? appbarColor = Colors.yellow[700];
  String? _title;
  GestureTapCallback? _onBackClick;
  MyAppBar(String title,{GestureTapCallback? onBackClick}){
    _title = title;
    _onBackClick = onBackClick;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: SafeArea(
        child: Stack(children: [
          Align(alignment: Alignment.center,child: ColoredText(_title!,textColor: Colors.white,textSize: 18,),),
          Align(alignment: Alignment.centerRight,child: Container(margin: EdgeInsets.only(right: 12),child: InkWell(child: Icon(Icons.arrow_back,color: Colors.white,),onTap: _onBackClick,)),)
        ],),
      ),
      decoration: BoxDecoration(color:appbarColor , boxShadow: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(
            5.0,
            5.0,
          ),
          blurRadius: 10.0,
          spreadRadius: 0.7,
        ),
      ]),
    );
  }

}
