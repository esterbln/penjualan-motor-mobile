import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/tipe/tipe.dart';
import 'package:uas_pemrograman_4_22411010_ester/api_service/api.dart';

class InputTipe extends StatefulWidget {
  const InputTipe({super.key});
  static String routeName = "/inputtipe_page";

  @override
  State<InputTipe> createState() => _InputTipeState();
}

class _InputTipeState extends State<InputTipe> {
 final dio = Dio();
 bool isLoading = false;

  TextEditingController tipeController = TextEditingController();
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
                "Tambahkan Tipe !",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: tipeController,
                decoration: const InputDecoration(
                  labelText: "Tipe",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 16,
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (tipeController.text.isEmpty && tipeController.text == '') {
                          toastification.show(
                              context: context,
                              title: const Text("Username Tidak Boleh Kosong!"),
                              type: ToastificationType.error,
                              autoCloseDuration: const Duration(seconds: 3),
                              style: ToastificationStyle.fillColored);
                        } else {
                          inputResponse();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          minimumSize: const Size.fromHeight(50)),
                      child: const Text(
                        "Tambahkan",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
    ),
    )),
    );
  }

  void inputResponse() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      Response response;
      response = await dio.post(insertTipe, data: {"jenis": tipeController.text});
      if (response.data['status'] == true) {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.success,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
        Navigator.pushNamed(context, Tipe.routeName);
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