import 'package:flutter/material.dart';
import 'breakpoints.dart';

enum ScreenSize {
  mobile,
  tablet,
  desktop;

  bool get isMobile => this == ScreenSize.mobile;
  bool get isTablet => this == ScreenSize.tablet;
  bool get isDesktop => this == ScreenSize.desktop;
}

class ScreenSizeHelper {
  ScreenSizeHelper._();

  static ScreenSize getSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < Breakpoints.mobile) {
      return ScreenSize.mobile;
    } else if (width < Breakpoints.tablet) {
      return ScreenSize.tablet;
    } else {
      return ScreenSize.desktop;
    }
  }

  static bool isMobile(BuildContext context) => getSize(context).isMobile;
  static bool isTablet(BuildContext context) => getSize(context).isTablet;
  static bool isDesktop(BuildContext context) => getSize(context).isDesktop;
}
