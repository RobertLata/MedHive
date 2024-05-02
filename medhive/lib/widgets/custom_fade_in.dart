import 'package:flutter/material.dart';

class CustomFadeIn extends StatefulWidget {
  final ImageProvider<Object> child;
  final Duration duration;
  final ImageProvider<Object>? placeholder;
  final double? height;
  final double? width;
  final BoxFit? fit;

  const CustomFadeIn({
    super.key,
    required this.child,
    required this.duration,
    this.placeholder,
    this.height,
    this.width,
    this.fit,
  });

  @override
  State<CustomFadeIn> createState() => _CustomFadeInState();
}

class _CustomFadeInState extends State<CustomFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
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
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: [
            if (widget.placeholder != null)
              Opacity(
                opacity: 1.0,
                child: Image(
                  image: widget.placeholder!,
                  height: widget.height,
                  width: widget.width,
                  fit: widget.fit,
                ),
              ),
            Opacity(
              opacity: _animation.value,
              child: Image(
                image: widget.child,
                height: widget.height,
                width: widget.width,
                fit: widget.fit,
              ),
            ),
          ],
        );
      },
    );
  }
}
