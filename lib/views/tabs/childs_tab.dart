import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zabaner/controllers/news_data_controller.dart';
import 'package:zabaner/views/tabs/list_model.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'dart:io' as io;

late io.Directory appDoc;

class ChildTab extends StatelessWidget{
  NewsSearchController controller;
   ChildTab({Key? key,required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(flex:0,child: ColoredText(controller.getTitle(0))),
        Expanded(
          flex: 1,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SmartRefresher(
              controller: controller.refreshController1,
              onRefresh: (){
                controller.getData();
              },
              header: const MaterialClassicHeader(),
              child: ListView.builder(shrinkWrap:true,itemCount:controller.allChildTabCategories.length+1,itemBuilder: (_context,index){
                if(index == controller.allChildTabCategories.length){
                  return SizedBox(
                    height: 100,
                  );
                }
                return ListModel(index: index,hasSubCategory: true,controller: controller,currentType: TabbarTypes.CHILD,);
              }),
            ),
          ),
        ),

      ],
    );
  }

}