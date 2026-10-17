import 'package:flutter/material.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/home_admin.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/motor/input_motor.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/motor/motor.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/motor/update_motor.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/pembayaran/pembayaran.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/tipe/input_tipe.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/tipe/tipe.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/tipe/update_tipe.dart';
import 'package:uas_pemrograman_4_22411010_ester/auth/login_page.dart';
import 'package:uas_pemrograman_4_22411010_ester/auth/register_page.dart';
import 'package:uas_pemrograman_4_22411010_ester/users/beli_motor.dart';
import 'package:uas_pemrograman_4_22411010_ester/users/home_users.dart';
import 'package:uas_pemrograman_4_22411010_ester/users/pembayaran.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Motor Teres Apps',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (context) => const LoginPage(),
        RegisterPage.routeName: (context) => const RegisterPage(),
        HomeAdmin.routeName: (context) => const HomeAdmin(),
        HomeUsers.routeName: (context) => const HomeUsers(),
        Tipe.routeName: (context) => const Tipe(),
        InputTipe.routeName: (context) => const InputTipe(),
        UpdateTipePage.routeName : (context) => const UpdateTipePage(),
        MotorPage.routeName : (context) => const MotorPage(),
        InputMotor.routeName: (context) => const InputMotor(),
        UpdateMotorPage.routeName: (context) => const UpdateMotorPage(),
        BeliMotor.routeName : (context) => const BeliMotor(),
        TransaksiUser.routeName: (context) => const TransaksiUser(),
        TransaksiAdmin.routeName: (context) => const TransaksiAdmin(),
      },
    );
  }
}