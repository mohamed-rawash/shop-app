import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shop_app/bloc/cubit/categories_cubit.dart';
import 'package:shop_app/bloc/states/categories_states.dart';
import 'package:shop_app/models/categories_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoriesCubit, ShopCategoriesStates>(
        listener: (context, state) {},
        builder: (context, state) {
          CategoriesCubit _cubit = CategoriesCubit.get(context);

          return Conditional.single(
            context: context,
            conditionBuilder: (BuildContext context) =>
                _cubit.categoriesModel != null,
            widgetBuilder: (BuildContext context) {
              List<DataModel> _categoriesData =
                  _cubit.categoriesModel!.data!.data;
              return Scaffold(
                backgroundColor: const Color(0xFFdebfb5),
                body: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _categoriesData.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) =>
                        _categoriesWidget(context, _categoriesData[index]),
                  ),
                ),
              );
            },
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
        });
  }

  Widget _categoriesWidget(BuildContext context, DataModel model) {
    return Container(
      height: MediaQuery.of(context).size.width / 2.5,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2.3,
            child: Image.network(
              model.image!,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              child: Text(
                model.name!,
                style: Theme.of(context).textTheme.headline1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.black),
        ],
      ),
    );
  }
}