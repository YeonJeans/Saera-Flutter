import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saera/home/bookmark_home/presentation/widgets/bookmark_home_background_image.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent
              ),
              icon: SvgPicture.asset(
                'assets/icons/back.svg',
                fit: BoxFit.scaleDown,
              ),
              label: const Text(' 뒤로', style: TextStyle(
                  color: ColorStyles.primary,
                  fontSize: 18,
                  fontFamily: "NotoSansKR",
                  fontWeight: FontWeight.normal))

          )
        ],
      ),
    );

    return Stack(
      children: [
        BookmarkBackgroundImage(key: null,),
        SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: <Widget>[
                  appBarSection
                ],
              ),
            )
        )
      ],
    );
  }
}
