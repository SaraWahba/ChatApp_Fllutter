import 'package:flutter/material.dart';


class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.width,
    this.height,
    this.textStyle,
    this.color,
  });
  final String text;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final Color? color;

  final void Function()? onTap;

  @override
  State<CustomButton> createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: widget.onTap,
      child: Listener(
        onPointerDown: onPointerDown,
        onPointerUp: onPointerUp,
        child: Container(
          width: widget.width,
          height: widget.height ?? 45,
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
          gradient: LinearGradient(
                colors: [
                  Color(0xFF93E3CF),
                  Color(0xFFFBA6AB),
                ]
            ),
            boxShadow: isPressed
                ? null
                : [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 2,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              widget.text,
              style: widget.textStyle ??
                  TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isPressed ? 14 : 16,
                    color: Colors.white,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  void onPointerDown(PointerDownEvent event) {
    setState(() {
      isPressed = true;
    });
  }

  void onPointerUp(PointerUpEvent event) {
    setState(() {
      isPressed = false;
    });
  }
}