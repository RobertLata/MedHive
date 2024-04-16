import 'package:flutter/material.dart';

import '../constants/mh_colors.dart';

class MhCheckbox extends StatefulWidget {
  final Function(bool isChecked) isChecked;
  final Text text;

  const MhCheckbox({
    required this.text,
    required this.isChecked,
    super.key,
  });

  @override
  State<MhCheckbox> createState() => _MhCheckboxState();
}

class _MhCheckboxState extends State<MhCheckbox> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Transform.scale(
        scale: 1.2,
        child: Checkbox(
          side: const BorderSide(width: 0.5, color: MhColors.mhBlueDisabled),
          fillColor: MaterialStateProperty.resolveWith(
                  (states) => MhColors.mhBlueRegular),
          hoverColor: Colors.transparent,
          value: _value,
          onChanged: (value) {
            setState(() {
              _value = value ?? false;
              widget.isChecked(_value);
            });
          },
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ),
      Expanded(
        child: widget.text,
      ),
    ]);
  }
}
