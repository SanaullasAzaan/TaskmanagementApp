import 'package:flutter/material.dart';

class ImageTextContainer extends StatelessWidget {
	final String imagePath;
	final String text;
	final double? width;
	final double? height;
	final double imageSize;
	final TextStyle? textStyle;

	const ImageTextContainer({
		Key? key,
		required this.imagePath,
		required this.text,
		this.width,
		this.height,
		this.imageSize = 200,
		this.textStyle,
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		final screenSize = MediaQuery.of(context).size;
		final responsiveWidth = width ?? screenSize.width * 0.9;
		final responsiveImageSize = imageSize * (screenSize.width / 400).clamp(0.5, 1.2);

		return Container(
			width: responsiveWidth,
			constraints: BoxConstraints(
				maxHeight: screenSize.height * 0.4, // Maximum 40% of screen height
				minHeight: screenSize.height * 0.2, // Minimum 20% of screen height
			),
			padding: EdgeInsets.all(screenSize.width * 0.03),
			decoration: BoxDecoration(
				color: Colors.white,
				borderRadius: BorderRadius.circular(12),
			),
			child: FittedBox(
				fit: BoxFit.scaleDown,
				child: Column(
					mainAxisSize: MainAxisSize.min,
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.center,
					children: [
						Image.asset(
							imagePath,
							width: responsiveImageSize,
							height: responsiveImageSize,
							fit: BoxFit.contain,
						),
						SizedBox(height: screenSize.height * 0.01),
						Text(
							text,
							textAlign: TextAlign.center,
							style: textStyle ?? TextStyle(
								fontSize: (screenSize.width * 0.045).clamp(14.0, 20.0),
								fontWeight: FontWeight.w500,
								color: Colors.black87,
							),
						),
					],
				),
			),
		);
	}
}
