import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final Color appBlueColor = const Color(0xFF8FE7FF);
  final Color textBlueColor = const Color(0xFF4C6184);
  final Color inactiveBgColor = const Color(0xFFEEF3F6);

  String selectedGender = 'Male'; 

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _coatColorController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _adoptionController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _breedController.dispose();
    _coatColorController.dispose();
    _dobController.dispose();
    _adoptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: appBlueColor,
              onPrimary: Colors.white,
              onSurface: textBlueColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        String formattedDate = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
        controller.text = formattedDate;
      });
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.only(left: 32, right: 32, bottom: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: appBlueColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 28),
                      title: const Text('Camera', style: TextStyle(fontFamily: 'Fredoka', color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                      onTap: () {
                        Navigator.pop(context); 
                        _pickImage(ImageSource.camera);
                      },
                    ),
                    const Divider(color: Colors.white, height: 1, thickness: 1),
                    ListTile(
                      leading: const Icon(Icons.photo_library_outlined, color: Colors.white, size: 28),
                      title: const Text('Album', style: TextStyle(fontFamily: 'Fredoka', color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                      onTap: () {
                        Navigator.pop(context); 
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(color: appBlueColor, borderRadius: BorderRadius.circular(16)),
                child: TextButton(
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(fontFamily: 'Fredoka', color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appBlueColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.undo, color: Colors.black87), 
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('Add a Pet', style: TextStyle(fontFamily: 'Fredoka', color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _showImageSourceActionSheet(context), 
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E2E2), 
                      shape: BoxShape.circle,
                      image: _imageFile != null 
                        ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                        : null,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E2E2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt_outlined, color: Colors.black54, size: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildInputField('Name', _nameController),
            
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGenderRadio('Male'),
                  const SizedBox(width: 24),
                  _buildGenderRadio('Female'),
                ],
              ),
            ),
            
            _buildInputField('Pet Type', _typeController),
            const SizedBox(height: 12),
            _buildInputField('Breed', _breedController),
            const SizedBox(height: 12),
            _buildInputField('Coat color', _coatColorController),
            const SizedBox(height: 12),
            _buildDateField('Date Of Birth', _dobController),
            const SizedBox(height: 12),
            _buildDateField('Adoption Date', _adoptionController),
            
            const SizedBox(height: 32),

            SizedBox(
              width: 140,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appBlueColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Map<String, dynamic> petData = {
                    'name': _nameController.text.isNotEmpty ? _nameController.text : 'Unknown',
                    'gender': selectedGender,
                    'breed': _breedController.text.isNotEmpty ? _breedController.text : '-',
                    'coatColor': _coatColorController.text.isNotEmpty ? _coatColorController.text : '-',
                    'dob': _dobController.text.isNotEmpty ? _dobController.text : '-',
                    'adoptionDate': _adoptionController.text.isNotEmpty ? _adoptionController.text : '-',
                    'image': _imageFile, 
                  };
                  Navigator.pop(context, petData); 
                },
                child: const Text('Save', style: TextStyle(fontFamily: 'Fredoka', color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          height: 40,
          decoration: BoxDecoration(color: inactiveBgColor, borderRadius: BorderRadius.circular(10)),
          child: TextField(
            controller: controller, 
            decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
            style: const TextStyle(fontFamily: 'Fredoka', fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          height: 40,
          decoration: BoxDecoration(color: inactiveBgColor, borderRadius: BorderRadius.circular(10)),
          child: TextField(
            controller: controller,
            readOnly: true, 
            onTap: () => _selectDate(context, controller), 
            decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
            style: const TextStyle(fontFamily: 'Fredoka', fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderRadio(String gender) {
    return GestureDetector(
      onTap: () => setState(() => selectedGender = gender),
      child: Row(
        children: [
          Container(
            width: 20, height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: selectedGender == gender ? textBlueColor : Colors.grey.shade400, width: 2),
            ),
            child: selectedGender == gender ? Center(child: Container(width: 10, height: 10, decoration: BoxDecoration(color: textBlueColor, shape: BoxShape.circle))) : null,
          ),
          const SizedBox(width: 8),
          Text(gender, style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 16)),
        ],
      ),
    );
  }
}