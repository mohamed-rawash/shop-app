import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cubit/favorites_cubit.dart';
import '../bloc/cubit/home_cubit.dart';
import '../bloc/states/favorites_states.dart';
import '../helper/toast-service.dart';
import '../models/home_data.dart';


class ProductItem extends StatelessWidget {
  ProductModel model;
  BuildContext context;


  ProductItem(this.model, this.context);

  @override
  Widget build(BuildContext context) {
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
