import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411010_ester/api_service/api.dart';
import 'package:uas_pemrograman_4_22411010_ester/auth/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static String routeName = "/register_page";
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final dio = Dio();

  bool isLoading = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController noTelpController = TextEditingController();
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
              const Text(
                "Registrasi Akun !",
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
                controller: fullnameController,
                decoration: const InputDecoration(
                  labelText: "Fullname",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: noTelpController,
                decoration: const InputDecoration(
                  labelText: "Phone",
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
                              title: const Text("Username Tidak Boleh Kosong!"),
                              type: ToastificationType.error,
                              autoCloseDuration: const Duration(seconds: 3),
                              style: ToastificationStyle.fillColored);
                        } else if (fullnameController.text.isEmpty &&
                            fullnameController.text == '') {
                          toastification.show(
                              context: context,
                              title: const Text("Fullname Tidak Boleh Kosong!"),
                              type: ToastificationType.error,
                              autoCloseDuration: const Duration(seconds: 3),
                              style: ToastificationStyle.fillColored);
                        } else if (emailController.text.isEmpty &&
                            emailController.text == '') {
                          toastification.show(
                              context: context,
                              title: const Text("Email Tidak Boleh Kosong!"),
                              type: ToastificationType.error,
                              autoCloseDuration: const Duration(seconds: 3),
                              style: ToastificationStyle.fillColored);
                        } else if (noTelpController.text.isEmpty &&
                            noTelpController.text == '') {
                          toastification.show(
                              context: context,
                              title: const Text(
                                  "Nomor Telepon Tidak Boleh Kosong!"),
                              type: ToastificationType.error,
                              autoCloseDuration: const Duration(seconds: 3),
                              style: ToastificationStyle.fillColored);
                        } else if (passwordController.text.isEmpty &&
                            passwordController.text == '') {
                          toastification.show(
                              context: context,
                              title: const Text("Password Tidak Boleh Kosong!"),
                              type: ToastificationType.error,
                              autoCloseDuration: const Duration(seconds: 3),
                              style: ToastificationStyle.fillColored);
                        } else {
                          registerResponse();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink[200],
                          minimumSize: const Size.fromHeight(50)),
                      child: const Text(
                        "Register",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Sudah punya akun?"),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginPage.routeName);
                      },
                      child: Text("Masuk disini"))
                ],
              )
            ],
          ),
        ),
      )),
    );
  }

  void registerResponse() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      Response response;
      response = await dio.post(register, data: {
        "username": usernameController.text,
        "fullname": fullnameController.text,
        "email": emailController.text,
        "noTelp": noTelpController.text,
        "password": passwordController.text,
      });
      if (response.data['status'] == true) {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.success,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
        Navigator.pushNamed(context, LoginPage.routeName);
      } else {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored);
      }
    } catch (e) {
      toastification.show(
          context: context,
          title: Text("Terjadi kesalahan pada server"),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}