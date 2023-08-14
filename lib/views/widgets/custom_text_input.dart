import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/widgets/colored_text.dart';

class CustomTextInput extends StatelessWidget {
  CustomTextInput(
      {Key? key,
      required this.hintText,
      this.iconPath,
      this.error,
      this.keyboardType,
      this.maxLines,
      this.allowEnglish,
      this.inputFormatters,
      this.enabled,
      this.useMaxAndMinLine,
      this.readOnly,
      this.textDirection,
      this.textEditingController,
      this.priceUnit,
      this.textAlign,
      this.fontSize,
      this.hintSize,
      this.password = false,
      this.onChanged,
      this.maxLength})
      : super(key: key);
  final String hintText;
  final String? iconPath;
  final String? priceUnit;
  var inputFormatters;

  final void Function(String)? onChanged;
  int? maxLines;
  bool? error;
  bool? enabled;
  bool? useMaxAndMinLine;
  bool? allowEnglish;
  bool? readOnly;
  TextDirection? textDirection;
  TextAlign? textAlign;
  final bool password;
  final int? maxLength;
  TextEditingController? textEditingController;
  double? fontSize, hintSize;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    var _inputFormatters = <TextInputFormatter>[];
    error ??= false;
    readOnly ??= false;
    useMaxAndMinLine ??= false;
    allowEnglish ??= true;
    enabled ??= true;
    textAlign ??= TextAlign.right;
    fontSize ??= 15;
    hintSize ??= 12;
    maxLines ??= 1;
    textDirection ??= TextDirection.rtl;
    _inputFormatters.add(
        LengthLimitingTextInputFormatter(maxLength)
    );
    if(!allowEnglish!){
      _inputFormatters.add(
        FilteringTextInputFormatter.deny(RegExp("[0-9a-zA-Z]")),
      );
    }
    if(inputFormatters != null) {
      _inputFormatters.addAll(inputFormatters);
    }
    if(password){
      return TextFormField(
          onChanged: onChanged,
          style:getTextStyle() ,
          textAlignVertical: TextAlignVertical.top,
          controller: textEditingController,
          keyboardType: keyboardType,
          obscureText: password,
          textDirection: textDirection,
          textAlign: textAlign!,
          enabled: enabled,
          readOnly: readOnly!,
          obscuringCharacter: '*',
          inputFormatters: _inputFormatters,
          decoration: getInputDecoration(context));
    }else{
      return TextFormField(
          onChanged: onChanged,
          style:getTextStyle() ,
          textAlignVertical: TextAlignVertical.center,
          controller: textEditingController,
          keyboardType: keyboardType,
          obscureText: password,
          enabled: enabled,
          textDirection: textDirection,
          readOnly: readOnly!,
          textAlign: textAlign!,
          obscuringCharacter: '*',
          minLines: maxLines ,
          maxLines:maxLines,
          inputFormatters: _inputFormatters,
          decoration: getInputDecoration(context));
    }

  }

  getTextStyle(){
    return TextStyle(fontFamily: "IRANSansPro", fontSize: fontSize,color: enabled! ? null :Color(0xffb0b0b0) );
  }

  getInputDecoration(context){
    return InputDecoration(
        filled: true,
        labelText: hintText,
        contentPadding: EdgeInsets.only(right: 6,left: 6,top: 8,bottom: 4),
        labelStyle:TextStyle(
            fontSize: hintSize,
            fontFamily: "IRANSansPro",
            color: Color(0xffb0b0b0)) ,
        hintStyle: TextStyle(
            fontSize: hintSize,
            fontFamily: "IRANSansPro",
            color: Color(0xffb0b0b0)),
        hintTextDirection: TextDirection.rtl,
        fillColor: enabled! ? Color(0xffffffff) : Colors.white38,
        prefixIconConstraints:
        BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 8),
        suffix: priceUnit == null ? null : SizedBox(child: Padding(padding:EdgeInsets.symmetric(horizontal: 8),child: ColoredText(priceUnit.toString(),textColor: Colors.black45,backgroundColor: Colors.transparent,)),),
        prefixIcon: iconPath == null
            ? null
            : SizedBox(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 13, top: 4, bottom: 4, right: 13),
            child: Image.asset(
              "assets/images/$iconPath",
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: error! ? const Color(0xffff0000) : primary.withOpacity(0.6),
                width: 0.8),
            borderRadius: const BorderRadius.all(Radius.circular(8))) ,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: error! ? const Color(0xffff0000) : primary,
                width: 0.8),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: error! ? const Color(0xffff0000) : primary,
                width: 0.8),
            borderRadius: const BorderRadius.all(Radius.circular(8))));
  }

}
