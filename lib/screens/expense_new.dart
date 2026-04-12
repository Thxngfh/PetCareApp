import 'package:flutter/material.dart';

class ExpenseEntry {
  final String id;
  final double amount;
  final String category;
  final DateTime date;

  ExpenseEntry({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
  });
}

class NewExpenseScreen extends StatefulWidget {
  const NewExpenseScreen({super.key});

  @override
  State<NewExpenseScreen> createState() => _NewExpenseScreenState();
}

class _NewExpenseScreenState extends State<NewExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  String? _selectedCategory;
  final Color blueColor = const Color(0xFF9FE2FB);

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Food', 'color': const Color(0xFF5BBFEA)},
    {'name': 'Supplement', 'color': const Color(0xFFB57BDB)},
    {'name': 'Toy', 'color': const Color(0xFF9FE2FB)},
    {'name': 'Vet bills', 'color': const Color(0xFFFFB6C1)},
  ];

  void _save() {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาใส่จำนวนเงินให้ถูกต้อง')),
      );
      return;
    }
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาเลือก Category')),
      );
      return;
    }
    final entry = ExpenseEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      category: _selectedCategory!,
      date: DateTime.now(),
    );
    Navigator.pop(context, entry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: blueColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('New Expense', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Expense Amount',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFE8F7FD),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Category',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F7FD),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedCategory,
                  hint: const Text(''),
                  icon: const Icon(Icons.arrow_drop_down),
                  onChanged: (val) => setState(() => _selectedCategory = val),
                  items: _categories.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat['name'],
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: cat['color'],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(cat['name']),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _save,
                child: const Text('Save',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}