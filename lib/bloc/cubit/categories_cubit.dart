import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/bloc/states/categories_states.dart';
import 'package:shop_app/helper/dio_helper.dart';
import 'package:shop_app/helper/end_point.dart';
import 'package:shop_app/models/categories_model.dart';

class CategoriesCubit extends Cubit<ShopCategoriesStates> {
  CategoriesCubit() : super(ShopCategoriesInitialState());

  static CategoriesCubit get(context) => BlocProvider.of(context);

  CategoriesModel? categoriesModel;

  getCategories(){
    emit(ShopCategoriesLoadingState());
    DioHelper.getData(url: GET_CATEGORIES)
        .then((value) {
          categoriesModel = CategoriesModel.fromJson(value.data);
          emit(ShopCategoriesSuccessesState());
          },)
        .catchError((e){
          emit(ShopCategoriesErrorState());
        },);
  }
}
