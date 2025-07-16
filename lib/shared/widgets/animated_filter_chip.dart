import 'package:flutter/material.dart';

/// Widget de filtro animado para mejorar la experiencia de usuario
/// en la selección de criterios de análisis.
class AnimatedFilterChip extends StatefulWidget {
  final String label;
  final bool selected;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const AnimatedFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<AnimatedFilterChip> createState() => _AnimatedFilterChipState();
}

class _AnimatedFilterChipState extends State<AnimatedFilterChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: widget.selected
                ? widget.color.withAlpha(51) // 0.2 * 255 = 51
                : Colors.grey.withAlpha(26), // 0.1 * 255 = 25.5 ≈ 26
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.selected ? widget.color : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: widget.selected ? widget.color : Colors.grey,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  fontWeight: widget.selected
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: widget.selected ? widget.color : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
