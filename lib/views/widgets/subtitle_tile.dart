import 'package:flutter/cupertino.dart';
import 'package:zabaner/models/utils.dart';

class SubtitleTile extends StatelessWidget{
  bool faVisible , enVisible;
  var faTile;
  var enTile;
  SubtitleTile({Key? key,required this.faVisible,required this.enVisible,required this.faTile,required this.enTile });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                return Container(
                    child: RichText(
                      text: TextSpan(
                        style: getSubDefault(false),
                        children:item.data,
                      ),
                    ));
              },),
          )
              : Container(),
          SizedBox(
            height: 6,
          ),
          faVisible == true
              ? Directionality(
            textDirection: TextDirection.rtl,
            child:FutureBuilder<List<InlineSpan>>(
              future: faTile,
              builder: (_context , item){
                return Container(
                    child: RichText(
                      text: TextSpan(
                        style: getSubDefault(true),
                        children:item.data,
                      ),
                    ));
              },),
          )
              : Container(),
          SizedBox(
            height: 24,
          ),
        ],
      )
          : Container(),
    );
  }
}