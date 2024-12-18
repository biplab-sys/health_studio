import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health_studio_user/core/controllers/language_controller.dart';
import 'package:health_studio_user/ui/widgets/app_bar.dart';
import 'package:health_studio_user/core/controllers/menu_controller.dart';
import 'package:health_studio_user/utils/colors.dart';
import 'package:health_studio_user/utils/spacing.dart';
import 'package:health_studio_user/ui/widgets/food_detail_card.dart';

class FoodDetailPage extends StatefulWidget {
  const FoodDetailPage({super.key});

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomMenuController>(
        init: CustomMenuController(),
        builder: (menuController) {
          return Scaffold(
            // bottomNavigationBar: bottomNavigationBar(),
            backgroundColor: Colors.blueAccent.shade400,
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/background.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                menuController.menuDetail == null
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.network(
                          menuController.menuDetail!.menu.image,
                          height: 0.42.sh,
                          width: 1.sw,
                          fit: BoxFit.fitWidth,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return SizedBox(
                              height: 0.42.sh,
                              width: 1.sw,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: activeDateBgColor,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            log("ERROR BUILDER $error");
                            return SizedBox(
                              height: 0.42.sh,
                              width: 1.sw,
                            );
                          },
                        ),
                      ),
                menuController.menuDetail == null
                    ? const SizedBox()
                    : SingleChildScrollView(
                        child: SafeArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              sizedBoxHeight6,
                              appBar(),
                              sizedBoxHeight16,
                              Center(
                                child: GetBuilder<LanguageTogglerController>(
                                  builder: (languageController) =>
                                      FoodDetailCard(
                                    nutritionContent: menuController
                                        .menuDetail!.attribute
                                        .map(
                                          (e) => Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12.0),
                                            child: NutritionContent(
                                              image: SvgPicture.asset(
                                                  "assets/images/menu/${e.titleEn}_icon.svg"),
                                              nutritionContent: e.value,
                                              nutritionName:
                                                  languageController.isEnglish
                                                      ? e.titleEn
                                                      : e.titleAr!,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    foodName: languageController.isEnglish
                                        ? menuController
                                            .menuDetail!.menu.titleEn
                                        : menuController
                                            .menuDetail!.menu.titleAr,
                                    foodDescription:
                                        languageController.isEnglish
                                            ? menuController
                                                .menuDetail!.menu.descriptionEn
                                            : menuController
                                                .menuDetail!.menu.descriptionAr,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          );
        });
  }
}
