import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:faker/faker.dart';

import 'package:rickandmorty/data/http/http.dart';
import 'package:rickandmorty/data/usecases/usecases.dart';

import 'package:rickandmorty/domain/entities/episode.dart';
import 'package:rickandmorty/domain/helpers/helpers.dart';

import '../../../resources/fake/episode_factory.dart';

import 'remote_load_episodes_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  late RemoteLoadEpisodesUseCase sut;
  late MockHttpClient httpClient;
  late String url;
  late Map bodyWithEpisodes;
  
  PostExpectation mockRequest() => 
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method')
    ));
  
  void setDataForMockRequest(data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void setErrorForMockRequest(error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpsUrl();
    sut = RemoteLoadEpisodesUseCase(httpClient: httpClient, url: url);
    bodyWithEpisodes = EpisodeFactory.makeResponseWithList();
    setDataForMockRequest(bodyWithEpisodes);
  });

  test('Deve fazer a requisição http com os parâmetros corretos.', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });

  test('Deve retorna uma lista de entidades se obter um http 200.', () async {
    final response = await sut.load();

    expect(response, [
      EpisodeEntity(
        episode: bodyWithEpisodes["results"][0]["episode"], 
        name: bodyWithEpisodes["results"][0]["name"], 
        airDate: bodyWithEpisodes["results"][0]["air_date"]
      ),
      EpisodeEntity(
        episode: bodyWithEpisodes["results"][1]["episode"], 
        name: bodyWithEpisodes["results"][1]["name"], 
        airDate: bodyWithEpisodes["results"][1]["air_date"]
      ),
    ]);
  });

  test('Deve lançar um erro inesperado se obter um http 500.', () {
    setErrorForMockRequest(HttpError.serverError); 

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}