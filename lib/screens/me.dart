import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:pethug/screens/loading_screen.dart';

class MeScreen extends StatefulWidget {
  final String email;
  final int petCount;
  final int healthRecordCount;
  final int photoCount;
  final VoidCallback? onPetDataChanged;

  const MeScreen({
    super.key,
    required this.email,
    this.petCount = 0,
    this.healthRecordCount = 0,
    this.photoCount = 0,
    this.onPetDataChanged,
  });

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  bool _isEditing = false;
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  final Color appBlueColor = const Color(0xFF8FE7FF);

  late String _displayName;
  late String _displayEmail;
  late String _phoneMain;
  late String _phoneSecondary;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneMainController = TextEditingController();
  final TextEditingController _phoneSecondaryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _displayName = 'Your Name';
    _displayEmail = widget.email.isEmpty ? 'ไม่มีอีเมล' : widget.email;
    _phoneMain = 'Phone Number';
    _phoneSecondary = '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneMainController.dispose();
    _phoneSecondaryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _pickedImage = File(image.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showImageSourceDialog(BuildContext context) {
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
                  decoration: BoxDecoration(
                    color: appBlueColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildActionSheetButton(
                        icon: Icons.camera_alt_outlined,
                        text: 'Camera',
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(ImageSource.camera);
                        },
                      ),
                      Container(height: 1, color: Colors.white.withOpacity(0.5)),
                      _buildActionSheetButton(
                        icon: Icons.photo_library_outlined,
                        text: 'Album',
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(ImageSource.gallery);
                        },
                      ),
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
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'Fredoka',
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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

  Widget _buildActionSheetButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Fredoka',
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _nameController.text = _displayName;
      _emailController.text = _displayEmail;
      _phoneMainController.text = _phoneMain;
      _phoneSecondaryController.text = _phoneSecondary;
    });
  }

  void _saveChanges() {
    setState(() {
      _isEditing = false;
      if (_nameController.text.isNotEmpty) _displayName = _nameController.text;
      if (_emailController.text.isNotEmpty) _displayEmail = _emailController.text;
      if (_phoneMainController.text.isNotEmpty) _phoneMain = _phoneMainController.text;
      if (_phoneSecondaryController.text.isNotEmpty) _phoneSecondary = _phoneSecondaryController.text;
    });
    widget.onPetDataChanged?.call();
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return SizedBox(
      height: 30,
      child: TextField(
        controller: controller,
        style: const TextStyle(fontFamily: 'Fredoka', fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  void _showHelpCenterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(color: Color(0xFFE2F5E2), shape: BoxShape.circle),
                child: const Icon(Icons.headset_mic, color: Color(0xFF65C466), size: 32),
              ),
              const SizedBox(height: 16),
              const Text(
                'Help Center & Emergency',
                style: TextStyle(fontFamily: 'Fredoka', fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _EmergencyContactCard(
                hospitalName: 'Thonglor Pet Hospital',
                phoneNumber: '02-079-9999',
                isOpen24hrs: true,
                onCallTap: () => _makePhoneCall('020799999'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(fontFamily: 'Fredoka', color: Colors.grey, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.privacy_tip, color: appBlueColor, size: 28),
                  const SizedBox(width: 8),
                  const Text(
                    'Privacy Policy',
                    style: TextStyle(fontFamily: 'Fredoka', fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey.withOpacity(0.2), thickness: 1),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPrivacySection(
                        '1. ข้อมูลที่เก็บ',
                        '• ข้อมูลผู้ใช้: ชื่อ, อีเมล, เบอร์โทร\n• ข้อมูลสัตว์เลี้ยง: ชื่อสัตว์, สายพันธุ์, อายุ, ประวัติสุขภาพ',
                      ),
                      _buildPrivacySection(
                        ' 2. วัตถุประสงค์ในการใช้ข้อมูล',
                        '• ให้บริการดูแลสัตว์เลี้ยง\n• ติดต่อผู้ใช้ (แจ้งเตือน, โปรโมชั่น)',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appBlueColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: const Text(
                    'เข้าใจแล้ว (Got it)',
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacySection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Fredoka',
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF1E1E1E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: appBlueColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDF5FF),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar
                          GestureDetector(
                            onTap: _isEditing ? () => _showImageSourceDialog(context) : null,
                            child: Stack(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3),
                                    image: DecorationImage(
                                      image: _pickedImage != null
                                          ? FileImage(_pickedImage!) as ImageProvider
                                          : const NetworkImage('https://i.pravatar.cc/150?img=32'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                if (_isEditing)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: const Color(0xFF4C6184),
                                        size: 14,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _isEditing
                                      ? _buildTextField(_nameController, 'Name')
                                      : Text(
                                          _displayName,
                                          style: const TextStyle(
                                            fontFamily: 'Fredoka',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                          // ✅ ปุ่ม Edit/Save เหมือน PetScreen
                          _isEditing
                              ? Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(
                                      Icons.check_box_outlined,
                                      color: Color(0xFF4C6184),
                                      size: 28,
                                    ),
                                    onPressed: _saveChanges,
                                  ),
                                )
                              : PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert, color: Colors.black54),
                                  offset: const Offset(0, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  color: const Color(0xFFB4E6F8),
                                  onSelected: (value) => value == 'edit' ? _startEditing() : null,
                                  itemBuilder: (context) => [
                                    const PopupMenuItem<String>(
                                      value: 'edit',
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                          'Edit',
                                          style: TextStyle(
                                            fontFamily: 'Fredoka',
                                            color: Color(0xFF4C6184),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Divider(color: const Color(0xFFB4E6F8).withOpacity(0.2), thickness: 1),
                      const SizedBox(height: 16),
                      _buildInfoRow(Icons.email_outlined, _displayEmail, _emailController, 'Email'),
                      const SizedBox(height: 12),
                      _buildInfoRow(null, _phoneMain, _phoneMainController, 'Phone Main'),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            // Stat Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _StatCard(count: widget.petCount.toString(), label: 'Pet'),
                  const SizedBox(width: 8),
                  _StatCard(count: widget.healthRecordCount.toString(), label: 'Health Record'),
                  const SizedBox(width: 8),
                  _StatCard(count: widget.photoCount.toString(), label: 'Photo'),
                ],
              ),
            ),

            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Help',
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      color: Color(0xFFD9534F),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F3F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _HelpItem(
                          icon: Icons.headset_mic_outlined,
                          iconColor: const Color(0xFF65C466),
                          iconBgColor: const Color(0xFFE2F5E2),
                          label: 'Help Center',
                          onTap: () => _showHelpCenterDialog(context),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.grey.withOpacity(0.2),
                          indent: 60,
                          endIndent: 20,
                        ),
                        _HelpItem(
                          icon: Icons.privacy_tip_outlined,
                          iconColor: appBlueColor,
                          iconBgColor: const Color(0xFFE5FAFF),
                          label: 'Privacy Policy',
                          onTap: () => _showPrivacyPolicyDialog(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Log out button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoadingScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout, color: Color(0xFFE57373), size: 20),
                  label: const Text(
                    'Log out',
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      color: Color(0xFFE57373),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide.none,
                    backgroundColor: const Color(0xFFFFEAEE),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData? icon,
    String text,
    TextEditingController controller,
    String hint,
  ) {
    return Row(
      children: [
        if (icon != null)
          Icon(icon, size: 20, color: Colors.black87)
        else
          const SizedBox(width: 20),
        const SizedBox(width: 12),
        Expanded(
          child: _isEditing
              ? _buildTextField(controller, hint)
              : Text(text, style: const TextStyle(fontFamily: 'Fredoka', fontSize: 14)),
        ),
      ],
    );
  }
}

// Helper Widgets
class _StatCard extends StatelessWidget {
  final String count;
  final String label;
  const _StatCard({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              count,
              style: const TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 12,
                color: Color(0xFF5A7184),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String label;
  final VoidCallback onTap;

  const _HelpItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        label,
        style: const TextStyle(fontFamily: 'Fredoka', fontSize: 15, color: Colors.black87),
      ),
      onTap: onTap,
    );
  }
}

class _EmergencyContactCard extends StatelessWidget {
  final String hospitalName;
  final String phoneNumber;
  final bool isOpen24hrs;
  final VoidCallback onCallTap;

  const _EmergencyContactCard({
    required this.hospitalName,
    required this.phoneNumber,
    required this.isOpen24hrs,
    required this.onCallTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.local_hospital, color: Color(0xFFD9534F), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hospitalName,
                  style: const TextStyle(
                    fontFamily: 'Fredoka',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phoneNumber,
                  style: const TextStyle(fontFamily: 'Fredoka', fontSize: 14, color: Colors.black54),
                ),
                if (isOpen24hrs) ...[
                  const SizedBox(height: 4),
                  const Text(
                    'Open 24 hrs',
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      color: Color(0xFF65C466),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.white),
            onPressed: onCallTap,
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF65C466),
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}