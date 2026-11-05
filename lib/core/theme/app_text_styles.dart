import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class AppTextStyles {
  static const _poppins = 'Poppins';
  static const _urbanist = 'Urbanist';
  static const _jakarta = 'PlusJakartaSans';

  static TextStyle _style(
    String family,
    FontWeight weight,
    double size,
    double lineHeight,
  ) => TextStyle(
    fontFamily: family,
    fontWeight: weight,
    fontSize: size.sp,
    height: lineHeight / size,
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static TextStyle get joinTitle => _style(_poppins, FontWeight.w700, 30, 36);
  static TextStyle get joinSubtitle =>
      _style(_poppins, FontWeight.w400, 16, 24);
  static TextStyle get codeDigit => _style(_poppins, FontWeight.w700, 22, 28);
  static TextStyle get joinHelper => _style(_poppins, FontWeight.w400, 13, 20);
  static TextStyle get joinAction => _style(_poppins, FontWeight.w700, 14, 20);

  static TextStyle get roomTitle =>
      _style(_urbanist, FontWeight.w700, 19.53, 27.34);
  static TextStyle get roomSubtitle =>
      _style(_urbanist, FontWeight.w400, 13.67, 19.53);
  static TextStyle get identityLabel =>
      _style(_urbanist, FontWeight.w500, 13.67, 19.53);
  static TextStyle get identityName =>
      _style(_urbanist, FontWeight.w900, 58.59, 58.59);
  static TextStyle get identityHint =>
      _style(_urbanist, FontWeight.w400, 13.67, 19.53);
  static TextStyle get primaryButton =>
      _style(_urbanist, FontWeight.w700, 18, 28);

  static TextStyle get senderName =>
      _style(_jakarta, FontWeight.w600, 13.23, 18.89);
  static TextStyle get messageBody =>
      _style(_jakarta, FontWeight.w400, 13.23, 18.89);
  static TextStyle get messageTime =>
      _style(_jakarta, FontWeight.w400, 11.34, 15.11);
  static TextStyle get dateLabel =>
      _style(_jakarta, FontWeight.w500, 11.34, 15.11);
  static TextStyle get inputText =>
      _style(_jakarta, FontWeight.w400, 13.23, 18.89);
}
