import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_event.dart';
import 'package:myapp/features/listings/presentation/bloc/listings_bloc.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/injection_container.dart' as di;
import 'package:myapp/widget_tree.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()..add(GetCurrentUserRequested()),
        ),
        BlocProvider(
          create: (_) => di.sl<ListingsBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Kigali City Services',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF001F3F),
            primary: const Color(0xFF001F3F),
            secondary: const Color(0xFFFFC857),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFF001B33),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF001F3F),
            foregroundColor: Colors.white,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF001F3F),
            selectedItemColor: Color(0xFFFFC857),
            unselectedItemColor: Colors.white70,
          ),
          useMaterial3: true,
        ),
        home: const WidgetTree(),
      ),
    );
  }
}
