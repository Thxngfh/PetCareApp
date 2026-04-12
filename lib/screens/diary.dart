import 'package:flutter/material.dart';
import 'package:pethug/models/diary_entry.dart';
import 'package:pethug/screens/diary_new.dart';
import 'package:pethug/screens/diary_photo.dart';
import 'package:pethug/screens/expense_screen.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  DiaryScreenState createState() => DiaryScreenState();
}

class DiaryScreenState extends State<DiaryScreen> {
  DateTime _focusedMonth = DateTime.now();
  int _tabIndex = 0;
  final List<DiaryEntry> _entries = [];
  final Color blueColor = const Color(0xFF9FE2FB);
  final GlobalKey<ExpenseScreenState> _expenseKey = GlobalKey<ExpenseScreenState>();

  int get currentTab => _tabIndex;
  void goToNewDiary() => _goToNewDiary();
  void goToNewExpense() => _expenseKey.currentState?.goToNewExpense();

  void _previousMonth() => setState(() =>
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1));

  void _nextMonth() => setState(() =>
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1));

  String _monthLabel() {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[_focusedMonth.month - 1]} ${_focusedMonth.year}';
  }

  String _dayLabel(DateTime date) {
    const days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    return days[date.weekday - 1];
  }

  List<DiaryEntry> get _filteredEntries => _entries
      .where((e) => e.date.year == _focusedMonth.year && e.date.month == _focusedMonth.month)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));

  void _deleteEntry(String id) =>
      setState(() => _entries.removeWhere((e) => e.id == id));

  Future<void> _goToNewDiary({DiaryEntry? existing}) async {
    final result = await Navigator.push<DiaryEntry>(
      context,
      MaterialPageRoute(builder: (_) => NewDiaryScreen(existingEntry: existing)),
    );
    if (result != null) {
      setState(() {
        if (existing != null) {
          final idx = _entries.indexWhere((e) => e.id == existing.id);
          if (idx != -1) _entries[idx] = result;
        } else {
          _entries.add(result);
        }
      });
    }
  }

  void _confirmDelete(DiaryEntry entry) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('ลบบันทึก?'),
        content: Text('ต้องการลบ "${entry.note}" ใช่ไหม?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก')),
          TextButton(
            onPressed: () { Navigator.pop(context); _deleteEntry(entry.id); },
            child: const Text('ลบ', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(children: [_buildTab('Diary', 0), _buildTab('Expense', 1)]),

          if (_tabIndex == 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.chevron_left), onPressed: _previousMonth),
                Text('< ${_monthLabel()} >', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.chevron_right), onPressed: _nextMonth),
              ],
            ),
            Expanded(
              child: _filteredEntries.isEmpty
                  ? const Center(
                      child: Text('ยังไม่มีบันทึก\nกด + เพื่อเพิ่ม',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey)),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredEntries.length,
                      itemBuilder: (_, index) => _buildEntryCard(_filteredEntries[index]),
                    ),
            ),
          ],

          if (_tabIndex == 1)
            Expanded(child: ExpenseScreen(key: _expenseKey)),
        ],
      ),

      floatingActionButton: _tabIndex == 0
          ? FloatingActionButton(
              heroTag: 'photo',
              mini: true,
              backgroundColor: Colors.white,
              elevation: 2,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DiaryPhotoScreen(entries: _entries),
                ),
              ),
              child: Icon(Icons.photo_library_outlined, color: blueColor),
            )
          : null,
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _tabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tabIndex = index),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(label,
                  style: TextStyle(
                    color: isSelected ? blueColor : Colors.grey,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  )),
            ),
            Container(height: 2, color: isSelected ? blueColor : Colors.transparent),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryCard(DiaryEntry entry) {
    return Dismissible(
      key: Key(entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => _deleteEntry(entry.id),
      child: GestureDetector(
        onTap: () => _goToNewDiary(existing: entry),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_dayLabel(entry.date), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  Text('${entry.date.day}',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF5BBFEA))),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(child: Text(entry.note, style: const TextStyle(fontSize: 16))),
              if (entry.imageBytes != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(entry.imageBytes!, width: 56, height: 56, fit: BoxFit.cover),
                )
              else
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.image_outlined, color: Colors.white),
                ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.grey),
                onPressed: () => _confirmDelete(entry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}