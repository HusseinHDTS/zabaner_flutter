import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zabaner/controllers/news_data_controller.dart';
import 'package:zabaner/views/tabs/list_model.dart';
import 'package:zabaner/widgets/colored_text.dart';

class AdultTab extends StatelessWidget{
  NewsSearchController controller;
   AdultTab({Key? key,required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(flex:0,child: ColoredText(controller.getTitle(1))),
        Expanded(
          flex: 1,
          child: SmartRefresher(
            controller: controller.refreshController2,
            onRefresh: (){
              controller.getData();
            },
            header: const MaterialClassicHeader(),
            child: ListView.builder(shrinkWrap: true,itemCount:controller.allAdultTabCategories.length,itemBuilder: (_context,index){
              return ListModel(index: index,controller: controller,currentType: TabbarTypes.ADULT);
            }),
          ),
        ),

      ],
    );

  }

}