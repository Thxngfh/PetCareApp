import 'package:flutter/material.dart';

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({super.key});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  int _selectedTypeIndex = 0;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
  //เพิ่ม Controller สำหรับ Pet Name
  final TextEditingController _nameController = TextEditingController();

  final List<Map<String, dynamic>> _types = [
    {'icon': Icons.vaccines, 'label': 'vaccine'},
    {'icon': Icons.medication, 'label': 'medication'},
    {'icon': Icons.edit_calendar, 'label': 'vet appointment'},
    {'icon': Icons.restaurant, 'label': 'feeding'}, 
    {'icon': Icons.bathtub, 'label': 'bathing'},
    {'icon': Icons.content_cut, 'label': 'grooming'},
  ];

  final Color appBlueColor = const Color(0xFF8FE7FF);
  final Color textBlueColor = const Color(0xFF5A7184); 
  final Color bgGrayColor = const Color(0xFFF2F4F5); 

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose(); 
    _nameController.dispose(); 
    super.dispose();
  }

  //ฟังก์ชันเปิดปฏิทินเลือกวันที่
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), 
      lastDate: DateTime(2100),  
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

    if (pickedDate != null) {
      setState(() {
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        _dateController.text = '${pickedDate.day} ${months[pickedDate.month - 1]} ${pickedDate.year}';
      });
    }
  }

  //ฟังก์ชันเปิดนาฬิกาเลือกเวลา
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: appBlueColor, 
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null && context.mounted) {
      setState(() {
        _timeController.text = pickedTime.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(color: appBlueColor),
                child: const Center(
                  child: Text(
                    'Add Reminder',
                    style: TextStyle(fontFamily: 'Fredoka', color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context), 
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade400, width: 1.5),
                        ),
                        child: const Icon(Icons.undo, size: 20, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text('Type', style: TextStyle(fontFamily: 'Fredoka', fontSize: 18, color: textBlueColor, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(), 
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 1.4, crossAxisSpacing: 12, mainAxisSpacing: 12,
                      ),
                      itemCount: _types.length,
                      itemBuilder: (context, index) {
                        final isSelected = _selectedTypeIndex == index;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedTypeIndex = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected ? appBlueColor : bgGrayColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? const Color(0xFFE0F7FA) : Colors.white, 
                                  ),
                                  child: Icon(_types[index]['icon'], color: textBlueColor, size: 24),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _types[index]['label'],
                                  style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 13, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    //เพิ่มช่องกรอก Name
                    _buildInputField('Pet Name', _nameController),
                    const SizedBox(height: 16),

                    //เรียกใช้ TextField แบบปกติ 
                    _buildInputField('Title', _titleController),
                    const SizedBox(height: 16),
                    
                    //เรียกใช้ TextField แบบกดเลือก Date 
                    _buildInputField(
                      'Date', 
                      _dateController, 
                      readOnly: true, 
                      onTap: () => _selectDate(context),
                      suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    
                    //เรียกใช้ TextField แบบกดเลือก Time 
                    _buildInputField(
                      'Time', 
                      _timeController, 
                      readOnly: true, 
                      onTap: () => _selectTime(context),
                      suffixIcon: const Icon(Icons.access_time, size: 20, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      'Location', 
                      _locationController,
                      suffixIcon: const Icon(Icons.location_on_outlined, size: 20, color: Colors.grey),
                    ),
                    const SizedBox(height: 40),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(color: appBlueColor, borderRadius: BorderRadius.circular(8)),
                              child: const Center(child: Text('Cancel', style: TextStyle(fontFamily: 'Fredoka', color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16), 

                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              //ส่งค่า Name กลับไปด้วย
                              final newReminderData = {
                                'name': _nameController.text.isEmpty ? 'My Pet' : _nameController.text, // เก็บชื่อสัตว์เลี้ยง
                                'title': _titleController.text.isEmpty ? 'New Reminder' : _titleController.text,
                                'date': _dateController.text.isEmpty ? 'Not set' : _dateController.text,
                                'time': _timeController.text.isEmpty ? '-' : _timeController.text,
                                'location': _locationController.text.isEmpty ? 'No location' : _locationController.text,
                                'icon': _types[_selectedTypeIndex]['icon'],
                              };
                              Navigator.pop(context, newReminderData); 
                            },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(color: const Color(0xFF3B5998), borderRadius: BorderRadius.circular(8)),
                              child: const Center(child: Text('Add', style: TextStyle(fontFamily: 'Fredoka', color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20), 
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันสร้าง TextField ให้รองรับการกด (onTap) และไอคอน (suffixIcon) 
  Widget _buildInputField(String label, TextEditingController controller, {bool readOnly = false, VoidCallback? onTap, Widget? suffixIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontFamily: 'Fredoka', fontSize: 16, color: textBlueColor, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(color: bgGrayColor, borderRadius: BorderRadius.circular(10)),
          child: TextField(
            controller: controller,
            readOnly: readOnly, 
            onTap: onTap,       
            style: const TextStyle(fontFamily: 'Fredoka'),
            decoration: InputDecoration(
              border: InputBorder.none, 
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              suffixIcon: suffixIcon, 
            ),
          ),
        ),
      ],
    );
  }
}