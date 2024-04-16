import 'package:flutter/material.dart';
import 'package:medhive/services/authentication_service.dart';

import '../constants/mh_colors.dart';
import '../constants/mh_margins.dart';
import '../constants/mh_style.dart';

enum TextFieldType { email, password, name }

class MhTextFormField extends StatefulWidget {
  final TextFieldType textFieldType;
  final String hintName;
  final TextEditingController controller;
  final FormFieldValidator? validatorInfo;
  final String? errorMessage;
  final bool isEnabled;

  const MhTextFormField({
    required this.textFieldType,
    required this.hintName,
    required this.controller,
    this.validatorInfo,
    this.errorMessage,
    this.isEnabled = true,
    super.key,
  });

  @override
  State<MhTextFormField> createState() => _MhTextFormFieldState();
}

class _MhTextFormFieldState extends State<MhTextFormField> {
  late bool _isObscure;
  final FocusNode _focusNode = FocusNode();
  bool _hasInputError = false;

  @override
  void initState() {
    _isObscure = widget.textFieldType == TextFieldType.password;
    _focusNode.addListener(() {
      switch (widget.textFieldType) {
        case TextFieldType.email:
          if (!_focusNode.hasFocus) {
            if (AuthenticationService.emailValidation(
                widget.controller.text, context) ==
                null) {
              setState(() {
                _hasInputError = false;
              });
            } else {
              setState(() {
                _hasInputError = true;
              });
            }
          }
          break;
        case TextFieldType.password:
          if (!_focusNode.hasPrimaryFocus) {
            if (AuthenticationService.passwordValidation(
                widget.controller.text, context) ==
                null) {
              setState(() {
                _hasInputError = false;
              });
            } else {
              setState(() {
                _hasInputError = true;
              });
            }
          }
          break;
        default:
          break;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.isEnabled,
      keyboardType: widget.textFieldType == TextFieldType.email
          ? TextInputType.emailAddress
          : null,
      focusNode: _focusNode,
      controller: widget.controller,
      validator: widget.validatorInfo,
      obscureText: _isObscure,
      decoration: InputDecoration(
        helperText: '',
        helperStyle: MhTextStyle.textFieldErrorStyle,
        errorStyle: MhTextStyle.textFieldErrorStyle,
        errorText: _hasInputError ? widget.errorMessage : null,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        hintText: widget.hintName,
        floatingLabelStyle: MhTextStyle.bodyRegularStyle.copyWith(
          color: MhColors.mhBlueDark,
        ),
        suffixIcon: widget.textFieldType == TextFieldType.password
            ? IconButton(
          splashColor: Colors.transparent,
          icon: Icon(
            _isObscure ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
            color: MhColors.mhBlueLight,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        )
            : null,
        border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(MhMargins.mhTextFieldBorderRadius)),
        enabledBorder: OutlineInputBorder(
          borderSide:
          const BorderSide(width: 0.5, color: MhColors.mhBlueDisabled),
          borderRadius: BorderRadius.circular(MhMargins.mhTextFieldBorderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: MhColors.mhBlueRegular),
          borderRadius: BorderRadius.circular(MhMargins.mhTextFieldBorderRadius),
        ),
      ),
    );
  }
}
