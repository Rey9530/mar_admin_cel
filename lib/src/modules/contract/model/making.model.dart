import 'package:intl/intl.dart';

class MakingCtrResponse {
  final List<MakingItem> data;
  final int status;
  final String message;

  MakingCtrResponse({
    required this.data,
    required this.status,
    required this.message,
  });

  factory MakingCtrResponse.fromJson(Map<String, dynamic> json) =>
      MakingCtrResponse(
        data: List<MakingItem>.from(
          json["data"].map(
            (x) => MakingItem.fromJson(x),
          ),
        ),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(
          data.map(
            (x) => x.toJson(),
          ),
        ),
        "status": status,
        "message": message,
      };
}

class MakingItem {
  final String nombres;
  final String apellidos;
  final String codigo;
  final String id;
  final String entrada;
  final String salida;
  final String fecha;
  final String tiempoExtra;
  final String tiempoTrabajado;

  MakingItem({
    required this.nombres,
    required this.apellidos,
    required this.codigo,
    required this.id,
    required this.entrada,
    required this.salida,
    required this.fecha,
    required this.tiempoExtra,
    required this.tiempoTrabajado,
  });

  factory MakingItem.fromJson(Map<String, dynamic> json) => MakingItem(
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        codigo: json["codigo"],
        id: json["id"],
        entrada: json["entrada"] != null
            ? DateFormat("h:mm a").format(
                DateTime.parse(json["entrada"]).toLocal(),
              )
            : "N/A",
        salida: json["salida"] != null
            ? DateFormat("h:mm a").format(
                DateTime.parse(json["salida"]).toLocal(),
              )
            : "N/A",
        tiempoExtra: json["tiempo_extra"],
        tiempoTrabajado: json["tiempo_trabajado"],
        fecha: json["fecha"] != null
            ? DateFormat("dd/MM/y").format(DateTime.parse(json["fecha"]))
            : "",
      );

  Map<String, dynamic> toJson() => {
        "nombres": nombres,
        "apellidos": apellidos,
        "codigo": codigo,
        "id": id,
        "entrada": entrada,
        "salida": salida,
        "tiempo_extra": tiempoExtra,
        "tiempo_trabajado": tiempoTrabajado,
      };
}
