import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;

class LocalistaionControllerprovider with ChangeNotifier {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController adress = TextEditingController();
  FocusNode townFocusNode = FocusNode();
  bool townOnFocus = false;
  bool isAddressNotSelected = true;
  bool adressSelectedInParis = false;
  String clientLocation = '';

  Placemark _pickPlaceMark = Placemark();
  Placemark get pickPlaceMark => _pickPlaceMark;
  List<Prediction> _predictionList = [];
  List<Prediction> get predictionList => _predictionList;

  void setIsAdressSelected() {
    isAddressNotSelected = false;
    notifyListeners();
  }

  void disposeAdressValue() {
    adress.clear();
    isAddressNotSelected = !isAddressNotSelected;
    notifyListeners();
  }

  void disposeEmailValue() {
    emailTextEditingController.clear();
    notifyListeners();
  }

  bool space() {
    return (adress.text.isNotEmpty && isAddressNotSelected);
  }

  void disposeAdressListeners() {
    isAddressNotSelected = true;
    notifyListeners();
  }

  void addressSelected({required Prediction suggestion}) {
    adress.text = suggestion.description.toString();
    notifyListeners();
    clientLocation = adress.text;
  }

  Future<List<Prediction>> searchLocation(String pattern) async {
    _predictionList = [];
    http.Response response = await http.get(
      headers: {"Content-Type": "application/json"},
      Uri.parse(
          "http://mvs.bslmeiyu.com/api/v1/config/place-api-autocomplete?search_text=${pattern}"),
    );

    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['status'] == 'OK') {
      data['predictions'].forEach(
          (prediction) => _predictionList.add(Prediction.fromJson(prediction)));
    }

    notifyListeners();
    return _predictionList;
  }

  Future<bool> isAdressSelectedInParis(String suggestion) async {
    var location = await locationFromAddress(suggestion);
    GeoPoint clientLocation =
        GeoPoint(location.first.latitude, location.first.longitude);
// 48.901071, 2.345290
// 48.816235, 2.361633

// 48.845301, 2.258381
// 48.850886, 2.415445

    return (48.816235 <= clientLocation.latitude) &&
        (clientLocation.latitude <= 48.901071) &&
        (2.251873 <= clientLocation.longitude) &&
        (clientLocation.longitude <= 2.415445);
  }
}

  // Future<List<Product>> getProductSuggestion(String query) async {
  //   final String response = await rootBundle.loadString('assets/fake_data/products.json');
  //   List data = await json.decode(response);
  //   return data.map((json) => Product.fromJson(json)).where((product) {
  //     final productNameLower = product.productName.toLowerCase();
  //     final queryLower = query.toLowerCase();
  //     return productNameLower.contains(queryLower);
  //   }).toList();
  // }

  

