import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zabaner/controllers/news_data_controller.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/tabs/adult_tab.dart';
import 'package:zabaner/views/tabs/childs_tab.dart';
import 'package:zabaner/views/tabs/national_tab.dart';
import 'package:zabaner/views/widgets/news_category_widget.dart';
import 'package:zabaner/views/widgets/news_widget.dart';
import 'package:zabaner/views/widgets/serach_text_input.dart';
import 'package:get/get.dart';
import 'package:zabaner/widgets/colored_text.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key, required this.isGuest}) : super(key: key);
  final bool isGuest;

  @override
  Widget build(BuildContext context) {
    final NewsDataController _newsDataController =
        Get.put(NewsDataController(isGuest));
    final NewsSearchController _searchController =
        Get.put(NewsSearchController());
    var selectedCategory = 0.obs;
    var onSearch = false.obs;
    return DefaultTabController(
      length: 3,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context)!;
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            // Your code goes here.
            // To get index of current tab use tabController.index
          }
        });
        return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: const Color(0xffffffff),
            appBar: AppBar(
              backgroundColor: orange,
              titleSpacing: 0,
              elevation: 0,
              title: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  ColoredText(
                    "دوره ها",
                    textColor: Colors.white,
                    textSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: 1,
                    decoration: const BoxDecoration(color: Colors.white60),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
              bottom: TabBar(
                controller: tabController,

                // indicator: BoxDecoration(
                //     gradient: LinearGradient(
                //       begin: Alignment.topCenter,
                //         end: Alignment.bottomCenter,
                //         colors: [orangeDark.withOpacity(0.1), orangeDark.withOpacity(0.4), orangeDark]),
                //     borderRadius: BorderRadius.vertical(top: Radius.circular(18),bottom: Radius.circular(8)),
                //     boxShadow: [
                //       BoxShadow(
                //           color: orangeDark.withOpacity(0.5),
                //           offset: Offset(0, 18),
                //           blurRadius: 3,
                //           spreadRadius: -10),
                //     ]),
                tabs: [
                  Tab(
                    child: Container(
                      child: ColoredText(
                        "کودکان",
                        textColor: Colors.white,
                        textSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      child: ColoredText(
                        "بزرگسالان",
                        textColor: Colors.white,
                        textSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      child: ColoredText(
                        "آزمون ها",
                        textColor: Colors.white,
                        textSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: Directionality(
              textDirection: TextDirection.ltr,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                child: Obx(
                  () => _searchController.isDataLoaded()
                      ? _searchController.dataError.isTrue
                          ? SmartRefresher(
                              controller: _searchController.refreshController4,
                              onRefresh: () {
                                _searchController.getData();
                              },
                              header: const MaterialClassicHeader(),
                              child: ErrorLoading())
                          : TabBarView(children: [
                              ChildTab(controller: _searchController),
                              AdultTab(controller: _searchController),
                              NationalTab(controller: _searchController),
                            ])
                      : Center(
                          child: Loading(),
                        ),
                ),
              ),
            ));
      }),
    );
  }
}
