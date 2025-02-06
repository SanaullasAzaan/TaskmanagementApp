import 'package:flutter/material.dart';
import 'dart:async';


class OnboardingScreen extends StatefulWidget {
	const OnboardingScreen({Key? key}) : super(key: key);

	@override
	State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
	final PageController _pageController = PageController();
	int _currentPage = 0;
	Timer? _timer;

	final List<OnboardingContent> _contents = [
		OnboardingContent(
			title: 'Welcome to Task Manager',
			description: 'Manage your tasks efficiently and boost your productivity',
			image: 'assets/images/onb1.png', // Add your image assets
		),
		OnboardingContent(
			title: 'Track Your Progress',
			description: 'Monitor your task completion and stay on schedule',
			image: 'assets/images/onb2.png',
		),
		OnboardingContent(
			title: 'Achieve Your Goals',
			description: 'Complete tasks and reach your goals faster than ever',
			image: 'assets/images/onb3.png',
		),
	];

	@override
	void initState() {
		super.initState();
		// Initialize timer for auto-sliding
		_timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
			if (_currentPage < _contents.length - 1) {
				_currentPage++;
			} else {
				_currentPage = 0;
			}
			_pageController.animateToPage(
				_currentPage,
				duration: const Duration(milliseconds: 300),
				curve: Curves.easeIn,
			);
		});
	}

	@override
	void dispose() {
		_timer?.cancel();
		_pageController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.white,
			body: SafeArea(
				child: Column(
					children: [
						// Sliding indicator
						Container(
							margin: const EdgeInsets.symmetric(vertical: 16),
							height: 6,
							child: ListView.builder(
								scrollDirection: Axis.horizontal,
								itemCount: _contents.length,
								shrinkWrap: true,
								itemBuilder: (context, index) {
									return Container(
										width: MediaQuery.of(context).size.width / _contents.length,
										margin: const EdgeInsets.symmetric(horizontal: 2),
										decoration: BoxDecoration(
											color: _currentPage >= index
													? Theme.of(context).primaryColor
													: Colors.grey[800],
											borderRadius: BorderRadius.circular(3),
										),
									);
								},
							),
						),
						// Page content
						Expanded(
							child: PageView.builder(
								controller: _pageController,
								itemCount: _contents.length,
								onPageChanged: (index) {
									const NeverScrollableScrollPhysics(); // Disable manual scrolling
									setState(() {
										_currentPage = index;
									});
								},
								itemBuilder: (context, index) {
									return Padding(
										padding: const EdgeInsets.all(16.0),
										child: Column(
											mainAxisAlignment: MainAxisAlignment.center,
											children: [
												Image.asset(
													_contents[index].image,
													height: 300,
												),
												const SizedBox(height: 32),
												Text(
													_contents[index].title,
													style: const TextStyle(
														fontSize: 24,
														fontWeight: FontWeight.bold,
														color: Colors.black,
													),
													textAlign: TextAlign.center,
												),
												const SizedBox(height: 16),
												Text(
													_contents[index].description,
													style: const TextStyle(
														fontSize: 16,
														color: Colors.black,
													),
													textAlign: TextAlign.center,
												),
											],
										),
									);
								},
							),
						),
						// Get Started button
						Padding(
							padding: const EdgeInsets.all(16.0),
							child: ElevatedButton(
								onPressed: () {
									if (_currentPage == _contents.length - 1) {
										// Navigate to login screen instead of home
										Navigator.pushReplacementNamed(context, '/login');
									} else {
										_pageController.nextPage(
											duration: const Duration(milliseconds: 300),
											curve: Curves.easeInOut,
										);
									}
								},
								child: Text(
									_currentPage == _contents.length - 1 ? 'Get Started' : 'Next',
								),
							),

						),

					],
				),
			),
		);
	}
}

class OnboardingContent {
	final String title;
	final String description;
	final String image;

	OnboardingContent({
		required this.title,
		required this.description,
		required this.image,
	});
}