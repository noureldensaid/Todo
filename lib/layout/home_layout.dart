import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:untitledlogin/shared/components/components.dart';
import 'package:untitledlogin/shared/cubit/cubit.dart';
import 'package:untitledlogin/shared/cubit/states.dart';

var taskTitleController = TextEditingController();
var taskTimeController = TextEditingController();
var taskDateController = TextEditingController();
var scaffoldKey = GlobalKey<ScaffoldState>();
var formKey = GlobalKey<FormState>();

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is InsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(AppCubit.get(context)
                  .titles[AppCubit.get(context).currentIndex]),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (AppCubit.get(context).isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    AppCubit.get(context).insertIntoDatabase(
                        title: taskTitleController.text,
                        date: taskDateController.text,
                        time: taskTimeController.text);

                    // insertIntoDatabase(
                    //   title: taskTitleController.text,
                    //   date: taskDateController.text,
                    //   time: taskTimeController.text,
                    // ).then(
                    //   (value) {
                    //     Navigator.pop(context);
                    //     AppCubit.get(context).isBottomSheetShown = false;
                    //
                    //     // setState(() {
                    //     //   fabIcon = Icons.edit;
                    //     // });
                    //   },
                    // );
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultTextFormField(
                                  label: 'Task Title',
                                  controller: taskTitleController,
                                  prefixIcon: Icons.title,
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'task title must be entered'
                                          .toLowerCase();
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                defaultTextFormField(
                                    label: 'Task Time',
                                    controller: taskTimeController,
                                    prefixIcon: Icons.watch_later_outlined,
                                    keyboardType: TextInputType.none,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'task time must be entered'
                                            .toLowerCase();
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        taskTimeController.text =
                                            value!.format(context).toString();
                                      });
                                    }),
                                const SizedBox(
                                  height: 15,
                                ),
                                defaultTextFormField(
                                  label: 'Task Date',
                                  controller: taskDateController,
                                  prefixIcon: Icons.calendar_today_rounded,
                                  keyboardType: TextInputType.none,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'task date must be entered'
                                          .toLowerCase();
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.utc(2050))
                                        .then((value) {
                                      taskDateController.text =
                                          DateFormat.yMMMEd().format(value!);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    AppCubit.get(context)
                        .changeBottomSheet(show: false, icon: Icons.edit);
                    //isBottomSheetShown = false;

                    // setState(() {
                    //   fabIcon = Icons.edit;
                    // });
                  });
                  AppCubit.get(context)
                      .changeBottomSheet(show: true, icon: Icons.add);
                  //isBottomSheetShown = true;
                  // setState(() {
                  //   fabIcon = Icons.add;
                  // });
                }
              },
              child: Icon(
                AppCubit.get(context).fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index) {
                AppCubit.get(context).changeNav(index);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check_circle_outline,
                    ),
                    label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.archive_outlined,
                    ),
                    label: 'Archive'),
              ],
            ),
            body: BuildCondition(
              condition: true,
              builder: (context) => AppCubit.get(context)
                  .screens[AppCubit.get(context).currentIndex],
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }
}

// database!.transaction((tnx) {
// tnx
//     .rawInsert('INSERT INTO tasks(title, date, time, status) '
// ' VALUES ( "first task" , "02221" , " 4:40", "new" )')
//     .then((value) {
// print('$value =values are inserted successfully');
// }).catchError((error) {
// print('error is = $error');
// });
//
// });
/*
* 1. create database
* 2. create tables
* 3. open database
* 4. insert to database
* 5. get from database
* 6. update in database
* 7. delete from database
 */

//create database function
// if (isBottomSheetShown) {
//   Navigator.pop(context);
//   isBottomSheetShown = false;
//   setState(() {
//     fabIcon = Icons.edit;
//   });
// } else {
//   isBottomSheetShown = true;
//   scaffoldKey.currentState!.showBottomSheet(
//     (context) => Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: double.infinity,
//           height: 80,
//           color: Colors.teal,
//         ),
//       ],
//     ),
//   );
//   setState(() {
//     fabIcon = Icons.add;
//   });
// }
