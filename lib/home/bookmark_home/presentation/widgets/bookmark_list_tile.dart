import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saera/style/color.dart';

class BookmarkListTile extends StatelessWidget {
  BookmarkListTile(this._data);

  final BookmarkListData _data;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 11),
      title: Transform.translate(
        offset: const Offset(0, 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _data.statement,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: "NotoSansKR",
                      fontWeight: FontWeight.normal),
                ),
                Row(
                  children: [
                    Chip(
                      backgroundColor: ColorStyles.saeraBeige,
                      label: Text(
                        _data.tag,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: "NotoSansKR",
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            IconButton(
                onPressed: null,
                icon: SvgPicture.asset('assets/icons/star_fill.svg')
            )
          ],
        ),
      )
    );
  }
}

class BookmarkListData {
  final String statement;
  final String tag;

  BookmarkListData(this.statement, this.tag);
}