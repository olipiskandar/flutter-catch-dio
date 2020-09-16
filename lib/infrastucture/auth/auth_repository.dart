import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:dartz/dartz.dart';
import 'package:hello_enam/domain/auth/model/login_request.dart';
import 'package:hello_enam/domain/auth/model/login_response.dart';

class AuthRepository {
  Dio _dio = new Dio();

  Future<Either<String, LoginResponse>> siginUser({
    @required LoginRequest loginRequest,
  }) async {
    Response _response;
    try {
      _response = await _dio.post('https://reqres.in/api/login',
          data: loginRequest.toJson());
      // Minta Response
      LoginResponse _loginResponse = LoginResponse.fromJson(_response.data);
      return right(_loginResponse);
    } on DioError catch (e) {
      // Error yg dihasilkan oleh Dio
      print(e.response.statusCode);
      String errorMessage = e.response.data.toString();
      switch (e.type) {
        case DioErrorType.CONNECT_TIMEOUT:
          break;
        case DioErrorType.SEND_TIMEOUT:
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          break;
        case DioErrorType.RESPONSE:
          errorMessage = e.response.data['error'];
          break;
        case DioErrorType.CANCEL:
          break;
        case DioErrorType.DEFAULT:
          break;
      }
      return left(errorMessage);
    }
  }
}
