// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:eshops/core/ui/theme/colors.dart';
import 'package:flutter/material.dart';


class CommonButton extends StatelessWidget {
  const CommonButton({
    Key? key,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.maxLines,
    this.tutorialKey,
    required this.title,
    this.onPressed,
    this.backgroundColor,
    this.borderColor = Colors.transparent,
    this.textColor,
    this.elevation,
    this.padding,
    this.radius,
    this.buttonWidth = double.infinity,
    this.buttonHeight = 48,
    this.fontSize,
    this.fontWeight,
    this.disabledBackgroundColor,
    this.suffix = const SizedBox.shrink(),
    this.prefix = const SizedBox.shrink(),
    @Deprecated(
      'Use onPressed instead. This will be removed in upcoming version',
    )
    this.textStyle,
    this.callback,
  }) : super(key: key);

  final String title;

  final void Function()? onPressed;
  final Color? backgroundColor;
  final Color borderColor;
  final Color? textColor;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final double buttonWidth;
  final double buttonHeight;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextStyle? textStyle;
  final dynamic callback;
  final Widget suffix;
  final Widget prefix;
  final int? maxLines;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final GlobalKey? tutorialKey;
  final Color? disabledBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.chineseBlue,
          elevation: elevation ?? 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 50),
            side: BorderSide(width: 1, color: borderColor),
          ),
          padding: padding ?? const EdgeInsets.all(16),
          disabledBackgroundColor: disabledBackgroundColor,
        ),
        onPressed: onPressed ?? callback,
        child: Row(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: mainAxisAlignment,
          children: [
            prefix,
            Flexible(
              child: Text(
                title,
                key: tutorialKey,
                maxLines: maxLines,
                style: TextStyle(
                  fontSize: fontSize ?? 12,
                  fontWeight: fontWeight ?? FontWeight.w500,
                  color: textColor ?? Colors.white,
                ),
              ),
            ),
            suffix,
          ],
        ),
      ),
    );
  }
}