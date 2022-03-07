import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'package:lottie/lottie.dart';
import 'package:shop_app/bloc/cubit/favorites_cubit.dart';
import 'package:shop_app/bloc/states/favorites_states.dart';
import 'package:shop_app/models/favorites_model.dart';


import '../bloc/cubit/home_cubit.dart';


class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {

  @override
  void initState() {
    super.initState();
    FavoritesCubit.get(context).getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoritesCubit, FavoritesStates>(
      listener: (context, state){},
      builder: (context, state) {
        FavoritesCubit _cubit = FavoritesCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.red.withOpacity(0.3),
        body: Conditional.single(
          context: context,
          conditionBuilder: (BuildContext context) => _cubit.products.isNotEmpty,
          widgetBuilder: (BuildContext context) {
            return Container(
            child: ListView.separated(
              physics: _cubit.products.length == 1 ||_cubit.products.length == 0?BouncingScrollPhysics():BouncingScrollPhysics(),
              itemCount: _cubit.products.length,
              separatorBuilder: (context, index) => const SizedBox(height: 3, width: double.infinity),
              itemBuilder: (context, index) => _favoritesWidget(context, _cubit.products[index]),
            ),
          );
          },
          fallbackBuilder: (BuildContext context) => state is! GetFavoritesLoadingState? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add Your Favorite Products',
                  style: Theme.of(context).textTheme.headline1,
                ),
                Lottie.asset(
                  'assets/images/empty_favorite.json',
                  repeat: true,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ): const Center(
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
        ),
      );
      },
    );
  }

  Widget _favoritesWidget(BuildContext context, Product model) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),

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
                    CircleAvatar(
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
                          FavoritesCubit.get(context).favorites = HomeCubit.get(context).favorites;
                          FavoritesCubit.get(context).changeFavorites(model.id!);
                          FavoritesCubit.get(context).products.removeWhere((element) => element.id == model.id);
                        },
                        padding: const EdgeInsets.all(0),
                      ),
                      radius: 24,
                      backgroundColor: Colors.red.withOpacity(0.2),
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