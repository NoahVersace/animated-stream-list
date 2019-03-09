import 'dart:async';

import 'package:flutter/material.dart';
import 'todo.dart';
import 'snackbar_factory.dart';

class TodoBloc {
  static const snackBarRemovedContent = "Todo removed";
  static const undoLabel = "undo";

  final SnackBarFactory _snackBarFactory;
  final List<Todo> _todoList = [];

  final StreamController<List<Todo>> _todoListStream = StreamController();
  Stream<List<Todo>> get todoListStream => _todoListStream.stream;

  final StreamController<SnackBar> _snackBarEvent = StreamController();
  Stream<SnackBar> get snackBarEvent => _snackBarEvent.stream;

  TodoBloc(this._snackBarFactory) {
    _todoListStream.add(_todoList);
  }

  void addTodo(Todo todo) {
    _todoList.add(todo);
    _todoList.sort();
    _todoListStream.add(_todoList);
  }

  void removeTodo(Todo todo) {
    _todoList.remove(todo);
    _todoList.sort();
    _todoListStream.add(_todoList);
    _showUndoSnackBar(todo);
  }

  void _showUndoSnackBar(Todo todo) {
    final snackBar = _snackBarFactory.createWithAction(
        content: snackBarRemovedContent,
        label: undoLabel,
        action: () => addTodo(todo));

    _snackBarEvent.add(snackBar);
  }

  void toggleDone(Todo todo) {
    final newTodo = todo.withDone(!todo.done);
    final indexOf = _todoList.indexOf(todo);
    _todoList[indexOf] = newTodo;
    _todoListStream.add(_todoList);
  }

  void dispose() {
    _snackBarEvent.close();
    _todoListStream.close();
  }
}
