import 'package:flutter/material.dart';
import 'package:mvvm/view/Splash_screen/splash_view.dart';
import 'package:mvvm/view/Splash_screen/user_view_model.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context)
  {
    return MultiProvider(
      providers:
      [

        ChangeNotifierProvider(create: (_) => UserViewModel())
      ],
      child: MaterialApp
        (
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: SplashView(),
         )

    );
  }
}


