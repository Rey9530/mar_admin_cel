class ChartResponse {
  final DataRespon data;
  final int status;
  final String message;

  ChartResponse({
    required this.data,
    required this.status,
    required this.message,
  });

  factory ChartResponse.fromJson(Map<String, dynamic> json) => ChartResponse(
        data: DataRespon.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
      );
}

class DataRespon {
  final List<ContrationChart> genders;
  final List<ContrationChart> contrations;

  DataRespon({
    required this.genders,
    required this.contrations,
  });

  factory DataRespon.fromJson(Map<String, dynamic> json) => DataRespon(
        genders: List<ContrationChart>.from(
            json["genders"].map((x) => ContrationChart.fromJson(x))),
        contrations: List<ContrationChart>.from(
            json["contrations"].map((x) => ContrationChart.fromJson(x))),
      );
}

class ContrationChart {
  final String nombre;
  final double cantidad;

  ContrationChart({
    required this.nombre,
    required this.cantidad,
  });

  factory ContrationChart.fromJson(Map<String, dynamic> json) =>
      ContrationChart(
        nombre: json["nombre"].toString(),
        cantidad: double.tryParse(json["cantidad"].toString()) ?? 0.00,
      );
}
