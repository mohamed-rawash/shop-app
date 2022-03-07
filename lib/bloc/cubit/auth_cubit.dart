// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:bloc/bloc.dart';
import 'package:dio/src/response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/bloc/states/auth_states.dart';
import 'package:shop_app/helper/cache_helper.dart';
import 'package:shop_app/helper/dio_helper.dart';
import 'package:shop_app/helper/end_point.dart';
import 'package:shop_app/models/user_model.dart';

class ShopAuthCubit extends Cubit<ShopAuthStates> {
  ShopAuthCubit() : super(ShopLoginInitialState());

  static ShopAuthCubit get(context) => BlocProvider.of(context);

  ShopLoginModel? loginModel;
  bool isLogin = false;
  String? _token;

  getToken() {
    _token = CacheHelper.getData(key: 'token');
    emit(GetTokenState());
  }

  void userLogin({email, password}) {
    emit(ShopLoginLoadingState());
    DioHelper.postData(
      url: LOGIN,
      data: {"email": email, "password": password},
    ).then((value) {
      loginModel = ShopLoginModel.fromJson(value.data);
      emit(ShopLoginSuccessState(loginModel!));
    }).catchError((error) {
      emit(ShopLoginErrorState(error.toString()));
    });
  }

  logout() async {
    try {
      DioHelper.postData(url: profile, data: {
        'fcm_token': _token,
      }).then((value) {
        CacheHelper.removeData(key: 'token');
      });
      emit(SuccessLogout());
    } catch (e) {
      emit(ErrorLogout());
    }
  }

  userLoginState({required String key}) {
    if (_token != null) isLogin = true;
    emit(ShopUserLoginStatusState());
  }
}
