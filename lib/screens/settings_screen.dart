import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shop_app/bloc/cubit/auth_cubit.dart';
import 'package:shop_app/bloc/states/auth_states.dart';
import 'package:shop_app/bloc/states/profile_states.dart';
import 'package:shop_app/screens/login_screen.dart';

import '../bloc/cubit/profile_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileCubit _cubit = ProfileCubit.get(context);
    return BlocConsumer<ProfileCubit, ProfileStates>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        backgroundColor: Colors.blue.withOpacity(0.2),
        body: Conditional.single(
          context: context,
          conditionBuilder: (context) => state is! ProfileLoadingState,
          widgetBuilder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width / 4),
                child: CircleAvatar(
                  child: _cubit.userInfo!.userData!.image == null
                      ? Image.asset(
                          'assets/images/user.png',
                          fit: BoxFit.cover,
                        )
                      : FadeInImage.assetNetwork(
                          width: double.infinity,
                          image: _cubit.userInfo!.userData!.image!.toString(),
                          fit: BoxFit.cover,
                          placeholder: 'assets/images/loading.gif',
                        ),
                  radius: MediaQuery.of(context).size.width / 4,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    _cubit.userInfo!.userData!.name!.toUpperCase(),
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              ListTile(
                leading: Icon(Icons.email, size: 32, color: Colors.black,),
                title: const Text('Email',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                subtitle: Text(
                  _cubit.userInfo!.userData!.email!,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
              ),
              ListTile(
                leading: Icon(Icons.phone, size: 32, color: Colors.black,),
                title: const Text('Phone Number',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),),
                subtitle: Text(
                  _cubit.userInfo!.userData!.phone!,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
              ),
              BlocConsumer<ShopAuthCubit, ShopAuthStates>(
                listener: (context, state) {},
                builder: (context, state) => GestureDetector(
                  child: const ListTile(
                    leading: Icon(Icons.logout_rounded, size: 32, color: Colors.black,),
                    title: Text('Logout',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),),
                  ),
                  onTap: (){
                    ShopAuthCubit.get(context).logout();
                    if(state is SuccessLogout)
                      Navigator.of(context).pushReplacementNamed( LoginScreen.routeName);
                  },
                ),
              ),
            ],
          ),
          fallbackBuilder: (context) => const Center(
            child: LoadingIndicator(
                indicatorType: Indicator.ballScaleMultiple,
                colors: [
                  Colors.blue,
                  Colors.purpleAccent,
                  Colors.red,
                ],
                strokeWidth: 0.1,
                backgroundColor: Colors.transparent,
                pathBackgroundColor: Colors.white),
          ),
        ),
      ),
    );
  }
}
