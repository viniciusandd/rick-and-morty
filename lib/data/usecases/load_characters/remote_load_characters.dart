import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';

import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadCharactersUseCase {
  final HttpClient httpClient;
  final String url;

  RemoteLoadCharactersUseCase({
    required this.httpClient,
    required this.url
  });

  Future<List<CharacterEntity>> load() async {
    try {
      final httpResponse = await this.httpClient.request(url: url, method: 'get');
      if (!httpResponse.containsKey("results")) throw HttpError.invalidData;
      return httpResponse["results"].map<CharacterEntity>((map) => RemoteCharacterModel.fromMap(map).toEntity()).toList();      
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}