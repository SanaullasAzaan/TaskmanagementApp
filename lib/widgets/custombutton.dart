import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
	final String text;
	final VoidCallback onPressed;
	final double? width;
	final double? height;
	final Color? backgroundColor;
	final Color? textColor;
	final double borderRadius;
	final EdgeInsetsGeometry? padding;
	final bool isLoading;

	const CustomButton({
		Key? key,
		required this.text,
		required this.onPressed,
		this.width,
		this.height = 50,
		this.backgroundColor,
		this.textColor,
		this.borderRadius = 12,
		this.padding,
		this.isLoading = false,
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return SizedBox(
			width: width,
			height: height,
			child: ElevatedButton(
				onPressed: isLoading ? null : onPressed,
				style: ElevatedButton.styleFrom(
					  backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
					  padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
					  shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(borderRadius),
					  ),

				),
				child: isLoading
						? const SizedBox(
								height: 20,
								width: 20,
								child: CircularProgressIndicator(
									strokeWidth: 2,
									valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
								),
							)
						: Text(
								text,
								style: TextStyle(
									color: textColor ?? Colors.white,
									fontSize: 16,
									fontWeight: FontWeight.w600,
								),
							),
			),
		);
	}
}