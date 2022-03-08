// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:bloc/bloc.dart';
import 'package:dio/src/response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/bloc/states/auth_states.dart';
import 'package:shop_app/helper/cache_helper.dart';
import 'package:shop_app/helper/dio_helper.dart';
import 'package:shop_app/helper/end_point.dart';
import 'package:shop_app/models/profile_model.dart';
import 'package:shop_app/models/register_model.dart';
import 'package:shop_app/models/user_model.dart';

class ShopAuthCubit extends Cubit<ShopAuthStates> {
  ShopAuthCubit() : super(ShopLoginInitialState());

  static ShopAuthCubit get(context) => BlocProvider.of(context);

  String? name;
  String? email;
  String? password;
  String? phone;
  ShopLoginModel? loginModel;
  bool? logoutResponse;

  bool isLogin = false;
  String? _token;

  getToken() {
    _token = CacheHelper.getData(key: 'token');
    emit(GetTokenState());
  }

  userRegister() {
    emit(ShopRegisterLoadingState());
    DioHelper.postData(
      url: register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
    ).then(
      (value) {
        print('=+= ' * 10);
        print(value.data['data']);
        print('=+= ' * 10);
        emit(ShopRegisterSuccessState(RegisterModel.fromJson(value.data)));
      },
    ).catchError((error) {
      print('-+- ' * 10);
      print(error.toString());
      print('-+- ' * 10);
      emit(ShopRegisterErrorState(error.toString()));
    });
  }

  void userLogin() {
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
    logoutResponse = await CacheHelper.removeData(key: 'token');
    emit(SuccessLogout());
  }

  userLoginState({required String key}) {
    if (_token != null) isLogin = true;
    emit(ShopUserLoginStatusState());
  }
}
