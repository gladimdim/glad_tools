import 'package:flutter/widgets.dart';

class ScreenSizeService {
  final BuildContext context;

  ScreenSizeService(this.context);

  Size get size => MediaQuery.of(context).size;

  double get height => size.height;

  double get width => size.width;

  double get visibleHeight {
    final viewInsets = EdgeInsets.fromWindowPadding(WidgetsBinding.instance!.window.viewInsets, WidgetsBinding.instance!.window.devicePixelRatio);
    final bottomOffset = viewInsets.bottom;
    const hiddenKeyboard = 0.0;
    final needsPadding = bottomOffset != hiddenKeyboard;
    final offset = needsPadding ? bottomOffset : hiddenKeyboard;
    return height - offset;
  }
}

SizedBox addPaddingWhenKeyboardAppears() {
  final viewInsets = EdgeInsets.fromWindowPadding(WidgetsBinding.instance!.window.viewInsets, WidgetsBinding.instance!.window.devicePixelRatio);
  final bottomOffset = viewInsets.bottom;
  const hiddenKeyboard = 0.0;
  final needsPadding = bottomOffset != hiddenKeyboard;
  final height = needsPadding ? bottomOffset : hiddenKeyboard;
  return SizedBox(height: height,);
}