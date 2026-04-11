import 'dart:typed_data';

class DiaryEntry {
  final String id;
  final String note;
  final DateTime date;
  final Uint8List? imageBytes; // เปลี่ยนจาก String? imagePath

  DiaryEntry({
    required this.id,
    required this.note,
    required this.date,
    this.imageBytes,
  });
}