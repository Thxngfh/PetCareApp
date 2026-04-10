import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ConsultScreen extends StatelessWidget {
  const ConsultScreen({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      debugPrint('Could not launch $launchUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ───────── Emergency Banner ─────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE4EA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFF1144), width: 1.5),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          color: Color(0xFFFF1144), size: 26),
                      SizedBox(width: 8),
                      Text(
                        'Emergency Case',
                        style: TextStyle(
                          color: Color(0xFFFF1144),
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'If your pet has severe symptoms such as difficulty breathing, seizures, heavy bleeding or loss of consciousness, please contact a veterinarian immediately.',
                    style: TextStyle(
                      color: Color(0xFFFF1144),
                      fontSize: 13.5,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ───────── Basic Check ─────────
            const Text(
              'Basic Health Check',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InitialSymptomCheckScreen(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFFC5F3FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8FE7FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.monitor_heart_outlined,
                        color: Color(0xFF3B5998),
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Initial Symptom Assessment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3B5998),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ───────── Emergency Contact ─────────
            const Text(
              'Emergency Contact',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _EmergencyContactCard(
              hospitalName: 'Thonglor Pet Hospital',
              phoneNumber: '02-079-9999',
              isOpen24hrs: true,
              onCallTap: () => _makePhoneCall('020799999'),
            ),

            const SizedBox(height: 10),

            _EmergencyContactCard(
              hospitalName: 'Thaweerat Animal Hospital',
              phoneNumber: '08-0925-1925',
              isOpen24hrs: true,
              onCallTap: () => _makePhoneCall('0809251925'),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── Card ─────────────────────────

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFC5F3FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hospitalName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B5998),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phoneNumber,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B5998),
                  ),
                ),
              ],
            ),
          ),

          if (isOpen24hrs)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF77FF85),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Open 24 hrs',
                style: TextStyle(
                  color: Color(0xFF1D8500),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),

          const SizedBox(width: 10),

          GestureDetector(
            onTap: onCallTap,
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.phone, color: Color(0xFFFF1144)),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────── Placeholder Screen ─────────

class InitialSymptomCheckScreen extends StatelessWidget {
  const InitialSymptomCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Initial Symptom Assessment'),
        backgroundColor: const Color(0xFFB3E5FC),
      ),
      body: const Center(
        child: Text(
          'Coming soon...',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}