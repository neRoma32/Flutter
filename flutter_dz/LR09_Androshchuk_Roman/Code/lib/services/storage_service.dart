import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_item.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  static const String _todosKey = 'todos';
  static const String _isDarkModeKey = 'isDarkMode';
  static const String _lastSaveTimeKey = 'lastSaveTime';
  
  //В
  static const String _totalCreatedKey = 'totalTasksCreated';
  static const String _streakKey = 'streak';
  static const String _lastActiveDateKey = 'lastActiveDate';

  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveTodos(List<TodoItem> todos) async {
    try {
      final List<Map<String, dynamic>> todosJson =
          todos.map((todo) => todo.toJson()).toList();
      final String jsonString = json.encode(todosJson);
      
      await _prefs?.setString(_todosKey, jsonString);
      await _prefs?.setString(_lastSaveTimeKey, DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('Error saving todos: $e');
    }
  }

  Future<List<TodoItem>> loadTodos() async {
    try {
      final String? jsonString = _prefs?.getString(_todosKey);
      if (jsonString == null) return [];
      
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((json) => TodoItem.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error saving todos: $e');
      return [];
    }
  }

  Future<void> saveThemeMode(bool isDarkMode) async {
    await _prefs?.setBool(_isDarkModeKey, isDarkMode);
  }

  bool loadThemeMode() {
    return _prefs?.getBool(_isDarkModeKey) ?? false;
  }

  String? getLastSaveTime() {
    final String? timeString = _prefs?.getString(_lastSaveTimeKey);
    if (timeString == null) return null;

    final DateTime time = DateTime.parse(timeString);
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  //В
  Future<void> saveStats(int totalCreated, int streak, String lastActiveDate) async {
    await _prefs?.setInt(_totalCreatedKey, totalCreated);
    await _prefs?.setInt(_streakKey, streak);
    await _prefs?.setString(_lastActiveDateKey, lastActiveDate);
  }

  int loadTotalCreated() => _prefs?.getInt(_totalCreatedKey) ?? 0;
  int loadStreak() => _prefs?.getInt(_streakKey) ?? 0;
  String? loadLastActiveDate() => _prefs?.getString(_lastActiveDateKey);

  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}