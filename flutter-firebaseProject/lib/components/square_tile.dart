import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  var onclickFuc;
  SquareTile({
    super.key,
    required this.imagePath,
    required this.onclickFuc,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onclickFuc();
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
        ),
        child: Image.asset(
          imagePath,
          height: 40,
        ),
      ),
    );
  }
}
