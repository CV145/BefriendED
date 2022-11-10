import 'package:flutter/material.dart';

class BouncingButton extends StatefulWidget {
  const BouncingButton({
    Key? key,
    this.label,
    this.onPress,
    this.child,
  }) : super(key: key);

  final String? label;
  final Function? onPress;
  final Widget? child;

  @override
  State<BouncingButton> createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<BouncingButton>
    with SingleTickerProviderStateMixin {
  late Animation<double> _scaleAnimation;
  late AnimationController _scaleController;

  @override
  void initState() {
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation =
        Tween<double>(begin: 1, end: 0.9).animate(_scaleController);
    super.initState();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      child: AnimatedBuilder(
        animation: _scaleController,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child ?? _animatedButton(),
        ),
      ),
    );
  }

  Widget _animatedButton() {
    return Container(
      // margin: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
      padding: const EdgeInsetsDirectional.fromSTEB(10, 12, 10, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x80000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      child: Center(
        child: Text(
          widget.label ?? 'Press',
          style: Theme.of(context).primaryTextTheme.titleMedium,
        ),
      ),
    );
  }

  void _tapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _tapUp(TapUpDetails details) {
    _scaleController.reverse();
    if (widget.onPress != null) {
      widget.onPress!();
    }
  }
}
