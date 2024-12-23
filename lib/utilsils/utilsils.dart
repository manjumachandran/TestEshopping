import 'package:flutter/material.dart';

class Utilsils {}
Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double screenWidth(BuildContext context, {double dividedBy = 1}) {
  return screenSize(context).width / dividedBy;
}
double screenHeight(BuildContext context, {double dividedBy = 1}) {
  return screenSize(context).height / dividedBy;
}




class ResponsiveUtils {
  static double getButtonWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.8; 
  }

  static double getButtonHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.1; 
  }
}
