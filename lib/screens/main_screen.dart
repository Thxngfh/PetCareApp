import 'package:flutter/material.dart';
import 'package:pethug/screens/pet.dart';
import 'package:pethug/screens/diary.dart';
import 'package:pethug/screens/health.dart';
import 'package:pethug/screens/consult.dart';
import 'package:pethug/screens/me.dart';
import 'package:pethug/screens/add_reminder.dart';
import 'package:pethug/screens/add_pet.dart'; 

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false, 
    home: MainScreen(userEmail: 'thongfahlukpear@gmail.com'), 
  ));
}

class MainScreen extends StatefulWidget {
  final String userEmail; 

  const MainScreen({super.key, this.userEmail = ''});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0; 
  late AnimationController _animController;
  late Animation<double> _circleAnim;
  final Color appBlueColor = const Color(0xFF8FE7FF);
  
  // สร้าง GlobalKey เพื่อดึงข้อมูลจากหน้าต่างๆ
  final GlobalKey<PetScreenState> _petKey = GlobalKey<PetScreenState>();
  final GlobalKey<DiaryScreenState> _diaryKey = GlobalKey<DiaryScreenState>();
  final GlobalKey<HealthScreenState> _healthKey = GlobalKey<HealthScreenState>(); 
  
  // ตัวแปรเก็บจำนวนต่างๆ
  int notificationCount = 0;
  int petCount = 0; 
  int healthRecordCount = 0; 
  // 🌟 ลบตัวแปร photoCount = 5; ออกไปแล้วครับ เพราะเราจะใช้การนับของจริงแทน

  // สร้าง List ของหน้าจอและส่งตัวแปรเข้าไป
  List<Widget> get _pages => [
    PetScreen(
      key: _petKey,
      onPetDataChanged: () => setState(() {}), 
    ),
    DiaryScreen(key: _diaryKey),
    HealthScreen(
      key: _healthKey,
      onReminderDeleted: () {
        setState(() {
          if (notificationCount > 0) notificationCount--; 
          if (healthRecordCount > 0) healthRecordCount--; 
        });
      },
    ),
    const ConsultScreen(),
    MeScreen(
      email: widget.userEmail, 
      petCount: petCount, 
      healthRecordCount: healthRecordCount,
      // 🌟 ดึงค่าจากฟังก์ชันนับรูปภาพจริงในหน้า Diary มาใส่!
      photoCount: _diaryKey.currentState?.getRealPhotoCount() ?? 0, 
    ), 
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _circleAnim = Tween<double>(begin: _selectedIndex.toDouble(), end: _selectedIndex.toDouble()).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    setState(() {
      _circleAnim = Tween<double>(
        begin: _selectedIndex.toDouble(),
        end: index.toDouble(),
      ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeInOut));
      _animController.forward(from: 0);
      _selectedIndex = index;
    });
  }

  Widget _buildTitle() {
    if (_selectedIndex == 0) {
      final petState = _petKey.currentState;
      final hasPet = petState?.hasPetData == true;
      final displayName = hasPet ? petState!.petName.toUpperCase() : "MY PET";

      return GestureDetector(
        onTap: hasPet ? () => petState!.showPetSelector(context) : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              displayName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Fredoka',
                fontSize: 24,
              ),
            ),
            if (hasPet) ...[
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, color: Colors.white, size: 28),
            ],
          ],
        ),
      );
    }

    const titles = ['Pet', 'Diary', 'Health', 'Consult', 'Me'];
    return Text(
      titles[_selectedIndex],
      style: const TextStyle(
        color: Colors.white, 
        fontWeight: FontWeight.bold, 
        fontFamily: 'Fredoka', 
        fontSize: 24
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appBlueColor,
        elevation: 0,
        leading: Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
              onPressed: () {setState(() => _selectedIndex = 2);},
            ),
            if (notificationCount > 0)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Color(0xFFFF4D4F), shape: BoxShape.circle),
                  child: Text(
                    '$notificationCount',
                    style: const TextStyle(fontFamily: 'Fredoka', color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
        title: _buildTitle(),
        centerTitle: true,
        actions: [
          if (_selectedIndex == 0 || _selectedIndex == 1 || _selectedIndex == 2)
            Container(
              margin: const EdgeInsets.only(right: 16),
              width: 38,
              height: 38,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.add, color: Colors.black87, size: 26), 
                onPressed: () async {
                  if (_selectedIndex == 0) {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddPetScreen()),
                    );
                    if (result != null && result is Map<String, dynamic>) {
                      _petKey.currentState?.addPet(result);
                      setState(() {
                        petCount++; 
                      }); 
                    }
                  } 
                  else if (_selectedIndex == 1) {
                    final diaryState = _diaryKey.currentState;
                    if (diaryState == null) return;
                    
                    if (diaryState.currentTab == 0) {
                      // 🌟 ลบ await ออกแล้ว จะได้ไม่แดง และไม่ต้องมีตัวบวกเลข photoCount แล้วครับ
                      diaryState.goToNewDiary(); 
                    } else {
                      diaryState.goToNewExpense();
                    }
                  } 
                  else if (_selectedIndex == 2) {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddReminderScreen()),
                    );
                    if (result != null) {
                      setState(() {
                        notificationCount++;
                        healthRecordCount++; 
                      }); 
                      _healthKey.currentState?.addReminder(result as Map<String, dynamic>);
                    }
                  }
                },
              ),
            ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        color: appBlueColor,
        child: SafeArea(
          child: SizedBox(
            height: 65,
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _circleAnim,
                  builder: (context, _) {
                    final tabWidth = MediaQuery.of(context).size.width / 5;
                    return Positioned(
                      top: 6,
                      left: _circleAnim.value * tabWidth + (tabWidth - 36) / 2,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(color: Color(0xFFFFC0CB), shape: BoxShape.circle),
                      ),
                    );
                  },
                ),
                Row(
                  children: [
                    _buildTab(0, Icons.pets, 'Pet'),
                    _buildTab(1, Icons.auto_stories_outlined, 'Diary'),
                    _buildTab(2, Icons.favorite_border, 'Health'),
                    _buildTab(3, Icons.chat_bubble_outline, 'Consult'),
                    _buildTab(4, Icons.person_outline, 'Me'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: isSelected ? 26 : 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Fredoka',
                color: Colors.white,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}