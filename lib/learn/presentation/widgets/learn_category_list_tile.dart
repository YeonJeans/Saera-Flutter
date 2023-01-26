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
        const Padding(padding: EdgeInsets.all(5.0)),
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
                "상황",
                style: TextStyles.medium00BoldTextStyle,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        Wrap(
          direction: Axis.horizontal,
          children: [
            CategoryIconTile(CategoryData(Icons.diversity_1_outlined, "대화")),
            CategoryIconTile(CategoryData(Icons.fitness_center_outlined, "운동")),
            CategoryIconTile(CategoryData(Icons.credit_card_outlined, "구매")),
            CategoryIconTile(CategoryData(Icons.call_outlined, "전화")),
            CategoryIconTile(CategoryData(Icons.family_restroom_outlined, "경조사")),
            CategoryIconTile(CategoryData(Icons.waving_hand_outlined, "자기소개"))
          ],
        ),
        const Padding(padding: EdgeInsets.all(5.0)),
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
                "문장 유형",
                style: TextStyles.medium00BoldTextStyle,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        Wrap(
          direction: Axis.horizontal,
          children: [
            CategoryIconTile(CategoryData(Icons.question_mark_outlined, "의문문")),
            CategoryIconTile(CategoryData(Icons.close_outlined, "부정문")),
            CategoryIconTile(CategoryData(Icons.elderly_outlined, "존댓말")),
            CategoryIconTile(CategoryData(Icons.sentiment_satisfied_alt_outlined, "감정표현")),
            CategoryIconTile(CategoryData(Icons.record_voice_over_outlined, "ㅢ/ㅟ/ㅚ")),
          ],
        )
      ],
    );
  }
}