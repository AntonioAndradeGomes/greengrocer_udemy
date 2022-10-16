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

  final searchTitle = ''.obs;

  bool get isLastPage {
    if (currentCategory!.items.length < itensPerPage) {
      return true;
    }
    return currentCategory!.pagination * itensPerPage > allProducts.length;
  }

  @override
  void onInit() {
    super.onInit();

    debounce(
      searchTitle,
      (_) {
        update();
      },
      time: const Duration(
        milliseconds: 600,
      ),
    );

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

  Future<void> getAllProducts({bool canLoad = true}) async {
    if (canLoad) {
      setLoading(
        true,
        isProduct: true,
      );
    }

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
        currentCategory!.items.addAll(data);
      },
      error: (message) {
        _utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  void loadMoreProducts() async {
    currentCategory!.pagination++;
    getAllProducts(
      canLoad: false,
    );
  }
}
