import 'package:flutter/material.dart';

/// Clase de utilidades que proporciona widgets y extensiones para añadir
/// animaciones sutiles y mejorar la experiencia de usuario en la aplicación.
class AnimationUtils {
  /// Duración predeterminada para las animaciones en toda la app
  static const Duration defaultDuration = Duration(milliseconds: 300);

  /// Duración para animaciones más rápidas
  static const Duration quickDuration = Duration(milliseconds: 150);

  /// Duración para animaciones más lentas
  static const Duration slowDuration = Duration(milliseconds: 500);

  /// Curva predeterminada para las animaciones en toda la app
  static const Curve defaultCurve = Curves.easeInOut;

  /// Curva para animaciones de aparición
  static const Curve appearCurve = Curves.easeOut;

  /// Curva para animaciones de desaparición
  static const Curve disappearCurve = Curves.easeIn;

  /// Widget que envuelve un hijo con una animación de aparición suave
  static Widget fadeInAnimation({
    required Widget child,
    Duration duration = defaultDuration,
    Curve curve = appearCurve,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        final safeValue = value.clamp(0.0, 1.0);
        return Opacity(opacity: safeValue, child: child ?? const SizedBox());
      },
      child: child,
    );
  }

  /// Widget que envuelve un hijo con una animación de deslizamiento desde abajo
  static Widget slideInAnimation({
    required Widget child,
    Duration duration = defaultDuration,
    Curve curve = appearCurve,
    double offset = 20.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: offset, end: 0.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(offset: Offset(0, value), child: child);
      },
      child: child,
    );
  }

  /// Widget que combina fadeIn y slideIn para una aparición más natural
  static Widget fadeSlideInAnimation({
    required Widget child,
    Duration duration = defaultDuration,
    Curve curve = appearCurve,
    double offset = 20.0,
  }) {
    return fadeInAnimation(
      duration: duration,
      curve: curve,
      child: slideInAnimation(
        duration: duration,
        curve: curve,
        offset: offset,
        child: child,
      ),
    );
  }

  /// Widget que proporciona un efecto de escala al presionar
  static Widget scaleTapAnimation({
    required Widget child,
    required VoidCallback? onTap,
    double scaleValue = 0.95,
  }) {
    return _ScaleTapAnimation(
      onTap: onTap,
      scaleValue: scaleValue,
      child: child,
    );
  }

  /// Widget animado para listas con aparición secuencial de elementos
  static Widget animatedListItem({
    required Widget child,
    required int index,
    Duration delay = const Duration(milliseconds: 50),
    Duration duration = defaultDuration,
    Curve curve = appearCurve,
  }) {
    return _AnimatedListItem(
      index: index,
      delay: delay,
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  /// Widget que proporciona una animación de salida suave
  static Widget fadeOutAnimation({
    required Widget child,
    Duration duration = defaultDuration,
    Curve curve = disappearCurve,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.0, end: 0.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: child,
    );
  }

  /// Widget que proporciona una animación de salida deslizante
  static Widget slideOutAnimation({
    required Widget child,
    Duration duration = defaultDuration,
    Curve curve = disappearCurve,
    double offset = 20.0,
    SlideDirection direction = SlideDirection.down,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: offset),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        final dx = direction == SlideDirection.left
            ? -value
            : direction == SlideDirection.right
            ? value
            : 0.0;
        final dy = direction == SlideDirection.up
            ? -value
            : direction == SlideDirection.down
            ? value
            : 0.0;
        return Transform.translate(offset: Offset(dx, dy), child: child);
      },
      child: child,
    );
  }
}

/// Enum para definir la dirección de las animaciones de deslizamiento
enum SlideDirection { up, down, left, right }

/// Widget interno que implementa la animación de elementos de lista con retardo
class _AnimatedListItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration delay;
  final Duration duration;
  final Curve curve;

  const _AnimatedListItem({
    required this.child,
    required this.index,
    required this.delay,
    required this.duration,
    required this.curve,
  });

  @override
  _AnimatedListItemState createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<_AnimatedListItem> {
  bool _show = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(milliseconds: widget.index * widget.delay.inMilliseconds),
      () {
        if (mounted) {
          setState(() => _show = true);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _show ? 1.0 : 0.0,
      duration: widget.duration,
      curve: widget.curve,
      child: AnimatedSlide(
        offset: _show ? Offset.zero : const Offset(0, 0.1),
        duration: widget.duration,
        curve: widget.curve,
        child: widget.child,
      ),
    );
  }
}

/// Widget interno para manejar el estado de la animación de escala al tap
class _ScaleTapAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleValue;

  const _ScaleTapAnimation({
    required this.child,
    required this.onTap,
    required this.scaleValue,
  });

  @override
  State<_ScaleTapAnimation> createState() => _ScaleTapAnimationState();
}

class _ScaleTapAnimationState extends State<_ScaleTapAnimation> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: widget.onTap == null
          ? null
          : (_) => setState(() => isPressed = true),
      onTapCancel: widget.onTap == null
          ? null
          : () => setState(() => isPressed = false),
      onTapUp: widget.onTap == null
          ? null
          : (_) => setState(() => isPressed = false),
      child: AnimatedScale(
        scale: isPressed ? widget.scaleValue : 1.0,
        duration: AnimationUtils.quickDuration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Extensión para AnimationController que proporciona animaciones comunes
extension AnimationControllerExt on AnimationController {
  /// Iniciar animación de pulse (latido)
  void pulse() {
    forward(from: 0.0).then((_) => reverse());
  }
}

/// Extensión para añadir animaciones a cualquier widget
extension AnimatedWidgetExt on Widget {
  /// Envuelve el widget con una animación de entrada con fade y slide
  Widget withFadeSlideAnimation({
    Duration duration = AnimationUtils.defaultDuration,
    Curve curve = AnimationUtils.appearCurve,
    double offset = 20.0,
  }) {
    return AnimationUtils.fadeSlideInAnimation(
      duration: duration,
      curve: curve,
      offset: offset,
      child: this,
    );
  }

  /// Envuelve el widget con una animación de escala al tap
  Widget withScaleTapAnimation({
    required VoidCallback? onTap,
    double scaleValue = 0.95,
  }) {
    return AnimationUtils.scaleTapAnimation(
      onTap: onTap,
      scaleValue: scaleValue,
      child: this,
    );
  }
}
