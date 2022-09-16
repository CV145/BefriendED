import 'dart:async';

import 'package:flutter/material.dart';

/// dealy in milliseconds
class DealyExpanded extends StatefulWidget {
  const DealyExpanded({
    Key? key,
    required this.child,
    this.delay,
  }) : super(key: key);

  final Widget child;
  final int? delay;

  @override
  State<DealyExpanded> createState() => _DealyExpandedState();
}

class _DealyExpandedState extends State<DealyExpanded> {
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
    return _isTime
        ? Expanded(
            child: widget.child,
          )
        : const SizedBox();
  }
}
