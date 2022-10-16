import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/models/category_model.dart';
import 'package:greengrocer/src/pages/home/repository/home_repository.dart';
import 'package:greengrocer/src/services/utils_services.dart';

const int itensPerPage = 6;

class HomeController extends GetxController {
  final _utilsServices = UtilsServices();
  final _homeRepository = HomeRepository();

  List<CategoryModel> allCategories = [];

  bool isLoading = false;

  CategoryModel? currentCategory;

  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  void selectCategory(CategoryModel category) {
    currentCategory = category;
    update();

    getAllProducts();
  }

  @override
  void onInit() {
    super.onInit();
    getAllCategories();
  }

  Future<void> getAllCategories() async {
    setLoading(true);
    final result = await _homeRepository.getAllCategories();
    setLoading(false);

    result.when(
      success: (data) {
        //adicionar itens na lista eliminando repetições
        allCategories.assignAll(data);
        debugPrint('Todas as categorias: $allCategories');
        if (allCategories.isEmpty) {
          return;
        }
        selectCategory(allCategories.first);
      },
      error: (message) {
        _utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  Future<void> getAllProducts() async {
    setLoading(true);
    Map<String, dynamic> body = {
      'page': currentCategory!.pagination,
      'categoryId': currentCategory!.id,
      'itemsPerPage': itensPerPage,
    };
    final result = await _homeRepository.getAllProducts(body);
    setLoading(false);
    result.when(
      success: (data) {
        debugPrint('Lista de produtos: $data');
      },
      error: (message) {
        _utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }
}
