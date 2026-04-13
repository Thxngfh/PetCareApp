import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// 1. อย่าลืม Import หน้าที่เกี่ยวข้องทั้งหมด
import 'manageweight.dart'; 
import 'weighthistory.dart';
import 'managevaccine.dart'; // เพิ่มอันนี้
// import 'vaccinehistory.dart'; // ถ้าคุณมีหน้าประวัติวัคซีนแยก ให้ Import ตรงนี้ครับ

class PetScreen extends StatefulWidget {
  final VoidCallback? onPetDataChanged;

  const PetScreen({super.key, this.onPetDataChanged});

  @override
  State<PetScreen> createState() => PetScreenState();
}

class PetScreenState extends State<PetScreen> {
  final Color appBlueColor = const Color(0xFF8FE7FF);
  final Color textBlueColor = const Color(0xFF4C6184);
  final Color cardLightBlue = const Color(0xFFDDF5FF);

  // ข้อมูลสัตว์เลี้ยงหลัก
  String petName = "No Pet";
  String petGender = "";
  String petBreed = "-";
  String petCoatColor = "-";
  String petDob = "-";
  String petAdoption = "-";
  
  // 2. ตัวแปรเก็บข้อมูลน้ำหนักและวัคซีน
  String petWeight = ""; 
  String petVaccine = ""; // เพิ่มตัวแปรโชว์ชื่อวัคซีนล่าสุดที่การ์ด
  
  List<Map<String, dynamic>> weightRecords = [];
  List<Map<String, dynamic>> vaccineRecords = []; // เพิ่มตัวแปรเก็บประวัติวัคซีน
  
  File? petImage;
  bool hasPetData = false;

  bool _isEditing = false;
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _adoptionController = TextEditingController();

  List<Map<String, dynamic>> upcomingReminders = [];

  // ... [ฟังก์ชัน updatePetData, _startEditing, _saveChanges, _pickImage, ฯลฯ ของคุณ] ...
  // (สมมติว่าเหมือนเดิม)

  void updatePetData(Map<String, dynamic> data) {
    setState(() {
      petName = data['name'];
      petGender = data['gender'];
      petBreed = data['breed'];
      petCoatColor = data['coatColor'];
      petDob = data['dob'];
      petAdoption = data['adoptionDate'];
      petImage = data['image'];
      hasPetData = true;
    });
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _pickedImage = null;
      _nameController.text = petName;
      _breedController.text = petBreed;
      _colorController.text = petCoatColor;
      _dobController.text = petDob;
      _adoptionController.text = petAdoption;
    });
  }

  void _saveChanges() {
    setState(() {
      _isEditing = false;
      if (_pickedImage != null) {
        petImage = _pickedImage;
      }
      petName = _nameController.text.isNotEmpty ? _nameController.text : petName;
      petBreed = _breedController.text.isNotEmpty ? _breedController.text : petBreed;
      petCoatColor = _colorController.text.isNotEmpty ? _colorController.text : petCoatColor;
      petDob = _dobController.text.isNotEmpty ? _dobController.text : petDob;
      petAdoption = _adoptionController.text.isNotEmpty ? _adoptionController.text : petAdoption;
      _pickedImage = null;
    });
    widget.onPetDataChanged?.call();
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  void _showImagePickerActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(color: appBlueColor, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      _buildActionSheetButton(icon: Icons.camera_alt_outlined, text: "Camera", onTap: () {
                        Navigator.pop(context);
                        _pickImageFromSource(ImageSource.camera);
                      }),
                      Container(height: 1, color: Colors.white.withOpacity(0.5)),
                      _buildActionSheetButton(icon: Icons.photo_library_outlined, text: "Album", onTap: () {
                        Navigator.pop(context);
                        _pickImageFromSource(ImageSource.gallery);
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: appBlueColor, borderRadius: BorderRadius.circular(16)),
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Cancel", style: TextStyle(fontFamily: 'Fredoka', color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionSheetButton({required IconData icon, required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(text, style: const TextStyle(fontFamily: 'Fredoka', color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  String getAge(String dob) {
    if (dob == "-") return "0Y 0M";
    try {
      List<String> parts = dob.split('/');
      if (parts.length == 3) {
        DateTime birthDate = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
        DateTime today = DateTime.now();
        int years = today.year - birthDate.year;
        int months = today.month - birthDate.month;
        if (months < 0) { years--; months += 12; }
        return "${years}Y ${months}M";
      }
    } catch (e) { return "0Y 0M"; }
    return "0Y 0M";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: !hasPetData
          ? Center(
              child: Text('Please Add a Pet +', style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 20)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- ส่วนบนเหมือนเดิม ---
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: cardLightBlue, borderRadius: BorderRadius.circular(24)),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: _isEditing ? () => _showImagePickerActionSheet(context) : null,
                              child: Stack(
                                children: [
                                  Container(
                                    width: 80, height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: Colors.white, border: Border.all(color: Colors.black87, width: 1.5),
                                      image: _isEditing && _pickedImage != null
                                          ? DecorationImage(image: FileImage(_pickedImage!), fit: BoxFit.cover)
                                          : (petImage != null ? DecorationImage(image: FileImage(petImage!), fit: BoxFit.cover) : null),
                                    ),
                                    child: (_isEditing && _pickedImage == null && petImage == null) || (!_isEditing && petImage == null)
                                        ? Icon(Icons.pets, color: textBlueColor, size: 40) : null,
                                  ),
                                  if (_isEditing)
                                    Positioned(
                                      bottom: 0, right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                        child: Icon(Icons.camera_alt, color: textBlueColor, size: 18),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      _isEditing
                                          ? Expanded(child: _buildNameEditField())
                                          : Text(petName.toUpperCase(), style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 24, fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 8),
                                      Icon(petGender == 'Male' ? Icons.male : Icons.female, color: appBlueColor, size: 24),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text("${getAge(petDob)}  $petGender", style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor.withOpacity(0.7), fontSize: 14)),
                                ],
                              ),
                            ),
                            _isEditing
                                ? Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                    child: IconButton(
                                      padding: EdgeInsets.zero, constraints: const BoxConstraints(),
                                      icon: const Icon(Icons.check_box_outlined, color: Color(0xFF4C6184), size: 28),
                                      onPressed: _saveChanges,
                                    ),
                                  )
                                : PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert, color: Colors.black54),
                                    offset: const Offset(0, 40),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    color: const Color(0xFFB4E6F8),
                                    onSelected: (String result) { if (result == 'edit') _startEditing(); },
                                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                        value: 'edit', height: 40,
                                        child: Center(child: Text('Edit', style: TextStyle(fontFamily: 'Fredoka', color: Color(0xFF4C6184), fontSize: 16, fontWeight: FontWeight.w600))),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: _buildInfoItem("Birthday", petDob, _dobController)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildInfoItem("Breed", petBreed, _breedController)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: _buildInfoItem("Adoption Date", petAdoption, _adoptionController)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildInfoItem("Coat color", petCoatColor, _colorController)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- 3. ส่วนการ์ด Weight & Vaccine ที่แก้ไขใหม่ ---
                  Row(
                    children: [
                      // Weight Card
                      Expanded(
                        child: _buildActionCard(
                          Icons.monitor_weight_outlined, 
                          "Weight", 
                          petWeight,
                          onCardTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => WeightHistoryScreen(weightRecords: weightRecords)),
                            );
                          },
                          onAddTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ManageWeightScreen()),
                            );
                            if (result != null && result is Map<String, dynamic>) {
                              setState(() {
                                petWeight = result["weight"];
                                weightRecords.insert(0, result); 
                              });
                            }
                          }
                        )
                      ),
                      const SizedBox(width: 16),
                      // Vaccine Card (แก้ไขตรงนี้ให้เหมือน Weight)
                      Expanded(
                        child: _buildActionCard(
                          Icons.vaccines_outlined, 
                          "Vaccine", 
                          petVaccine, // โชว์ชื่อวัคซีนล่าสุด
                          onCardTap: () {
                             // ถ้าคุณสร้างหน้า VaccineHistoryScreen แล้วให้แก้ตรงนี้นะครับ
                             // Navigator.push(context, MaterialPageRoute(builder: (context) => VaccineHistoryScreen(vaccineRecords: vaccineRecords)));
                          },
                          onAddTap: () async {
                            // กดปุ่ม + แล้วไปหน้า ManageVaccine
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ManageVaccineScreen()),
                            );
                            if (result != null && result is Map<String, dynamic>) {
                              setState(() {
                                petVaccine = result["type"]; // เอาชื่อวัคซีนมาโชว์ที่การ์ด
                                vaccineRecords.insert(0, result); // เก็บเข้าประวัติ
                                
                                // (แถม) เพิ่มเข้า Reminder อัตโนมัติก็ได้
                                upcomingReminders.insert(0, {
                                  "title": result["type"],
                                  "icon": Icons.vaccines_outlined
                                });
                              });
                            }
                          }
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- ส่วน Reminder ด้านล่างเหมือนเดิม ---
                  Row(
                    children: [
                      Icon(Icons.calendar_month, color: textBlueColor, size: 28),
                      const SizedBox(width: 8),
                      Text("Upcoming Reminder", style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  upcomingReminders.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text("No upcoming reminders yet.", style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor.withOpacity(0.5), fontSize: 16)),
                          ),
                        )
                      : Column(
                          children: upcomingReminders.map((reminder) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(color: cardLightBlue, borderRadius: BorderRadius.circular(16)),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                    child: Icon(reminder['icon'] ?? Icons.vaccines_outlined, color: textBlueColor),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(reminder['title'] ?? 'Reminder', style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 16, fontWeight: FontWeight.w600)),
                                      Text(petName, style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor.withOpacity(0.7), fontSize: 14)),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                ],
              ),
            ),
    );
  }

  // --- Widget ตัวช่วยอื่นๆ เหมือนเดิม ---
  Widget _buildNameEditField() {
    return Container(
      height: 36, padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: TextField(
        controller: _nameController,
        decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
        textAlignVertical: TextAlignVertical.center, style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        _isEditing
            ? Container(
                height: 36, padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                  textAlignVertical: TextAlignVertical.center, style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 14),
                ),
              )
            : Text(value, style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor.withOpacity(0.7), fontSize: 14)),
      ],
    );
  }

  Widget _buildActionCard(IconData icon, String title, String value, {VoidCallback? onAddTap, VoidCallback? onCardTap}) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: cardLightBlue, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: textBlueColor, size: 20),
                const SizedBox(width: 8),
                Text(title, style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ถ้าค่าว่างให้โชว์ "-" แทน
                Expanded(
                  child: Text(
                    value.isEmpty ? "" : value, 
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor.withOpacity(0.5), fontSize: 20, fontWeight: FontWeight.w300)
                  ),
                ),
                GestureDetector(
                  onTap: onAddTap,
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.add, color: Colors.black87, size: 20),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}