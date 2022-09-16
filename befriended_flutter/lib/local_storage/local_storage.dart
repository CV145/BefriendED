import 'dart:async';
// import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
class LocalStorage {
  /// {@macro local_storage_todos_api}
  LocalStorage({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  // final _todoStreamController = BehaviorSubject<List<Todo>>.seeded(const []);

  /// The key used for storing the todos locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const nameKey = '__name_key__';

  @visibleForTesting
  static const phoneNumberKey = '__phone_number_key__';

  @visibleForTesting
  static const countryCodeKey = '__country_code_key__';

  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  String? getName() {
    return _getValue(nameKey);
  }

  Future<void> setName(String value) {
    return _plugin.setString(nameKey, value);
  }

  String? getPhoneNumber() {
    return _getValue(phoneNumberKey);
  }

  String? getCountryCode() {
    return _getValue(countryCodeKey);
  }

  Future<void> setPhoneNumber(String phoneNumber, String countryCode) {
    _plugin.setString(countryCodeKey, countryCode);
    return _plugin.setString(phoneNumberKey, phoneNumber);
  }

  void _init() {
    // final todosJson = _getValue(kTodosCollectionKey);
    // if (todosJson != null) {
    //   final todos = List<Map>.from(json.decode(todosJson) as List)
    //       .map((jsonMap) => Todo.fromJson(Map<String, dynamic>.from(jsonMap)))
    //       .toList();
    //   _todoStreamController.add(todos);
    // } else {
    //   _todoStreamController.add(const []);
    // }
  }

  // @override
  // Stream<List<Todo>> getTodos() => _todoStreamController.asBroadcastStream();

  // @override
  // Future<void> saveTodo(Todo todo) {
  //   final todos = [..._todoStreamController.value];
  //   final todoIndex = todos.indexWhere((t) => t.id == todo.id);
  //   if (todoIndex >= 0) {
  //     todos[todoIndex] = todo;
  //   } else {
  //     todos.add(todo);
  //   }

  //   _todoStreamController.add(todos);
  //   return _setValue(kTodosCollectionKey, json.encode(todos));
  // }

  // @override
  // Future<void> deleteTodo(String id) async {
  //   final todos = [..._todoStreamController.value];
  //   final todoIndex = todos.indexWhere((t) => t.id == id);
  //   if (todoIndex == -1) {
  //     throw TodoNotFoundException();
  //   } else {
  //     todos.removeAt(todoIndex);
  //     _todoStreamController.add(todos);
  //     return _setValue(kTodosCollectionKey, json.encode(todos));
  //   }
  // }

  // @override
  // Future<int> clearCompleted() async {
  //   final todos = [..._todoStreamController.value];
  //   final completedTodosAmount = todos.where((t) => t.isCompleted).length;
  //   todos.removeWhere((t) => t.isCompleted);
  //   _todoStreamController.add(todos);
  //   await _setValue(kTodosCollectionKey, json.encode(todos));
  //   return completedTodosAmount;
  // }

  // @override
  // Future<int> completeAll({required bool isCompleted}) async {
  //   final todos = [..._todoStreamController.value];
  //   final changedTodosAmount =
  //       todos.where((t) => t.isCompleted != isCompleted).length;
  //   final newTodos = [
  //     for (final todo in todos) todo.copyWith(isCompleted: isCompleted)
  //   ];
  //   _todoStreamController.add(newTodos);
  //   await _setValue(kTodosCollectionKey, json.encode(newTodos));
  //   return changedTodosAmount;
  // }
}
