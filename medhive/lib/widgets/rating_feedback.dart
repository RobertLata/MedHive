import 'package:flutter/material.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/constants/mh_margins.dart';
import 'package:medhive/constants/mh_style.dart';
import 'package:medhive/widgets/stars_widget.dart';

class RatingFeedback extends StatefulWidget {
  final Function(double value) ratingValue;
  const RatingFeedback({super.key, required this.ratingValue});

  @override
  State<RatingFeedback> createState() => _RatingFeedbackState();
}

class _RatingFeedbackState extends State<RatingFeedback> {
  String dropdownValue = '3';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DropdownButton<String>(
          value: dropdownValue,
          elevation: 16,
          style: const TextStyle(color: MhColors.mhPurple),
          underline: Container(
            height: 2,
            color: MhColors.mhPurple,
          ),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
              widget.ratingValue(double.parse(dropdownValue));
            });
          },
          items: <String>['1', '2', '3', '4', '5']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: MhTextStyle.bodyRegularStyle
                    .copyWith(color: MhColors.mhPurple),
              ),
            );
          }).toList(),
        ),
        const SizedBox(
          width: MhMargins.standardPadding,
        ),
        StarsWidget(
          starSize: 30,
          starColor: MhColors.mhPurple,
          rating: double.parse(dropdownValue),
        )
      ],
    );
  }
}
