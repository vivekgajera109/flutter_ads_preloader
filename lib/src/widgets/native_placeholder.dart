import 'package:flutter/widgets.dart';

class NativePlaceholder extends StatelessWidget {
  final double height;
  const NativePlaceholder({super.key, this.height = 140});

  @override
  Widget build(BuildContext context) {
    return Container(height: height);
  }
}
