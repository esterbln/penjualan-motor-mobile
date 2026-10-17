// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/home_admin.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/tipe/input_tipe.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/tipe/update_tipe.dart';
import 'package:uas_pemrograman_4_22411010_ester/api_service/api.dart';

class Tipe extends StatefulWidget {
  const Tipe({super.key});
  static const routeName = '/tipe';
  @override
  State<Tipe> createState() => _TipeState();
}

class _TipeState extends State<Tipe> {
  final dio = Dio();
  bool isLoading = false;
  var dataTipe = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.pink,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, HomeAdmin.routeName);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            const Text('Tipe Motor', style: TextStyle(color: Colors.white))
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, InputTipe.routeName);
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
      ),
      backgroundColor: const Color(0xFF232429),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (context, index) {
                var Tipe = dataTipe[index];
                return ListTile(
                    title: Text(Tipe['jenis'],
                        style: const TextStyle(color: Colors.white)),
                    leading: const Icon(
                      Icons.bike_scooter,
                      color: Colors.white,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context,UpdateTipePage.routeName, arguments: Tipe);
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.yellowAccent,
                            size: 20,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.confirm,
                                title: 'Hapus Tipe',
                                text:
                                    'Yakin ingin menghapus Tipe ${Tipe['jenis']}?',
                                confirmBtnText: 'Ya',
                                cancelBtnText: 'Tidak',
                                confirmBtnColor: Colors.red,
                                onConfirmBtnTap: () {
                                  deleteTipeResponse(Tipe['idTipe']);
                                });
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ],
                    ));
              },
              itemCount: dataTipe.length,
            ),
    );
  }

  void getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      Response response;
      response = await dio.get(getAllTipe);
      if (response.data['status'] == true) {
        dataTipe = response.data['data'];
      } else {
        dataTipe = [];
      }
    } catch (e) {
      toastification.show(
        context: context,
        title: const Text('Server tidak meresponse'),
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

  void deleteTipeResponse(int id) async {
    try {
      Response response;

      response = await dio.delete(hapusTipe + id.toString());
      if (response.data['status'] == true) {
        toastification.show(
          context: context,
          title: Text(response.data['msg']),
          type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored,
        );
        Navigator.pushNamed(context, Tipe.routeName);
      }
    } catch (e) {
      print(e);
      toastification.show(
        context: context,
        title: Text('Terjadi kesalahan pada server'),
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
