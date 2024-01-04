import 'package:dio/dio.dart';
import 'package:marcacion_admin/src/common/const/const.dart';
import 'package:marcacion_admin/src/common/models/error_model.dart';
import 'package:marcacion_admin/src/common/services/services.dart';

class DioConnection {
  static final Dio _dio = Dio();

  static void configureDio() {
    // Base del url
    _dio.options.baseUrl = APIURL;

    // Config Headers
    _dio.options.headers = {
      'Authorization': 'Bearer ${LocalStorage.prefs.getString('token') ?? ''}'
    };
  }

  static Future get_(String endpoint,
      [Map<String, dynamic>? queryParameters]) async {
    try {
      Response response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      ErrorResponse msg;
      if (e.response != null) {
        if (e.response?.data != null) {
          msg = ErrorResponse.fromJson(e.response?.data);
          NotificationsService.showSnackbarError(msg.message);
        } else {
          msg = ErrorResponse(
            time: DateTime.now(),
            path: endpoint,
            data: "Error al generar la peticion",
            message: '',
            status: 500,
          );
        }
      } else {
        msg = ErrorResponse(
          time: DateTime.now(),
          path: endpoint,
          data: "Error al generar la peticion",
          message: '',
          status: 500,
        );
      }
      NotificationsService.showSnackbarError(msg.message);
      return msg;
    }
  }

  static Future getExcel(String endpoint,
      [Map<String, dynamic>? queryParameters]) async {
    try {
      Response response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Ocurrió un error en la generacion del documento');
      }
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      ErrorResponse msg;
      if (e.response != null) {
        if (e.response?.data != null) {
          msg = ErrorResponse.fromJson(e.response?.data);
          NotificationsService.showSnackbarError(msg.message);
        } else {
          msg = ErrorResponse(
            time: DateTime.now(),
            path: endpoint,
            data: "Error al generar la peticion",
            message: '',
            status: 500,
          );
        }
      } else {
        msg = ErrorResponse(
          time: DateTime.now(),
          path: endpoint,
          data: "Error al generar la peticion",
          message: '',
          status: 500,
        );
      }
      NotificationsService.showSnackbarError(msg.message);
      return msg;
    }
  }

  static Future post_(String endpoint, dynamic data) async {
    // final formData = FormData.fromMap(data);

    try {
      final resp = await _dio.post(endpoint, data: data);
      return resp.data;
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      ErrorResponse msg;
      if (e.response != null) {
        if (e.response?.data != null) {
          msg = ErrorResponse.fromJson(e.response?.data);
        } else {
          msg = ErrorResponse(
            time: DateTime.now(),
            path: endpoint,
            data: "Error al generar la peticion",
            message: '',
            status: 500,
          );
        }
      } else {
        msg = ErrorResponse(
          time: DateTime.now(),
          path: endpoint,
          data: "Error al generar la peticion",
          message: '',
          status: 500,
        );
      }
      NotificationsService.showSnackbarError(msg.message);
      return msg;
    }
  }

  static Future put_(String endpoint, Map<String, dynamic> data) async {
    // final formData = FormData.fromMap(data);

    try {
      final resp = await _dio.put(endpoint, data: data);
      return resp.data;
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      ErrorResponse msg;
      if (e.response != null) {
        if (e.response?.data != null) {
          msg = ErrorResponse.fromJson(e.response?.data);
          NotificationsService.showSnackbarError(msg.message);
        } else {
          msg = ErrorResponse(
            time: DateTime.now(),
            path: endpoint,
            data: "Error al generar la peticion",
            message: '',
            status: 500,
          );
        }
      } else {
        msg = ErrorResponse(
          time: DateTime.now(),
          path: endpoint,
          data: "Error al generar la peticion",
          message: '',
          status: 500,
        );
      }
      NotificationsService.showSnackbarError(msg.message);
      return msg;
    }
  }

  static Future delete_(String endpoint) async {
    // final formData = FormData.fromMap(data);

    try {
      final resp = await _dio.delete(endpoint);
      return resp.data;
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      ErrorResponse msg;
      if (e.response != null) {
        if (e.response?.data != null) {
          msg = ErrorResponse.fromJson(e.response?.data);
          NotificationsService.showSnackbarError(msg.message);
        } else {
          msg = ErrorResponse(
            time: DateTime.now(),
            path: endpoint,
            data: "Error al generar la peticion",
            message: '',
            status: 500,
          );
        }
      } else {
        msg = ErrorResponse(
          time: DateTime.now(),
          path: endpoint,
          data: "Error al generar la peticion",
          message: '',
          status: 500,
        );
      }
      NotificationsService.showSnackbarError(msg.message);
      return msg;
    }
  }
}
