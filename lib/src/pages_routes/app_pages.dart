import 'package:get/get.dart';
import 'package:greengrocer/src/pages/auth/views/sign_in_screen.dart';
import 'package:greengrocer/src/pages/auth/views/sign_up_screen.dart';
import 'package:greengrocer/src/pages/base/base_screen.dart';
import 'package:greengrocer/src/pages/base/binding/navigation_binding.dart';
import 'package:greengrocer/src/pages/cart/binding/cart_binding.dart';
import 'package:greengrocer/src/pages/home/binding/home_binding.dart';
import 'package:greengrocer/src/pages/product/product_screen.dart';
import 'package:greengrocer/src/pages/splash/splash_screen.dart';
import 'package:greengrocer/src/pages_routes/app_routes.dart';

abstract class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.splashRoute,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.signInRoute,
      page: () => SignInScreen(),
    ),
    GetPage(
      name: AppRoutes.signUpRoute,
      page: () => SignUnScreen(),
    ),
    GetPage(
      name: AppRoutes.baseRoute,
      bindings: [
        NavigationBinding(),
        HomeBinding(),
        CartBinding(),
      ],
      page: () => BaseScreen(),
    ),
    GetPage(
      name: AppRoutes.productRoute,
      page: () => ProductScreen(),
    ),
  ];
}
