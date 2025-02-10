import 'package:flutter/material.dart';

class AddTaskAppBar extends StatelessWidget implements PreferredSizeWidget {
	const AddTaskAppBar({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return AppBar(
			leading: IconButton(
				icon: const Icon(Icons.arrow_back, color: Colors.black),
				onPressed: () => Navigator.pop(context),
			),
			title: const Text(
				'Add Task',
				style: TextStyle(
					color: Colors.black,
					fontSize: 20,
					fontWeight: FontWeight.bold,
				),
			),
			backgroundColor: Colors.white,
			elevation: 0,
			centerTitle: true,
		);
	}

	@override
	Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
