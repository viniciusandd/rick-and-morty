import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

import '../../models/models.dart';

import '../../http/http.dart';

class RemoteLoadEpisodesUseCase implements LoadEpisodesUseCase {
  final HttpClient httpClient;
  final String url;

  RemoteLoadEpisodesUseCase({
    required this.httpClient,
    required this.url
  });

  Future<List<EpisodeEntity>> load() async {
    try {
      final httpResponse = await this.httpClient.request(url: url, method: 'get');
      if (!httpResponse.containsKey("results")) throw HttpError.invalidData;
      return httpResponse["results"].map<EpisodeEntity>((map) => RemoteEpisodeModel.fromMap(map).toEntity()).toList();
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}