import 'package:get/get.dart';
import 'package:notes/module/Auth/presentation/pages/login_screen.dart';
import 'package:notes/module/Auth/presentation/pages/register_screen.dart';
import 'package:notes/module/home/presentation/pages/add_note.dart';
import 'package:notes/module/home/presentation/pages/home_screen.dart';

class AppRoutes {
  /// Auth
  static const String loginScreen = '/loginScreen';
  static const String homeScreen = '/homeScreen';
  static const String registerScreen = '/registerScreen';
  static const String todoForm = '/TodoForm';

  static List<GetPage> get routes => [
        GetPage(
          name: loginScreen,
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: homeScreen,
          page: () => const HomeScreen(),
        ),
        GetPage(
          name: registerScreen,
          page: () => const RegisterScreen(),
        ),
        GetPage(
          name: todoForm,
          page: () => NoteForm(),
        ),
      ];
}
