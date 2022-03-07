import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/bloc/cubit/auth_cubit.dart';
import 'package:shop_app/bloc/cubit/onboarding_cubit.dart';
import 'package:shop_app/bloc/cubit/profile_cubit.dart';
import 'package:shop_app/bloc/states/onboarding_states.dart';
import 'package:shop_app/helper/dio_helper.dart';
import 'package:shop_app/screens/home.dart';
import 'package:shop_app/screens/login_screen.dart';
import 'package:shop_app/screens/on_boarding_screen.dart';
import 'package:shop_app/widgets/thems.dart';

import 'bloc/bloc_observer.dart';
import 'bloc/cubit/categories_cubit.dart';
import 'bloc/cubit/favorites_cubit.dart';
import 'bloc/cubit/home_cubit.dart';
import 'helper/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<OnBoardingCubit>(
              create: (context) => OnBoardingCubit()..getSharedData(key: 'onBoarding'),
          ),
          BlocProvider<ShopAuthCubit>(
            create: (BuildContext context) => ShopAuthCubit()..getToken()..userLoginState(key: 'token'),
          ),
          BlocProvider<HomeCubit>(
            create: (BuildContext context) => HomeCubit()..getToken()..getHomeData(),
          ),
          BlocProvider<CategoriesCubit>(
            create: (BuildContext context) => CategoriesCubit()..getCategories(),
          ),
          BlocProvider<FavoritesCubit>(
            create: (BuildContext context) => FavoritesCubit()..getToken()..getFavorites(),
          ),
          BlocProvider<ProfileCubit>(create: (_) => ProfileCubit()..getToken()..getUserInfo()),
        ],
      child: BlocConsumer<OnBoardingCubit, OnBoardingStates>(
        listener: (context, state){
          if(state is OnBoardingInitialState){
          }
        },
        builder:(context, state){
          bool onBoard = OnBoardingCubit.get(context).isOnBoard;
          bool isLogin = ShopAuthCubit.get(context).isLogin;
          return  MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Themes.ligtTheme,
            darkTheme: Themes.darkTheme,
            home: !onBoard? OnBoardingScreen(): isLogin? Home():LoginScreen(),
            routes: {
              Home.routeName: (_) => Home(),
              OnBoardingScreen.routeName: (_) => OnBoardingScreen(),
              LoginScreen.routeName: (_) => LoginScreen(),
            },
          );
        }
      ),
    );
  }
}
