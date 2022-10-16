import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/models/category_model.dart';
import 'package:greengrocer/src/models/item_model.dart';
import 'package:greengrocer/src/pages/home/repository/home_repository.dart';
import 'package:greengrocer/src/services/utils_services.dart';

const int itensPerPage = 6;

class HomeController extends GetxController {
  final _utilsServices = UtilsServices();
  final _homeRepository = HomeRepository();

  bool isCategoryLoading = false;
  bool isProductLoading = true;
  List<CategoryModel> allCategories = [];

  CategoryModel? currentCategory;

  List<ItemModel> get allProducts => currentCategory?.items ?? [];

  @override
  void onInit() {
    super.onInit();
    getAllCategories();
  }

  void setLoading(bool value, {bool isProduct = false}) {
    if (!isProduct) {
      isCategoryLoading = value;
    } else {
      isProductLoading = value;
    }
    update();
  }

  void selectCategory(CategoryModel category) {
    currentCategory = category;
    update();
    if (currentCategory!.items.isNotEmpty) {
      return;
    }
    getAllProducts();
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
    setLoading(
      true,
      isProduct: true,
    );
    Map<String, dynamic> body = {
      'page': currentCategory!.pagination,
      'categoryId': currentCategory!.id,
      'itemsPerPage': itensPerPage,
    };
    final result = await _homeRepository.getAllProducts(body);
    setLoading(
      false,
      isProduct: true,
    );
    result.when(
      success: (data) {
        debugPrint('Lista de produtos: $data');
        currentCategory!.items = data;
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
