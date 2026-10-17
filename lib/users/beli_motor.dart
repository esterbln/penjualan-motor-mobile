import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411010_ester/api_service/api.dart';
import 'package:uas_pemrograman_4_22411010_ester/users/home_users.dart';

class BeliMotor extends StatefulWidget {
  const BeliMotor({super.key});
  static String routeName = '/beli-motor';
  @override
  State<BeliMotor> createState() => _BeliMotorState();
}

class _BeliMotorState extends State<BeliMotor> {
  final dio = Dio();
  bool isLoading = false;
  var total = 0.0;
  String? idPengguna;
  int? idMotor;
  var user;

  TextEditingController merekController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController jumlahBeliController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    merekController.text = args['motor']['merek'];
    hargaController.text = args['motor']['harga'].toString();
    idMotor = args['motor']['id_motor'];
    idPengguna = args['user']['username'];
    user = args['user'];

    return Scaffold(
      backgroundColor: const Color(0xFF232429),
      body: SingleChildScrollView(
          child: Center(
              child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            const Text("Beli Motor",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(
              height: 16,
            ),
            Image.network("$imageUrl/${args['motor']['gambar']}",
                width: 200, height: 200, fit: BoxFit.cover),
            const SizedBox(
              height: 32,
            ),
            TextField(
              controller: merekController,
              enabled: false,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                labelText: "Merek",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: hargaController,
              enabled: false,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                labelText: "Harga",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: jumlahBeliController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                labelText: "Jumlah Beli",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  if (value.isNotEmpty) {
                    total = double.parse(hargaController.text) *
                        double.parse(value);
                    totalController.text = total.toString();
                  } else {
                    total = 0.0;
                    totalController.text = total.toString();
                  }
                });
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: totalController,
              enabled: false,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                labelText: "Total",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 16,
            ),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      if (jumlahBeliController.text.isEmpty &&
                          jumlahBeliController.text == '') {
                        toastification.show(
                            context: context,
                            title: const Text("Jumlah Beli Tidak Boleh Kosong!"),
                            autoCloseDuration: const Duration(seconds: 3),
                            type: ToastificationType.error,
                            style: ToastificationStyle.fillColored);
                      } else {
                        responseTransaksi();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        minimumSize: const Size.fromHeight(50)),
                    child: const Text(
                      "Beli Motor",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ],
        ),
      ))),
    );
  }

  void responseTransaksi() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      Response response;
      response = await dio.post(insertTransaksi, data: {
        "idPengguna": idPengguna,
        "idMotor": idMotor,
        "harga": hargaController.text,
        "jumlah": jumlahBeliController.text,
        "total": totalController.text
      });
      if (response.data['status'] == true) {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.success,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
        Navigator.pushNamed(context, HomeUsers.routeName, arguments: user);
      }
    } catch (e) {
      toastification.show(
        context: context,
        title: const Text('Terjadi kesalahan pada server'),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
        style: ToastificationStyle.fillColored,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}