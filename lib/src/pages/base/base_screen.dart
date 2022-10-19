import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/pages/base/controller/navigation_controller.dart';
import 'package:greengrocer/src/pages/cart/view/cart_tab.dart';
import 'package:greengrocer/src/pages/home/view/home_tab.dart';
import 'package:greengrocer/src/pages/orders/orders_tab.dart';
import 'package:greengrocer/src/pages/profile/profile_tab.dart';

class BaseScreen extends StatelessWidget {
  final _navigationController = Get.find<NavigationController>();

  BaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: _navigationController.currentIndex,
          onTap: (index) {
            _navigationController.navigatePageView(index);
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.green,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withAlpha(100),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart_outlined,
              ),
              label: 'Carrinho',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
              ),
              label: 'Pedidos',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
              ),
              label: 'Perfil',
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _navigationController.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HomeTab(),
          const CartTab(),
          const OrdersTab(),
          const ProfileTab(),
        ],
      ),
    );
  }
}
