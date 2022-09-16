import 'dart:async';

import 'package:flutter/material.dart';

/// dealy in milliseconds
class DealySizedBox extends StatefulWidget {
  const DealySizedBox({
    Key? key,
    this.width,
    this.height,
    this.child,
    this.delay,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Widget? child;
  final int? delay;

  @override
  State<DealySizedBox> createState() => _DealySizedBoxState();
}

class _DealySizedBoxState extends State<DealySizedBox> {
  bool _isTime = false;
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(milliseconds: widget.delay ?? 400),
      () => setState(() {
        _isTime = true;
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: _isTime ? widget.child : null,
    );
  }
}
