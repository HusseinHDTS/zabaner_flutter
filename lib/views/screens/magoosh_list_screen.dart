import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/screens/profile_screen.dart';
import 'package:zabaner/views/screens/video_detailt_screen.dart';
import 'package:zabaner/widgets/my_app_bar.dart';

import '../../widgets/colored_text.dart';

class MagooshListScreen extends StatefulWidget {
  String? title;
  String? filter;
  String type;
  var id;

  MagooshListScreen(this.id, {this.title,this.type = "ielts", this.filter, Key? key})
      : super(key: key);

  @override
  State<MagooshListScreen> createState() => _MagooshListScreenState();
}

class _MagooshListScreenState extends State<MagooshListScreen> {
  final GetConnect _getConnect = GetConnect();

  Future<dynamic> getData() async {
    var requestBody = {};
    String link = getIeltsData;
    if (widget.type == "ielts") {
      link = getIeltsData;
    } else if (widget.type == "ielts-general") {
      link = getIeltsGeneralData;
    }
    var result = await _getConnect.get(link);
    var data = jsonDecode(result.bodyString ?? "[]");
    if (widget.filter == null) {
      return data;
    }
    var results = [];
    data.removeWhere((item) {
      if (item['category'] == widget.filter) {
        return false;
      } else {
        return true;
      }
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: ColoredAppBar(),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width / 40),
            child: FutureBuilder<dynamic>(
              future: getData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var data = snapshot.data;
                String title = "";
                if (widget.type == "ielts") {
                  title = "آیلتس آکادمیک Magoosh";
                } else if (widget.type == "ielts-general") {
                  title = "آیلتس جنرال Magoosh";
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin:
                        EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                        child: ColoredText(
                          "$title > ${widget.title ?? ""}",
                        )),
                    Expanded(
                        child: data.length == 0
                            ? NoData()
                            : ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (_, index) {
                              return resourceItemHolder(
                                  title: data[index]['mTitleFa'],
                                  hasMore: false,
                                  itemType: "video",
                                  extraContent: [
                                    Row(
                                      children: [
                                        Flexible(
                                            flex: 1,
                                            child: resourceIconDetail(
                                                title: data[index]
                                                ['podcastTime']
                                                    .toString() +
                                                    " دقیقه ",
                                                iconPath:
                                                "assets/images/time.png")),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Flexible(
                                            flex: 1,
                                            child: Container())
                                      ],
                                    ),
                                  ],
                                  imagePath:
                                  getUrl(data[index]['imagePath']),
                                  onClick: () {
                                    Get.to(()=>VideoDetailScreen(
                                      isGuest: false,
                                      id: data[index]['id'],
                                      itemType: widget.type,
                                    ));
                                  },
                                  index: index);
                            })),
                  ],
                );
              },
            ),
          ),
        ));
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: ColoredAppBar(),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width / 40),
            child: FutureBuilder<dynamic>(
              future: getData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var data = snapshot.data;
                String title = "";
                if (widget.type == "ielts") {
                  title = "آیلتس آکادمیک Magoosh";
                } else if (widget.type == "ielts-general") {
                  title = "آیلتس جنرال Magoosh";
                }
                return Column(
                  children: [
                    SizedBox(
                      height: Get.height / 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // profile image
                          InkWell(
                            onTap: () =>
                                Get.to(() => ProfileScreen(isGuest: false)),
                            child: CircleAvatar(
                              radius: Get.width / 18,
                              // backgroundImage: NetworkImage(_controller
                              //         .getProfileImage ??
                              //     "https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Solid_white.svg/2048px-Solid_white.svg.png"),
                            ),
                          ),

                          // Hello Text
                          ColoredText(
                            title,
                            textSize: 18,
                            textDirection: TextDirection.rtl,
                          ),

                          // Logo in top left
                          SizedBox.square(
                            // padding: EdgeInsets.only(left: Get.width / 25),
                            dimension: Get.width / 8,
                            // height: Get.height / 14,
                            child: Container(),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              var item = data[index];
                              return InkWell(
                                  onTap: () {
                                    Get.to(() => VideoDetailScreen(
                                          isGuest: false,
                                          id: item['id'],
                                          itemType: widget.type,
                                        ));
                                  },
                                  child: Container(
                                    width: Get.width,
                                    height: Get.height / 5.5,
                                    margin: EdgeInsets.only(
                                        bottom: Get.height / 40),
                                    decoration: BoxDecoration(
                                        color: const Color(0xffebebeb),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Row(children: [
                                      // image
                                      Container(
                                        width: Get.width / 3,
                                        height: Get.height,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  getUrl(
                                                      item['imagePath'] ?? "")),
                                            )),
                                      ),

                                      // empty space
                                      SizedBox(
                                        width: Get.width / 12,
                                      ),

                                      Expanded(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['mTitleFa'].toString(),
                                            style: TextStyle(
                                                fontFamily: "IRANSansPro",
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              ImageIcon(
                                                  AssetImage(
                                                      "assets/images/time.png"),
                                                  size: 22),
                                              Text("    " +
                                                  item['podcastTime']
                                                      .toString() +
                                                  " دقیقه ")
                                            ],
                                          ),
                                        ],
                                      ))
                                    ]),
                                  ));
                            }),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ));
  }
}

class TedListScreen extends StatefulWidget {
  String? title;
  String? filter;
  var id;

  TedListScreen(this.id, {Key? key, this.filter,this.title}) : super(key: key);

  @override
  State<TedListScreen> createState() => _TedListScreenState();
}

class _TedListScreenState extends State<TedListScreen> {
  final GetConnect _getConnect = GetConnect();

  Future<dynamic> getData() async {
    var requestBody = {};
    String link = getTedData;
    var result = await _getConnect.get(link);
    var data = jsonDecode(result.bodyString ?? "[]");
    if (widget.filter == null) {
      return data;
    }
    var results = [];
    data.removeWhere((item) {
      if (item['category'] == widget.filter) {
        return false;
      } else {
        return true;
      }
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: ColoredAppBar(),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width / 40),
            child: FutureBuilder<dynamic>(
              future: getData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var data = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                        child: ColoredText(
                          "سخنرانی های TED" + " > " + (widget.title ?? ""),
                        )),
                    Expanded(
                        child: data.length == 0
                            ? NoData()
                            : ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (_, index) {
                                  return resourceItemHolder(
                                      title: data[index]['mTitleFa'],
                                      hasMore: false,
                                      itemType: "video",
                                      extraContent: [
                                        Row(
                                          children: [
                                            Flexible(
                                                flex: 1,
                                                child: resourceIconDetail(
                                                    title: data[index]
                                                                ['podcastTime']
                                                            .toString() +
                                                        " دقیقه ",
                                                    iconPath:
                                                        "assets/images/time.png")),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Flexible(
                                                flex: 1,
                                                child: resourceIconDetail(
                                                    title:
                                                        "لهجه: ${(data[index]['accent'] ?? "")}",
                                                    iconSize: 12,
                                                    iconPath:
                                                        "assets/images/audio_book.png"))
                                          ],
                                        ),
                                        SizedBox(height: 4,),
                                        Row(
                                          children: [
                                            Flexible(
                                                flex: 1,
                                                child: resourceIconDetail(
                                                    title:
                                                    "سطح: ${data[index]['itemLevel']??""}",
                                                    iconSize: 12,
                                                    iconPath:
                                                    "assets/images/level-ltr.png")),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Flexible(
                                                flex: 1,
                                                child:Container())
                                          ],
                                        ),
                                      ],
                                      imagePath:
                                          getUrl(data[index]['imagePath']),
                                      onClick: () {
                                        Get.to(() => VideoDetailScreen(
                                              isGuest: false,
                                              id: data[index]['id'],
                                              itemType: "ted",
                                            ));
                                      },
                                      index: index);
                                })),
                  ],
                );
              },
            ),
          ),
        ));
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: ColoredAppBar(),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width / 40),
            child: FutureBuilder<dynamic>(
              future: getData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var data = snapshot.data;
                String title = "سخنرانی های TED";
                return Column(
                  children: [
                    SizedBox(
                      height: Get.height / 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // profile image
                          InkWell(
                            onTap: () =>
                                Get.to(() => ProfileScreen(isGuest: false)),
                            child: CircleAvatar(
                              radius: Get.width / 18,
                            ),
                          ),

                          // Hello Text
                          ColoredText(
                            title,
                            textSize: 18,
                            textDirection: TextDirection.rtl,
                          ),

                          // Logo in top left
                          SizedBox.square(
                            // padding: EdgeInsets.only(left: Get.width / 25),
                            dimension: Get.width / 8,
                            // height: Get.height / 14,
                            child: Container(),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              var item = data[index];
                              return InkWell(
                                  onTap: () {
                                    Get.to(() => VideoDetailScreen(
                                          isGuest: false,
                                          id: item['id'],
                                          itemType: "ted",
                                        ));
                                  },
                                  child: Container(
                                    width: Get.width,
                                    height: Get.height / 5.5,
                                    margin: EdgeInsets.only(
                                        bottom: Get.height / 40),
                                    decoration: BoxDecoration(
                                        color: const Color(0xffebebeb),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Row(children: [
                                      // image
                                      Container(
                                        width: Get.width / 3,
                                        height: Get.height,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  getUrl(
                                                      item['imagePath'] ?? "")),
                                            )),
                                      ),

                                      // empty space
                                      SizedBox(
                                        width: Get.width / 12,
                                      ),

                                      Expanded(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['mTitleFa'].toString(),
                                            style: TextStyle(
                                                fontFamily: "IRANSansPro",
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              ImageIcon(
                                                  AssetImage(
                                                      "assets/images/time.png"),
                                                  size: 22),
                                              Text("    " +
                                                  item['podcastTime']
                                                      .toString() +
                                                  " دقیقه ")
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Transform.scale(
                                                scaleX: 1,
                                                child: ImageIcon(
                                                    AssetImage(
                                                        "assets/images/audio_book.png"),
                                                    size: 22),
                                              ),
                                              Text("    " "لهجه: " +
                                                  (item['accent'] ?? ""))
                                            ],
                                          ),
                                        ],
                                      ))
                                    ]),
                                  ));
                            }),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ));
  }
}
