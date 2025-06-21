import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OmtTextField extends StatelessWidget {
  const OmtTextField({
    super.key,
    this.hintText = '',
    required this.onSaved,
    this.suffixIcon = null,
    this.obscureText=false,
    required this.validator
  });
  final String? hintText;
  final Function(String) onSaved;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(obscureText: obscureText,
      autocorrect: false,
      validator: validator,
      onSaved: (newValue) => onSaved(newValue!),
      decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
