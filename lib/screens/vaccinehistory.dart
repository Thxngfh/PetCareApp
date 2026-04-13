import 'package:flutter/material.dart';

class VaccineHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> vaccineRecords;

  const VaccineHistoryScreen({super.key, required this.vaccineRecords});

  // สีตามธีมแอป
  final Color appBlueColor = const Color(0xFF8FE7FF);
  final Color textBlueColor = const Color(0xFF4C6184);
  final Color cardBgColor = const Color(0xFFF0F4F7);
  final Color iconThemeColor = const Color(0xFF5A729A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appBlueColor,
        elevation: 0,
        centerTitle: true,
        // ปุ่มย้อนกลับ (Undo icon)
        leading: IconButton(
          icon: const Icon(Icons.undo, color: Color(0xFF4C6184), size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Vaccination Details',
          style: TextStyle(
            fontFamily: 'Fredoka',
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: vaccineRecords.isEmpty
          ? _buildEmptyState()
          : _buildVaccineList(),
    );
  }

  // กรณีไม่มีประวัติวัคซีน
  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No vaccination history.',
        style: TextStyle(
          fontFamily: 'Fredoka',
          color: textBlueColor.withOpacity(0.4),
          fontSize: 18,
        ),
      ),
    );
  }

  // รายการประวัติวัคซีน (ตาม Screenshot 02.07.38)
  Widget _buildVaccineList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      itemCount: vaccineRecords.length,
      itemBuilder: (context, index) {
        final record = vaccineRecords[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              // ไอคอนเข็มฉีดยาและขวดยาในกรอบสีขาว
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(
                    Icons.vaccines, // ไอคอนวัคซีนของ Flutter
                    color: iconThemeColor,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // ข้อมูลชื่อวัคซีนและวันที่
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record['type'] ?? 'Unknown Vaccine',
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        color: textBlueColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record['date'] ?? '-',
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        color: iconThemeColor.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}