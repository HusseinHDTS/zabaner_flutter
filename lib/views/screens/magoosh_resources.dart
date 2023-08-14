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

  MagooshResources({this.category, required this.type, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = "";
    if (type == "ielts") {
      title = "آیلتس آکادمیک Magoosh";
    } else if (type == "ielts-general") {
      title = "آیلتس جنرال Magoosh";
    }
    return resourcesHolder(
      iconWidget: Icon(
        Icons.account_tree_outlined,
        color: Colors.black.withOpacity(0.2),
      ),
      onClick: (index) {
        Get.to(() => MagooshListScreen(category[index]['id'],
            filter: category[index]['id'],title: category[index]['title'], type: type));
      },
      items: category,
      title: title,
    );
  }
}

class TedResources extends StatelessWidget {
  var category;

  TedResources({this.category, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = "سخنرانی های TED";
    return resourcesHolder(
      iconWidget: Icon(
        Icons.meeting_room_outlined,
        color: Colors.black.withOpacity(0.2),
      ),
      title: title,
      onClick: (index) {
        Get.to(() => TedListScreen(
              category[index]['id'],
              filter: category[index]['id'],
              title: category[index]['title'],
            ));
      },
      items: category,
    );
  }
}
