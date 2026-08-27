class HabitModel {
  final String id;
  final String name;
  final String category;
  final int streak;
  final bool isCompletedToday;
  final String type;
  final List<bool> weeklyProgress;

  // Getters to bridge any naming differences across files safely
  String get title => name;
  int get streakCount => streak;

  HabitModel({
    required this.id,
    required this.name,
    required this.category,
    required this.streak,
    required this.isCompletedToday,
    required this.type,
    List<bool>? weeklyProgress,
  }) : weeklyProgress = weeklyProgress ?? const [false, false, false, false, false, false, false];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'streak': streak,
      'isCompletedToday': isCompletedToday,
      'type': type,
      'weeklyProgress': weeklyProgress,
    };
  }

  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name']?.toString() ?? json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? 'GENERAL',
      streak: json['streak'] is int 
          ? json['streak'] 
          : (json['streakCount'] is int ? json['streakCount'] : int.tryParse(json['streak']?.toString() ?? '1') ?? 1),
      isCompletedToday: json['isCompletedToday'] == true,
      type: json['type']?.toString() ?? 'productivity',
      weeklyProgress: json['weeklyProgress'] != null 
          ? List<bool>.from(json['weeklyProgress']) 
          : const [false, false, false, false, false, false, false],
    );
  }

  HabitModel copyWith({
    String? name,
    String? category,
    int? streak,
    bool? isCompletedToday,
    String? type,
    List<bool>? weeklyProgress,
    int? streakCount,
  }) {
    return HabitModel(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      streak: streakCount ?? streak ?? this.streak,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
      type: type ?? this.type,
      weeklyProgress: weeklyProgress ?? this.weeklyProgress,
    );
  }
}