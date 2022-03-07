import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/bloc/cubit/home_cubit.dart';
import 'package:shop_app/bloc/states/favorites_states.dart';
import 'package:shop_app/helper/cache_helper.dart';
import 'package:shop_app/helper/dio_helper.dart';
import 'package:shop_app/helper/end_point.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/favorites_model.dart';

class FavoritesCubit extends Cubit<FavoritesStates>{
  FavoritesCubit() : super(FavoritesInitialState());

  static FavoritesCubit get(context) => BlocProvider.of(context);

  String? _token;
  ChangeFavoritesModel? changeFavoritesModel;
  Map<int, bool> favorites = {};
  List<Product> products = [];

  void getToken(){
    _token = CacheHelper.getData(key: 'token');
    print(_token);
    emit(GetTokenState());
  }

  changeFavorites(int productId){
    favorites[productId] = !favorites[productId]!;
    emit(ChangeFavoriteButtonState());
    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
      token: _token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      if(!changeFavoritesModel!.status!){
        favorites[productId] = !favorites[productId]!;
      }
      print(changeFavoritesModel!.status.toString());
      print(changeFavoritesModel!.message);
      emit(ChangeFavoritesSuccessState(changeFavoritesModel!));
    }).catchError((e){
      favorites[productId] = !favorites[productId]!;
      emit(ChangeFavoritesErrorState());
    });
  }

  getFavorites(){
    emit(GetFavoritesLoadingState());
    products.clear();
    DioHelper.getData(
      url: 'favorites',
      token: _token,
    ).then((value) {
      print('*-**-* ' * 10);
      print(value.data.toString());
      print('*-**-* ' * 10);
      value.data['data']['data'].forEach((value){
        products.add(Product.fromJson(value['product']));
      });
      emit(GetFavoritesSuccessState());
    },)
        .catchError((e){
      emit(GetFavoritesErrorState());
    },);
  }

}