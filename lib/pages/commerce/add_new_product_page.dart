import 'dart:io';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:proximitystore/config/images/app_images.dart';
import 'package:proximitystore/config/routes/routes.dart';
import 'package:proximitystore/models/product.dart';
import '../../config/colors/app_colors.dart';
import '../../providers/business_provider.dart';
import '../../services/validation_items.dart';
import '../../utils/firebase_firestore_services.dart';
import '../../widgets/custom_blue_button.dart';
import '../../widgets/custom_cupertino_dialog.dart';
import '../../widgets/custom_grey_button.dart';
import '../../widgets/custom_white_button.dart';
import '../../widgets/text_input_field.dart';

class AddNewProductPage extends StatelessWidget {
  const AddNewProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Consumer<BusinessProvider>(
              builder: (context, value, child) => Scaffold(
                body: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.zero,
                        child: context
                                .read<BusinessProvider>()
                                .isPickedFileEmpty
                            ? Image(
                                fit: BoxFit.cover,
                                height: 0.505.sh,
                                image: AssetImage(
                                    'assets/icons/commerce_picture_place_holder.png'),
                              )
                            : FutureBuilder<PickedFile?>(
                                future:
                                    context.read<BusinessProvider>().pickedFile,
                                builder: (context, snap) {
                                  if (snap.hasData) {
                                    return Container(
                                      height: 0.505.sh,
                                      width: double.infinity,
                                      child: Image.file(
                                        File(snap.data!.path),
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  } else if (!snap.hasData) {
                                    return SizedBox(
                                      child: Column(
                                        children: [
                                          Image(
                                            image: AssetImage(
                                                'assets/icons/commerce_picture_place_holder.png'),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: Text(
                                          'problem lors de l\'importation de votre photo'),
                                    );
                                  }
                                }),
                      ),
                      0.0197.sh.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.082.sw),
                        child: CustomWhiteButton(
                          leading: Image(
                            image: AssetImage(AppImages.editIcon),
                          ),
                          textInput: 'editPhoto'.tr(),
                          onPressed: () async {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (_) => CustomCupertinoDialog(
                                title: 'editPhoto'.tr(),
                                firstActionText: 'chooseFromGallery'.tr(),
                                secondActionText: 'openTheCamera'.tr(),
                                firstOnPresssed: () {
                                  context
                                      .read<BusinessProvider>()
                                      .setPickedFileFromGalery();
                                },
                                secondOnPresssed: () {
                                  context
                                      .read<BusinessProvider>()
                                      .setPickedFileFromCamera();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      0.065.sh.verticalSpace,
                      TextInputField(
                          minLines: 5,
                          maxLines: 5,
                          maxLength: 150,
                          additionalTopPading: 0.04.sh,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: context
                              .watch<BusinessProvider>()
                              .productDescription,
                          hintText: 'enterdescription'.tr(),
                          inputLabel: 'productDescription'.tr(),
                          keyboardType: TextInputType.multiline,
                          validator: (val) {
                            if ((val == null) || (val.isEmpty)) {
                              return "ce champ est obligatoire !";
                            } else if (val.length < 8) {
                              return "Description trés court";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            context
                                .read<BusinessProvider>()
                                .setTemperleftProduct();
                          }),
                      0.015.sh.verticalSpace,
                      Padding(
                        padding: EdgeInsets.only(
                          right: 0.082.sw,
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            '${context.watch<BusinessProvider>().temperLeftProduct} ' +
                                'CharactersLeft'.tr(),
                            style:
                                Theme.of(context).textTheme.headline3?.copyWith(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ),
                      ),
                      0.045.sh.verticalSpace,
                      TextInputField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (price) =>
                            ValidationItem(val: price).validateProductPrice(),
                        controller:
                            context.watch<BusinessProvider>().productPrice,
                        hintText: 'enterPrice'.tr(),
                        inputLabel: 'price'.tr(),
                        keyboardType: TextInputType.phone,
                      ),
                      0.0418.sh.verticalSpace,
                      Padding(
                        padding: EdgeInsets.only(left: 0.082.sw),
                        child: Text(
                          'sector'.tr(),
                          style:
                              Theme.of(context).textTheme.headline3?.copyWith(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.4,
                                  ),
                        ),
                      ),
                      0.03.sh.verticalSpace,
                      Consumer<BusinessProvider>(
                        builder: (context, value, child) => SizedBox(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0.082.sw),
                            child: Container(
                              width: double.infinity,
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: context
                                    .watch<BusinessProvider>()
                                    .chekedsectorsList
                                    .keys
                                    .map((item) {
                                  return GestureDetector(
                                    onTap: () {
                                      context
                                          .read<BusinessProvider>()
                                          .setSectorCheked(sectorName: item);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(3.sm),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.w, vertical: 13.h),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: (context
                                                      .watch<BusinessProvider>()
                                                      .chekedsectorsList[item] ??
                                                  false)
                                              ? AppColors.lightGreenColor
                                              : AppColors.deepBlueColor,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(6.0),
                                        ),
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.w700),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: item,
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.deepBlueColor,
                                                  )),
                                              context
                                                          .watch<
                                                              BusinessProvider>()
                                                          .chekedsectorsList[item] ??
                                                      false
                                                  ? TextSpan(
                                                      text: '  ✓',
                                                      style: TextStyle(
                                                        color: AppColors
                                                            .lightGreenColor,
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    )
                                                  : TextSpan(text: ' '),
                                            ]),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      0.0763.sh.verticalSpace,
                      Consumer<BusinessProvider>(
                          builder: (context, value, child) => context
                                  .watch<BusinessProvider>()
                                  .getIsAddProductButtonEnabled()
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0.043.sw),
                                  child: SizedBox(
                                      width: double.infinity,
                                      child: CustomBlueButton(
                                        onPressed: () async {
                                          Product newProduct = Product(
                                            storeId: await context
                                                .read<BusinessProvider>()
                                                .getStoreIdConnected(),
                                            productName: context
                                                .read<BusinessProvider>()
                                                .productDescription
                                                .text,
                                            productImage:
                                                await FireStoreServices()
                                                    .getImageurl(
                                                        context: context,
                                                        path: 'products'),
                                            productPrice: double.parse(context
                                                .read<BusinessProvider>()
                                                .productPrice
                                                .text),
                                            productStatus: 'en attente',
                                            productCategoy: context
                                                .read<BusinessProvider>()
                                                .lastSectorNameSelected,
                                          );

                                          newProduct.productPrice.toString().isNotEmpty &&
                                                  newProduct.productCategoy
                                                      .isNotEmpty &&
                                                  newProduct
                                                      .productImage.isNotEmpty
                                              ? await FireStoreServices()
                                                  .createProduct(newProduct)
                                                  .then((value) => Navigator.pushNamed(
                                                          context, AppRoutes.searchProductPage, arguments: {
                                                        'currentRoute':
                                                            'addNewProductpage'
                                                      }).whenComplete(() => context
                                                          .read<BusinessProvider>()
                                                          .disposeAddproductControllers()))
                                              : null;
                                        },
                                        textInput: 'addTheProduct'.tr(),
                                      )),
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0.043.sw),
                                  child: SizedBox(
                                      width: double.infinity,
                                      child: CustomGreyButton(
                                        onPressed: null,
                                        textInput: 'addTheProduc'.tr(),
                                      )),
                                )),
                      0.0022.sh.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 0.067.sw,
                top: 0.0689,
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context
                      .read<BusinessProvider>()
                      .disposeAddproductControllers();
                },
                child: Text(
                  'cancel'.tr(),
                  style: Theme.of(context).textTheme.headline2?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
