import 'package:flutter/material.dart';

class AddTaskAppBar extends StatelessWidget {
	const AddTaskAppBar({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Container(
			padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
			child: Row(
				children: [
					IconButton(
						icon: const Icon(
							Icons.arrow_back,
							color: Colors.black,
							size: 24,
						),
						onPressed: () {
							Navigator.pop(context);
						},
					),
					const SizedBox(width: 8),
					const Text(
						'Create Task',
						style: TextStyle(
							fontSize: 24,
							fontWeight: FontWeight.bold,
							color: Colors.black,
							fontFamily: 'Exo2',
						),
					),
				],
			),
		);
	}
}