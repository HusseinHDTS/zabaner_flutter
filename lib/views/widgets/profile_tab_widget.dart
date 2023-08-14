import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  final String image, title;
  final EdgeInsets? imageMargin;
  final Color? imageColor;
  Color? textColor;
  final void Function()? onTap;
  ProfileTab(
      {Key? key, required this.image, this.onTap, this.textColor,this.imageMargin,this.imageColor, required this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    textColor ??= imageColor;
    return Column(
      children: [
        // Tab Icon
        InkWell(
          onTap: onTap,
          child: Container(
            width: MediaQuery.of(context).size.width / 8.5,
            height: MediaQuery.of(context).size.height / 17,
            padding: imageMargin,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 0.5, color: const Color(0xff707070))),
            child: Image.asset(
              "assets/images/$image",
              fit: BoxFit.fill,
              color: imageColor,
            ),
          ),
        ),
        SizedBox(height: 5,),
        // Tab text
        Text(
          title,
          style: TextStyle(
              fontFamily: "IRANSansPro", fontSize: 10, color: textColor),
        )
      ],
    );
  }
}
