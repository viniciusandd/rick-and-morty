class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Bad Request: ");
}

class NotFoundException extends CustomException {
  NotFoundException([message]) : super(message, "Not Found: ");
}

class UnexpectedErrorException extends CustomException {
  UnexpectedErrorException([message]) : super(message, "Unexpected Error: ");
}

class NoConnectionException extends CustomException {
  NoConnectionException([message]) : super(message, "No Connection: ");
}

class NoInternetException extends CustomException {
  NoInternetException([message]) : super(message, "No Connection: ");
}