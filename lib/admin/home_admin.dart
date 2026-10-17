import 'package:flutter/material.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/motor/motor.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/pembayaran/pembayaran.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/tipe/tipe.dart';
import 'package:uas_pemrograman_4_22411010_ester/auth/login_page.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});
  static const routeName = '/home_admin';
  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Row(
          children: [
            Icon(Icons.home, color: Colors.white),
            SizedBox(
              width: 10,
            ),
            Text(
              "Teres Motor Apps",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            )
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: const Color(0xFF232429),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 80,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2f2f2f),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, Tipe.routeName),
                        child: const Column(
                          children: [
                            Icon(Icons.bike_scooter_outlined,
                                size: 32.0, color: Colors.white),
                            SizedBox(height: 4),
                            Text('Tipe', style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 100,
                      height: 80,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2f2f2f),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, MotorPage.routeName),
                        child: const Column(
                          children: [
                            Icon(Icons.electric_bike_outlined,
                                size: 32.0, color: Colors.white),
                            SizedBox(height: 4),
                            Text('Motor', style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 80,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2f2f2f),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, TransaksiAdmin.routeName),
                        child: const Column(
                          children: [
                            Icon(Icons.receipt, size: 32.0, color: Colors.white),
                            SizedBox(height: 4),
                            Text('Transaksi', style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 100,
                      height: 80,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2f2f2f),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, LoginPage.routeName),
                        child: const Column(
                          children: [
                            Icon(Icons.exit_to_app,
                                size: 32.0, color: Colors.white),
                            SizedBox(height: 4),
                            Text('Keluar', style: TextStyle(color: Colors.white))
                          ],

                        ),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}