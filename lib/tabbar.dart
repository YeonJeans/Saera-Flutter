import 'package:flutter/material.dart';
import 'package:saera/home/bookmark_home/presentation/bookmark_home_screen.dart';

import 'package:saera/home/presentation/home_screen.dart';
import 'package:saera/learn/presentation/learn_screen.dart';
import 'package:saera/mypage/presentation/mypage_screen.dart';
import 'package:saera/style/color.dart';
import 'package:saera/style/font.dart';

class TabBarMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '새터민을 위한 억양 연습',
      home: BottomNavigator(),
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
    );
  }
}

class BottomNavigator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BottomNavigatorState();
  }
}

class _BottomNavigatorState extends State<BottomNavigator> with SingleTickerProviderStateMixin {

  int _seletedIndex = 0;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  _handleTabSelection() {
    setState(() {
      _seletedIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> _widgetOptions = [
    HomePage(),
    LearnPage(),
    BookmarkPage(),
    MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: SizedBox(
          height: 60.0,
          child: TabBar(
            controller: _tabController,
            tabs: <Widget>[
              Tab(
                icon: _seletedIndex == 0 ? Icon(Icons.home, color: ColorStyles.primary) : Icon(Icons.home_outlined, color: ColorStyles.primary),
                iconMargin: EdgeInsets.only(bottom: 5.0),
                child: Text(
                  '홈',
                  style: _seletedIndex == 0? TextStyles.tabBarBoldTextStyle : TextStyles.tabBarRegularTextStyle,
                ),
              ),
              Tab(
                icon: _seletedIndex == 1 ? Icon(Icons.view_list, color: ColorStyles.primary) : Icon(Icons.view_list_outlined, color: ColorStyles.primary),
                iconMargin: EdgeInsets.only(bottom: 5.0),
                child: Text(
                  '학습',
                  style: _seletedIndex == 1? TextStyles.tabBarBoldTextStyle : TextStyles.tabBarRegularTextStyle,
                ),
              ),
              Tab(
                icon: _seletedIndex == 2? Icon(Icons.star, color: ColorStyles.primary) : Icon(Icons.star_border, color: ColorStyles.primary),
                iconMargin: EdgeInsets.only(bottom: 5.0),
                child: Text(
                  '북마크',
                  style: _seletedIndex == 2? TextStyles.tabBarBoldTextStyle : TextStyles.tabBarRegularTextStyle,
                ),
              ),
              Tab(
                icon: _seletedIndex == 3? Icon(Icons.person, color: ColorStyles.primary) : Icon(Icons.person_2_outlined, color: ColorStyles.primary),
                iconMargin: EdgeInsets.only(bottom: 5.0),
                child: Text(
                  '내 정보',
                  style: _seletedIndex == 3? TextStyles.tabBarBoldTextStyle : TextStyles.tabBarRegularTextStyle,
                ),
              ),
            ],
            indicatorColor: Colors.transparent,
          ),
        ),
        body: Container(
          child: TabBarView(
            controller: _tabController,
            children: _widgetOptions,
          ),
        )
    );
  }
}