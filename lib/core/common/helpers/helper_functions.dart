import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final String imageBasePath='https://image.tmdb.org/t/p/w500';
void showToast(String message,{bool isError=false}) {
  final context = navigatorKey.currentContext;
  if (context == null) return;

  DelightToastBar(snackbarDuration: Duration(milliseconds: 1500),
    autoDismiss: true,
    position: DelightSnackbarPosition.top,
    builder: (_) => ToastCard(
      color: isError
          ? Colors.red
          : Theme.of(context).colorScheme.primary,
      title: Text(
        message,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
      ),
    ),
  ).show(context);
}
