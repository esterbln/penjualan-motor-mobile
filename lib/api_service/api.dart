// Alamat API (penjualan-motor-api).
// Chrome atau Windows: http://localhost:3000
// Emulator Android: http://10.0.2.2:3000
// HP asli: ganti dengan IP laptop di jaringan Wi-Fi yang sama
String baseUrl = "http://localhost:3000";

//image
String imageUrl = '$baseUrl/img/motor/';

//auth
String register = "$baseUrl/pengguna/register";
String login = "$baseUrl/pengguna/login";

//genre
String getAllTipe = "$baseUrl/tipe/get";
String insertTipe = "$baseUrl/tipe/insert";
String hapusTipe = "$baseUrl/tipe/delete/";
String editTipe = "$baseUrl/tipe/edit/";

//movie
String getAllMotor = "$baseUrl/motor/get-all";
String hapusMotor = "$baseUrl/motor/delete/";
String inputMotor = "$baseUrl/motor/insert";
String editMotor = "$baseUrl/motor/edit/";

//transaksi
String insertTransaksi = "$baseUrl/pembayaran/insert";
String getTransaksi = "$baseUrl/pembayaran/get-all";
String getTransaksiId = "$baseUrl/pembayaran/get/";
String confirmTranskasi = "$baseUrl/pembayaran/confirm-pembayaran/";
