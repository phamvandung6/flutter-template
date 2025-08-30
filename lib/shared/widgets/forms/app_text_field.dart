import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom text field variants
enum AppTextFieldType {
  text,
  email,
  password,
  phone,
  number,
  multiline,
}

/// Reusable text field with consistent styling and validation
class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final AppTextFieldType type;
  final TextEditingController? controller;
  final String? initialValue;
  final bool enabled;
  final bool readOnly;
  final bool required;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool obscureText;
  final EdgeInsets? contentPadding;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.type = AppTextFieldType.text,
    this.controller,
    this.initialValue,
    this.enabled = true,
    this.readOnly = false,
    this.required = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.inputFormatters,
    this.textInputAction,
    this.focusNode,
    this.obscureText = false,
    this.contentPadding,
  });

  /// Email text field constructor
  const AppTextField.email({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.initialValue,
    this.enabled = true,
    this.readOnly = false,
    this.required = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.inputFormatters,
    this.textInputAction,
    this.focusNode,
    this.contentPadding,
  })  : type = AppTextFieldType.email,
        maxLines = 1,
        maxLength = null,
        obscureText = false;

  /// Password text field constructor
  const AppTextField.password({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.initialValue,
    this.enabled = true,
    this.readOnly = false,
    this.required = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.inputFormatters,
    this.textInputAction,
    this.focusNode,
    this.contentPadding,
  })  : type = AppTextFieldType.password,
        maxLines = 1,
        maxLength = null,
        obscureText = true;

  /// Multiline text field constructor
  const AppTextField.multiline({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.initialValue,
    this.enabled = true,
    this.readOnly = false,
    this.required = false,
    this.maxLines = 3,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.inputFormatters,
    this.textInputAction,
    this.focusNode,
    this.contentPadding,
  })  : type = AppTextFieldType.multiline,
        obscureText = false;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          RichText(
            text: TextSpan(
              text: widget.label!,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              children: [
                if (widget.required)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          focusNode: _focusNode,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          obscureText: _obscureText,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          keyboardType: _getKeyboardType(),
          textInputAction: widget.textInputAction ?? _getTextInputAction(),
          inputFormatters: widget.inputFormatters ?? _getInputFormatters(),
          validator: widget.validator ?? _getDefaultValidator(),
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            hintText: widget.hint,
            helperText: widget.helperText,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon ?? _getPrefixIcon(),
            suffixIcon: _getSuffixIcon(),
            contentPadding: widget.contentPadding,
            counterText: widget.maxLength != null ? null : '',
          ),
        ),
      ],
    );
  }

  /// Get keyboard type based on field type
  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case AppTextFieldType.email:
        return TextInputType.emailAddress;
      case AppTextFieldType.phone:
        return TextInputType.phone;
      case AppTextFieldType.number:
        return TextInputType.number;
      case AppTextFieldType.multiline:
        return TextInputType.multiline;
      case AppTextFieldType.password:
      case AppTextFieldType.text:
      default:
        return TextInputType.text;
    }
  }

  /// Get text input action based on field type
  TextInputAction _getTextInputAction() {
    switch (widget.type) {
      case AppTextFieldType.multiline:
        return TextInputAction.newline;
      case AppTextFieldType.password:
        return TextInputAction.done;
      default:
        return TextInputAction.next;
    }
  }

  /// Get input formatters based on field type
  List<TextInputFormatter>? _getInputFormatters() {
    switch (widget.type) {
      case AppTextFieldType.phone:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(15),
        ];
      case AppTextFieldType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      default:
        return null;
    }
  }

  /// Get default validator based on field type
  FormFieldValidator<String>? _getDefaultValidator() {
    if (!widget.required) return null;

    switch (widget.type) {
      case AppTextFieldType.email:
        return (value) {
          if (value == null || value.isEmpty) {
            return 'Email is required';
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Please enter a valid email';
          }
          return null;
        };
      case AppTextFieldType.password:
        return (value) {
          if (value == null || value.isEmpty) {
            return 'Password is required';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        };
      case AppTextFieldType.phone:
        return (value) {
          if (value == null || value.isEmpty) {
            return 'Phone number is required';
          }
          if (value.length < 10) {
            return 'Please enter a valid phone number';
          }
          return null;
        };
      default:
        return (value) {
          if (value == null || value.isEmpty) {
            return '${widget.label ?? 'This field'} is required';
          }
          return null;
        };
    }
  }

  /// Get prefix icon based on field type
  Widget? _getPrefixIcon() {
    switch (widget.type) {
      case AppTextFieldType.email:
        return const Icon(Icons.email_outlined);
      case AppTextFieldType.password:
        return const Icon(Icons.lock_outlined);
      case AppTextFieldType.phone:
        return const Icon(Icons.phone_outlined);
      case AppTextFieldType.number:
        return const Icon(Icons.numbers_outlined);
      default:
        return null;
    }
  }

  /// Get suffix icon (including password visibility toggle)
  Widget? _getSuffixIcon() {
    if (widget.type == AppTextFieldType.password) {
      return IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    return widget.suffixIcon;
  }
}

/// Extension for easy form field creation
extension AppTextFieldExtension on Widget {
  /// Add spacing after text field
  Widget withSpacing({double spacing = 16}) {
    return Column(
      children: [
        this,
        SizedBox(height: spacing),
      ],
    );
  }
}
