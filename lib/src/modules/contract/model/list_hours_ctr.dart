class ListHoursCtrResponse {
  final List<ListHoursCtr> data;
  final int status;
  final String message;

  ListHoursCtrResponse({
    required this.data,
    required this.status,
    required this.message,
  });

  factory ListHoursCtrResponse.fromJson(Map<String, dynamic> json) =>
      ListHoursCtrResponse(
        data: List<ListHoursCtr>.from(
            json["data"].map((x) => ListHoursCtr.fromJson(x))),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
      };
}

class ListHoursCtr {
  final String horCodigo;
  final String horName;
  final List<MarHdeDetailHo> marHdeDetailHo;

  ListHoursCtr({
    required this.horCodigo,
    required this.horName,
    required this.marHdeDetailHo,
  });

  factory ListHoursCtr.fromJson(Map<String, dynamic> json) => ListHoursCtr(
        horCodigo: json["hor_codigo"],
        horName: json["hor_nombre"],
        marHdeDetailHo: List<MarHdeDetailHo>.from(
            json["mar_hde_detalle_ho"].map((x) => MarHdeDetailHo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "hor_codigo": horCodigo,
        "hor_nombre": horName,
        "mar_hde_detalle_ho":
            List<dynamic>.from(marHdeDetailHo.map((x) => x.toJson())),
      };
}

class MarHdeDetailHo {
  String hdeCodigo;
  String hdeCodhor;
  String horCodDay;
  String hdeStart1;
  String hdeFin1;
  String hdeStart2;
  String hdeFin2;
  final MarDiaDias marDiaDias;

  MarHdeDetailHo({
    required this.hdeCodigo,
    required this.hdeCodhor,
    required this.horCodDay,
    required this.hdeStart1,
    required this.hdeFin1,
    required this.hdeStart2,
    required this.hdeFin2,
    required this.marDiaDias,
  });

  factory MarHdeDetailHo.fromJson(Map<String, dynamic> json) => MarHdeDetailHo(
        hdeCodigo: json["hde_codigo"],
        hdeCodhor: json["hde_codhor"],
        horCodDay: json["hde_coddia"],
        hdeStart1: json["hde_inicio_1"],
        hdeFin1: json["hde_fin_1"],
        hdeStart2: json["hde_inicio_2"],
        hdeFin2: json["hde_fin_2"],
        marDiaDias: MarDiaDias.fromJson(json["mar_dia_dias"]),
      );

  Map<String, dynamic> toJson() => {
        "hde_codigo": hdeCodigo,
        "hde_codhor": hdeCodhor,
        "hde_coddia": horCodDay,
        "hde_inicio_1": hdeStart1,
        "hde_fin_1": hdeFin1,
        "hde_inicio_2": hdeStart2,
        "hde_fin_2": hdeFin2,
        "mar_dia_dias": marDiaDias.toJson(),
      };
}

class MarDiaDias {
  final String diaCodigo;
  final String diaName;
  final String diaDiaCodigo;

  MarDiaDias({
    required this.diaCodigo,
    required this.diaName,
    required this.diaDiaCodigo,
  });

  factory MarDiaDias.fromJson(Map<String, dynamic> json) => MarDiaDias(
        diaCodigo: json["dia_codigo"],
        diaName: json["dia_nombre"],
        diaDiaCodigo: json["dia_dia_codigo"],
      );

  Map<String, dynamic> toJson() => {
        "dia_codigo": diaCodigo,
        "dia_nombre": diaName,
        "dia_dia_codigo": diaDiaCodigo,
      };
}
