import 'package:flutter/material.dart';

/// Widget que proporciona un selector de fechas animado para mejorar
/// la experiencia de usuario en la selección de fechas.
class AnimatedDateRangePicker extends StatefulWidget {
  final DateTimeRange? selectedRange;
  final Function(DateTimeRange) onRangeSelected;
  final String title;
  final Color color;

  const AnimatedDateRangePicker({
    super.key,
    this.selectedRange,
    required this.onRangeSelected,
    required this.title,
    this.color = Colors.blue,
  });

  @override
  State<AnimatedDateRangePicker> createState() =>
      _AnimatedDateRangePickerState();
}

class _AnimatedDateRangePickerState extends State<AnimatedDateRangePicker>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Future<void> _selectDateRange() async {
    final initialRange =
        widget.selectedRange ??
        DateTimeRange(
          start: DateTime.now().subtract(const Duration(days: 7)),
          end: DateTime.now(),
        );

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: initialRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: ColorScheme.light(primary: widget.color)),
          child: child!,
        );
      },
    );

    if (picked != null) {
      widget.onRangeSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasSelectedRange = widget.selectedRange != null;

    final String rangeText = hasSelectedRange
        ? '${_formatDate(widget.selectedRange!.start)} - ${_formatDate(widget.selectedRange!.end)}'
        : 'Seleccionar fechas';

    return Column(
      children: [
        InkWell(
          onTap: _toggleExpand,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: widget.color,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: Column(
            children: [
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectDateRange,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: hasSelectedRange
                        ? widget.color.withAlpha(26)
                        : Colors.grey.withAlpha(26), // 0.1 * 255 = 25.5 ≈ 26
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: hasSelectedRange
                          ? widget.color.withAlpha(128)
                          : Colors.grey.withAlpha(
                              77,
                            ), // 0.5 * 255 = 127.5 ≈ 128, 0.3 * 255 = 76.5 ≈ 77
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: hasSelectedRange ? widget.color : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          rangeText,
                          style: TextStyle(
                            color: hasSelectedRange
                                ? Colors.black87
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                      if (hasSelectedRange)
                        IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          onPressed: () {
                            widget.onRangeSelected(
                              DateTimeRange(
                                start: DateTime.now().subtract(
                                  const Duration(days: 7),
                                ),
                                end: DateTime.now(),
                              ),
                            );
                          },
                          color: Colors.grey,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
