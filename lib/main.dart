import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/onboadringscreen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/unplanned_task_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp();
	runApp(
		const ProviderScope(
			child: MyApp(),
		),
	);
}

class MyApp extends StatelessWidget {
	const MyApp({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			debugShowCheckedModeBanner: false,
			title: 'Task Management App',
			theme: ThemeData(
				primarySwatch: Colors.blue,
			),
			home: const OnboardingScreen(),
			routes: {
				'/home': (context) => const HomeScreen(),
				'/login': (context) => const LoginScreen(),
				'/unplanned': (context) => const UnplannedTaskScreen(),
			},
		);
	}
}
