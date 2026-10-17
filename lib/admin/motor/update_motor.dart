import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/model/tipe_modal.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/motor/motor.dart';
import 'package:uas_pemrograman_4_22411010_ester/api_service/api.dart';

class UpdateMotorPage extends StatefulWidget {
  const UpdateMotorPage({super.key});
  static String routeName = '/update-motor';
  @override
  State<UpdateMotorPage> createState() => _UpdateMotorPageState();
}

class _UpdateMotorPageState extends State<UpdateMotorPage> {
  final dio = Dio();
  bool isLoading = false;
  int? idTipe;
  String? tipe;
  int? id_motor;

  TextEditingController merekcontroller = TextEditingController();
  TextEditingController hargacontroller = TextEditingController();
  TextEditingController penilaiancontroller = TextEditingController();
  TextEditingController keterangancontroller = TextEditingController();

  GenreModel? _selectedTipe;

  Future<List<GenreModel>> getData() async {
    try {
      var response = await Dio().get(getAllTipe);
      final data = response.data["data"];
      if (data != null) {
        return GenreModel.fromJsonList(data);
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
    return [];
  }

  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;

  Future<void> pickImage() async {
    try {
      // Pick an image
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final Uint8List imageBytes = await image.readAsBytes();
        setState(() {
          _imageBytes = imageBytes;
        });
      }
    } catch (e) {
      throw Exception("Failed to pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    merekcontroller.text = args['merek'];
    hargacontroller.text = args['harga'].toString();
    penilaiancontroller.text = args['penilaian'].toString();
    keterangancontroller.text = args['keterangan'];
    id_motor = args['id_motor'];
    tipe = args['tipe_motor_tipeTotipe']['jenis'].toString();
    idTipe = args['tipe_motor_tipeTotipe']['idTipe'];

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
            const Text("Form Edit Motor",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: merekcontroller,
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
              controller: hargacontroller,
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
              controller: keterangancontroller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                labelText: "Keterangan",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 5,
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: penilaiancontroller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                labelText: "Penilaian",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 16,
            ),
            DropdownSearch<GenreModel>(
              popupProps: PopupProps.dialog(
                itemBuilder:
                    (BuildContext context, GenreModel item, bool isDisabled) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: ListTile(
                      title: Text(item.jenis),
                      leading: CircleAvatar(child: Text(item.jenis[0])),
                    ),
                  );
                },
                showSearchBox: true,
                searchFieldProps: const TextFieldProps(
                  decoration: InputDecoration(
                    hintText: "Search Tipe...",
                  ),
                ),
              ),
              asyncItems: (String? filter) => getData(),
              itemAsString: (GenreModel? item) => item?.userAsString() ?? "",
              onChanged: (GenreModel? data) {
                setState(() {
                  _selectedTipe = data;
                  idTipe = data?.idTipe;
                });
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Select Tipe",
                  hintStyle: TextStyle(color: Colors.white),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              selectedItem: _selectedTipe,
              dropdownBuilder:
                  (BuildContext context, GenreModel? selectedItem) {
                var text = _selectedTipe == null
                    ? tipe.toString()
                    : _selectedTipe!.jenis;
                return Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                pickImage();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  minimumSize: const Size.fromHeight(50)),
              child: const Text("Pilih Gambar",
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(
              height: 16,
            ),
            _imageBytes != null
                ? Image.memory(
                    _imageBytes!,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                : Image.network("$imageUrl/${args['gambar']}",
                    width: 200, height: 200, fit: BoxFit.cover),
            const SizedBox(
              height: 32,
            ),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      // if (genreController.text.isEmpty &&
                      //     genreController.text == '') {
                      //   toastification.show(
                      //       context: context,
                      //       title: const Text("Nama Genre Tidak Boleh Kosong!"),
                      //       autoCloseDuration: const Duration(seconds: 3),
                      //       type: ToastificationType.error,
                      //       style: ToastificationStyle.fillColored);
                      // } else {
                      //   // inputGenreResponse();
                      // }
                      updateMotorResponse(
                          _imageBytes,
                          merekcontroller.text,
                          hargacontroller.text,
                          _selectedTipe == null
                              ? idTipe
                              : _selectedTipe!.idTipe,
                          penilaiancontroller.text,
                          keterangancontroller.text);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        minimumSize: const Size.fromHeight(50)),
                    child: const Text(
                      "Edit Motor",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ],
        ),
      ))),
    );
  }

  void updateMotorResponse(
      gambar, merek, harga, tipe, penilaian,keterangan) async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      var data = <String, dynamic>{
        if (gambar != null)
          "gambar": MultipartFile.fromBytes(
            gambar!,
            filename: 'test.jpg',
          ),
        "merek": merek,
        "harga": harga.toString(),
        "tipe": tipe.toString(),
        "penilaian": penilaian.toString(),
        "keterangan": keterangan,
      };
      FormData formData = FormData.fromMap(data);
      Response response;
      response = await dio.put(editMotor + id_motor.toString(), data: formData);
      if (response.data['status'] == true) {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.success,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
        Navigator.pushNamed(context, MotorPage.routeName);
      }
    } catch (e) {
      toastification.show(
          context: context,
          title: const Text("Terjadi kesalahan pada server"),
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