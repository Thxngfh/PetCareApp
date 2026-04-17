import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:pethug/models/diary_entry.dart';

class NewDiaryScreen extends StatefulWidget {
  final DiaryEntry? existingEntry;
  const NewDiaryScreen({super.key, this.existingEntry});

  @override
  State<NewDiaryScreen> createState() => _NewDiaryScreenState();
}

class _NewDiaryScreenState extends State<NewDiaryScreen> {
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  Uint8List? _imageBytes;
  final Color blueColor = const Color(0xFF9FE2FB);
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.existingEntry != null) {
      _noteController.text = widget.existingEntry!.note;
      _selectedDate = widget.existingEntry!.date;
      _imageBytes = widget.existingEntry!.imageBytes;
    }
  }

  Future<void> _pickFromCamera() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (photo != null) {
      final bytes = await photo.readAsBytes();
      setState(() => _imageBytes = bytes);
    }
  }

  Future<void> _pickFromAlbum() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (photo != null) {
      final bytes = await photo.readAsBytes();
      setState(() => _imageBytes = bytes);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF9FE2FB), // สีวงกลมวันที่เลือก
              onPrimary: Colors.white, // สีตัวเลขในวงกลม
              onSurface: Colors.black87, // สีตัวเลขปกติ
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF9FE2FB), // สีปุ่ม Cancel/OK
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _save() {
    if (_noteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาใส่โน็ตก่อนบันทึก')),
      );
      return;
    }
    final entry = DiaryEntry(
      id: widget.existingEntry?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      note: _noteController.text.trim(),
      date: _selectedDate,
      imageBytes: _imageBytes,
    );
    Navigator.pop(context, entry);
  }

  @override
  Widget build(BuildContext context) {
    // ── 1. คลุมด้วย GestureDetector เพื่อแตะที่ว่างแล้วหุบแป้นพิมพ์ ──
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: blueColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.existingEntry != null ? 'Edit Diary' : 'New Diary',
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        // ── 2. ใส่ SingleChildScrollView เพื่อให้หน้าจอเลื่อนได้ตอนแป้นพิมพ์เด้ง ──
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Note', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add Note ✏️',
                  filled: true,
                  fillColor: const Color(0xFFE8F7FD),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Measured At
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F7FD),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Measured At:  ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Preview รูป
              if (_imageBytes != null) ...[
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        _imageBytes!,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () => setState(() => _imageBytes = null),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Camera / Album
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blueColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.camera_alt_outlined,
                          color: Colors.white),
                      label: const Text('Camera',
                          style: TextStyle(color: Colors.white)),
                      onPressed: _pickFromCamera,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blueColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.photo_library_outlined,
                          color: Colors.white),
                      label: const Text('Album',
                          style: TextStyle(color: Colors.white)),
                      onPressed: _pickFromAlbum,
                    ),
                  ),
                ],
              ),

              // ── 3. เปลี่ยน Spacer() เป็น SizedBox(height: 32) หรือความสูงตามต้องการ ──
              // (เนื่องจาก Spacer จะทำให้เกิด Error เมื่ออยู่ใน SingleChildScrollView)
              const SizedBox(height: 40),

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
      ),
    );
  }
}