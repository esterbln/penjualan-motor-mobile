import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/home_admin.dart';
import 'package:uas_pemrograman_4_22411010_ester/api_service/api.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411010_ester/auth/register_page.dart';
import 'package:uas_pemrograman_4_22411010_ester/users/home_users.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String routeName = "/login_page";
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final dio = Dio();
  bool isLoading = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                "assets/two.png",
                width: 150,
                height: 150,
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                "Login Akun !",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                obscureText: true,
              ),
              const SizedBox(
                height: 16,
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (usernameController.text.isEmpty &&
                            usernameController.text == '') {
                          toastification.show(
                              context: context,
                              title: const Text("Username tidak boleh kosong!"),
                              type: ToastificationType.error,
                              autoCloseDuration: const Duration(seconds: 3),
                              style: ToastificationStyle.fillColored);
                        } else if (passwordController.text.isEmpty &&
                            passwordController.text == '') {
                          toastification.show(
                              context: context,
                              title: const Text("Password tidak boleh kosong!"),
                              type: ToastificationType.error,
                              autoCloseDuration: const Duration(seconds: 3),
                              style: ToastificationStyle.fillColored);
                        } else {
                          loginResponse();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink[200],
                          minimumSize: const Size.fromHeight(50)),
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Belum punya akun?"),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RegisterPage.routeName);
                      },
                      child: const Text("Daftar disini"))
                ],
              )
            ],
          ),
        ),
      )),
    );
  }

  void loginResponse() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      Response response;
      response = await dio.post(login, data: {
        "username": usernameController.text,
        "password": passwordController.text
      });
      if (response.data['status'] == true) {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.success,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
        print(response.data['data']);
        var pengguna = response.data['data'];
        if (pengguna['role'] == 1) {
          Navigator.pushNamed(context, HomeAdmin.routeName,
              arguments: pengguna);
        } else if (pengguna['role'] == 2) {
          Navigator.pushNamed(context, HomeUsers.routeName,
              arguments: pengguna);
        } else {
          toastification.show(
              context: context,
              title: const Text('Akses dilarang!'),
              type: ToastificationType.error,
              autoCloseDuration: const Duration(seconds: 3),
              style: ToastificationStyle.fillColored);
        }
      } else {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.error,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
      }
    } catch (e) {
      toastification.show(
          context: context,
          title: const Text("Server tidak merespon"),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
