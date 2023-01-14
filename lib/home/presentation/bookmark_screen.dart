import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saera/style/color.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  Widget build(BuildContext context) {
    Widget appBarSection = Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
              onPressed: null,
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/back.svg',
                    fit: BoxFit.scaleDown,
                  ),
                  const Text(
                      '뒤로',
                      style: TextStyle(color: ColorStyles.saeraBlue, fontSize: 18, fontFamily: "NotoSansKR", fontWeight: FontWeight.normal)
                  )
                ],
              )
          )
        ],
      ),
    );

    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/home_detail_bg.png'),
                    fit: BoxFit.fill
                )
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              children: <Widget>[
                appBarSection
              ],
            ),
          ),
        )
    );
  }
}
