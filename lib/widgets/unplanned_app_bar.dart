import 'package:flutter/material.dart';

class UnplannedAppBar extends StatelessWidget {
	const UnplannedAppBar({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Container(
			padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
			child: const Text(
				'Unplanned Tasks',
				style: TextStyle(
					fontSize: 24,
					fontWeight: FontWeight.bold,
					color: Colors.black,
					fontFamily: 'Exo2',
				),
			),
		);
	}
}
