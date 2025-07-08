import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OmtButton extends StatelessWidget {
  const OmtButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color,
    this.isLoading = false,
    this.radius=30
  });
  final Function() onPressed;
  final String text;
  final Color? color;
  final double radius;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? Theme.of(context).colorScheme.primary;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        height: 45.h,
        width: 60,
        child: CupertinoButton(
          padding: EdgeInsets.symmetric(vertical: 16),
          onPressed: onPressed,
          color: buttonColor,

          child:
              isLoading
                  ? CircularProgressIndicator.adaptive(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  )
                  : Text(
                    text,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: -0.7,
                    ),
                  ),
        ),
      ),
    );
  }
}
