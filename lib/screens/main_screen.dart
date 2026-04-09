import 'package:flutter/material.dart';

import 'package:pethug/screens/pet.dart';
import 'package:pethug/screens/diary.dart';
import 'package:pethug/screens/health.dart';
import 'package:pethug/screens/consult.dart';
import 'package:pethug/screens/me.dart';

void main() {
  runApp(const MaterialApp(home: MainScreen()));
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 4;
  late AnimationController _animController;
  late Animation<double> _circleAnim;

  final Color appBlueColor = const Color(0xFF9FE2FB);

  final List<Widget> _pages = const [
    PetScreen(), DiaryScreen(), HealthScreen(), ConsultScreen(), MeScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _circleAnim = Tween<double>(begin: 4, end: 4).animate(
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

  String _getTitle() {
    const titles = ['Pet', 'Diary', 'Health', 'Consult', 'Me'];
    return titles[_selectedIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appBlueColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.white),
          onPressed: () {},
        ),
        title: Text(
          _getTitle(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: appBlueColor,
        child: SafeArea(
          child: SizedBox(
            height: 65,
            child: Stack(
              children: [
                // 🩷 วงกลมชมพูเลื่อนได้อยู่หลัง icon
                AnimatedBuilder(
                  animation: _circleAnim,
                  builder: (context, _) {
                    final tabWidth = MediaQuery.of(context).size.width / 5;
                    return Positioned(
                      top: 5,
                      left: _circleAnim.value * tabWidth + (tabWidth - 36) / 2,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFC0CB),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
                // Icons และ labels ทับบน circle
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
        onTap: () => _onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: isSelected ? 26 : 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
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