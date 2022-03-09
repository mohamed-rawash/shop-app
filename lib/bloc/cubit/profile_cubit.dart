import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/bloc/states/profile_states.dart';
import 'package:shop_app/helper/dio_helper.dart';
import 'package:shop_app/helper/end_point.dart';
import 'package:shop_app/models/profile_model.dart';

import '../../helper/cache_helper.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(ProfileInitialState());

  static ProfileCubit get(context) => BlocProvider.of(context);

  String? _token;
  Profile? userInfo;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void getToken() {
    _token = CacheHelper.getData(key: 'token');
    emit(GetTokenState());
  }

  getUserInfo() {
    emit(ProfileLoadingState());
    try {
      DioHelper.getData(
        url: profile,
        token: _token,
      ).then((value) {
        userInfo = Profile.fromJson(value.data);
        nameController.text = userInfo!.userData!.name!;
        emailController.text = userInfo!.userData!.email!;
        phoneController.text = userInfo!.userData!.phone!;
        print('-+- ' * 10);
        print(userInfo!.userData!.name);
        print(nameController.text);
        print(emailController.text);
        print(phoneController.text.isEmpty);
        print('-+- ' * 10);
        emit(ProfileSuccessState());
      });
    } catch (e) {
      emit(ProfileErrorState());
    }
  }

  updateUserInfo() {
    emit(ProfileUpdateLoadingState());
    DioHelper.putData(
      url: update,
      data: {
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text
      },
      token: _token,
    )
        .then(
          (value) {
            userInfo = Profile.fromJson(value.data);
            emit(ProfileUpdateSuccessState());
          },
        )
        .catchError(
          (error) {
            print("Error => " + error.toString());
            emit(ProfileUpdateErrorState());
          },
        );
  }
}
