// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:shop_app/bloc/cubit/auth_cubit.dart';
import 'package:shop_app/bloc/states/auth_states.dart';
import 'package:shop_app/helper/cache_helper.dart';
import 'package:shop_app/screens/home.dart';


class LoginScreen extends StatelessWidget {
  static const String routeName = '/login_screen';

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAuthCubit, ShopAuthStates>(
      listener: (context, state) {
        if(state is ShopLoginSuccessState){
          if(state.loginModel.status!){
            CacheHelper.saveData(key: 'token', value: state.loginModel.data!.token).then((value) {
              Navigator.of(context).pushReplacementNamed(Home.routeName);
            });
          }else{
            Fluttertoast.showToast(
                msg: state.loginModel.message!,
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.cyanAccent.withOpacity(0.8),
          body: Container(
            margin: EdgeInsetsDirectional.only(top: MediaQuery.of(context).size.height / 4),
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
                          children: [
                            SizedBox(
                              height: 150,
                              width: 150,
                              child: Lottie.asset(
                                'assets/images/login_animation.json',
                                repeat: true,
                                fit: BoxFit.cover,
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
                                prefixIcon: Icon(Icons.email),
                                hintText: 'Email',
                              ),
                              controller: _emailController,
                              validator: (val){
                                if(val!.isEmpty || !val.contains('@'))
                                  return 'Please enter an valid email';
                                if(! val.endsWith('.com'))
                                  return 'Please enter an valid email';
                                return null;
                              },
                              onSaved: (val) {
                                email = val!;
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
                                controller: _passwordController,
                                validator: (val){
                                  if(val!.length < 5)
                                    return 'Password is too short';
                                  return null;
                                },
                                onSaved: (val) => password = val!,
                                obscureText: true
                            ),
                            const SizedBox(height: 20),
                            Conditional.single(
                              context: context,
                              conditionBuilder: (BuildContext context) => state is! ShopLoginLoadingState,
                              widgetBuilder: (BuildContext context) => ElevatedButton(
                                child: const Text(
                                  "LOGIN",
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
                                    ShopAuthCubit.get(context).userLogin(email: _emailController.text, password: _passwordController.text);

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
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {}
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
