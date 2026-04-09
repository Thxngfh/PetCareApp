import 'package:flutter/material.dart';



void main() {
  runApp(const MaterialApp(home: DiaryScreen()));
}
class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  DateTime _focusedMonth = DateTime(2026, 2);
  int _tabIndex = 0; // 0 = Diary, 1 = Expense

  // ตัวอย่าง diary data
  final List<Map<String, dynamic>> _entries = [
    {'date': DateTime(2026, 2, 14), 'note': 'Sora', 'image': null},
    {'date': DateTime(2026, 2, 20), 'note': 'Happy', 'image': null},
    {'date': DateTime(2026, 2, 14), 'note': 'Cute', 'image': null},
  ];

  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  String _monthLabel() {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[_focusedMonth.month - 1]} ${_focusedMonth.year}';
  }

  String _dayLabel(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final Color blueColor = const Color(0xFF9FE2FB);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Tab: Diary / Expense
          Container(
            color: Colors.white,
            child: Row(
              children: [
                _buildTab('Diary', 0, blueColor),
                _buildTab('Expense', 1, blueColor),
              ],
            ),
          ),

          if (_tabIndex == 0) ...[
            // Month navigator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _previousMonth,
                  ),
                  Text(
                    '< ${_monthLabel()} >',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _nextMonth,
                  ),
                ],
              ),
            ),

            // Diary entries
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  final entry = _entries[index];
                  final date = entry['date'] as DateTime;
                  return _buildEntryCard(entry, date);
                },
              ),
            ),
          ],

          if (_tabIndex == 1)
            const Expanded(
              child: Center(child: Text('Expense (coming soon)')),
            ),
        ],
      ),

      // ปุ่ม + เพิ่ม diary และปุ่มรูป
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ปุ่มดูรูปทั้งหมด
          FloatingActionButton(
            heroTag: 'photo',
            mini: true,
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DiaryPhotoScreen()),
              );
            },
            child: Icon(Icons.photo_library_outlined, color: blueColor),
          ),
          const SizedBox(height: 8),
        ],
      ),

      // ปุ่ม + เพิ่ม diary
      persistentFooterButtons: null,
    );
  }

  Widget _buildTab(String label, int index, Color blueColor) {
    final isSelected = _tabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tabIndex = index),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? blueColor : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Container(height: 2, color: blueColor)
            else
              Container(height: 2, color: Colors.transparent),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryCard(Map<String, dynamic> entry, DateTime date) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NewDiaryScreen(existingEntry: entry),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // วันที่
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _dayLabel(date),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  '${date.day}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5BBFEA),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // โน็ต
            Expanded(
              child: Text(
                entry['note'] ?? '',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            // รูป (ถ้ามี)
            if (entry['image'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  entry['image'],
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image_outlined, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// หน้า New Diary (เพิ่ม/แก้ไข)
// ============================================================
class NewDiaryScreen extends StatefulWidget {
  final Map<String, dynamic>? existingEntry;
  const NewDiaryScreen({super.key, this.existingEntry});

  @override
  State<NewDiaryScreen> createState() => _NewDiaryScreenState();
}

class _NewDiaryScreenState extends State<NewDiaryScreen> {
  final TextEditingController _noteController = TextEditingController();
  DateTime? _selectedDate;
  final Color blueColor = const Color(0xFF9FE2FB);

  @override
  void initState() {
    super.initState();
    if (widget.existingEntry != null) {
      _noteController.text = widget.existingEntry!['note'] ?? '';
      _selectedDate = widget.existingEntry!['date'];
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: blueColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.undo, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('New Diary', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Note', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Add Note
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F7FD),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: const [
                    Text('Add Note ', style: TextStyle(color: Colors.grey)),
                    Icon(Icons.edit, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFE8F7FD),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Measured At
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F7FD),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: const [
                    Text('Measured At ', style: TextStyle(color: Colors.grey)),
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F7FD),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _selectedDate != null
                    ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                    : '',
                style: const TextStyle(color: Colors.black87),
              ),
            ),
            const SizedBox(height: 24),

            // Camera / Album
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                    label: const Text('Camera', style: TextStyle(color: Colors.white)),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.photo_library_outlined, color: Colors.white),
                    label: const Text('Album', style: TextStyle(color: Colors.white)),
                    onPressed: () {},
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Save
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// หน้า Diary Photo (ซ้าย)
// ============================================================
class DiaryPhotoScreen extends StatelessWidget {
  const DiaryPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color blueColor = const Color(0xFF9FE2FB);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Diary photo', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: 12, // placeholder
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image_outlined, color: Colors.white54),
        ),
      ),
    );
  }
}