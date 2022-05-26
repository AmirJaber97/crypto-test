import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:rec_tasl/models/ExrateResponse.dart';
import 'package:rec_tasl/providers/crypto_provider.dart';

const String COIN_API = "https://rest.coinapi.io/v1";

class ApiService {
  final _dio = Dio();

  ApiService() {
    _dio.options.headers = {
      "X-CoinAPI-Key" : COIN_API_TOKEN
    };
    _dio.interceptors.add(PrettyDioLogger(requestBody: true, requestHeader: true));
  }

  Future<ExrateResponse?> getExrate(String pair) async {
    try {
      var response = await _dio.get('$COIN_API/exchangerate/$pair');
      return ExrateResponse.fromJson(response.data);
    } on DioError catch (e) {
      log('http exception caught ${e.error}');
    } catch (e) {
      log('exception caught');
    }
  }
}
