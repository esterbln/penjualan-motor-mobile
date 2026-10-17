
class GenreModel {
  final int idTipe;
  final String jenis;

  GenreModel({
    required this.idTipe,
    required this.jenis,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      idTipe: json["idTipe"],
      jenis: json["jenis"],
    );
  }

  static List<GenreModel> fromJsonList(List list) {
    return list.map((item) => GenreModel.fromJson(item)).toList();
  }

  /// Prevent overriding toString
  String userAsString() {
    return '#$idTipe $jenis';
  }

  /// Check equality of two models
  bool isEqual(GenreModel model) {
    return idTipe == model.idTipe;
  }

  @override
  String toString() => jenis;
}