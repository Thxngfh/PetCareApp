import 'package:flutter/material.dart';

class ManageWeightScreen extends StatefulWidget {
  const ManageWeightScreen({super.key});

  @override
  State<ManageWeightScreen> createState() => _ManageWeightScreenState();
}

class _ManageWeightScreenState extends State<ManageWeightScreen> {
  // กำหนดสีที่ใช้ในหน้านี้
  final Color appBlueColor = const Color(0xFF8FE7FF);
  final Color textBlueColor = const Color(0xFF4C6184);
  final Color cardLightBlue = const Color(0xFFDDF5FF);

  // Controllers สำหรับรับค่าจาก TextFields
  final TextEditingController _kgController = TextEditingController();
  final TextEditingController _gramController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ตั้งค่าเริ่มต้นของวันที่ให้เป็น "วันนี้"
    DateTime today = DateTime.now();
    _dateController.text = "${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year}";
  }

  void _saveWeight() {
    String kg = _kgController.text.isNotEmpty ? _kgController.text : "0";
    String gram = _gramController.text.isNotEmpty ? ".${_gramController.text}" : "";
    
    // เปลี่ยนมาส่งเป็น Map เพื่อเก็บข้อมูล วันที่ และ โน้ต กลับไปหน้าหลัก (สำหรับหน้า History)
    Navigator.pop(context, {
      "weight": "$kg$gram KG",
      "date": _dateController.text,
      "note": _noteController.text,
    }); 
  }

  // ฟังก์ชันแสดงปฏิทินเลือกวันที่
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // เลือกย้อนหลังได้ถึงปี 2000
      lastDate: DateTime(2100), // เลือกไปข้างหน้าได้ถึงปี 2100
      builder: (context, child) {
        // แต่งสีปฏิทินให้เข้ากับธีมแอป
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: textBlueColor, 
              onPrimary: Colors.white, 
              onSurface: textBlueColor, 
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: textBlueColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        // จัดรูปแบบเป็น วัน/เดือน/ปี
        _dateController.text = "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
      });
    }
  }

  @override
  void dispose() {
    _kgController.dispose();
    _gramController.dispose();
    _noteController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appBlueColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.undo, color: Color(0xFF4C6184), size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Manage Weight',
          style: TextStyle(
            fontFamily: 'Fredoka', 
            color: Colors.white, 
            fontSize: 24, 
            fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ส่วน Header ของ Weight
            Text('Weight', style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('The pets weight', style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor.withOpacity(0.8), fontSize: 16)),
            const SizedBox(height: 16),
            
            // กล่องกรอกน้ำหนัก
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: cardLightBlue, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kilogram', style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  _buildWhiteTextField(_kgController, TextInputType.number),
                  
                  const SizedBox(height: 16),
                  
                  Text('Gram', style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  _buildWhiteTextField(_gramController, TextInputType.number),
                ],
              ),
            ),
            
            const SizedBox(height: 32),

            // ส่วน Header ของ Note
            Text('Note', style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            
            // กล่องกรอก Note และ วันที่
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: cardLightBlue, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Add Note ', style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 16, fontWeight: FontWeight.w500)),
                      Icon(Icons.edit, color: textBlueColor, size: 18),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildWhiteTextField(_noteController, TextInputType.text),
                  
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Text('Measured At ', style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 16, fontWeight: FontWeight.w500)),
                      Icon(Icons.calendar_today_outlined, color: textBlueColor, size: 18),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // เปลี่ยนเป็น TextField แบบกดเลือกวันที่
                  _buildDatePickerField(),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ปุ่ม Save
            Center(
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: _saveWeight,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appBlueColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontFamily: 'Fredoka', color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget ช่วยสร้างกล่องกรอกข้อความสีขาวแบบปกติ
  Widget _buildWhiteTextField(TextEditingController controller, TextInputType keyboardType) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          isDense: true,
        ),
        style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 16),
      ),
    );
  }

  // Widget พิเศษสำหรับเลือกวันที่ (กดแล้วมีปฏิทินเด้ง)
  Widget _buildDatePickerField() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _dateController,
        readOnly: true, // ป้องกันไม่ให้พิมพ์เอง
        onTap: () => _selectDate(context), // กดแล้วเรียกฟังก์ชันโชว์ปฏิทิน
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          isDense: true,
        ),
        style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 16),
      ),
    );
  }
}