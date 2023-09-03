import "package:flutter/material.dart";

class ScrollDeltaChangeNotifier extends ChangeNotifier {
  ScrollDeltaChangeNotifier(this.dy);

  double dy;

  void scroll(double dy) {
    double fixed = (10 * dy ~/ 10).toDouble().clamp(-2, 2);
    if (fixed != this.dy) {
      this.dy = fixed;
      notifyListeners();
    }
  }
}
