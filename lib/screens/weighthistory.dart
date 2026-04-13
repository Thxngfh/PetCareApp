import 'package:flutter/material.dart';

class WeightHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> weightRecords;

  const WeightHistoryScreen({super.key, required this.weightRecords});

  // กำหนดสีตามธีมในรูปภาพ
  final Color appBlueColor = const Color(0xFF8FE7FF);
  final Color textBlueColor = const Color(0xFF4C6184);
  final Color cardBgColor = const Color(0xFFF0F4F7); // สีพื้นหลังเทาอ่อนของ Card
  final Color weightIconColor = const Color(0xFF5A729A); // สีน้ำเงินของไอคอนตุ้มน้ำหนัก

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 1. ปรับ Header ให้เป็น AppBar ตามดีไซน์
      appBar: AppBar(
        backgroundColor: appBlueColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.undo, color: Color(0xFF4C6184), size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Weight',
          style: TextStyle(
            fontFamily: 'Fredoka',
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: weightRecords.isEmpty
          ? _buildEmptyState() // 2. แสดงสถานะไม่มีข้อมูล
          : _buildHistoryList(), // 3. แสดงรายการประวัติ
    );
  }

  // Widget สำหรับหน้าว่างเปล่า
  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No weight history.',
        style: TextStyle(
          fontFamily: 'Fredoka',
          color: textBlueColor.withOpacity(0.4),
          fontSize: 18,
        ),
      ),
    );
  }

  // Widget สำหรับ List ประวัติ
  Widget _buildHistoryList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      itemCount: weightRecords.length,
      itemBuilder: (context, index) {
        final record = weightRecords[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              // ดีไซน์ไอคอนตุ้มน้ำหนัก (Weight Scale Icon)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // รูปทรงของตุ้มน้ำหนัก
                      Icon(Icons.monitor_weight, color: weightIconColor, size: 60),
                      // ข้อความ KG ตรงกลาง
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'KG',
                          style: TextStyle(
                            fontFamily: 'Fredoka',
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // ข้อมูลน้ำหนักและวันที่
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${record['weight']} kg',
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        color: textBlueColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record['date'] ?? '',
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        color: weightIconColor.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                    // แสดง Note (เช่น weight gain) ถ้ามีข้อมูล
                    if (record['note'] != null && record['note'].toString().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          record['note'],
                          style: TextStyle(
                            fontFamily: 'Fredoka',
                            color: weightIconColor.withOpacity(0.6),
                            fontSize: 12,
                          ),
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