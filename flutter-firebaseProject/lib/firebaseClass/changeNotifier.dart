import 'package:emailfirebase/pages/Dashboard/educationScreen.dart';
import 'package:emailfirebase/pages/Dashboard/personalScreen.dart';
import 'package:flutter/cupertino.dart';

class PageSwap extends ChangeNotifier {
  final controller = PageController();
  int totalTab = 2;
  int currentPage = 0;
  void gotoNextPage() {
    if (currentPage < totalTab) {
      controller.nextPage(duration: Duration(seconds: 2), curve: Curves.easeIn);
      currentPage = currentPage + 1;
      notifyListeners();
    } else {}
  }

  void gotoCustomPage(int index) {
    // if (currentPage > 0) {
    controller.jumpToPage(
      index,
      // duration: Duration(milliseconds: 500), curve: Curves.easeInOut
    );
    currentPage = index;
    notifyListeners();
    // }
  }
}
