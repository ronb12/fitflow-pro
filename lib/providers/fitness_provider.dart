import 'package:flutter/foundation.dart';
import 'dart:math';

class Exercise {
  final String name;
  final String category;
  final String description;
  final int duration;
  final int sets;
  final int reps;
  final String difficulty;
  final String muscleGroup;
  final String equipment;

  Exercise({
    required this.name,
    required this.category,
    required this.description,
    required this.duration,
    required this.sets,
    required this.reps,
    required this.difficulty,
    required this.muscleGroup,
    required this.equipment,
  });
}

class Workout {
  final String name;
  final List<Exercise> exercises;
  final int totalDuration;
  final String difficulty;
  final String focus;
  final DateTime createdAt;

  Workout({
    required this.name,
    required this.exercises,
    required this.totalDuration,
    required this.difficulty,
    required this.focus,
    required this.createdAt,
  });
}

class WorkoutSession {
  final String id;
  final Workout workout;
  final DateTime startTime;
  final DateTime? endTime;
  final List<ExerciseCompletion> completedExercises;

  WorkoutSession({
    required this.id,
    required this.workout,
    required this.startTime,
    this.endTime,
    required this.completedExercises,
  });

  int get duration {
    if (endTime != null) {
      return endTime!.difference(startTime).inMinutes;
    }
    return DateTime.now().difference(startTime).inMinutes;
  }
}

class ExerciseCompletion {
  final Exercise exercise;
  final int actualSets;
  final int actualReps;
  final int actualDuration;
  final bool completed;

  ExerciseCompletion({
    required this.exercise,
    required this.actualSets,
    required this.actualReps,
    required this.actualDuration,
    required this.completed,
  });
}

class FitnessProvider with ChangeNotifier {
  List<Exercise> _exercises = [];
  List<Workout> _workouts = [];
  List<Workout> _aiGeneratedWorkouts = [];
  List<WorkoutSession> _workoutSessions = [];
  
  String _userFitnessLevel = 'beginner';
  String _userGoal = 'general_fitness';
  int _userAge = 25;
  String _userGender = 'not_specified';
  double _userWeight = 70.0;
  double _userHeight = 170.0;

  // Getters
  List<Exercise> get exercises => _exercises;
  List<Workout> get workouts => _workouts;
  List<Workout> get aiGeneratedWorkouts => _aiGeneratedWorkouts;
  List<WorkoutSession> get workoutSessions => _workoutSessions;
  String get userFitnessLevel => _userFitnessLevel;
  String get userGoal => _userGoal;

  FitnessProvider() {
    _initializeExercises();
    _generateAIWorkouts();
  }

  void _initializeExercises() {
    _exercises = [
      // Cardio exercises
      Exercise(
        name: 'Running',
        category: 'cardio',
        description: 'High-intensity cardiovascular exercise',
        duration: 30,
        sets: 1,
        reps: 0,
        difficulty: 'intermediate',
        muscleGroup: 'legs',
        equipment: 'none',
      ),
      Exercise(
        name: 'Cycling',
        category: 'cardio',
        description: 'Low-impact cardiovascular workout',
        duration: 45,
        sets: 1,
        reps: 0,
        difficulty: 'beginner',
        muscleGroup: 'legs',
        equipment: 'bicycle',
      ),
      Exercise(
        name: 'Jump Rope',
        category: 'cardio',
        description: 'High-intensity cardio with coordination',
        duration: 20,
        sets: 3,
        reps: 0,
        difficulty: 'intermediate',
        muscleGroup: 'full_body',
        equipment: 'jump_rope',
      ),
      
      // Strength exercises
      Exercise(
        name: 'Push-ups',
        category: 'strength',
        description: 'Upper body strength exercise',
        duration: 0,
        sets: 3,
        reps: 15,
        difficulty: 'beginner',
        muscleGroup: 'chest',
        equipment: 'none',
      ),
      Exercise(
        name: 'Squats',
        category: 'strength',
        description: 'Lower body strength exercise',
        duration: 0,
        sets: 3,
        reps: 20,
        difficulty: 'beginner',
        muscleGroup: 'legs',
        equipment: 'none',
      ),
      Exercise(
        name: 'Plank',
        category: 'strength',
        description: 'Core stability exercise',
        duration: 60,
        sets: 3,
        reps: 0,
        difficulty: 'beginner',
        muscleGroup: 'core',
        equipment: 'none',
      ),
      
      // Flexibility exercises
      Exercise(
        name: 'Stretching',
        category: 'flexibility',
        description: 'Improve flexibility and range of motion',
        duration: 15,
        sets: 1,
        reps: 0,
        difficulty: 'beginner',
        muscleGroup: 'full_body',
        equipment: 'none',
      ),
      Exercise(
        name: 'Yoga Flow',
        category: 'flexibility',
        description: 'Gentle yoga sequence for flexibility',
        duration: 30,
        sets: 1,
        reps: 0,
        difficulty: 'beginner',
        muscleGroup: 'full_body',
        equipment: 'yoga_mat',
      ),
    ];
  }

  // AI-powered workout generation
  void _generateAIWorkouts() {
    _aiGeneratedWorkouts = [
      _generateAIWorkout('cardio_focus'),
      _generateAIWorkout('strength_focus'),
      _generateAIWorkout('flexibility_focus'),
      _generateAIWorkout('balanced'),
      _generateAIWorkout('weight_loss'),
      _generateAIWorkout('muscle_gain'),
    ];
    notifyListeners();
  }

  Workout _generateAIWorkout(String focus) {
    List<Exercise> selectedExercises = [];
    int totalDuration = 0;
    String difficulty = _userFitnessLevel;
    
    switch (focus) {
      case 'cardio_focus':
        selectedExercises = _exercises
            .where((e) => e.category == 'cardio')
            .take(3)
            .toList();
        totalDuration = 45;
        break;
      case 'strength_focus':
        selectedExercises = _exercises
            .where((e) => e.category == 'strength')
            .take(4)
            .toList();
        totalDuration = 40;
        break;
      case 'flexibility_focus':
        selectedExercises = _exercises
            .where((e) => e.category == 'flexibility')
            .take(2)
            .toList();
        totalDuration = 30;
        break;
      case 'balanced':
        selectedExercises = [
          _exercises.firstWhere((e) => e.category == 'cardio'),
          _exercises.firstWhere((e) => e.category == 'strength'),
          _exercises.firstWhere((e) => e.category == 'flexibility'),
        ];
        totalDuration = 35;
        break;
      case 'weight_loss':
        selectedExercises = [
          ..._exercises.where((e) => e.category == 'cardio').take(2),
          ..._exercises.where((e) => e.category == 'strength').take(2),
        ];
        totalDuration = 50;
        break;
      case 'muscle_gain':
        selectedExercises = [
          ..._exercises.where((e) => e.category == 'strength').take(4),
          ..._exercises.where((e) => e.category == 'cardio').take(1),
        ];
        totalDuration = 45;
        break;
    }

    return Workout(
      name: 'AI ${focus.replaceAll('_', ' ').toUpperCase()} Workout',
      exercises: selectedExercises,
      totalDuration: totalDuration,
      difficulty: difficulty,
      focus: focus,
      createdAt: DateTime.now(),
    );
  }

  // Generate personalized workout based on user preferences
  Workout generatePersonalizedWorkout() {
    List<Exercise> personalizedExercises = [];
    int totalDuration = 0;
    
    // AI logic based on user profile
    if (_userGoal == 'weight_loss') {
      // More cardio for weight loss
      personalizedExercises.addAll(
        _exercises.where((e) => e.category == 'cardio').take(2)
      );
      personalizedExercises.addAll(
        _exercises.where((e) => e.category == 'strength').take(2)
      );
      totalDuration = 50;
    } else if (_userGoal == 'muscle_gain') {
      // More strength training
      personalizedExercises.addAll(
        _exercises.where((e) => e.category == 'strength').take(4)
      );
      personalizedExercises.addAll(
        _exercises.where((e) => e.category == 'cardio').take(1)
      );
      totalDuration = 45;
    } else {
      // General fitness - balanced approach
      personalizedExercises.addAll(
        _exercises.where((e) => e.category == 'cardio').take(1)
      );
      personalizedExercises.addAll(
        _exercises.where((e) => e.category == 'strength').take(2)
      );
      personalizedExercises.addAll(
        _exercises.where((e) => e.category == 'flexibility').take(1)
      );
      totalDuration = 40;
    }

    return Workout(
      name: 'Personalized AI Workout',
      exercises: personalizedExercises,
      totalDuration: totalDuration,
      difficulty: _userFitnessLevel,
      focus: _userGoal,
      createdAt: DateTime.now(),
    );
  }

  // Start a workout session
  WorkoutSession startWorkout(Workout workout) {
    final session = WorkoutSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      workout: workout,
      startTime: DateTime.now(),
      completedExercises: [],
    );
    
    _workoutSessions.add(session);
    notifyListeners();
    return session;
  }

  // Complete an exercise in a workout session
  void completeExercise(String sessionId, Exercise exercise, int actualSets, int actualReps, int actualDuration) {
    final session = _workoutSessions.firstWhere((s) => s.id == sessionId);
    final completion = ExerciseCompletion(
      exercise: exercise,
      actualSets: actualSets,
      actualReps: actualReps,
      actualDuration: actualDuration,
      completed: true,
    );
    
    session.completedExercises.add(completion);
    notifyListeners();
  }

  // End a workout session
  void endWorkout(String sessionId) {
    final session = _workoutSessions.firstWhere((s) => s.id == sessionId);
    session.endTime = DateTime.now();
    notifyListeners();
  }

  // Update user profile
  void updateUserProfile({
    String? fitnessLevel,
    String? goal,
    int? age,
    String? gender,
    double? weight,
    double? height,
  }) {
    if (fitnessLevel != null) _userFitnessLevel = fitnessLevel;
    if (goal != null) _userGoal = goal;
    if (age != null) _userAge = age;
    if (gender != null) _userGender = gender;
    if (weight != null) _userWeight = weight;
    if (height != null) _userHeight = height;
    
    // Regenerate AI workouts with new profile
    _generateAIWorkouts();
    notifyListeners();
  }

  // Get exercises by category
  List<Exercise> getExercisesByCategory(String category) {
    return _exercises.where((e) => e.category == category).toList();
  }

  // Get exercises by difficulty
  List<Exercise> getExercisesByDifficulty(String difficulty) {
    return _exercises.where((e) => e.difficulty == difficulty).toList();
  }

  // Search exercises
  List<Exercise> searchExercises(String query) {
    return _exercises
        .where((e) => 
            e.name.toLowerCase().contains(query.toLowerCase()) ||
            e.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Get workout statistics
  Map<String, dynamic> getWorkoutStats() {
    final completedSessions = _workoutSessions.where((s) => s.endTime != null).toList();
    
    if (completedSessions.isEmpty) {
      return {
        'totalWorkouts': 0,
        'totalDuration': 0,
        'averageDuration': 0,
        'favoriteFocus': 'None',
      };
    }

    final totalDuration = completedSessions.fold<int>(0, (sum, session) => sum + session.duration);
    final averageDuration = totalDuration / completedSessions.length;
    
    // Find most common workout focus
    final focusCounts = <String, int>{};
    for (final session in completedSessions) {
      focusCounts[session.workout.focus] = (focusCounts[session.workout.focus] ?? 0) + 1;
    }
    final favoriteFocus = focusCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return {
      'totalWorkouts': completedSessions.length,
      'totalDuration': totalDuration,
      'averageDuration': averageDuration.round(),
      'favoriteFocus': favoriteFocus,
    };
  }
}
