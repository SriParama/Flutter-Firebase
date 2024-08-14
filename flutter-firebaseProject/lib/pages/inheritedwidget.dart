import 'package:flutter/material.dart';

class ParentWidget extends InheritedWidget {
  ParentWidget({super.key, required this.child, this.color = Colors.grey})
      : super(child: child);
  Color color;
  final Widget child;

  static ParentWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ParentWidget>();
  }

  @override
  bool updateShouldNotify(ParentWidget oldWidget) {
    return color != oldWidget.color;
  }
}
