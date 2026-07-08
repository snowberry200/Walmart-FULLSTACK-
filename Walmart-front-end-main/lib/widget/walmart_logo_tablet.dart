import 'package:flutter/material.dart';

class WalmartLogo extends StatelessWidget {
  const WalmartLogo({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width / 8,
      height: width / 8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        image: DecorationImage(
          image: AssetImage('images/wall.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
