import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shop_app/bloc/cubit/favorites_cubit.dart';
import 'package:shop_app/bloc/cubit/home_cubit.dart';
import 'package:shop_app/bloc/states/favorites_states.dart';
import 'package:shop_app/bloc/states/home%20_states.dart';
import 'package:shop_app/helper/toast-service.dart';
import 'package:shop_app/models/home_data.dart';

import '../widgets/product_item.dart';

class ProductsScreen extends StatelessWidget {
  ProductsScreen({Key? key}) : super(key: key);

 GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, ShopHomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        HomeCubit _cubit = HomeCubit.get(context);
        return Conditional.single(
          context: context,
          conditionBuilder: (BuildContext context) => _cubit.homeModel != null,
          widgetBuilder: (BuildContext context) => Scaffold(
              backgroundColor: _cubit.colors[_cubit.currentIndex],
              body: SafeArea(
                  child: state == ShopHomeErrorState
                      ? Center(
                          child: Container(
                            child: Image.asset(
                              'assets/images/bug.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : productsBuilder(_cubit.homeModel!, context))),
          fallbackBuilder: (BuildContext context) => const Center(
            child: LoadingIndicator(
                indicatorType: Indicator.ballScaleMultiple,

                /// Required, The loading type of the widget
                colors: [
                  Colors.blue,
                  Colors.purpleAccent,
                  Colors.red,
                ],

                /// Optional, The color collections
                strokeWidth: 0.2,

                /// Optional, The stroke of the line, only applicable to widget which contains line
                backgroundColor: Colors.transparent,

                /// Optional, Background of the widget
                pathBackgroundColor: Colors.white

                /// Optional, the stroke backgroundColor
                ),
          ),
        );
      },
    );
  }

  Widget productsBuilder(HomeModel model, BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          CarouselSlider(
            items: model.data!.banners
                .map(
                  (value) => value.image == null
                      ? Container(
                          color: Colors.amber,
                        )
                      : FadeInImage.assetNetwork(
                          width: double.infinity,
                          image: value.image.toString(),
                          fit: BoxFit.cover,
                          placeholder: 'assets/images/loading.gif',
                        ),
                )
                .toList(),
            options: CarouselOptions(
              height: MediaQuery.of(context).size.width / 1.6,
              initialPage: 0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(seconds: 2),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
              viewportFraction: 1,
              reverse: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: MediaQuery.of(context).size.width,
                childAspectRatio: 1 / 1.26,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (ctx, index) {
                return ProductItem(model.data!.products[index], context);
              },
              itemCount: model.data!.products.length,
            ),
          ),
        ],
      ),
    );
  }



}
