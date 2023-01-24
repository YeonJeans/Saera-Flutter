import 'package:flutter/material.dart';
import 'package:saera/learn/presentation/widgets/learn_category_icon_tile.dart';
import 'package:saera/style/color.dart';

import '../../../style/font.dart';

class CategoryListTile extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 16, top: 12, bottom: 12),
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: const BoxDecoration(
            color: ColorStyles.saeraYellow,
            borderRadius: BorderRadius.all(Radius.circular(8.0))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Text(
              "장소",
                style: TextStyles.medium00BoldTextStyle,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        Wrap(
          direction: Axis.horizontal,
          children: [
            CategoryIconTile(CategoryData(Icons.local_hospital_outlined, "병원")),
            CategoryIconTile(CategoryData(Icons.corporate_fare_outlined, "회사")),
            CategoryIconTile(CategoryData(Icons.local_convenience_store_outlined, "편의점")),
            CategoryIconTile(CategoryData(Icons.local_cafe_outlined, "카페")),
            CategoryIconTile(CategoryData(Icons.account_balance_outlined, "은행")),
            CategoryIconTile(CategoryData(Icons.checkroom_outlined, "옷가게")),
            CategoryIconTile(CategoryData(Icons.food_bank_outlined, "음식점"))
          ],
        ),
        Container(
          padding: EdgeInsets.only(left: 16, top: 12, bottom: 12),
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: const BoxDecoration(
              color: ColorStyles.saeraYellow,
              borderRadius: BorderRadius.all(Radius.circular(8.0))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Text(
                "발음법",
                style: TextStyles.medium00BoldTextStyle,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        Wrap(
          direction: Axis.horizontal,
          children: [
            CategoryIconTile(CategoryData(Icons.local_hospital_outlined, "병원")),
            CategoryIconTile(CategoryData(Icons.corporate_fare_outlined, "회사")),
            CategoryIconTile(CategoryData(Icons.local_convenience_store_outlined, "편의점")),
            CategoryIconTile(CategoryData(Icons.local_cafe_outlined, "카페")),
            CategoryIconTile(CategoryData(Icons.account_balance_outlined, "은행")),
            CategoryIconTile(CategoryData(Icons.checkroom_outlined, "옷가게")),
            CategoryIconTile(CategoryData(Icons.food_bank_outlined, "음식점"))
          ],
        )
      ],
    );
  }
}