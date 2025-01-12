import 'package:flutter/cupertino.dart';

void showAlertDialogOnlyYes(BuildContext context, {String? title, String? content}) {
  showCupertinoDialog<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title ?? 'Akhiri'),
      content: Text(content ?? 'Apakah anda sudah mendatangi tempat dan menandai telah dihadiri?'),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Mengerti'),
        ),
      ],
    ),
  );
}

void showAlertDialogYesOrNo(BuildContext context, {String? title, String? content, Function()? onPressed}) {
  showCupertinoDialog<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title ?? 'Akhiri'),
      content: Text(content ?? 'Apakah anda sudah mendatangi tempat dan menandai telah dihadiri?'),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          onPressed: () {
            Navigator.pop(context);
          },
          isDestructiveAction: true,
          child: const Text('Tidak'),
        ),
        CupertinoDialogAction(
          onPressed: onPressed,
          isDestructiveAction: true,
          child: const Text('Ya'),
        ),
      ],
    ),
  );
}

