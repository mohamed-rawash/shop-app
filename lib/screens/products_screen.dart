import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shop_app/bloc/cubit/favorites_cubit.dart';
import 'package:shop_app/bloc/cubit/home_cubit.dart';
import 'package:shop_app/bloc/states/favorites_states.dart';
import 'package:shop_app/bloc/states/home%20_states.dart';
import 'package:shop_app/helper/toast-service.dart';
import 'package:shop_app/models/home_data.dart';

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
                backgroundColor: Colors.white,

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
                return productItem(model.data!.products[index], context);
              },
              itemCount: model.data!.products.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget productItem(ProductModel model, BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Image.network(
                model.image!,
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.width / 1.4,
                width: double.infinity,
              ),
              if (model.discount != 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  color: Colors.red,
                  child: const Text(
                    'Discount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name!,
                  style: Theme.of(context).textTheme.headline1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  model.description!,
                  style: Theme.of(context).textTheme.headline2,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    if (model.discount != 0)
                      Text(
                        '${model.oldPrice.round()} EG',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            decoration: TextDecoration.lineThrough),
                      ),
                    const SizedBox(width: 10),
                    Text(
                      '${model.price.round()} EG',
                      style: TextStyle(
                          color:
                              model.discount != 0 ? Colors.green : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    BlocConsumer<FavoritesCubit, FavoritesStates>(
                      listener: (context, state) {
                        if (state is ChangeFavoritesSuccessState) {
                          if (!state.model.status!) {
                            ToastService.toast(context, state.model.message!, Colors.red);
                          } else {
                            ToastService.toast(context, state.model.message!, Colors.green);
                          }
                        }
                      },
                      builder: (context, state) => CircleAvatar(
                        child: IconButton(
                          icon: HomeCubit.get(context).favorites[model.id]!
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                  color: Colors.red,
                                ),
                          iconSize: 30,
                          splashRadius: 30,
                          onPressed: () {
                            FavoritesCubit.get(context).favorites =
                                HomeCubit.get(context).favorites;
                            FavoritesCubit.get(context)
                                .changeFavorites(model.id!);
                          },
                          padding: const EdgeInsets.all(0),
                        ),
                        radius: 24,
                        backgroundColor: Colors.red.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
