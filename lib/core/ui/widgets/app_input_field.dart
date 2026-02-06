import 'package:eshops/core/ui/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AppInputField extends StatefulWidget {
  const AppInputField({
    Key? key,
    this.controller,
    this.focusNode,
    this.autovalidateMode,
    this.keyboardType,
    this.textInputAction,
    this.decoration,
    this.validator,
    this.showSuffixIconAlways = false,
    this.enabled = true,
    this.autofocus = false,
    this.initialValue,
    this.errorText,
    this.formattersArray = const [],
    this.onChanged,
    this.onFieldSubmit,
    this.handleDropdown,
    this.handleDate,
    this.datePicketIcon,
    this.dropdownArrowIcon,
    this.dropdownBuilder,
    this.dateBuilder,
    this.fetchingBuilderContents,
    this.obscureText = false,
    this.labelText,
    this.hintText,
    this.isPassword = false,
    this.borderColor,
    this.focusedBorderColor,
    this.labelColor,
  }) : super(key: key);
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final AutovalidateMode? autovalidateMode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final InputDecoration? decoration;
  final String? Function(String?)? validator;
  final bool showSuffixIconAlways;
  final bool enabled;
  final bool autofocus;
  final String? initialValue;
  final String? errorText;
  final List<TextInputFormatter> formattersArray;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmit;
  final void Function()? handleDropdown;
  final void Function()? handleDate;
  final Widget? datePicketIcon;
  final Widget? dropdownArrowIcon;
  final Widget Function(Widget textField)? dropdownBuilder;
  final Widget Function(Widget textField)? dateBuilder;
  final bool? fetchingBuilderContents;
  final bool obscureText;
  final String? labelText;
  final String? hintText;
  final bool isPassword;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? labelColor;

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  bool hasFocus = false;
  final _textWidgetKey = GlobalKey();
  late final TextEditingController _textEditingController;
  late bool _obscureText;

  bool get isBuilderInput =>
      widget.dropdownBuilder != null || widget.dateBuilder != null;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.initialValue);
    _obscureText = widget.obscureText;
    if (!widget.showSuffixIconAlways) {
      widget.focusNode?.addListener(() {
        if (hasFocus != widget.focusNode?.hasFocus) {
          if (mounted) {
            setState(() {
              hasFocus = widget.focusNode!.hasFocus;
            });
          }
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant AppInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled &&
        oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != _textEditingController.text &&
        widget.controller == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _textEditingController.text = widget.initialValue ?? "";
      });
    } else if (widget.controller == null &&
        oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != _textEditingController.text) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _textEditingController.text = widget.initialValue ?? "";
      });
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultBorderColor = widget.borderColor ?? 
        AppColors.auroMetalSaurus;
    final defaultFocusedBorderColor = widget.focusedBorderColor ?? 
        AppColors.primary;
    final defaultLabelColor = widget.labelColor ?? 
        AppColors.auroMetalSaurus;
    InputDecoration effectiveDecoration = widget.decoration ??
        InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          labelStyle: TextStyle(
            fontSize: 14,
            color: defaultLabelColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: defaultBorderColor,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: defaultBorderColor,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: defaultFocusedBorderColor,
              width: 2.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
        );

    Widget? suffixIcon;
    if (isBuilderInput) {
      if (widget.fetchingBuilderContents ?? false) {
        suffixIcon = const SizedBox(
          height: 20,
          width: 20,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(strokeWidth: 2.0),
          ),
        );
      } else if (widget.dropdownBuilder != null) {
        suffixIcon = IconButton(
          onPressed: widget.handleDropdown,
          icon: widget.dropdownArrowIcon ??
              Icon(
                Icons.keyboard_arrow_down,
                color: widget.enabled ? null : const Color(0xFFF0F1F3),
              ),
        );
      } else {
        suffixIcon = IconButton(
          onPressed: widget.handleDate,
          icon: widget.datePicketIcon ??
              Icon(
                Icons.calendar_month,
                color: widget.enabled ? null : const Color(0xFFF0F1F3),
              ),
        );
      }
    } else if (widget.isPassword) {
      suffixIcon = IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColors.error,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    } else if (widget.showSuffixIconAlways) {
      suffixIcon = widget.decoration?.suffixIcon;
    } else if (hasFocus) {
      suffixIcon = widget.decoration?.suffixIcon;
    }

    effectiveDecoration = effectiveDecoration.copyWith(
      errorText: widget.errorText,
      filled: !widget.enabled && !isBuilderInput ? true : null,
      enabled: isBuilderInput ? false : widget.enabled,
      fillColor: widget.enabled || isBuilderInput
          ? null
          : const Color(0xFFF0F1F3),
      suffixIcon: suffixIcon,
    );

    final textFormField = TextFormField(
      key: _textWidgetKey,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      controller: widget.controller ?? _textEditingController,
      autovalidateMode: widget.autovalidateMode,
      inputFormatters: widget.formattersArray.isNotEmpty
          ? widget.formattersArray
          : [],
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: widget.isPassword ? _obscureText : widget.obscureText,
      decoration: effectiveDecoration,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmit,
    );

    if (widget.dropdownBuilder != null) {
      return GestureDetector(
        onTap: widget.handleDropdown,
        child: widget.dropdownBuilder?.call(textFormField),
      );
    }
    if (widget.dateBuilder != null) {
      return GestureDetector(
        onTap: widget.handleDate,
        child: widget.dateBuilder?.call(textFormField),
      );
    }

    return textFormField;
  }
}
