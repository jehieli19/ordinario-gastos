import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/categories.dart';

class ExpensesFilters extends StatefulWidget {
  final Function(DateTimeRange?, Set<String>, String) onChanged;
  const ExpensesFilters({super.key, required this.onChanged});

  @override
  State<ExpensesFilters> createState() => _ExpensesFiltersState();
}

class _ExpensesFiltersState extends State<ExpensesFilters> {
  DateTimeRange? _dateRange;
  final Set<String> _selectedCategories = {};
  String _search = '';
  Timer? _debounce;

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() => _search = value);
      widget.onChanged(_dateRange, _selectedCategories, _search);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search and Date Row
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              onPressed: () async {
                final now = DateTime.now();
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(now.year - 2),
                  lastDate: DateTime(now.year + 2),
                  initialDateRange: _dateRange,
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                          primary: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() => _dateRange = picked);
                  widget.onChanged(_dateRange, _selectedCategories, _search);
                }
              },
              icon: Icon(
                Icons.calendar_month,
                color: _dateRange != null ? Theme.of(context).colorScheme.primary : null,
              ),
              style: IconButton.styleFrom(
                 backgroundColor: _dateRange != null ? Theme.of(context).colorScheme.primaryContainer : null,
              ),
            ),
            if (_dateRange != null)
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () {
                   setState(() => _dateRange = null);
                   widget.onChanged(_dateRange, _selectedCategories, _search);
                },
              ),
          ],
        ),
        const SizedBox(height: 12),
        // Categories Horizontal List
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: categoryNames.values.map((cat) {
              final selected = _selectedCategories.contains(cat);
              final catData = categoryDetails[Category.values.firstWhere(
                  (e) => categoryNames[e] == cat,
                  orElse: () => Category.others)];
              
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(cat),
                  selected: selected,
                  showCheckmark: false,
                  avatar: selected ? null : Icon(catData?.icon, size: 16, color: catData?.color),
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.black87,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                  backgroundColor: Colors.white,
                  selectedColor: Theme.of(context).colorScheme.primary,
                  side: BorderSide(
                    color: selected
                        ? Colors.transparent
                        : Colors.grey.shade300,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _selectedCategories.add(cat);
                      } else {
                        _selectedCategories.remove(cat);
                      }
                    });
                    widget.onChanged(_dateRange, _selectedCategories, _search);
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
