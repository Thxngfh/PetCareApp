import 'package:flutter/material.dart';

class ManageVaccineScreen extends StatefulWidget {
  const ManageVaccineScreen({super.key});

  @override
  State<ManageVaccineScreen> createState() => _ManageVaccineScreenState();
}

class _ManageVaccineScreenState extends State<ManageVaccineScreen> {
  // กำหนดสีให้ตรงกับธีมของแอป
  final Color appBlueColor = const Color(0xFF8FE7FF);
  final Color textBlueColor = const Color(0xFF4C6184);
  final Color cardLightBlue = const Color(0xFFDDF5FF);

  // Controllers สำหรับรับค่า ชื่อวัคซีน และ วันที่
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ตั้งค่าเริ่มต้นของวันที่ให้เป็น "วันนี้"
    DateTime today = DateTime.now();
    _dateController.text = "${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year}";
  }

  void _saveVaccine() {
    // ส่งข้อมูลแบบ Map กลับไปให้หน้า History ของ Vaccine
    Navigator.pop(context, {
      "type": _typeController.text.isNotEmpty ? _typeController.text : "Unknown",
      "date": _dateController.text,
    }); 
  }

  // ฟังก์ชันแสดงปฏิทินเลือกวันที่ (เหมือนหน้า Weight)
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), 
      lastDate: DateTime(2100), 
      builder: (context, child) {
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
        _dateController.text = "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
      });
    }
  }

  @override
  void dispose() {
    _typeController.dispose();
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
          'Vaccination Details',
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
            // ส่วน Header ของ Vaccine
            Text('Vaccine', style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            // กล่องกรอกข้อมูลวัคซีน
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: cardLightBlue, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Type of vaccine', style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  _buildWhiteTextField(_typeController, TextInputType.text),
                  
                  const SizedBox(height: 16),
                  
                  Text('Date of vaccination', style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  // ช่องเลือกวันที่
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
                  onPressed: _saveVaccine,
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
        readOnly: true, 
        onTap: () => _selectDate(context), 
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