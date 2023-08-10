import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'dart:ui' as ui;

import 'lyric.dart';
import 'package:get/get.dart';

class ChristianLyrics {

  StreamController<int> positionWithOffsetController = StreamController<int>.broadcast();
  int lastPositionUpdateTime = 0;
  int positionWithOffset = 0;
  int lastPositionWithOffset = 0;
  RxBool fa = true.obs , en = true.obs , autoScroll = true.obs;
  PlayingLyric? playingLyric = PlayingLyric();

  ChristianLyrics() {
    resetLyric();
  }

  void resetLyric({bool? faEnable ,bool? enEnable}) {
    faEnable ??=fa.value;
    enEnable ??=en.value;
    if(fa.value != faEnable){
      fa.value = faEnable;
    }
    if(en.value != enEnable){
      en.value = enEnable;
    }
    lastPositionUpdateTime = DateTime.now().millisecondsSinceEpoch;
    lastPositionWithOffset = positionWithOffset;
    //print("a: ${lastPositionUpdateTime} - ${lastPositionWithOffset}");
  }

  void setLyricContent(String lyricContent,{String faLyrics= ""}) {
    positionWithOffset = 0;
    this.playingLyric!.setLyric(lyric: lyricContent,faLyric: faLyrics);
  }

  void setPositionWithOffset({int position=0, int duration=1}) {
    positionWithOffset = position;
    positionWithOffsetController.add(positionWithOffset);
  }

  Future<ui.Image> getUiImage(String imageLink)async{
    ByteData bd = await NetworkAssetBundle(Uri.parse(imageLink)).load(imageLink);
    final Uint8List bytes = bd.buffer.asUint8List();

    final ui.Codec codec = await ui.instantiateImageCodec(bytes,targetHeight: 300);
    ui.Image _image = (await codec.getNextFrame()).image;
    return _image;
  }

  Widget getLyric(BuildContext context, {String imagePath = "",double scrollOffset = 0, bool? faE, bool? enE, bool isPlaying = false,bool? autoScrollE = true,TextStyle? tStyle}) {
    if(faE != null && fa.value != faE){
      fa.value = faE;
    }
    if(enE != null && en.value != enE){
      en.value = enE;
    }
    if(autoScrollE != null && autoScroll.value != autoScrollE){
      autoScroll.value = autoScrollE;
    }
    TextStyle style = (tStyle ?? Theme.of(context).textTheme.bodyText1!.copyWith(height: 1.5, fontSize: 20, color: Colors.white));

    if (this.playingLyric!.hasLyric) {
      return LayoutBuilder(builder: (context, constraints) {
        final normalStyle = style.copyWith(color: style.color!.withOpacity(0.3),fontSize: 18);
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: StreamBuilder(
                stream: positionWithOffsetController.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  final result = snapshot.data ?? 0;
                  return FutureBuilder<ui.Image?>(
                      future: getUiImage(imagePath),
                      builder: (context,snapshot) {
                        bool hasData =snapshot.hasData;
                        if(imagePath == ""){
                          hasData = true;
                        }
                        return hasData ? Obx((){
                          if(fa.value || en.value || autoScroll.value){

                          }
                          // return ListView.builder(
                          //     itemCount: playingLyric!.lyric!.size,
                          //     itemBuilder: (_,index){
                          //       return ColoredText(playingLyric!.lyric![index].line);
                          //     });
                          return Lyric(
                            lyric: playingLyric!.lyric!,
                            lyricLineStyle: normalStyle,
                            highlight: style.color!,
                            scrollOffset: scrollOffset,
                            position: result,
                            faEnable: fa.value,
                            enEnable: en.value,
                            image: imagePath == "" ? null : snapshot.data,
                            autoScroll: autoScroll.value,
                            textAlign: TextAlign.left ,
                            onTap: () {
                            },
                            size: Size(constraints.maxWidth, constraints.maxHeight == double.infinity ? 0 : constraints.maxHeight),
                            playing: isPlaying,
                          );
                        }) : subtitleLoading();
                      }
                  );
                }
            )
        );
      });
    } else {
      return Container(
        child: Center(
          child: Text("", style: style),
        ),
      );
    }

  }

}
