import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:untitledlogin/shared/cubit/cubit.dart';

Widget defaultMaterialButton({
  required double width,
  required Color background,
  required String text,
  required void Function() onPressed,
}) =>
    Container(
      width: width,
      height: 40.0,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultTextFormField({
  required String label,
  void Function()? suffixPressed,
  required TextEditingController controller,
  required IconData prefixIcon,
  BorderRadius? borderRadius,
  bool showData = false,
  IconData? suffixIcon,
  required TextInputType keyboardType,
  required FormFieldValidator<String> validator,
  void Function(String)? onFieldSubmitted,
  void Function()? onTap,
}) =>
    TextFormField(
      onTap: onTap,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: showData,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        suffixIcon: IconButton(
          icon: Icon(
            suffixIcon,
          ),
          onPressed: suffixPressed,
        ),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onFieldSubmitted: onFieldSubmitted,
    );

Widget buildEmptyScreen({required List<Map> tasks}) => BuildCondition(
      condition: tasks.isNotEmpty,
      builder: (context) => ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
          separatorBuilder: (context, index) => const Divider(thickness: 1.00),
          itemCount: tasks.length),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 60,
              color: Colors.grey.shade500,
            ),
            Text(
              'Add new tasks',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      onDismissed: (direction) {
        AppCubit.get(context).deleteDatabase(id: model['id']);
      },
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                '${model["time"]}',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model["title"]}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${model["date"]}',
                    style: const TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: 'done', id: model['id']);
              },
              icon: const Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: 'archived', id: model['id']);
              },
              icon: const Icon(
                Icons.archive,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
