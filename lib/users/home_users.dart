import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411010_ester/api_service/api.dart';
import 'package:uas_pemrograman_4_22411010_ester/auth/login_page.dart';
import 'package:uas_pemrograman_4_22411010_ester/users/beli_motor.dart';
import 'package:uas_pemrograman_4_22411010_ester/users/pembayaran.dart';

class HomeUsers extends StatefulWidget {
  const HomeUsers({super.key});
  static const routeName = '/home_users';
  @override
  State<HomeUsers> createState() => _HomeUsersState();
}

class _HomeUsersState extends State<HomeUsers> {
  bool isLoading = false;
  var dataMotor = [];
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.pink,
          title: const Row(
            children: [
              Text('Teres Motor Apps', style: TextStyle(color: Colors.white))
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, TransaksiUser.routeName,
                      arguments: args);
                },
                icon: const Icon(
                  Icons.shopping_basket_sharp,
                  color: Colors.white,
                )),
            const SizedBox(width: 10),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, LoginPage.routeName);
                },
                icon: const Icon(
                  Icons.logout,
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
                  final motor = dataMotor[index];
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
                              imageUrl + motor['gambar'],
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
                                  motor['merek'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                // Tipe
                                Text(
                                  "Tipe: ${motor['tipe_motor_tipeTotipe']['jenis']}",
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
                                      color: starIndex < motor['penilaian'].toInt()
                                          ? Colors.yellow
                                          : Colors.grey,
                                    ),
                                  )..add(
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          motor['penilaian'].toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Rp. ${motor['harga']}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                                const SizedBox(height: 10),
                                // Deskripsi Film
                                Text(
                                  motor['keterangan'],
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
                                      'Beli',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, BeliMotor.routeName,
                                            arguments: {
                                              "motor": motor,
                                              "user": args
                                            });
                                      },
                                      icon: const Icon(
                                        Icons.shopping_basket_sharp,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
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
}