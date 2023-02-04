import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saera/learn/search_learn/presentation/search_learn_screen.dart';

import '../../../style/color.dart';
import '../../../style/font.dart';

class CategoryIconTile extends StatelessWidget {
  const CategoryIconTile(this._data);

  final CategoryData _data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 23.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () => Get.to(SearchPage(), arguments: _data.text),
              icon: Icon(
                _data.icon,
                size: 40,
                color: ColorStyles.primary,
              )
          ),
          Text(
            "  ${_data.text}",
            style: TextStyles.regularBlueTextStyle,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class CategoryData {
  final IconData icon;
  final String text;

  CategoryData(this.icon, this.text);
}