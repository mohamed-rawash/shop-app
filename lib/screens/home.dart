import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/bloc/cubit/home_cubit.dart';
import 'package:shop_app/bloc/states/home%20_states.dart';
import 'package:shop_app/screens/search_screen.dart';

class Home extends StatelessWidget {
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, ShopHomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        HomeCubit _cubit = HomeCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              _cubit.titles[_cubit.currentIndex],
              style: Theme.of(context).textTheme.headline1,
            ),
            actions: [
              if(_cubit.currentIndex == 0)IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                splashRadius: 24,
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen())),
              )
            ],
            backgroundColor: _cubit.colors[_cubit.currentIndex],
          ),
          body: _cubit.bottomScreen[_cubit.currentIndex],
          bottomNavigationBar: BottomNavyBar(
            selectedIndex: _cubit.currentIndex,
            showElevation: true, // use this to remove appBar's elevation
            onItemSelected: (index){
              _cubit.changeBottomNavIndex(index);
            },
            items: [
              BottomNavyBarItem(
                icon: const Icon(Icons.home),
                title: const Text('Home'),
                activeColor: Colors.red,
              ),
              BottomNavyBarItem(
                  icon: const Icon(Icons.apps),
                  title: const Text('Categories'),
                  activeColor: const Color(0xFFdebfb5),
              ),
              BottomNavyBarItem(
                  icon: const Icon(Icons.favorite),
                  title: const Text('Favorites'),
                  activeColor: Colors.pink
              ),
              BottomNavyBarItem(
                  icon: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  activeColor: Colors.blue
              ),
            ],
          ),
        );
      },
    );
  }
}

