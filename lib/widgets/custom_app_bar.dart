import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
	final String title;
	final VoidCallback? onMenuTap;
	final Color? backgroundColor;
	final Color? titleColor;
	final Color? menuIconColor;

	const CustomAppBar({
		Key? key,
		required this.title,
		this.onMenuTap,
		this.backgroundColor,
		this.titleColor,
		this.menuIconColor,
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Container(
			padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
			decoration: BoxDecoration(
				color: backgroundColor ?? Colors.transparent,
				borderRadius: const BorderRadius.only(
					bottomLeft: Radius.circular(15),
					bottomRight: Radius.circular(15),
				),
			),
			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: [
					Text(
						title,
						style: TextStyle(
							fontSize: 24,
							fontWeight: FontWeight.bold,
							color: titleColor ?? Colors.black,
							fontFamily: 'Exo2',
						),
					),
					Container(
						decoration: BoxDecoration(
							color: Colors.grey.withOpacity(0.1),
							borderRadius: BorderRadius.circular(12),
						),
						child: Material(
							color: Colors.transparent,
							child: InkWell(
								borderRadius: BorderRadius.circular(12),
								onTap: onMenuTap ?? () {
									Scaffold.of(context).openEndDrawer();
								},
								child: Padding(
									padding: const EdgeInsets.all(8.0),
									child: Icon(
										Icons.filter_alt_outlined,
										color: menuIconColor ?? Colors.black,
										size: 24,
									),
								),
							),
						),
					),
				],
			),
		);
	}
}