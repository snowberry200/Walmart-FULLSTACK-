import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 150,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          image: DecorationImage(
            filterQuality: FilterQuality.high,
            image: AssetImage(
              "images/walmart.png",
            ),
            scale: 2,
            fit: BoxFit.cover,
          )),
    );
  }
}
