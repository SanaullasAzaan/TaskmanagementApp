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
		return Container(
			width: width ?? MediaQuery.of(context).size.width * 0.9,
			height: height,
			padding: const EdgeInsets.all(16),
			decoration: BoxDecoration(
				color: Colors.white,
				borderRadius: BorderRadius.circular(12),
			),

			child: Column(
				mainAxisSize: MainAxisSize.min,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Image.asset(
						imagePath,
						width: imageSize,
						height: imageSize,
						fit: BoxFit.contain,
					),
					const SizedBox(height: 12),
					Text(
						text,
						style: textStyle ?? const TextStyle(
							fontSize: 16,
							fontWeight: FontWeight.w500,
							color: Colors.black87,
						),
					),
				],
			),
		);
	}
}