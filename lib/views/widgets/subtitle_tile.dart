import 'package:flutter/cupertino.dart';
import 'package:zabaner/models/utils.dart';

class SubtitleTile extends StatelessWidget{
  bool faVisible , enVisible;
  var faTile;
  var enTile;
  SubtitleTile({Key? key,required this.faVisible,required this.enVisible,required this.faTile,required this.enTile });

  @override
  Widget build(BuildContext context) {
    bool hasFa = true,hasEn = true;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3),
      child:faVisible == true ||
          enVisible == true
          ? Column(
        children: [
          enVisible == true
              ? Directionality(
            textDirection: TextDirection.ltr,
            child:FutureBuilder<List<InlineSpan>>(
              future: enTile,
              builder: (_context , item){
                hasEn = item.data != null && item.data!.isNotEmpty;
                return Column(
                  children: [
                    item.data != null && item.data!.isNotEmpty ?  Container(
                      width:double.infinity,
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: RichText(
                            text: TextSpan(
                              style: getSubDefault(false),
                              children:item.data,
                            ),
                          ),
                        )) : Container(),
                    item.data != null && item.data!.isNotEmpty ? SizedBox(
                      height: 6,
                    ) : Container()
                  ],
                );
              },),
          )
              : Container(),
          faVisible == true
              ? Directionality(
            textDirection: TextDirection.rtl,
            child:FutureBuilder<List<InlineSpan>>(
              future: faTile,
              builder: (_context , item){
                hasFa = item.data != null && item.data!.isNotEmpty;
                return Column(
                  children: [
                    item.data != null && item.data!.isNotEmpty ? Container(
                        width:double.infinity,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: RichText(
                            text: TextSpan(
                              style: getSubDefault(true),
                              children:item.data,
                            ),
                          ),
                        )) : Container(),
                    item.data != null && item.data!.isNotEmpty ? SizedBox(
                      height: 24,
                    ) : Container(),
                  ],
                );
              },),
          )
              : Container(),
          hasFa ? SizedBox(height: 14,) : Container(),
        ],
      )
          : Container(),
    );
  }
}