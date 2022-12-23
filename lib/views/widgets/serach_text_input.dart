import 'package:flutter/material.dart';

class SearchTextInput extends StatelessWidget {
  SearchTextInput(
      {Key? key, this.onClick, this.onFieldSubmitted, this.onChange,this.focus,this.textController})
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
            prefixIconConstraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 8),
            prefixIcon: onChange,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(17))),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(17)))));
  }
}
