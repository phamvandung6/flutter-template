import 'package:flutter/material.dart';

/// Loading indicator variants
enum LoadingIndicatorType {
  circular,
  linear,
  dots,
  pulse,
}

/// Reusable loading indicator with different variants
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.type = LoadingIndicatorType.circular,
    this.size,
    this.color,
    this.message,
    this.showMessage = false,
  });

  /// Circular loading indicator
  const AppLoadingIndicator.circular({
    super.key,
    this.size,
    this.color,
    this.message,
    this.showMessage = false,
  }) : type = LoadingIndicatorType.circular;

  /// Linear loading indicator
  const AppLoadingIndicator.linear({
    super.key,
    this.color,
    this.message,
    this.showMessage = false,
  })  : type = LoadingIndicatorType.linear,
        size = null;

  /// Dots loading indicator
  const AppLoadingIndicator.dots({
    super.key,
    this.size,
    this.color,
    this.message,
    this.showMessage = false,
  }) : type = LoadingIndicatorType.dots;

  /// Pulse loading indicator
  const AppLoadingIndicator.pulse({
    super.key,
    this.size,
    this.color,
    this.message,
    this.showMessage = false,
  }) : type = LoadingIndicatorType.pulse;
  final LoadingIndicatorType type;
  final double? size;
  final Color? color;
  final String? message;
  final bool showMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;

    final indicator = _buildIndicator(context, effectiveColor);

    if (showMessage && message != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          const SizedBox(height: 16),
          Text(
            message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return indicator;
  }

  Widget _buildIndicator(BuildContext context, Color effectiveColor) {
    final effectiveSize = size ?? 24.0;

    switch (type) {
      case LoadingIndicatorType.circular:
        return SizedBox(
          width: effectiveSize,
          height: effectiveSize,
          child: CircularProgressIndicator(
            strokeWidth: effectiveSize * 0.1,
            valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
          ),
        );

      case LoadingIndicatorType.linear:
        return LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
          backgroundColor: effectiveColor.withOpacity(0.2),
        );

      case LoadingIndicatorType.dots:
        return _DotsLoadingIndicator(
          color: effectiveColor,
          size: effectiveSize,
        );

      case LoadingIndicatorType.pulse:
        return _PulseLoadingIndicator(
          color: effectiveColor,
          size: effectiveSize,
        );
    }
  }
}

/// Custom dots loading animation
class _DotsLoadingIndicator extends StatefulWidget {
  const _DotsLoadingIndicator({
    required this.color,
    required this.size,
  });
  final Color color;
  final double size;

  @override
  State<_DotsLoadingIndicator> createState() => _DotsLoadingIndicatorState();
}

class _DotsLoadingIndicatorState extends State<_DotsLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _animations = List.generate(3, (index) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.2,
            0.6 + index * 0.2,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 3,
      height: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Transform.scale(
                scale: 0.5 + (_animations[index].value * 0.5),
                child: Container(
                  width: widget.size * 0.3,
                  height: widget.size * 0.3,
                  decoration: BoxDecoration(
                    color: widget.color
                        .withOpacity(0.3 + (_animations[index].value * 0.7)),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

/// Custom pulse loading animation
class _PulseLoadingIndicator extends StatefulWidget {
  const _PulseLoadingIndicator({
    required this.color,
    required this.size,
  });
  final Color color;
  final double size;

  @override
  State<_PulseLoadingIndicator> createState() => _PulseLoadingIndicatorState();
}

class _PulseLoadingIndicatorState extends State<_PulseLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.3 + (_animation.value * 0.4)),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
