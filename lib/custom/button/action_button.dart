import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  final Widget child;
  final EdgeInsets padding;
  final double borderWidth;
  final Color color;
  final double opacity;
  final VoidCallback? onTap;
  final Color bgColor;
  final AnimationController? controller;

  const ActionButton({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.borderWidth = 1.0,
    this.color = Colors.blue,
    this.opacity = 1.0,
    this.controller,
    required this.bgColor,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _outlineAnim;
  late final Animation<double> _fillAnim;
  bool _createdController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      );
      _createdController = true;
    } else {
      _controller = widget.controller!;
    }

    // 设定两个区间：轮廓阶段在 0.0 - 0.5，填充在 0.5 - 1.0
    _outlineAnim = _controller.drive(
      CurveTween(curve: const Interval(0.0, 0.5, curve: Curves.linear)),
    );
    _fillAnim = _controller.drive(
      CurveTween(curve: const Interval(0.5, 1.0, curve: Curves.easeOut)),
    );
  }

  @override
  void dispose() {
    if (_createdController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onLongPressStart(LongPressStartDetails _) => _controller.forward();

  void _onLongPressEnd(LongPressEndDetails _) {
    // 如果正在向前但未完成，则回退
    if (_controller.status == AnimationStatus.forward &&
        _controller.value < 1.0) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final finalContentColor = Theme.of(context).colorScheme.onInverseSurface;

    return GestureDetector(
      onLongPressStart: _onLongPressStart,
      onTap: widget.onTap,
      onLongPressEnd: _onLongPressEnd,
      child: Container(
        // 外层仍保留一个背景以避免透明问题（按需调整）
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.02),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            final outlineProgress = _outlineAnim.value;
            final fillProgress = _fillAnim.value;
            final contentColor =
                (fillProgress >= 0.999) ? finalContentColor : primaryColor;
            final coloredChild = IconTheme(
              data: IconThemeData(color: contentColor),
              child: DefaultTextStyle.merge(
                style: TextStyle(color: contentColor),
                child: widget.child,
              ),
            );
            return CustomPaint(
              painter: _ActionButtonPainter(
                bgColor: widget.bgColor,
                outlineProgress: outlineProgress,
                fillProgress: fillProgress,
                strokeWidth: widget.borderWidth,
                color: widget.color.withOpacity(widget.opacity),
              ),
              child: Padding(
                padding: widget.padding,
                child: coloredChild,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ActionButtonPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final double outlineProgress;
  final double fillProgress;
  final Color bgColor;

  _ActionButtonPainter({
    required this.bgColor,
    required this.outlineProgress,
    required this.fillProgress,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final radius = Radius.circular(size.height / 2);
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, radius);
    canvas.save();
    canvas.clipRRect(rrect);
    if (fillProgress > 0.0) {
      final fillWidth = size.width * fillProgress;
      final fillRect = Rect.fromLTWH(0, 0, fillWidth, size.height);
      final fillRRect = RRect.fromRectAndRadius(fillRect, radius);
      final fillPaint = Paint()
        ..color = bgColor
        ..style = PaintingStyle.fill;
      canvas.drawRRect(fillRRect, fillPaint);
    }

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      final length = metric.length;
      final end = length * outlineProgress;
      if (end > 0) {
        final partial = metric.extractPath(0, end);
        canvas.drawPath(partial, strokePaint);
      }
    }
    canvas.restore();
    if (outlineProgress >= 0.999) {
      final fullPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawRRect(rrect, fullPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ActionButtonPainter oldDelegate) {
    return oldDelegate.outlineProgress != outlineProgress ||
        oldDelegate.fillProgress != fillProgress ||
        oldDelegate.color != color ||
        oldDelegate.bgColor != bgColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
