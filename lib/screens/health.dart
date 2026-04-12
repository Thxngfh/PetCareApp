import 'package:flutter/material.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  String _selectedTab = 'information';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Tab Buttons ──
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
                          Icon(Icons.notifications_none, size: 20,
                              color: _selectedTab == 'notification' ? Colors.white : const Color(0xFFA5A5A5)),
                          const SizedBox(width: 6),
                          Text('Notification',
                              style: TextStyle(
                                fontFamily: 'Fredoka',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: _selectedTab == 'notification' ? Colors.white : const Color(0xFFA5A5A5),
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
                          Icon(Icons.info_outline, size: 20,
                              color: _selectedTab == 'information' ? Colors.white : const Color(0xFFA5A5A5)),
                          const SizedBox(width: 6),
                          Text('Information',
                              style: TextStyle(
                                fontFamily: 'Fredoka',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: _selectedTab == 'information' ? Colors.white : const Color(0xFFA5A5A5),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Content ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _selectedTab == 'information'
                  ? _buildInformationContent()
                  : const SizedBox.shrink(), 
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section: Care Tips ──
        const _SectionHeader(
          icon: Icons.add,
          iconColor: Colors.red,
          title: 'Care Tips',
        ),
        const SizedBox(height: 12),

        const _CareTipCard(
          icon: Icons.restaurant,
          title: 'Proper Feeding',
          tips: [
            'Feed according to your pet\'s age and appropriate weight',
            'Divide meals into 2–3 times per day',
            'Avoid foods that are toxic to pets',
          ],
        ),
        const SizedBox(height: 10),

        const _CareTipCard(
          icon: Icons.fitness_center,
          title: 'Exercise',
          tips: [
            'Take your pet for a walk 30–60 minutes per day',
            'Provide playtime and mental stimulation',
            'Adjust exercise level according to age',
          ],
        ),
        const SizedBox(height: 10),

        const _CareTipCard(
          icon: Icons.clean_hands_outlined,
          title: 'Hygiene Care',
          tips: [
            'Bathe your pet every 1–2 weeks',
            'Brush fur daily to prevent tangles',
            'Trim nails and clean ears regularly',
          ],
        ),
        const SizedBox(height: 10),

        const _CareTipCard(
          icon: Icons.monitor_heart_outlined,
          title: 'Health Check',
          tips: [
            'Take your pet for a health check at least once a year',
            'Vaccinate and deworm according to schedule',
            'Observe behavior and watch for unusual symptoms',
          ],
        ),

        const SizedBox(height: 24),

        // ── Section: Basic First Aid ──
        const _SectionHeader(
          icon: Icons.medical_services,
          iconColor: Colors.red,
          title: 'Basic First Aid',
        ),
        const SizedBox(height: 12),

        const _CareTipCard(
          icon: Icons.pets,
          title: 'Pet Choking',
          tips: [
            'Take your pet for a health check at least once a year', // อัปเดตข้อมูลตามที่ต้องการได้เลยครับ
            'Vaccinate and deworm according to schedule',
            'Observe behavior and watch for unusual symptoms',
          ],
        ),
        const SizedBox(height: 10),

        const _CareTipCard(
          icon: Icons.healing_outlined,
          title: 'Bite Wound',
          tips: [
            'Gently clean the wound with clean water',
            'Stop the bleeding with a clean cloth',
            'Do not use medicine or alcohol',
            'Take your pet to the veterinarian for examination',
          ],
          hasNote: true,
          noteText: 'Do not use medicine or alcohol',
        ),
        const SizedBox(height: 10),

        const _CareTipCard(
          icon: Icons.search,
          title: 'Swallowed a Foreign Object',
          tips: [
            'Do not try to make your pet vomit',
            'Keep the object (if possible) to show the vet',
            'Observe symptoms and behavior',
            'Contact a veterinarian immediately',
          ],
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}

// ── Section Header ──
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;

  const _SectionHeader({
    required this.icon,
    required this.iconColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 26),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Fredoka',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

// ── Care Tip Card ──
class _CareTipCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> tips;
  final bool hasNote;
  final String? noteText;

  const _CareTipCard({
    required this.icon,
    required this.title,
    required this.tips,
    this.hasNote = false,
    this.noteText,
  });

  @override
  Widget build(BuildContext context) {
    final bulletTips = hasNote && noteText != null
        ? tips.where((t) => t != noteText).toList()
        : tips;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF3F6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF2B4A8B), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B4A8B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...bulletTips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('•  ',
                      style: TextStyle(fontSize: 14, color: Color(0xFF2B4A8B))),
                  Expanded(
                    child: Text(
                      tip,
                      style: const TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 14,
                        color: Color(0xFF2B4A8B),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (hasNote && noteText != null) ...[
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                noteText!,
                style: const TextStyle(
                  fontFamily: 'Fredoka',
                  fontSize: 13.5,
                  color: Color(0xFF2B4A8B),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}