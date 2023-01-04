import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zabaner/controllers/book_ist_controller.dart';
import 'package:zabaner/models/resources_model.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/screens/chapter_list_screen.dart';
import 'package:zabaner/views/screens/profile_screen.dart';

class BooksListScreen extends StatelessWidget {
  BooksListScreen({
    this.filter,
  });

  String? filter;

  @override
  Widget build(BuildContext context) {
    final BookListController _controller =
        Get.put(BookListController(filter: filter));
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: AppBar(
              leadingWidth: Get.width,
              backgroundColor: const Color(0xffffffff),
              elevation: 0,
              leading: Padding(
                padding: EdgeInsets.only(right: Get.width / 40),
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Colors.black,
                      ),
                      Text(
                        "بازگشت",
                        style: TextStyle(
                            fontFamily: "Yekan", color: Color(0xff000000)),
                      ),
                    ],
                  ),
                ),
              )),
          body: _controller.obx((status) => Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width / 40),
              child: SmartRefresher(
                controller: _controller.refreshController,
                onRefresh: (){
                  _controller.getData();
                },
                header: const MaterialClassicHeader(),
                child: _controller.errorData.isTrue ? ErrorLoading() : Column(children: [
                  // Top of screen
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
                        const Text(
                          "داستان های کوتاه",
                          style: TextStyle(fontFamily: "Yekan", fontSize: 18),
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
                      child: ListView.builder(
                          itemCount: _controller.model.length,
                          itemBuilder: (_, index) {
                            return InkWell(
                              onTap: () => Get.to(() => ChapterListScreen(
                                id: _controller.model[index].id,
                                type: "book",
                                imageLink: _controller.model[index].imagePath,
                              )),
                              child: Container(
                                width: Get.width,
                                height: Get.height / 6,
                                margin: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                decoration: BoxDecoration(
                                    color: Color(0xffDBDBDB),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(children: [
                                  // image
                                  Container(
                                    width: Get.width / 3,
                                    height: Get.height,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              _controller.model[index].imagePath),
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _controller.model[index].title,
                                            style: TextStyle(
                                                fontFamily: "Yekan",
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              ImageIcon(
                                                  AssetImage(
                                                      "assets/images/time.png"),
                                                  size: 22),
                                              FutureBuilder<String>(
                                                  future: _controller.calculateTime(
                                                      _controller.model[index].id),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.connectionState ==
                                                        ConnectionState.waiting) {
                                                      return Text(
                                                          "\t\t" "صبر کنید ...");
                                                    } else if (snapshot
                                                        .connectionState ==
                                                        ConnectionState.done) {
                                                      return Text("\t\t"
                                                          "${snapshot.data} دقیقه");
                                                    }
                                                    return Text(
                                                        "\t\t" "صبر کنید ...");
                                                  }),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              ImageIcon(
                                                  AssetImage(
                                                      "assets/images/words.png"),
                                                  size: 22),
                                              Text("\t\t"
                                                  "${_controller.model[index].wordsCount} کلمه")
                                            ],
                                          )
                                        ],
                                      ))
                                ]),
                              ),
                            );
                          }))
                ]),
              )))),
    );
  }
}
