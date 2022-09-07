import 'package:flutter/material.dart';
import 'package:proximitystore/pages/commerce/search_product_Nosheet_page.dart';
import 'package:proximitystore/pages/commerce/search_product_page.dart';
import 'package:proximitystore/utils/firebase_firestore_services.dart';

class HasProductWrapper extends StatefulWidget {
  const HasProductWrapper({Key? key}) : super(key: key);

  @override
  State<HasProductWrapper> createState() => _HasProductWrapperState();
}

class _HasProductWrapperState extends State<HasProductWrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<bool>(
        stream: FireStoreServices().getSignedInStoreHasProduct(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == false)
              return SearchProductPage();
            else
              return SearchProductNosheetPage();
          } else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
