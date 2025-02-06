import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
	final int selectedIndex;
	final Function(int) onItemSelected;

	const CustomBottomNavigationBar({
		Key? key,
		required this.selectedIndex,
		required this.onItemSelected,
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Container(
			decoration: BoxDecoration(
				color: Colors.white,
				boxShadow: [
					BoxShadow(
						color: Colors.grey.withOpacity(0.2),
						spreadRadius: 1,
						blurRadius: 8,
						offset: const Offset(0, -2),
					),
				],
			),
			child: SafeArea(
				child: Padding(
					padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
					child: Row(
						mainAxisAlignment: MainAxisAlignment.spaceAround,
						children: [
							_buildNavItem(0, Icons.timeline, 'Timeline'),
							_buildNavItem(1, Icons.dashboard, 'Board'),
							_buildNavItem(2, Icons.work, 'Workspace'),
						],
					),
				),
			),
		);
	}

	Widget _buildNavItem(int index, IconData icon, String label) {
		final isSelected = selectedIndex == index;
		return GestureDetector(
			onTap: () => onItemSelected(index),
			behavior: HitTestBehavior.opaque,
			child: SizedBox(
				width: 80,
				child: Column(
					mainAxisSize: MainAxisSize.min,
					children: [
						Icon(
							icon,
							color: isSelected ? Colors.blue : Colors.grey,
							size: 24,
						),
						const SizedBox(height: 4),
						Text(
							label,
							style: TextStyle(
								color: isSelected ? Colors.blue : Colors.grey,
								fontSize: 12,
								fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
							),
						),
					],
				),
			),
		);
	}
}