import 'package:flutter/material.dart';

class InitialSymptomCheckScreen extends StatelessWidget {
  const InitialSymptomCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SymptomSelectionScreen();
  }
}

//Symptom Selection

class SymptomSelectionScreen extends StatefulWidget {
  const SymptomSelectionScreen({super.key});

  @override
  State<SymptomSelectionScreen> createState() => _SymptomSelectionScreenState();
}

class _SymptomSelectionScreenState extends State<SymptomSelectionScreen> {
  final List<String> _symptoms = [
    'Vomiting',
    'Diarrhea',
    'Fever',
    'Lethargy / Weakness',
    'Coughing',
    'Difficulty breathing',
    'Limping',
    'Loss of appetite',
    'Seizures / Twitching',
    'Bleeding',
  ];

  final Set<String> _selected = {};

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar('Initial Symptom Check'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'You can select more than one symptom',
              style: TextStyle(fontFamily: 'Fredoka', fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: _symptoms.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3.2,
                ),
                itemBuilder: (context, index) {
                  final symptom = _symptoms[index];
                  final isSelected = _selected.contains(symptom);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selected.remove(symptom);
                        } else {
                          _selected.add(symptom);
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFC5F3FF)
                            : const Color(0xFFE9EDF0),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFC5F3FF)
                              : const Color(0xFFE9EDF0),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          symptom,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Fredoka',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? const Color(0xFF3B5998) : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            _buildBottomButtons(
              context,
              onBack: () => Navigator.pop(context),
              onNext: _selected.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SeverityLevelScreen(
                            selectedSymptoms: _selected.toList(),
                          ),
                        ),
                      );
                    },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

//Severity Level

enum SeverityLevel { mild, moderate, severe }

class SeverityLevelScreen extends StatefulWidget {
  final List<String> selectedSymptoms;

  const SeverityLevelScreen({super.key, required this.selectedSymptoms});

  @override
  State<SeverityLevelScreen> createState() => _SeverityLevelScreenState();
}

class _SeverityLevelScreenState extends State<SeverityLevelScreen> {
  SeverityLevel? _selected;

  static const _options = [
    _SeverityOption(
      level: SeverityLevel.mild,
      label: 'Mild',
      description: 'Still eating and playing normally.',
      color: Color(0xFF3B5998),
    ),
    _SeverityOption(
      level: SeverityLevel.moderate,
      label: 'Moderate',
      description: 'Symptoms are noticeable and affect behavior.',
      color: Color(0xFFE88400),
    ),
    _SeverityOption(
      level: SeverityLevel.severe,
      label: 'Severe',
      description: 'Severe symptoms: not eating and not moving.',
      color: Color(0xFFFF1144),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar('Initial Symptom Check'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Severity Level',
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'How severe are the symptoms?',
              style: TextStyle(fontFamily: 'Fredoka', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 24),
            ..._options.map((option) => _SeverityCard(
                  option: option,
                  isSelected: _selected == option.level,
                  onTap: () => setState(() => _selected = option.level),
                )),
            const Spacer(),
            _buildBottomButtons(
              context,
              onBack: () => Navigator.pop(context),
              onNext: _selected == null
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AssessmentResultScreen(
                            selectedSymptoms: widget.selectedSymptoms,
                            severity: _selected!,
                          ),
                        ),
                      );
                    },
              nextLabel: 'View Results',
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SeverityOption {
  final SeverityLevel level;
  final String label;
  final String description;
  final Color color;

  const _SeverityOption({
    required this.level,
    required this.label,
    required this.description,
    required this.color,
  });
}

class _SeverityCard extends StatelessWidget {
  final _SeverityOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _SeverityCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? (option.level == SeverityLevel.mild
                  ? const Color(0xFFBFE9F5)
                  : option.level == SeverityLevel.moderate
                      ? const Color(0xFFFFF59D)
                      : const Color(0xFFFFCDD2))
              : const Color(0xFFE9EDF0),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: option.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.label,
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: option.color,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  option.description,
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: option.color.withOpacity(0.85),
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

//Assessment Result 

class AssessmentResultScreen extends StatelessWidget {
  final List<String> selectedSymptoms;
  final SeverityLevel severity;

  const AssessmentResultScreen({
    super.key,
    required this.selectedSymptoms,
    required this.severity,
  });

  _ResultContent _getResult() {
    final urgentSymptoms = {
      'Difficulty breathing',
      'Seizures / Twitching',
      'Bleeding',
    };
    final hasUrgentSymptom = selectedSymptoms.any((s) => urgentSymptoms.contains(s));

    if (hasUrgentSymptom || severity == SeverityLevel.severe) {
      //  Severe / Urgent
      return _ResultContent(
        heroBg: const Color(0xFFFFCDD2),
        heroIcon: Icons.warning_amber_rounded,
        heroIconColor: const Color(0xFFFF1144),
        heroTitle: 'Seek veterinary\ncare immediately!',
        heroTitleColor: const Color(0xFFFF1144),
        recommendations: [
          'Please take your pet to see a veterinarian as soon as possible.',
          'If it is outside clinic hours, please contact a 24-hour emergency veterinary clinic.',
          'Do not wait to monitor the symptoms or give medication on your own.',
        ],
        noteBg: const Color.fromARGB(255, 255, 235, 240),
      );
    } else if (severity == SeverityLevel.moderate) {
      //  Moderate
      return _ResultContent(
        heroBg: const Color(0xFFFFF9C4),
        heroIcon: Icons.add_circle,
        heroIconColor: const Color(0xFFE88400),
        heroTitle: 'See a veterinarian\nwithin 24 hours',
        heroTitleColor: const Color(0xFFE88400),
        recommendations: [
          'Schedule a veterinary appointment within 1–2 days.',
          'Monitor the symptoms closely.',
          'If the symptoms worsen, take your pet to see a veterinarian immediately.',
        ],
        noteBg: const Color.fromARGB(255, 255, 235, 240),
      );
    } else {
      //  Mild
      return _ResultContent(
        heroBg: const Color(0xFFBFE9F5),
        heroIcon: Icons.visibility,
        heroIconColor: const Color(0xFF3B5998),
        heroTitle: 'Continue to\nMonitor Symptoms',
        heroTitleColor: const Color(0xFF3B5998),
        recommendations: [
          'The symptoms may not be severe, but they should be monitored closely.',
          'Provide clean water and easily digestible food.',
          'Let your pet rest in a warm and quiet place.',
          'If the symptoms do not improve within 1–2 days, consult a veterinarian.',
        ],
        noteBg: const Color.fromARGB(255, 255, 235, 240),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = _getResult();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar('Initial Symptom Check'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Hero Result Card 
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
              decoration: BoxDecoration(
                color: result.heroBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(result.heroIcon, size: 80, color: result.heroIconColor),
                  const SizedBox(height: 16),
                  Text(
                    result.heroTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: result.heroTitleColor,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            //Recommendations Card 
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.info_outline, size: 18, color: Color(0xFF3B5998)),
                      SizedBox(width: 6),
                      Text(
                        'Recommendations',
                        style: TextStyle(
                          fontFamily: 'Fredoka',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3B5998),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...result.recommendations.map(
                    (tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '· ',
                            style: TextStyle(fontSize: 14, color: Color(0xFF3B5998)),
                          ),
                          Expanded(
                            child: Text(
                              tip,
                              style: const TextStyle(
                                fontFamily: 'Fredoka',
                                fontSize: 13.5,
                                color: Color(0xFF3B5998),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            //Note Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: result.noteBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B5998),
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: 'Note: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          'This system provides preliminary advice only and cannot replace a diagnosis from a veterinarian. Please consult a veterinarian for proper treatment.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ── Close Button ───────────────────────────────────────────────
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8FE7FF),
                  padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ResultContent {
  final Color heroBg;
  final IconData heroIcon;
  final Color heroIconColor;
  final String heroTitle;
  final Color heroTitleColor;
  final List<String> recommendations;
  final Color noteBg;

  const _ResultContent({
    required this.heroBg,
    required this.heroIcon,
    required this.heroIconColor,
    required this.heroTitle,
    required this.heroTitleColor,
    required this.recommendations,
    required this.noteBg,
  });
}

//Shared Helpers 

PreferredSizeWidget _buildAppBar(String title) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: const Color(0xFF8FE7FF),
    elevation: 0,
    title: Text(
      title,
      style: const TextStyle(fontFamily: 'Fredoka', color: Colors.white, fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
    iconTheme: const IconThemeData(color: Colors.white),
  );
}

Widget _buildBottomButtons(
  BuildContext context, {
  required VoidCallback onBack,
  required VoidCallback? onNext,
  String nextLabel = 'Next',
}) {
  return Row(
    children: [
      Expanded(
        child: ElevatedButton(
          onPressed: onBack,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8FE7FF),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Back',
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: ElevatedButton(
          onPressed: onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: onNext == null
                ? const Color(0xFFE0E0E0)
                : const Color(0xFF3B5998),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 0,
          ),
          child: Text(
            nextLabel,
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: onNext == null ? Colors.grey : Colors.white,
            ),
          ),
        ),
      ),
    ],
  );
}