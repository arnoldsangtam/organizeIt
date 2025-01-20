import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/user.dart';
import 'package:todoapp/providers/alarm_state_provider.dart';
import 'package:todoapp/providers/button_state_provider.dart';
import 'package:todoapp/providers/current_user_provider.dart';
import 'package:todoapp/screens/create_task.dart';
import 'package:todoapp/screens/home.dart';
import 'package:todoapp/screens/profile.dart';
import 'package:todoapp/screens/sign_up.dart';
import 'package:todoapp/screens/signin_screen.dart';
import 'package:todoapp/screens/start_screen.dart';
import 'package:todoapp/services/notifi_service.dart';

import 'models/task.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialize notification plugin
  NotificationService().initNotification();
  tz.initializeTimeZones();

  //get device timezone dynamically
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  // Convert the string to a Location object and set it in the timezone package
  final tz.Location location = tz.getLocation(currentTimeZone);
  //set location for timezone package
  tz.setLocalLocation(location);

  //initialize Hive
  await Hive.initFlutter();
  // register hive User type adapter
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(TaskAdapter());

  //open a hive box of User
  await Hive.openBox<User>('users');
  //open a box to store task ID
  var box = await Hive.openBox<int>('id');
  if (box.isEmpty) {
    await box.put('lastID', 0); // Set initial value to 0
  }
  Animate.restartOnHotReload = true;
  runApp(const TodoApp());
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  //function to check which screen to display first
  firstScreen() {
    var box = Hive.box<User>('users');
    List<User> users = box.values.toList();
    if (users.isEmpty) {
      return const StartScreen();
    } else {
      for (User item in users) {
        if (item.isLogin) {
          return const Home();
        } else {
          return const SignInScreen();
        }
      }
    }
  }

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  // error route
  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("Page not found!")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ButtonStateProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AlarmStateProvider(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: widget.firstScreen(),
        onGenerateRoute: (settings) {
          // Extract route name and arguments
          final String? routeName = settings.name;
          final dynamic args = settings.arguments;

          // Handle routes
          if (routeName == 'createTask') {
            return MaterialPageRoute(
              builder: (context) => const CreateTask(isCreate: true),
            );
          } else if (routeName == 'editTask') {
            // Expecting a Task object as an argument
            if (args is Task) {
              return MaterialPageRoute(
                builder: (context) => CreateTask(isCreate: false, task: args),
              );
            }
            // Handle invalid arguments
            return _errorRoute();
          } else {
            // Fallback for unknown routes
            return _errorRoute();
          }
        },
        routes: {
          'signin': (context) => const SignInScreen(),
          'signup': (context) => const SignUpScreen(),
          'home': (context) => const Home(),
          'profile': (context) => const Profile(),
        },
      ),
    );
  }
}
