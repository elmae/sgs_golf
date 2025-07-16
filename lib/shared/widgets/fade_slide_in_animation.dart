import 'package:flutter/material.dart';

/// Widget que proporciona una animación de entrada con fade y slide
/// y permite especificar un delay inicial para animaciones secuenciales
class FadeSlideInAnimation extends StatefulWidget {
  final Widget child;
  final double delay;
  final AnimationController controller;
  final Offset beginOffset;

  const FadeSlideInAnimation({
    super.key,
    required this.child,
    this.delay = 0.0,
    required this.controller,
    this.beginOffset = const Offset(0, 30),
  });

  @override
  State<FadeSlideInAnimation> createState() => _FadeSlideInAnimationState();
}

class _FadeSlideInAnimationState extends State<FadeSlideInAnimation> {
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Calcula la animación con el delay especificado
    final curvedAnimation = CurvedAnimation(
      parent: widget.controller,
      curve: Interval(
        widget.delay.clamp(
          0.0,
          0.9,
        ), // El delay no puede superar 0.9 para asegurar que la animación ocurre
        1.0,
        curve: Curves.easeOut,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(curvedAnimation);
    _slideAnimation = Tween<Offset>(
      begin: widget.beginOffset,
      end: Offset.zero,
    ).animate(curvedAnimation);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: _slideAnimation.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
