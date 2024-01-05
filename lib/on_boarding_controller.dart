import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:test1/colors.dart';
import 'package:test1/model_on_boarding.dart';
import 'package:test1/on_boarding_screen.dart';
import 'package:test1/text_strings.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController{

  final controller = LiquidController();
  RxInt currentPage = 0.obs;

  final pages = [
      OnBoardingPage(
        model: OnBoardingModel(
          image: "assets/Picture.png",
          title: tOnBoardingTitle1,
          subTitle: tOnBoardingSubTitle1,
          counterText: tOnBoardingCounter1,
          bgColor: tOnBoardingPage1Color,
        ),
      ),

      OnBoardingPage(
        model: OnBoardingModel(
          image: "assets/Picture.png",
          title: tOnBoardingTitle2,
          subTitle: tOnBoardingSubTitle2,
          counterText: tOnBoardingCounter2,
          bgColor: tOnBoardingPage2Color,
        ),
      ),

      OnBoardingPage(
        model: OnBoardingModel(
          image: "assets/Picture.png",
          title: tOnBoardingTitle3,
          subTitle: tOnBoardingSubTitle3,
          counterText: tOnBoardingCounter3,          bgColor: tOnBoardingPage3Color,
        ),
      )
    ];

    skip() => controller.jumpToPage(page: 2);
    animateToNextSlide(){
    int nextPage = controller.currentPage + 1;
                controller.animateToPage(page: nextPage);}
    onPageChangeCallback(int activePageIndex) => currentPage.value = activePageIndex;
}