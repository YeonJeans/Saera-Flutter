import 'package:flutter/material.dart';

import 'package:saera/home/presentation/home_screen.dart';
import 'package:saera/learn/presentation/learn_screen.dart';
import 'package:saera/mypage/presentation/mypage_screen.dart';

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
    _tabController = TabController(length: 3, vsync: this);
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
    MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: SizedBox(
          height: 80.0,
          child: TabBar(

            controller: _tabController,
            tabs: <Widget>[
              Tab(
                icon: _seletedIndex == 0 ? Icon(Icons.home, color: Color(0xff4478FF)) : Icon(Icons.home_outlined, color: Color(0xff4478FF)),
                child: Text(
                  '홈',
                  style: TextStyle(color: Color(0xff4478FF), fontSize: 11),
                ),
              ),
              Tab(
                icon: _seletedIndex == 1 ? Icon(Icons.list_alt, color: Color(0xff4478FF)) : Icon(Icons.list_alt_outlined, color: Color(0xff4478FF)),
                child: Text(
                  '학습',
                  style: TextStyle(color: Color(0xff4478FF), fontSize: 11),
                ),
              ),
              Tab(
                icon: _seletedIndex == 2? Icon(Icons.person, color: Color(0xff4478FF),) : Icon(Icons.person_2_outlined, color: Color(0xff4478FF)),
                child: Text(
                  '내 정보',
                  style: TextStyle(color: Color(0xff4478FF), fontSize: 11),
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