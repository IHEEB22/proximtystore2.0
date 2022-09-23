import 'package:flutter/cupertino.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proximitystore/models/product.dart';

class ClientProvider with ChangeNotifier {
  // Completer<GoogleMapController> mapController = Completer();
  TextEditingController _labelTextController = TextEditingController();
  // List<ClientProduct> productList = [];
  TextEditingController get labelTextController => _labelTextController;
  bool hideProductSuggestion = false;
  bool hideLabelSuggestion = false;
  Product? productSelected;
  bool hideKeyBord = false;

  void setLabelValue(String productLabel) {
    _labelTextController.text = productLabel;
    notifyListeners();
  }

  void setProductSelected({required Product product}) {
    productSelected = product;
    notifyListeners();
  }

  void setHideProductSuggestion() {
    hideProductSuggestion = !hideProductSuggestion;
    notifyListeners();
  }

  Future setHideLabelSuggestion() async {
    hideLabelSuggestion = true;
    notifyListeners();
  }

  void disableHideLabelSuggestion() {
    hideLabelSuggestion = false;
    notifyListeners();
  }

  void hidekeyBord() {
    hideKeyBord = !hideKeyBord;
    notifyListeners();
  }

  // Future<List<Product>> getLabelList(String query) async {
  //   final String response =
  //       await rootBundle.loadString('assets/fake_data/clientproducts.json');

  //   List data = await json.decode(response);

  //   List<Product> productList =
  //       data.map((json) => Product.fromJson(json)).toList();
  //   return productList
  //       .where((product) => product.productName
  //           .split(' ')[0]
  //           .toLowerCase()
  //           .startsWith(query.toLowerCase()))
  //       .toList();
  // }

  // Future<List<Product>> getProductSuggestion(
  //     {required String query, required BuildContext context}) async {
  //   final String response =
  //       await rootBundle.loadString('assets/fake_data/clientproducts.json');

  //   List data = await json.decode(response);

  //   List<Product> productList =
  //       data.map((json) => Product.fromJson(json)).toList();

  //   notifyListeners();

  //   return productList.where((product) {
  //     final productNameLower = product.productName.toLowerCase();
  //     final queryLower = query.toLowerCase();

  //     Map<String, bool> filterSelected =
  //         context.read<BusinessProvider>().chekedsectorsList;
  //     if (filterSelected.isEmpty)
  //       return productNameLower.contains(queryLower);
  //     else
  //       return productNameLower.contains(queryLower) &&
  //           filterSelected.containsKey(product.productCategoy);
  //   }).toList();
  // }
}
