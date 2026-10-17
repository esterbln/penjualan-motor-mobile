import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/tipe/tipe.dart';
import 'package:uas_pemrograman_4_22411010_ester/api_service/api.dart';

class UpdateTipePage extends StatefulWidget {
  const UpdateTipePage({super.key});
  static String routeName = "/updatetipe_page";

  @override
  State<UpdateTipePage> createState() => _UpdateTipePageState();
}

class _UpdateTipePageState extends State<UpdateTipePage> {
  final dio = Dio();
  bool isLoading = false;
  TextEditingController tipeController = TextEditingController();
  String jenis = "";
  int? idTipe;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    jenis = args['jenis'];
    idTipe = args['idTipe'];
    tipeController.text = jenis;
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
                "Edit Tipe!",
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
                        if (tipeController.text.isEmpty &&
                            tipeController.text == '') {
                          toastification.show(
                              context: context,
                              title: const Text("Username Tidak Boleh Kosong!"),
                              type: ToastificationType.error,
                              autoCloseDuration: const Duration(seconds: 3),
                              style: ToastificationStyle.fillColored);
                        } else {
                          UpdateTipeResponse(idTipe!, tipeController.text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          minimumSize: const Size.fromHeight(50)),
                      child: const Text(
                        "Edit",
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

  void UpdateTipeResponse(int idTipe, jenis) async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      Response response;
      response = await dio.put(editTipe + idTipe.toString(), data: {
        "jenis": jenis,
      });
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
