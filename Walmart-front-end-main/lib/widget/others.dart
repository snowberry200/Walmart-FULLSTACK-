import 'package:flutter/material.dart';

class OthersInfos extends StatelessWidget {
  const OthersInfos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isSmallScreen = width <= 670;
    bool isMediumScreen = width > 670 && width < 1200;

    return SizedBox(
      width: double.infinity,
      child: isSmallScreen
          ? _buildSmallScreenLayout()
          : _buildMediumLargeScreenLayout(isMediumScreen),
    );
  }

  Widget _buildSmallScreenLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Privacy & Security',
          style: TextStyle(decoration: TextDecoration.underline, fontSize: 13),
        ),
        SizedBox(height: 10),
        Text('CA Privacy Rights',
            style:
                TextStyle(decoration: TextDecoration.underline, fontSize: 13)),
        SizedBox(height: 10),
        Text('Do Not Sell My Personal Information',
            style:
                TextStyle(decoration: TextDecoration.underline, fontSize: 13)),
        SizedBox(height: 10),
        Text('Request My Personal Information',
            style:
                TextStyle(decoration: TextDecoration.underline, fontSize: 13)),
        SizedBox(height: 10),
        Text('Help',
            style:
                TextStyle(decoration: TextDecoration.underline, fontSize: 13)),
        SizedBox(height: 10),
        Text('Terms of Use',
            style:
                TextStyle(decoration: TextDecoration.underline, fontSize: 13)),
        SizedBox(height: 10),
        Align(
            alignment: Alignment.bottomRight,
            child: Text(
              '©2022 Walmart. All Rights Reserved.',
              style: TextStyle(fontSize: 10),
            )),
      ],
    );
  }

  Widget _buildMediumLargeScreenLayout(bool isMediumScreen) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
        ),
        // Wrap Row in SingleChildScrollView for horizontal scrolling on medium screens
        isMediumScreen
            ? Expanded(
                flex: 2,
                child: Align(
                  alignment: AlignmentGeometry.topLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _buildLinksRow(),
                  ),
                ),
              )
            : _buildLinksRow(),
        Flexible(
          flex: 1,
          child: const Align(
            alignment: Alignment.bottomRight,
            child: Text(
              '©2022 Walmart. All Rights Reserved.',
              style: TextStyle(fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLinksRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Privacy & Security',
          style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 12,
              letterSpacing: 1.4),
        ),
        SizedBox(width: 10),
        Text('CA Privacy Rights',
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 12,
                letterSpacing: 1.4)),
        SizedBox(width: 10),
        Text('Do Not Sell My Personal Information',
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 12,
                letterSpacing: 1.4)),
        SizedBox(width: 10),
        Text('Request My Personal Information',
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 12,
                letterSpacing: 1.4)),
        SizedBox(width: 20),
        Text('Help',
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 12,
                letterSpacing: 1.4)),
        SizedBox(width: 20),
        Text('Terms of Use',
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 12,
                letterSpacing: 1.4)),
      ],
    );
  }
}
