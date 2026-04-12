import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'expense_new.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  ExpenseScreenState createState() => ExpenseScreenState();
}

class ExpenseScreenState extends State<ExpenseScreen> {
  final Color blueColor = const Color(0xFF9FE2FB);
  DateTime _focusedMonth = DateTime.now();
  final Map<String, List<ExpenseEntry>> _monthlyEntries = {};

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Food', 'color': const Color(0xFF5BBFEA)},
    {'name': 'Supplement', 'color': const Color(0xFFB57BDB)},
    {'name': 'Toy', 'color': const Color(0xFF9FE2FB)},
    {'name': 'Vet bills', 'color': const Color(0xFFFFB6C1)},
  ];

  String get _monthKey =>
      '${_focusedMonth.year}-${_focusedMonth.month.toString().padLeft(2, '0')}';

  List<ExpenseEntry> get _currentEntries => _monthlyEntries[_monthKey] ?? [];
  double get _totalAmount => _currentEntries.fold(0, (sum, e) => sum + e.amount);

  Map<String, double> get _categoryTotals {
    final Map<String, double> totals = {};
    for (final e in _currentEntries) {
      totals[e.category] = (totals[e.category] ?? 0) + e.amount;
    }
    return totals;
  }

  Color _colorForCategory(String name) {
    return _categories.firstWhere(
      (c) => c['name'] == name,
      orElse: () => {'color': Colors.grey},
    )['color'];
  }

  void _previousMonth() => setState(() =>
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1));

  void _nextMonth() => setState(() =>
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1));

  String _monthLabel() {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[_focusedMonth.month - 1]} ${_focusedMonth.year}';
  }

  // public method ให้ DiaryScreen เรียกได้
  Future<void> goToNewExpense() => _goToNewExpense();

  Future<void> _goToNewExpense() async {
    final result = await Navigator.push<ExpenseEntry>(
      context,
      MaterialPageRoute(builder: (_) => const NewExpenseScreen()),
    );
    if (result != null) {
      setState(() {
        _monthlyEntries[_monthKey] = [..._currentEntries, result];
      });
    }
  }

  void _deleteEntry(String id) {
    setState(() {
      _monthlyEntries[_monthKey] = _currentEntries.where((e) => e.id != id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.chevron_left), onPressed: _previousMonth),
                Text('< ${_monthLabel()} >', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.chevron_right), onPressed: _nextMonth),
              ],
            ),
          ),

          // Donut chart
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(180, 180),
                  painter: _DonutChartPainter(
                    data: _categoryTotals,
                    colors: {for (final c in _categories) c['name'] as String: c['color'] as Color},
                    total: _totalAmount,
                  ),
                ),
                Text(
                  '\$ ${_totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF5BBFEA)),
                ),
              ],
            ),
          ),

          // Legend
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            child: Wrap(
              spacing: 16,
              runSpacing: 4,
              children: _categories.map((cat) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10, height: 10,
                      decoration: BoxDecoration(color: cat['color'], shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 4),
                    Text(cat['name'], style: const TextStyle(fontSize: 12)),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: _currentEntries.isEmpty
                ? const Center(
                    child: Text('ยังไม่มีรายการ\nกด + เพื่อเพิ่ม',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _currentEntries.length,
                    itemBuilder: (_, i) => _buildExpenseRow(_currentEntries[i]),
                  ),
          ),
        ],
      ),
      // ไม่มี FAB แล้ว
    );
  }

  Widget _buildExpenseRow(ExpenseEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Container(
            width: 12, height: 12,
            decoration: BoxDecoration(color: _colorForCategory(entry.category), shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(entry.category, style: const TextStyle(fontSize: 15))),
          Text('\$ ${entry.amount.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _deleteEntry(entry.id),
            child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
          ),
        ],
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final Map<String, double> data;
  final Map<String, Color> colors;
  final double total;

  _DonutChartPainter({required this.data, required this.colors, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    if (total == 0) {
      final paint = Paint()
        ..color = Colors.grey.shade200
        ..style = PaintingStyle.stroke
        ..strokeWidth = 30;
      canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2 - 15, paint);
      return;
    }

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2 - 15,
    );

    double startAngle = -math.pi / 2;
    for (final entry in data.entries) {
      final sweep = (entry.value / total) * 2 * math.pi;
      final paint = Paint()
        ..color = colors[entry.key] ?? Colors.grey
        ..style = PaintingStyle.stroke
        ..strokeWidth = 30
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}