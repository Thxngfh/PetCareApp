import 'package:flutter/material.dart';

class HealthScreen extends StatefulWidget {
  final VoidCallback? onReminderDeleted;
  
  const HealthScreen({super.key, this.onReminderDeleted});

  @override
  State<HealthScreen> createState() => HealthScreenState();
}

class HealthScreenState extends State<HealthScreen> {
  String _selectedTab = 'notification';

  List<Map<String, dynamic>> remindersList = [];

  final Color textBlueColor = const Color(0xFF4C6184); 

  // ฟังก์ชันรับข้อมูลจากหน้า Add (ถูกเรียกใช้จาก MainScreen ผ่าน GlobalKey)
  void addReminder(Map<String, dynamic> data) {
    setState(() {
      remindersList.insert(0, data); 
      _selectedTab = 'notification'; 
    });
  }

  // ฟังก์ชันลบข้อมูลพร้อมหน้าต่างยืนยัน
  void _deleteReminder(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Reminder',
          style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to delete this reminder?',
          style: TextStyle(fontFamily: 'Fredoka', fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('Cancel', style: TextStyle(fontFamily: 'Fredoka', color: Colors.grey, fontSize: 16)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4D4F), 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            onPressed: () {
              setState(() {
                remindersList.removeAt(index); 
              });
              
              widget.onReminderDeleted?.call(); // แจ้ง MainScreen ให้ลดตัวเลขกระดิ่ง
              
              Navigator.pop(context); 
            },
            child: const Text('Delete', style: TextStyle(fontFamily: 'Fredoka', color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          //Tab Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 'notification'),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTab == 'notification'
                            ? const Color(0xFF8FE7FF)
                            : const Color(0xFFF0F3F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_none,
                              size: 20,
                              color: _selectedTab == 'notification'
                                  ? Colors.white
                                  : const Color(0xFFA5A5A5)),
                          const SizedBox(width: 6),
                          Text(
                              remindersList.isEmpty ? 'Notification' : 'Notification(${remindersList.length})',
                              style: TextStyle(
                                fontFamily: 'Fredoka',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _selectedTab == 'notification'
                                    ? Colors.white
                                    : const Color(0xFFA5A5A5),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 'information'),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTab == 'information'
                            ? const Color(0xFF8FE7FF)
                            : const Color(0xFFF0F3F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline,
                              size: 20,
                              color: _selectedTab == 'information'
                                  ? Colors.white
                                  : const Color(0xFFA5A5A5)),
                          const SizedBox(width: 6),
                          Text('Information',
                              style: TextStyle(
                                fontFamily: 'Fredoka',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _selectedTab == 'information'
                                    ? Colors.white
                                    : const Color(0xFFA5A5A5),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //Content
          Expanded(
            child: _selectedTab == 'information'
                ? SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildInformationContent(),
                  )
                : _buildNotificationContent(),
          ),
        ],
      ),
    );
  }

  //Notification
  Widget _buildNotificationContent() {
    if (remindersList.isEmpty) {
      return const Center(
        child: Text("No reminders yet.",
            style: TextStyle(fontFamily: 'Fredoka', color: Colors.grey, fontSize: 16)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: remindersList.length,
      itemBuilder: (context, index) {
        final item = remindersList[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFDDF4F9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Icon(item['icon'] ?? Icons.vaccines, color: textBlueColor, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item['title'] ?? 'Title',
                            style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _deleteReminder(index), 
                          child: const Icon(Icons.delete_outline, color: Color(0xFFFF4D4F), size: 22),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),

                    // ── 4. เอาคำว่า 'Sora' ออก แล้วใส่ชื่อที่รับค่ามาจาก Add Screen ──
                    Text(
                      item['name'] ?? 'My Pet', 
                      style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor.withOpacity(0.8), fontSize: 14)
                    ),
                    
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFFA1E4F8), borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today_outlined, size: 14, color: textBlueColor),
                              const SizedBox(width: 4),
                              Text(item['date'] ?? '4 Feb 2026', style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 12, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFFE2DEE0), borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time, size: 14, color: Color(0xFF8B8B8B)),
                              const SizedBox(width: 4),
                              Text(item['time'] ?? '10:00 AM', style: const TextStyle(fontFamily: 'Fredoka', color: Color(0xFF8B8B8B), fontSize: 12, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('Location: ${item['location'] ?? 'No location'}', style: TextStyle(fontFamily: 'Fredoka', color: textBlueColor, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //Information
  Widget _buildInformationContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(icon: Icons.add, iconColor: Colors.red, title: 'Care Tips'),
        const SizedBox(height: 12),
        const _CareTipCard(
          icon: Icons.restaurant,
          title: 'Proper Feeding',
          tips: ['Feed according to your pet\'s age and appropriate weight', 'Divide meals into 2–3 times per day', 'Avoid foods that are toxic to pets'],
        ),
        const SizedBox(height: 10),
        const _CareTipCard(
          icon: Icons.fitness_center,
          title: 'Exercise',
          tips: ['Take your pet for a walk 30–60 minutes per day', 'Provide playtime and mental stimulation', 'Adjust exercise level according to age'],
        ),
        const SizedBox(height: 10),
        const _CareTipCard(
          icon: Icons.clean_hands_outlined,
          title: 'Hygiene Care',
          tips: ['Bathe your pet every 1–2 weeks', 'Brush fur daily to prevent tangles', 'Trim nails and clean ears regularly'],
        ),
        const SizedBox(height: 10),
        const _CareTipCard(
          icon: Icons.monitor_heart_outlined,
          title: 'Health Check',
          tips: ['Take your pet for a health check at least once a year', 'Vaccinate and deworm according to schedule', 'Observe behavior and watch for unusual symptoms'],
        ),
        const SizedBox(height: 24),
        const _SectionHeader(icon: Icons.medical_services, iconColor: Colors.red, title: 'Basic First Aid'),
        const SizedBox(height: 12),
        const _CareTipCard(
          icon: Icons.pets,
          title: 'Pet Choking',
          tips: ['Take your pet for a health check at least once a year', 'Vaccinate and deworm according to schedule', 'Observe behavior and watch for unusual symptoms'],
        ),
        const SizedBox(height: 10),
        const _CareTipCard(
          icon: Icons.healing_outlined,
          title: 'Bite Wound',
          tips: ['Gently clean the wound with clean water', 'Stop the bleeding with a clean cloth', 'Do not use medicine or alcohol', 'Take your pet to the veterinarian for examination'],
          hasNote: true,
          noteText: 'Do not use medicine or alcohol',
        ),
        const SizedBox(height: 10),
        const _CareTipCard(
          icon: Icons.search,
          title: 'Swallowed a Foreign Object',
          tips: ['Do not try to make your pet vomit', 'Keep the object (if possible) to show the vet', 'Observe symptoms and behavior', 'Contact a veterinarian immediately'],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  const _SectionHeader({required this.icon, required this.iconColor, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 26),
        const SizedBox(width: 6),
        Text(title, style: const TextStyle(fontFamily: 'Fredoka', fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }
}

class _CareTipCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> tips;
  final bool hasNote;
  final String? noteText;
  const _CareTipCard({required this.icon, required this.title, required this.tips, this.hasNote = false, this.noteText});

  @override
  Widget build(BuildContext context) {
    final bulletTips = hasNote && noteText != null ? tips.where((t) => t != noteText).toList() : tips;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(color: const Color(0xFFEEF3F6), borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF2B4A8B), size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontFamily: 'Fredoka', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2B4A8B))),
            ],
          ),
          const SizedBox(height: 10),
          ...bulletTips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•  ', style: TextStyle(fontSize: 14, color: Color(0xFF2B4A8B))),
                    Expanded(
                      child: Text(tip, style: const TextStyle(fontFamily: 'Fredoka', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2B4A8B), height: 1.4)),
                    ),
                  ],
                ),
              )),
          if (hasNote && noteText != null) ...[
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(noteText!, style: const TextStyle(fontFamily: 'Fredoka', fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF2B4A8B), height: 1.4)),
            ),
          ],
        ],
      ),
    );
  }
}