import 'package:flutter/material.dart';

class MyPixel extends StatelessWidget {
  // const MyPixel({super.key});
  final innerColor;
  final outerColor;
  final child;
  MyPixel({this.innerColor, this.outerColor, this.child});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: EdgeInsets.all(4),
          color: outerColor,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                color: innerColor,
                child: Center(
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
