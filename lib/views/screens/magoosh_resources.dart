import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/screens/magoosh_list_screen.dart';
import 'package:zabaner/views/screens/video_list_screen.dart';
import 'package:zabaner/widgets/colored_text.dart';

class MagooshResources extends StatelessWidget {
  var category;
  String type;
  MagooshResources({this.category,required this.type,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = "";
    if(type == "ielts"){
      title = "آیلتس آکادمیک Magoosh";
    }else if(type == "ielts-general"){
      title = "آیلتس جنرال Magoosh";
    }
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width / 30,
                  // bottom: MediaQuery.of(context).size.height / 150,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 12,
                  height: MediaQuery.of(context).size.height / 20,
                  child: Icon(Icons.account_tree_outlined,color: Colors.black.withOpacity(0.2),),
                ),
              ),
              ColoredText(
                title,
                textSize: 14,
                fontWeight: FontWeight.w500,
                textDirection: TextDirection.rtl,
              )
            ],
          ),
        ),
        resourcesBackground(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 5.4,
          child: Directionality(textDirection: TextDirection.rtl, child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: category.length,
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 25,
                right: MediaQuery.of(context).size.width / 25,
              ),
              itemBuilder: (context, index) {
                var item = category[index];
                return InkWell(
                  onTap: () => Get.to(()=> MagooshListScreen(item['id'],filter: item['id'],type:type)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        height: MediaQuery.of(context).size.height / 7.3,
                        child: Center(child: ClipRRect(borderRadius:BorderRadius.circular(8),child: Container(child: CachedNetworkImage(imageUrl: getUrl(item['imagePath'] ?? ""),),)),),
                      ),
                      Container(
                        child: Center(
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: ColoredText(
                              getText(item['title']),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              overflow: TextOverflow.ellipsis,
                              textSize: 12,
                            ),
                          ),
                        ),
                      )

                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width / 3.8,
                      //   child: Text(
                      //     getText(title),
                      //     overflow: TextOverflow.ellipsis,
                      //     textAlign: TextAlign.center,
                      //     style: const TextStyle(
                      //         color: Color(0xff000000), fontSize: 12, fontFamily: "Yekan"),
                      //   ),
                      // )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                width: MediaQuery.of(context).size.width / 15,
              ),
            ),
          )),
        ),
        SizedBox(height: 18,)
        // Divider(
        //   color: const Color(0xffDBDBDB),
        //   height: MediaQuery.of(context).size.height / 30,
        // )
      ],
    );
  }
}
class TedResources extends StatelessWidget {
  var category;
  TedResources({this.category,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = "سخنرانی های TED";
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width / 30,
                  // bottom: MediaQuery.of(context).size.height / 150,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 12,
                  height: MediaQuery.of(context).size.height / 20,
                  child: Icon(Icons.meeting_room_outlined,color: Colors.black.withOpacity(0.2),),
                ),
              ),
              ColoredText(
                title,
                textSize: 14,
                fontWeight: FontWeight.w500,
                textDirection: TextDirection.rtl,
              )
            ],
          ),
        ),
        resourcesBackground(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 5.4,
          child: Directionality(textDirection: TextDirection.rtl, child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: category.length,
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 25,
                right: MediaQuery.of(context).size.width / 25,
              ),
              itemBuilder: (context, index) {
                var item = category[index];
                return InkWell(
                  onTap: () => Get.to(()=> TedListScreen(item['id'],filter: item['id'],)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        height: MediaQuery.of(context).size.height / 7.3,
                        child: Center(child: ClipRRect(borderRadius:BorderRadius.circular(8),child: Container(child: CachedNetworkImage(imageUrl: getUrl(item['imagePath'] ?? ""),),)),),
                      ),
                      Container(
                        child: Center(
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: ColoredText(
                              getText(item['title']),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              overflow: TextOverflow.ellipsis,
                              textSize: 12,
                            ),
                          ),
                        ),
                      )

                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width / 3.8,
                      //   child: Text(
                      //     getText(title),
                      //     overflow: TextOverflow.ellipsis,
                      //     textAlign: TextAlign.center,
                      //     style: const TextStyle(
                      //         color: Color(0xff000000), fontSize: 12, fontFamily: "Yekan"),
                      //   ),
                      // )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                width: MediaQuery.of(context).size.width / 15,
              ),
            ),
          )),
        ),
        SizedBox(height: 18,)
        // Divider(
        //   color: const Color(0xffDBDBDB),
        //   height: MediaQuery.of(context).size.height / 30,
        // )
      ],
    );
  }
}
