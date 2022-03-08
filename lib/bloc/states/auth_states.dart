import 'package:shop_app/models/profile_model.dart';
import 'package:shop_app/models/user_model.dart';

import '../../models/register_model.dart';

abstract class ShopAuthStates {}

class ShopLoginInitialState extends ShopAuthStates {}

class GetTokenState extends ShopAuthStates {}

class ShopRegisterLoadingState extends ShopAuthStates {}

class ShopRegisterSuccessState extends ShopAuthStates {
  final RegisterModel userInfo;

  ShopRegisterSuccessState(this.userInfo);
}

class ShopRegisterErrorState extends ShopAuthStates {
  final String error;

  ShopRegisterErrorState(this.error);
}

class ShopLoginLoadingState extends ShopAuthStates {}

class ShopLoginSuccessState extends ShopAuthStates {
  final ShopLoginModel loginModel;

  ShopLoginSuccessState(this.loginModel);
}

class ShopLoginErrorState extends ShopAuthStates {

  final String error;
  ShopLoginErrorState(this.error);
}

class ShopUserLoginStatusState extends ShopAuthStates {}

class SuccessLogout extends ShopAuthStates {}

class ErrorLogout extends ShopAuthStates {}