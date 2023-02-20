import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saera/style/color.dart';
import 'package:saera/style/font.dart';

class ChoiceChipWidget extends StatefulWidget {
  final String chipName;
  ChoiceChipWidget(this.chipName);

  @override
  State<ChoiceChipWidget> createState() => _ChoiceChipWidgetState();
}

class _ChoiceChipWidgetState extends State<ChoiceChipWidget> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(widget.chipName, style: TextStyles.small25TextStyle),
      avatar: _isSelected ? SvgPicture.asset('assets/icons/filter_up.svg') : SvgPicture.asset('assets/icons/filter_down.svg'),
      selected: _isSelected,
      side: BorderSide(color: ColorStyles.filterGray),
      backgroundColor: Colors.white,
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
        });
      },
      selectedColor: widget.chipName == '장소' ? ColorStyles.saeraBlue : ColorStyles.saeraBeige,
    );
  }

}