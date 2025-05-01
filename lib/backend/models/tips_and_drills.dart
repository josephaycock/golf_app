class GolfTip {
  final String title;
  final String description;
  final String category;

  GolfTip({
    required this.title,
    required this.description,
    required this.category,
  });
}

class PracticeDrill {
  final String title;
  final String description;
  final String difficulty;
  final String equipment;
  final int estimatedTime; // in minutes

  PracticeDrill({
    required this.title,
    required this.description,
    required this.difficulty,
    required this.equipment,
    required this.estimatedTime,
  });
}

// Sample data
final List<GolfTip> golfTips = [
  GolfTip(
    title: 'Proper Grip',
    description: 'Hold the club in your fingers, not your palms. The "V" formed by your thumb and index finger should point to your right shoulder (for right-handed golfers).',
    category: 'Fundamentals',
  ),
  GolfTip(
    title: 'Ball Position',
    description: 'For irons, position the ball in the middle of your stance. For driver, position it off your front foot. For wedges, position it slightly back in your stance.',
    category: 'Setup',
  ),
  GolfTip(
    title: 'Weight Transfer',
    description: 'Start with weight evenly distributed, shift to back foot during backswing, then transfer to front foot during downswing.',
    category: 'Swing',
  ),
];

final List<PracticeDrill> practiceDrills = [
  PracticeDrill(
    title: 'Alignment Stick Drill',
    description: 'Place an alignment stick on the ground parallel to your target line. Practice setting up with your feet, hips, and shoulders parallel to the stick.',
    difficulty: 'Beginner',
    equipment: 'Alignment stick',
    estimatedTime: 15,
  ),
  PracticeDrill(
    title: 'Towel Under Arm Drill',
    description: 'Place a towel under your right armpit (for right-handed golfers) and keep it there throughout the swing to maintain proper connection.',
    difficulty: 'Intermediate',
    equipment: 'Towel',
    estimatedTime: 20,
  ),
  PracticeDrill(
    title: 'Impact Bag Drill',
    description: 'Practice hitting into an impact bag to develop proper impact position and compression.',
    difficulty: 'Advanced',
    equipment: 'Impact bag',
    estimatedTime: 30,
  ),
]; 