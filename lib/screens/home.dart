import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:shop_app/bloc/cubit/home_cubit.dart';
import 'package:shop_app/bloc/states/home%20_states.dart';
import 'package:shop_app/models/home_data.dart';
import 'package:shop_app/screens/search_screen.dart';
import 'package:shop_app/widgets/product_item.dart';

class Home extends StatelessWidget {
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, ShopHomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        HomeCubit _cubit = HomeCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              _cubit.titles[_cubit.currentIndex],
              style: Theme.of(context).textTheme.headline1,
            ),
            actions: [
              if (_cubit.currentIndex == 0)
                IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    splashRadius: 24,
                    onPressed: () =>
                        showSearch(context: context, delegate: DataSearch())
                    // Navigator.push(context,
                    // MaterialPageRoute(builder: (context) => SearchScreen())),
                    )
            ],
            backgroundColor: _cubit.colors[_cubit.currentIndex],
          ),
          body: OfflineBuilder(
            connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
            ) {
              final bool connected = connectivity != ConnectivityResult.none;
              if (connected) {
                return _cubit.bottomScreen[_cubit.currentIndex];
              } else {
                return Lottie.asset(
                  'assets/images/no-internet.json',
                  repeat: true,
                  fit: BoxFit.cover,
                );
              }
            },
            child: const Center(
              child: LoadingIndicator(
                  indicatorType: Indicator.ballScaleMultiple,
                  colors: [
                    Colors.blue,
                    Colors.purpleAccent,
                    Colors.red,
                  ],
                  strokeWidth: 0.2,
                  backgroundColor: Colors.transparent,
                  pathBackgroundColor: Colors.white),
            ),
          ),
          bottomNavigationBar: BottomNavyBar(
            selectedIndex: _cubit.currentIndex,
            showElevation: true, // use this to remove appBar's elevation
            onItemSelected: (index) {
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
                  activeColor: Colors.pink),
              BottomNavyBarItem(
                  icon: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  activeColor: Colors.blue),
            ],
          ),
        );
      },
    );
  }
}

class DataSearch extends SearchDelegate {

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor: Colors.redAccent.withOpacity(0.3),
      appBarTheme: AppBarTheme (
        backgroundColor: Colors.redAccent.withOpacity(0.3),
        elevation: 10.0,
      ),
        inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
    ),
      textTheme: const TextTheme(
        bodyText1: TextStyle(
          fontSize:20,
          color: Colors.white,
        ),
        headline1: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        headline2:  TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
        headline3: TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.clear,
          color: Colors.black,
          size: 32,
        ),
        splashRadius: 24,
        onPressed: () => query = '',
      ),
      const SizedBox(width: 10),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
          size: 32,
        ),
        splashRadius: 24,
        onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return  BlocConsumer<HomeCubit, ShopHomeStates>(
      listener: (context, state) {},
      builder: (context, state){
        HomeCubit _cubit = HomeCubit.get(context);
        _cubit.query = query;
       if(query.isEmpty)
         _cubit.searchedItems.clear();
       else
         _cubit.getSearchData();
       return Scaffold(
         backgroundColor: Colors.redAccent.withOpacity(0.3),
         body: _cubit.searchedItems.isEmpty?
         Center(
           child: Lottie.asset(
             'assets/images/search-white.json',
             repeat: true,
             fit: BoxFit.cover,
           ),
         ):Padding(
           padding: const EdgeInsets.only(top: 16, left: 10, right: 10),
           child: ListView.separated(
             physics: const BouncingScrollPhysics(),
             itemCount: _cubit.searchedItems.length,
             separatorBuilder: (context, index) => const SizedBox(height: 10),
             itemBuilder: (context, index) => ProductItem(_cubit.searchedItems[index], context),
           ),
         ),
       );
      },
    );
  }
}
