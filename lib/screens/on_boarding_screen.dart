import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/helper/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'login_screen.dart';


class OnBoardingScreen extends StatefulWidget {
  static const String routeName = '/on_boarding_screen';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<BoardingModel> boarding = [
    BoardingModel(
        image:'assets/images/onboard2.png',
        title:'title 1',
    ),
    BoardingModel(
      image:'assets/images/onboard.jpg',
      title:'title 1',
    ),
    BoardingModel(
      image:'assets/images/onboard1.jpg',
      title:'title 1',
    ),
  ];

  PageController boardController = PageController();
  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18,
              ),
            ),
            onPressed: () {
              submit();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: boardController,
                physics: const BouncingScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) => onBoardingItem(boarding[index], context),
                onPageChanged: (index){
                  if (index == boarding.length - 1){
                    setState(() {
                      isLast = true;
                    });
                  }else{
                    setState(() {
                      isLast = false;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                SmoothPageIndicator(
                    controller: boardController,
                    count: boarding.length,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 10,
                      dotWidth: 20,
                      expansionFactor: 4,
                      spacing: 5,
                    ),
                ),
                const Spacer(),
                FloatingActionButton(
                  child: const Icon(Icons.arrow_forward_ios),
                  // ignore: curly_braces_in_flow_control_structures
                  onPressed: (){
                    if(isLast){
                      submit();
                    }else{
                      boardController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget onBoardingItem(BoardingModel model, BuildContext context){
    return Column(
      children: [
        Container(
          width:double.infinity,
          height: 400,
          margin: EdgeInsets.all(12),
          child: Card(
            elevation: 10,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Image.asset(model.image, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height:10),
      ],
    );
  }

  void submit(){
    print('** ' *10);
    CacheHelper.saveData(key: "onBoarding", value: true,).then((value) {
      print(value);
      if(value){
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      }
    }).catchError((e){
      print('** ' *10);
      print('error message');
      print(e.toString());
      print('** ' *10);
    });
  }
}

class BoardingModel{
  final String image;
  final String title;

  BoardingModel({
    required this.image,
    required this.title
  });
}


