import 'package:flutter/material.dart';

import '../../constants.dart';

class PaginationBubble extends StatefulWidget {
  final bool isActive;
  final int number;
  PaginationBubble({
    this.isActive = false,
    @required this.number,
  });

  @override
  _PaginationBubbleState createState() => _PaginationBubbleState();
}

class _PaginationBubbleState extends State<PaginationBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: widget.isActive ? kPrimaryColor : Colors.black26,
        shape: BoxShape.circle,
      ),
      child: Text(
        widget.number.toString() ?? "",
        style: TextStyle(
          color: widget.isActive ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
