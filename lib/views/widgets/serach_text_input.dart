import 'package:flutter/material.dart';

class SearchTextInput extends StatelessWidget {
  SearchTextInput(
      {Key? key,
      this.onClick,
      this.onFieldSubmitted,
      this.onChange,
      this.focus,
      this.textController})
      : super(key: key);
  final Function()? onClick;
  Widget? onChange;
  FocusNode? focus;
  final Function(String)? onFieldSubmitted;
  TextEditingController? textController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        // onChanged: onChanged,
        onTap: onClick,
        controller: textController,
        onFieldSubmitted: onFieldSubmitted,
        textInputAction: TextInputAction.search,
        style: const TextStyle(fontFamily: "Yekan", fontSize: 14),
        textAlignVertical: TextAlignVertical.top,
        textAlign: TextAlign.center,
        focusNode: focus,
        decoration: InputDecoration(
            filled: true,
            hintText: "نام کتاب، انیمیشن، پادکست...",
            contentPadding: EdgeInsets.zero,
            hintStyle: const TextStyle(
                fontFamily: "Yekan", fontSize: 12, color: Color(0xffffffff)),
            hintTextDirection: TextDirection.rtl,
            fillColor: const Color(0xffDBDBDB),
            prefixIconConstraints:
                BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 8),
            prefixIcon: onChange,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(17))),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(17)))));
  }
}

class TicketTextInput extends StatelessWidget{
  TextEditingController textController;
  FocusNode? focus;
  String? hint;
  int? lines;
  TicketTextInput({Key? key,this.lines,this.hint,required this.textController, this.focus}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: textController,
        style: const TextStyle(fontFamily: "Yekan", fontSize: 14),
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.right,
        focusNode: focus,
        minLines: lines,
        maxLines: lines,
        decoration: InputDecoration(
            hintText: hint,
            contentPadding: EdgeInsets.zero,
            hintStyle: const TextStyle(
                fontFamily: "Yekan", fontSize: 12, color: Color(0xff919090)),
            hintTextDirection: TextDirection.rtl,
            fillColor: Color(0xff000000),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(17))),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(17)))));
  }

}

class MessageTextInput extends StatelessWidget {
  TextEditingController textController;
  FocusNode focus;
  MessageTextInput({Key? key,required this.textController,required this.focus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: textController,
        style: const TextStyle(fontFamily: "Yekan", fontSize: 14),
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.right,
        textInputAction: TextInputAction.send,
        focusNode: focus,
        decoration: const InputDecoration(
            hintText: "لطفا پیام خود را بنویسید",
            contentPadding: EdgeInsets.zero,
            hintStyle: TextStyle(
                fontFamily: "Yekan", fontSize: 12, color: Color(0xff919090)),
            hintTextDirection: TextDirection.rtl,
            fillColor: Color(0xff000000),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(17))),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(17)))));
  }
}
