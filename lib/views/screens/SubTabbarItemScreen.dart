import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zabaner/controllers/news_data_controller.dart';
import 'package:zabaner/controllers/sub_tabbar_item_controller.dart';
import 'package:zabaner/models/tabbar_item.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/screens/tabbar_item_screen.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:zabaner/widgets/my_app_bar.dart';

class SubTabbarItemScreen extends StatefulWidget {
  String? filter;
  String? submitTitle;
  List<TabbarItem> items;
  List<TabbarItem> cItems = [];
  String firstTitle , secondTitle;

  SubTabbarItemScreen({this.filter, required this.items,this.submitTitle,this.firstTitle = "",this.secondTitle = ""});

  @override
  State<StatefulWidget> createState() {
    items.forEach((element){
      if(element.subCategory.toString().trim() == filter.toString().trim()){
        cItems.add(element);
      }
    });
    return _SubTabbarItemScreen(cItems, filter);
  }

}

class _SubTabbarItemScreen extends State<SubTabbarItemScreen> {
  List<TabbarItem> items;
  String? filter;
  _SubTabbarItemScreen(this.items, this.filter);

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: ColoredAppBar(),
          body:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 18, vertical: 18),
                  child: ColoredText(
                    "${widget.firstTitle} > ${widget.secondTitle}",)),
              Expanded(
                  child: items.length == 0
                      ? NoData()
                      : ListView.builder(
                      itemCount:
                      items.length,
                      itemBuilder: (_, index) {
                        return resourceItemHolder(
                            title: items[index].title,
                            hasMore: false,
                            itemType: "podcast",
                            imagePath: items[index].image,
                            onClick: () {
                              Get.to(()=>TabbarItemScreen(items[index]));
                            },
                            index: index);
                      })),
            ],
          ),
        ));
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: ColoredAppBar(),
          body: items.length == 0 ? NoData() : ListView.builder(
              itemCount: items.length,
              itemBuilder: (_context, index) {
                return InkWell(
                  onTap: (){
                    if(items[index].video.substring(items[index].video.lastIndexOf("/")+1) == "undefined"){
                      ColoredSnack(title: "ویدیویی وجود ندارد!",description: "خطا هنگام پیدا کردن ویدیو",type: SnackType.ERROR);
                      return;
                    }
                    Get.to(()=>TabbarItemScreen(items[index]));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.symmetric(horizontal: 12,vertical: 22),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Colors.black12),
                    child: Row(children: [
                      Flexible(flex:1,child: Container(width: 120,height:double.infinity,child: Image.network(items[index].image,fit: BoxFit.fill),)),
                      Flexible(flex:1,child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: EdgeInsets.all(12),
                          child: Column(children: [
                            Align(alignment:Alignment.topRight,child: ColoredText(items[index].mTitle == "" ? items[index].title : items[index].mTitle,textColor: Colors.black,)),
                            SizedBox(height: 8,),
                            Align(alignment:Alignment.centerRight,child: Container(margin:EdgeInsets.only(right: 8),child: ColoredText(widget.submitTitle.toString(),textColor: Colors.black,textAlign: TextAlign.right,))),
                          ],),
                        ),
                      )),
                    ],),
                  ),
                );
              }),
        ));
  }
}
