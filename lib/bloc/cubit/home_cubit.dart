import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/bloc/states/home%20_states.dart';
import 'package:shop_app/helper/cache_helper.dart';

import 'package:shop_app/helper/dio_helper.dart';
import 'package:shop_app/helper/end_point.dart';
import 'package:shop_app/models/home_data.dart';
import 'package:shop_app/screens/categories_screen.dart';
import 'package:shop_app/screens/favorite_screen.dart';
import 'package:shop_app/screens/products_screen.dart';
import 'package:shop_app/screens/search_screen.dart';
import 'package:shop_app/screens/settings_screen.dart';

class HomeCubit extends Cubit<ShopHomeStates>{
  HomeCubit() : super(ShopHomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> bottomScreen = [
    ProductsScreen(),
    CategoriesScreen(),
    FavouritesScreen(),
    SettingsScreen(),
  ];
  List<String> titles = [
    'Salla',
    'Categories',
    'Favorites',
    'Settings'
  ];
  List<Color> colors = [
    Colors.red.withOpacity(0.2),
    Color(0xFFdebfb5),
    Colors.pink.withOpacity(0.2),
    Colors.blue.withOpacity(0.2),
  ];
  HomeModel? homeModel;
  String? _token;
  Map<int, bool> favorites = {};

  void changeBottomNavIndex(int index){
    currentIndex = index;
    emit(ShopHomeChangBottomNavIndex());
  }

  void getToken(){
    _token = CacheHelper.getData(key: 'token')?? '';
    emit(ShopHomeGetTokenState());
  }

  void getHomeData()async{
    emit(ShopHomeLoadingState());
   DioHelper.getData(url: HOME, token: _token).then((value) {
      homeModel = HomeModel.fromJson(value.data);

      homeModel!.data!.products.forEach((element) {
        favorites.addAll({
          element.id!: element.inFavorites!,
        });
      });

      emit(ShopHomeSuccessesState());
    }).catchError((e){
      print(e.toString());
      emit(ShopHomeErrorState());
    });
  }
}