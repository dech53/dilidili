import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  final Widget child;
  final EdgeInsets padding;
  final double borderWidth;
  final Color color;
  final double opacity;
  final Function? onTap;
  final Color bgColor;
  final AnimationController? controller;

  const ActionButton({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.borderWidth = 1.0,
    this.color = Colors.blue,
    this.opacity = 0.5,
    this.controller,
    required this.bgColor,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 600),
        );
  }

  void _onLongPressStart(_) => _controller.forward();

  void _onLongPressEnd(_) {
    if (_controller.status == AnimationStatus.forward &&
        _controller.value < 1.0) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: _onLongPressStart,
      onTap: () => widget.onTap!(),
      onLongPressEnd: _onLongPressEnd,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onInverseSurface,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: AnimatedBuilder(
          animation: _controller.view,
          builder: (_, __) {
            return CustomPaint(
              painter: _ActionButtonPainter(
                bgColor: widget.bgColor,
                progress: _controller.value,
                strokeWidth: widget.borderWidth,
                // ignore: deprecated_member_use
                color: widget.color.withOpacity(widget.opacity),
              ),
              child: Padding(
                padding: widget.padding,
                child: widget.child,
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
  final double progress;
  final Color bgColor;
  _ActionButtonPainter({
    required this.bgColor,
    required this.progress,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final radius = Radius.circular(size.height / 2);
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, radius);

    final fillPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill;

    final fillWidth = size.width * progress;
    final fillRect = Rect.fromLTWH(0, 0, fillWidth, size.height);
    final fillRRect =
        RRect.fromRectAndRadius(fillRect, Radius.circular(size.height / 2));

    canvas.clipRRect(rrect);
    canvas.drawRRect(fillRRect, fillPaint);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final Rect rect = Offset.zero & size;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
