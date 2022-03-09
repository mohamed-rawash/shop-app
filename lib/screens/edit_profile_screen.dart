import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shop_app/bloc/cubit/profile_cubit.dart';
import 'package:shop_app/bloc/states/profile_states.dart';
import 'package:shop_app/helper/toast-service.dart';


class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  static const String routeName = '/edit_profile';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
      listener: (context, state) async {
        if(state is ProfileUpdateSuccessState) {
          if(ProfileCubit.get(context).userInfo!.status!){
            await ToastService.toast(context, ProfileCubit.get(context).userInfo!.message!, Colors.greenAccent);
            Navigator.pop(context);
          }else {
            await ToastService.toast(context, ProfileCubit.get(context).userInfo!.message!, Colors.red);
            ProfileCubit.get(context).getUserInfo();
            Navigator.pop(context);
          }
        }
      },
      builder: (context, state) {
        ProfileCubit _cubit = ProfileCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.blue[100],
          appBar: AppBar(
            title: Text(
              'Edit Profile',
              style: Theme.of(context).textTheme.headline1,
            ),
            backgroundColor: Colors.blue[200],
          ),
          body: Conditional.single(
              context: context,
              conditionBuilder: (context) => state is! ProfileUpdateLoadingState,
              widgetBuilder: (context) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
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
                      const SizedBox(height: 40),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          prefixIcon: Icon(Icons.drive_file_rename_outline, color: Colors.black, ),
                        ),
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                        controller: _cubit.nameController,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          prefixIcon: Icon(Icons.email, color: Colors.black, ),
                        ),
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                        controller: _cubit.emailController,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          prefixIcon: Icon(Icons.phone, color: Colors.black, ),
                        ),
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                        controller: _cubit.phoneController,
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        child: const Text(
                          'Update',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            minimumSize: Size(MediaQuery.of(context).size.width / 2, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                            shadowColor: Colors.grey
                        ),
                        onPressed: () => _cubit.updateUserInfo(),
                      ),
                    ],
                  ),
                ),
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
        );
      },
    );
  }
}
