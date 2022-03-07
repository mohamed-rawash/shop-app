import 'package:bloc/bloc.dart';
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

  void getToken(){
    _token = CacheHelper.getData(key: 'token');
    emit(GetTokenState());
  }

  getUserInfo () {
    emit(ProfileLoadingState());
    try {
      DioHelper.getData(
        url: profile,
        token: _token,
      ).then((value) {
        userInfo = Profile.fromJson(value.data);
        print('-+- ' * 10 );
        print(userInfo!.userData!.name);
        print('-+- ' * 10 );
        emit(ProfileSuccessState());
      });
    } catch(e) {
      emit(ProfileErrorState());
    }
  }
}