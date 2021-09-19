import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rickandmorty/api/custom_exceptions.dart';

class Base {
  final String baseUrl = "https://rickandmortyapi.com";
  final http.Client _client;

  Base(this._client);

  Future<bool> _checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<bool> _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com')
        .timeout(Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on TimeoutException catch (_) {
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<bool> _fakeCheckInternet() => Future.delayed(Duration(seconds: 5), () => false);

  Future<void> _executeRequiredChecks() async {
    Map verifications = {
      "hasConnection": await _checkConnection(),
      "hasInternet": await _checkInternet()
    };
    _processChecks(verifications);
  }

  void _processChecks(Map verifications) {
    if (!verifications["hasConnection"]) {
      throw NoConnectionException(); 
    }
    if (!verifications["hasInternet"]) {
      throw NoInternetException(); 
    }
  }
  
  Future<http.Response> get(String endpoint) async {
    await _executeRequiredChecks();
    Uri uri = Uri.parse("${this.baseUrl}/$endpoint");
    http.Response response = await this._client.get(uri);
    return _checkResponse(response);
  }

  http.Response _checkResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        throw BadRequestException();
      case 404:
        throw NotFoundException(response.body.toString());
      case 500:
      default:
        throw UnexpectedErrorException();
    }
  }
}