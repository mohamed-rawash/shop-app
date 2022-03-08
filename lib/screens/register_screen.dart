import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:shop_app/bloc/cubit/auth_cubit.dart';
import 'package:shop_app/bloc/states/auth_states.dart';
import 'package:shop_app/helper/cache_helper.dart';
import 'package:shop_app/helper/toast-service.dart';
import 'package:shop_app/screens/home.dart';


class RegisterScreen extends StatelessWidget {
  static const String routeName = '/register_screen';

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAuthCubit, ShopAuthStates>(
        listener: (context, state) {
          if(state is ShopRegisterSuccessState){
            if(state.userInfo.status!){
              CacheHelper.saveData(key: 'token', value: state.userInfo.userData!.token).then((value) {
                Navigator.of(context).pushReplacementNamed(Home.routeName);
              });
            }else{
              print('== ' * 10);
              ToastService.toast(context, state.userInfo.message!, Colors.red);
            }
          }
        },
        builder: (context, state) {
          ShopAuthCubit _cubit = ShopAuthCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.cyanAccent.withOpacity(0.8),
            body: Container(
              margin: EdgeInsetsDirectional.only(top: MediaQuery.of(context).size.height / 6),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 8,
                      margin: EdgeInsets.all(0),
                      child: Container(
                        margin:const EdgeInsets.only(top: 16, bottom: 36, left: 16, right: 16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 150,
                                width: 150,
                                child: Lottie.asset(
                                  'assets/images/welcome.json',
                                  repeat: true,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  prefixIcon: Icon(Icons.drive_file_rename_outline),
                                  hintText: 'User Name',
                                ),
                                validator: (val){
                                  if(val!.isEmpty) {
                                    return 'You Must fill this field';
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  _cubit.name = val!;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  prefixIcon: Icon(Icons.email),
                                  hintText: 'Email',
                                ),
                                validator: (val){
                                  if(val!.isEmpty || !val.contains('@'))
                                    return 'Please enter an valid email';
                                  if(! val.endsWith('.com'))
                                    return 'Please enter an valid email';
                                  return null;
                                },
                                onSaved: (val) {
                                  _cubit.email = val!;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    prefixIcon: Icon(Icons.lock),
                                    hintText: 'Password',
                                  ),
                                  validator: (val){
                                    if(val!.length < 5)
                                      return 'Password is too short';
                                    return null;
                                  },
                                  onSaved: (val) => _cubit.password = val!,
                                  obscureText: true
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  prefixIcon: Icon(Icons.phone),
                                  hintText: 'Phone Number',
                                ),
                                validator: (val){
                                  if(val!.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  _cubit.phone = val!;
                                },
                              ),
                              const SizedBox(height: 20),
                              Conditional.single(
                                context: context,
                                conditionBuilder: (BuildContext context) => state is! ShopRegisterLoadingState,
                                widgetBuilder: (BuildContext context) => ElevatedButton(
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                    primary: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    elevation: 10,
                                  ),
                                  onPressed: () async{
                                    if(_formKey.currentState!.validate()){
                                      _formKey.currentState!.save();
                                      _cubit.userRegister();
                                    }
                                  },
                                ),
                                fallbackBuilder: (BuildContext context) => const CircularProgressIndicator(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}