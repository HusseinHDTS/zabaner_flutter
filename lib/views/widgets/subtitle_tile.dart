import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zabaner/models/utils.dart';

class SubtitleTile extends StatelessWidget {
  bool faVisible, enVisible;
  var faTile;
  var enTile;
  TextAlign? textAlign;

  SubtitleTile(
      {Key? key,
      required this.faVisible,
      required this.enVisible,
      required this.faTile,
      required this.enTile,
      this.textAlign});

  @override
  Widget build(BuildContext context) {
    bool hasFa = true, hasEn = true;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 3),
      child: faVisible == true || enVisible == true
          ? Column(
              children: [
                enVisible == true
                    ? FutureBuilder<List<InlineSpan>>(
                        future: enTile,
                        builder: (_context, item) {
                          if(!item.hasData){
                            return Container();
                          }
                          hasEn = item.data != null && item.data!.isNotEmpty;
                          return Column(
                            textDirection: TextDirection.ltr,
                            children: [
                              item.data != null && item.data!.isNotEmpty
                                  ? Container(
                                      width: double.infinity,
                                      child: Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text.rich(
                                            TextSpan(
                                              style: getSubDefault(false),
                                              children: item.data,
                                            ),
                                            textAlign:
                                                textAlign ?? TextAlign.left,
                                            // textDirection: TextDirection.ltr,
                                            locale: const Locale.fromSubtags(
                                                languageCode: "en"),
                                          ),
                                        ),
                                      ))
                                  : Container(),
                              item.data != null && item.data!.isNotEmpty
                                  ? SizedBox(
                                      height: 6,
                                    )
                                  : Container()
                            ],
                          );
                        },
                      )
                    : Container(),
                faVisible == true
                    ? FutureBuilder<List<InlineSpan>>(
                      future: faTile,
                      builder: (_context, item) {
                        if(!item.hasData){
                          return Container();
                        }
                        hasFa = item.data != null && item.data!.isNotEmpty;
                        return Column(
                          children: [
                            item.data != null && item.data!.isNotEmpty
                                ? Container(
                                width: double.infinity,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text.rich(
                                    TextSpan(
                                      style: getSubDefault(false),
                                      children: item.data,
                                    ),
                                    textAlign: textAlign ?? TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    locale: const Locale.fromSubtags(
                                        languageCode: "fa"),
                                  ),
                                ))
                                : Container(),
                            item.data != null && item.data!.isNotEmpty
                                ? SizedBox(
                              height: 6,
                            )
                                : Container()
                          ],
                        );
                      },
                    )
                    : Container(),
                hasFa
                    ? SizedBox(
                        height: 14,
                      )
                    : Container(),
              ],
            )
          : Container(),
    );
  }
}
