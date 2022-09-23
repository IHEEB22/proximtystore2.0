import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:proximitystore/config/routes/routes.dart';
import 'package:proximitystore/providers/business_provider.dart';
import 'package:proximitystore/providers/client_provider.dart';
import 'package:proximitystore/utils/firebase_firestore_services.dart';

import '../config/colors/app_colors.dart';
import '../config/images/app_images.dart';
import '../models/product.dart';

class AutocompleteSearchLabel extends StatelessWidget {
  const AutocompleteSearchLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientProvider>(
      builder: (context, value, child) => Container(
        child: Focus(
          onFocusChange: (bool focus) => focus
              ? context.read<ClientProvider>().disableHideLabelSuggestion()
              : null,
          child: TypeAheadFormField<Product>(
            suggestionsBoxVerticalOffset: 0.04.sh,
            hideSuggestionsOnKeyboardHide:
                context.watch<ClientProvider>().hideLabelSuggestion,
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
              color: AppColors.invisibleColor,
              constraints: BoxConstraints(maxHeight: 160),
              offsetX: 1.02,
              elevation: 0,
            ),
            debounceDuration: Duration(microseconds: 500),
            onSuggestionSelected: (Product sugesstion) async {
              context
                  .read<ClientProvider>()
                  .setLabelValue(sugesstion.productName);

              Navigator.pushNamed(context, AppRoutes.searchFiltredProductPage);
            },
            itemBuilder: (context, Product suggestion) {
              final product = suggestion;

              return Container(
                child: ListTile(
                  contentPadding:
                      EdgeInsets.only(left: 12, bottom: 0, right: 6),
                  leading: SizedBox(
                    width: 140,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      product.productName.split(' ')[0],
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontFamily: "Montserrat",
                            fontSize: 18.sp,
                            letterSpacing: 0.02,
                          ),
                    ),
                  ),
                  title: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      product.productCategoy,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontFamily: "Montserrat",
                            fontSize: 12.sp,
                            color: AppColors.blueGreyColor,
                            fontWeight: FontWeight.w300,
                          ),
                    ),
                  ),
                  trailing: Text(
                    '(' +
                        // '${product.inStock.toString()}'
                        Random().nextInt(100).toString() +
                        '\+' ')',
                    style: Theme.of(context).textTheme.headline2?.copyWith(
                          fontFamily: "Montserrat",
                          fontSize: 12.sp,
                          letterSpacing: 0.02,
                          // fontWeight: FontWeight.w300,
                        ),
                  ),
                ),
              );
            },
            errorBuilder: (context, error) => SizedBox(
              child: Text('$error'),
            ),
            noItemsFoundBuilder: (context) => Container(
              child: Center(
                child: Text(
                  'Produit n\'éxiste pas',
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        fontFamily: 'Montserrat',
                        fontSize: 18.sp,
                        color: AppColors.blueGreyColor,
                      ),
                ),
              ),
            ),
            suggestionsCallback: (String query) async {
              return await FireStoreServices().getAllProductsLabel(query);
            },
            textFieldConfiguration: TextFieldConfiguration(
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                  RegExp(
                      '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                ),
              ],
              // enabled: context.read<ClientProvider>().hideLabelSuggestion,
              autofocus: true,
              // focusNode: context.watch<BusinessProvider>().serachProductFocusNode,
              controller: context
                  .watch<BusinessProvider>()
                  .productTextEditingController,

              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    height: 1.2,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                  ),
              decoration: InputDecoration(
                isDense: true,
                prefixIconConstraints:
                    BoxConstraints(maxHeight: 0.028.sh, maxWidth: 0.1.sw),
                prefixIcon: Image(
                    height: 0.12.sh,
                    width: 0.2.sw,
                    image: AssetImage(
                      AppImages.searchIcon,
                    )),
                hintText: 'searchProduct'.tr(),
                hintStyle: TextStyle(
                  color: AppColors.blueGreyColor,
                  fontFamily: 'Montserrat',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w300,
                ),
                fillColor: Colors.white,
                filled: true,
                errorStyle: TextStyle(
                  color: AppColors.pinkColor,
                  fontFamily: 'Montserrat',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.2,
                ),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 0.0426.sw, vertical: 0.0166.sh),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.sm),
                  ),
                  borderSide: BorderSide(
                    color: AppColors.blueGreyColor,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.deepBlueColor,
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.pinkColor,
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.pinkColor,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
