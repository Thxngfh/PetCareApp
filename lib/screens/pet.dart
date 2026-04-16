import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'manageweight.dart'; 
import 'weighthistory.dart';
import 'managevaccine.dart';
import 'vaccinehistory.dart'; 

//Model สำหรับสัตว์เลี้ยงแต่ละตัว 

class PetData {
  String name;
  String gender;
  String breed;
  String coatColor;
  String dob;
  String adoptionDate;
  File? image;
  String weight;
  String vaccine;
  List<Map<String, dynamic>> weightRecords;
  List<Map<String, dynamic>> vaccineRecords;
  List<Map<String, dynamic>> upcomingReminders;

  PetData({
    required this.name,
    required this.gender,
    this.breed = '-',
    this.coatColor = '-',
    this.dob = '-',
    this.adoptionDate = '-',
    this.image,
    this.weight = '',
    this.vaccine = '',
    List<Map<String, dynamic>>? weightRecords,
    List<Map<String, dynamic>>? vaccineRecords,
    List<Map<String, dynamic>>? upcomingReminders,
  })  : weightRecords = weightRecords ?? [],
        vaccineRecords = vaccineRecords ?? [],
        upcomingReminders = upcomingReminders ?? [];
}

//PetScreen 

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

  //รายการสัตว์เลี้ยงทั้งหมด
  List<PetData> pets = [];
  int _activePetIndex = 0;

  bool _isEditing = false;
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _adoptionController = TextEditingController();

  //Getters สำหรับสัตว์เลี้ยงที่ active 
  bool get hasPetData => pets.isNotEmpty;
  PetData? get _activePet => pets.isEmpty ? null : pets[_activePetIndex];

  //ใช้ใน main_screen.dart
  String get petName => _activePet?.name ?? 'No Pet';

  //เพิ่มสัตว์เลี้ยงใหม่ (เรียกจาก main_screen)
  void addPet(Map<String, dynamic> data) {
    setState(() {
      pets.add(PetData(
        name: data['name'] ?? 'Unknown',
        gender: data['gender'] ?? 'Male',
        breed: data['breed'] ?? '-',
        coatColor: data['coatColor'] ?? '-',
        dob: data['dob'] ?? '-',
        adoptionDate: data['adoptionDate'] ?? '-',
        image: data['image'],
      ));
      _activePetIndex = pets.length - 1; // switch ไปตัวใหม่ทันที
    });
    widget.onPetDataChanged?.call();
  }

  void updatePetData(Map<String, dynamic> data) => addPet(data);

  //Dropdown เลือกสัตว์เลี้ยง

  void showPetSelector(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        pageBuilder: (context, _, __) => _PetSelectorPage(
          pets: pets,
          activePetIndex: _activePetIndex,
          appBlueColor: appBlueColor,
          textBlueColor: textBlueColor,
          onSelect: (i) {
            setState(() => _activePetIndex = i);
            widget.onPetDataChanged?.call();
          },
        ),
      ),
    );
  }

  //Edit helpers

  void _startEditing() {
    final pet = _activePet;
    if (pet == null) return;
    setState(() {
      _isEditing = true;
      _pickedImage = null;
      _nameController.text = pet.name;
      _breedController.text = pet.breed;
      _colorController.text = pet.coatColor;
      _dobController.text = pet.dob;
      _adoptionController.text = pet.adoptionDate;
    });
  }

  void _saveChanges() {
    final pet = _activePet;
    if (pet == null) return;
    setState(() {
      _isEditing = false;
      if (_pickedImage != null) pet.image = _pickedImage;
      if (_nameController.text.isNotEmpty) pet.name = _nameController.text;
      if (_breedController.text.isNotEmpty) pet.breed = _breedController.text;
      if (_colorController.text.isNotEmpty) pet.coatColor = _colorController.text;
      if (_dobController.text.isNotEmpty) pet.dob = _dobController.text;
      if (_adoptionController.text.isNotEmpty) pet.adoptionDate = _adoptionController.text;
      _pickedImage = null;
    });
    widget.onPetDataChanged?.call();
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) setState(() => _pickedImage = File(image.path));
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

  //Build 

  @override
  Widget build(BuildContext context) {
    if (!hasPetData) {
      return Center(
        child: Text('Please Add a Pet +', style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 20)),
      );
    }

    final pet = _activePet!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Profile Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: cardLightBlue, borderRadius: BorderRadius.circular(24)),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Avatar
                    GestureDetector(
                      onTap: _isEditing ? () => _showImagePickerActionSheet(context) : null,
                      child: Stack(
                        children: [
                          Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white,
                              border: Border.all(color: Colors.black87, width: 1.5),
                              image: _isEditing && _pickedImage != null
                                  ? DecorationImage(image: FileImage(_pickedImage!), fit: BoxFit.cover)
                                  : (pet.image != null ? DecorationImage(image: FileImage(pet.image!), fit: BoxFit.cover) : null),
                            ),
                            child: (_isEditing && _pickedImage == null && pet.image == null) || (!_isEditing && pet.image == null)
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
                                  : Text(pet.name.toUpperCase(), style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 24, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              Icon(pet.gender == 'Male' ? Icons.male : Icons.female, color: appBlueColor, size: 24),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text("${getAge(pet.dob)}  ${pet.gender}", style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor.withOpacity(0.7), fontSize: 14)),
                        ],
                      ),
                    ),
                    //Edit / Save button
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
                    Expanded(child: _buildInfoItem("Birthday", pet.dob, _dobController)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildInfoItem("Breed", pet.breed, _breedController)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _buildInfoItem("Adoption Date", pet.adoptionDate, _adoptionController)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildInfoItem("Coat color", pet.coatColor, _colorController)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          //Weight & Vaccine Cards 
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  Icons.monitor_weight_outlined,
                  "Weight",
                  pet.weight,
                  onCardTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => WeightHistoryScreen(weightRecords: pet.weightRecords),
                    ));
                  },
                  onAddTap: () async {
                    final result = await Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const ManageWeightScreen(),
                    ));
                    if (result != null && result is Map<String, dynamic>) {
                      setState(() {
                        pet.weight = result["weight"];
                        pet.weightRecords.insert(0, result);
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionCard(
                  Icons.vaccines_outlined,
                  "Vaccine",
                  pet.vaccine,
                  onCardTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => VaccineHistoryScreen(vaccineRecords: pet.vaccineRecords),
                    ));
                  },
                  onAddTap: () async {
                    final result = await Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const ManageVaccineScreen(),
                    ));
                    if (result != null && result is Map<String, dynamic>) {
                      setState(() {
                        pet.vaccine = result["type"];
                        pet.vaccineRecords.insert(0, result);
                      });
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          //Upcoming Reminders 
          Row(
            children: [
              Icon(Icons.calendar_month, color: textBlueColor, size: 28),
              const SizedBox(width: 8),
              Text("Upcoming Reminder", style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          pet.upcomingReminders.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text("No upcoming reminders yet.", style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor.withOpacity(0.5), fontSize: 16)),
                  ),
                )
              : Column(
                  children: pet.upcomingReminders.map((reminder) {
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
                              Text(pet.name, style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor.withOpacity(0.7), fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  //Widget helpers 

  Widget _buildNameEditField() {
    return Container(
      height: 36, padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: TextField(
        controller: _nameController,
        decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 16, fontWeight: FontWeight.bold),
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
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 14),
                ),
              )
            : Text(value, style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor.withOpacity(0.7), fontSize: 14)),
      ],
    );
  }

  Widget _buildActionCard(IconData icon, String title, String value,
      {VoidCallback? onAddTap, VoidCallback? onCardTap}) {
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
                Expanded(
                  child: Text(
                    value.isEmpty ? "" : value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor.withOpacity(0.5), fontSize: 20, fontWeight: FontWeight.w300),
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
            ),
          ],
        ),
      ),
    );
  }
}

// Full-screen Pet Selector Page
class _PetSelectorPage extends StatefulWidget {
  final List<PetData> pets;
  final int activePetIndex;
  final Color appBlueColor;
  final Color textBlueColor;
  final void Function(int index) onSelect;

  const _PetSelectorPage({
    required this.pets,
    required this.activePetIndex,
    required this.appBlueColor,
    required this.textBlueColor,
    required this.onSelect,
  });

  @override
  State<_PetSelectorPage> createState() => _PetSelectorPageState();
}

class _PetSelectorPageState extends State<_PetSelectorPage> {
  late int _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.activePetIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF8FE7FF),
        elevation: 0,
        leading: Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
              onPressed: () {},
            ),
            Positioned(
              top: 12, right: 12,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Color(0xFFFF4D4F), shape: BoxShape.circle),
                child: const Text('1',
                    style: TextStyle(fontFamily: 'Fredoka', color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.pets[_selected].name,
              style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold,
                fontFamily: 'Fredoka', fontSize: 24,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, color: Colors.white, size: 28),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 38, height: 38,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.add, color: Colors.black87, size: 26),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: widget.pets.length,
        itemBuilder: (context, i) {
          final pet = widget.pets[i];
          final isActive = i == _selected;

          return GestureDetector(
            onTap: () {
              setState(() => _selected = i);
              widget.onSelect(i);
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFDDF5FF),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      color: Colors.white,
                      image: pet.image != null
                          ? DecorationImage(image: FileImage(pet.image!), fit: BoxFit.cover)
                          : null,
                    ),
                    child: pet.image == null
                        ? Icon(Icons.pets, color: widget.textBlueColor, size: 36)
                        : null,
                  ),
                  const SizedBox(width: 20),

                  //Name + gender
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          pet.name,
                          style: TextStyle(
                            fontFamily: 'Fredoka',
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: widget.textBlueColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          pet.gender == 'Male' ? Icons.male : Icons.female,
                          color: const Color(0xFF8FE7FF),
                          size: 26,
                        ),
                      ],
                    ),
                  ),

                  //Checkmark circle
                  if (isActive)
                    Container(
                      width: 44, height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3B5998),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 26),
                    ),
                ],
              ),
            ),
          );
        },
      ),

      //Bottom nav (decorative)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFFF80AB),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Pet'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_stories_outlined), label: 'Diary'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Health'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Consult'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Me'),
        ],
        onTap: (_) {},
      ),
    );
  }
}