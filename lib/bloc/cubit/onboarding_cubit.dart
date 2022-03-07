// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/bloc/states/onboarding_states.dart';
import 'package:shop_app/helper/cache_helper.dart';

class OnBoardingCubit extends Cubit<OnBoardingStates>{
  OnBoardingCubit() : super(OnBoardingInitialState());

  static OnBoardingCubit get(context) => BlocProvider.of(context);

  bool isOnBoard = false;

  void getSharedData({required String key}){

    var currentStatus = CacheHelper.getData(key: key);

    if(currentStatus != null)
      isOnBoard = currentStatus;

    emit(OnBoardingCurrentState());
  }

}