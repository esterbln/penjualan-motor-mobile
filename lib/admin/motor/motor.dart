import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/home_admin.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/motor/input_motor.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/motor/update_motor.dart';
import 'package:uas_pemrograman_4_22411010_ester/api_service/api.dart';

class MotorPage extends StatefulWidget {
  const MotorPage({super.key});
  static String routeName = '/motor-admin';

  @override
  State<MotorPage> createState() => _MotorPageState();
}

class _MotorPageState extends State<MotorPage> {
  bool isLoading = false;
  var dataMotor = [];
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    getData();
  }

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
              const Text('Motor', style: TextStyle(color: Colors.white))
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, InputMotor.routeName);
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
                itemCount: dataMotor.length,
                itemBuilder: (context, index) {
                  final Motor = dataMotor[index];
                  return Card(
                    color: Colors.grey[850],
                    margin: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gambar Film
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              imageUrl + Motor['gambar'],
                              width: 80,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 120,
                                  color: Colors.grey,
                                  child:
                                      const Icon(Icons.broken_image, size: 40),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Detail Film
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Judul Film
                                Text(
                                  Motor['merek'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                // Tipe
                                Text(
                                  "Tipe: ${Motor['tipe_motor_tipeTotipe']['jenis']}",
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                // Rating dengan Bintang
                                Row(
                                  children: List.generate(
                                    5,
                                    (starIndex) => Icon(
                                      Icons.star,
                                      size: 16,
                                      color: starIndex < Motor['penilaian'].toInt()
                                          ? Colors.yellow
                                          : Colors.grey,
                                    ),
                                  )..add(
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          Motor['penilaian'].toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                ),
                                const SizedBox(height: 10),
                                // Deskripsi Film
                                Text(
                                  Motor['keterangan'],
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Edit',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, UpdateMotorPage.routeName,
                                            arguments: Motor);
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.yellow,
                                      ),
                                    ),
                                    Text(
                                      'Hapus',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.confirm,
                                            title: 'Hapus Motor',
                                            text:
                                                'Yakin ingin menghapus motor ${Motor['merek']}?',
                                            confirmBtnText: 'Ya',
                                            cancelBtnText: 'Tidak',
                                            confirmBtnColor: Colors.red,
                                            onConfirmBtnTap: () {
                                              deleteMotorResponse(
                                                  Motor['id_motor']);
                                            });
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ));
  }

  void getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      Response response;
      response = await dio.get(getAllMotor);
      if (response.data['status'] == true) {
        dataMotor = response.data['data'];
        print(dataMotor);
      } else {
        dataMotor = [];
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

  void deleteMotorResponse(int id) async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      Response response;

      response = await dio.delete(hapusMotor + id.toString());
      if (response.data['status'] == true) {
        toastification.show(
          context: context,
          title: Text(response.data['msg']),
          type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored,
        );
        Navigator.pushNamed(context, MotorPage.routeName);
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
