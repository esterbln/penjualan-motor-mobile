import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/model/tipe_modal.dart';
import 'package:uas_pemrograman_4_22411010_ester/admin/motor/motor.dart';
import 'package:uas_pemrograman_4_22411010_ester/api_service/api.dart';

class InputMotor extends StatefulWidget {
  const InputMotor({super.key});
  static const routeName = '/input-motor';

  @override
  State<InputMotor> createState() => _InputMotorState();
}

class _InputMotorState extends State<InputMotor> {
  final dio = Dio();

  bool isLoading = false;

  int? idTipe;

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
      throw Exception('Terjadi Kesalahan: $e');
    }
    return [];
  }

  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;

  Future<void> pickImage() async {
    try {
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
                "Tambah Data Motor",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: merekcontroller,
                decoration: const InputDecoration(
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
                decoration: const InputDecoration(
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
                decoration: const InputDecoration(
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
                decoration: const InputDecoration(
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
                  return Text(
                    selectedItem?.jenis ?? "Select Tipe",
                    style: const TextStyle(
                      color: Colors.black, // Warna teks yang dipilih
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
                child: const Text(
                  "Pilih Gambar",
                  style: TextStyle(color: Colors.white),
                ),
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
                  : const Text(
                      "Tidak ada gambar yang dipilih",
                      style: TextStyle(color: Colors.black),
                    ),
              const SizedBox(
                height: 32,
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        inputMotorResponse();
                        // if (genrecontroller.text.isEmpty && genrecontroller.text == '') {
                        //   toastification.show(
                        //       context: context,
                        //       title: const Text("Username Tidak Boleh Kosong!"),
                        //       type: ToastificationType.error,
                        //       autoCloseDuration: const Duration(seconds: 3),
                        //       style: ToastificationStyle.fillColored);
                        // } else {
                        //   inputResponse();
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          minimumSize: const Size.fromHeight(50)),
                      child: const Text(
                        "Input Motor",
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

  void inputMotorResponse() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      FormData formData = FormData.fromMap({
        'gambar': MultipartFile.fromBytes(_imageBytes!, filename: 'test.jpg'),
        "merek": merekcontroller.text,
        "harga": hargacontroller.text,
        "tipe": idTipe.toString(),
        "penilaian": penilaiancontroller.text,
        "keterangan": keterangancontroller.text
      });
      Response response;
      response = await dio.post(inputMotor, data: formData);
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
        (() {
          isLoading = false;
        });
      });
    }
  }
}
