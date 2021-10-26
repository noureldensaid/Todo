import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitledlogin/modules/archived_tasks/archived_tasks.dart';
import 'package:untitledlogin/modules/done_tasks/done_tasks.dart';
import 'package:untitledlogin/modules/new_tasks/new_tasks.dart';
import 'package:untitledlogin/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<String> titles = const ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  List<Widget> screens = const [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  void changeNav(int index) {
    currentIndex = index;
    emit(ChangeNavBarState());
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheet({required bool show, required IconData icon}) {
    isBottomSheetShown = show;
    fabIcon = icon;
    emit(ChangeBottomSheetState());
  }

  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDataBase() {
    openDatabase(
      'Todo.db',
      version: 1,
      onCreate: (db, version) {
        //create database
        print('database is created');
        emit(CreateDatabaseState());
        //create table in database
        db
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title STRING ,'
                ' date STRING , time STRING , status STRING )')
            .then((value) => print('table is created'))
            .catchError((error) => print('error is ${error.toString()}'));
      },
      onOpen: (database) {
        print('database is opened');

        getFromDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(CreateDatabaseState());
    });
  }

  void getFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    database!.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(GetDatabaseState());
    });
  }

  insertIntoDatabase({
    required String? title,
    required String? date,
    required String? time,
  }) async {
    await database!.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES ( "$title" , "$date" , "$time", "new" )')
          .then((value) {
        print(' values inserted successfully');
        emit(InsertDatabaseState());

        // fel layout kont ba3d ma bda5al el data banady 3aleha tany fana ha3mel mafs el kalam hena ba2a
        getFromDatabase(database);
      }).catchError((error) {
        print('error is: ${error.toString()}');
      });
      return Future(() => null);
    });
  }

  void updateDatabase({
    required String status,
    required int id,
  }) async {
    return await database!.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      getFromDatabase(database);
      emit(UpdateDatabaseState());
    });
  }

  void deleteDatabase({
    required int id,
  }) async {
    return await database!.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      [id],
    ).then((value) {
      getFromDatabase(database);
      emit(DeleteDatabaseState());
    });
  }
}
