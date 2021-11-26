import '../../../domain/helpers/helpers.dart';

import '../../http/http.dart';

class RemoteLoadCharactersUseCase {
  final HttpClient httpClient;
  final String url;

  RemoteLoadCharactersUseCase({
    required this.httpClient,
    required this.url
  });

  Future<void> load() async {
    try {
      await this.httpClient.request(url: url, method: 'get');
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}