import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';

class DateSelectorBar extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const DateSelectorBar({super.key, required this.onDateSelected});

  @override
  State<DateSelectorBar> createState() => _DateSelectorBarState();
}

class _DateSelectorBarState extends State<DateSelectorBar> {
  DateTime _selectedDate = DateTime.now();
  late List<DateTime> _dates;

  @override
  void initState() {
    super.initState();
    // Gera uma lista com 7 dias antes e 7 dias depois do dia atual
    final now = DateTime.now();
    _dates = List.generate(15, (index) => now.add(Duration(days: index - 7)));
  }

  String _getDayLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    final difference = targetDate.difference(today).inDays;

    if (difference == 0) return 'HOJE';
    if (difference == -1) return 'ONTEM';
    if (difference == 1) return 'AMANHÃ';

    // Formata o dia da semana abreviado (ex: SEG, TER) em maiúsculas
    return DateFormat('EEE', 'pt_PT').format(date).toUpperCase();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      color: AppColors.background,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _dates.length,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemBuilder: (context, index) {
          final date = _dates[index];
          final isSelected = _isSameDay(date, _selectedDate);

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
              widget.onDateSelected(date);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryOrange : AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? AppColors.primaryOrange : AppColors.surfaceLight,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getDayLabel(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('dd/MM').format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}