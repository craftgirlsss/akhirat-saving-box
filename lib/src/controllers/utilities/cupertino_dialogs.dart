import 'package:flutter/cupertino.dart';

void customCupertinoDialog(BuildContext context, {Widget? child}) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => Container(
      height: 216,
      padding: const EdgeInsets.only(top: 6.0),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(top: false, child: child ?? const SizedBox()),
    ),
  );
}

void customCupertinoDialogActionSheet(BuildContext context, {Widget? child}) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => child!,
  );
}