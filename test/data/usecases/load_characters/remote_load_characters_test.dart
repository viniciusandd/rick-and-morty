import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';

import 'package:rickandmorty/data/http/http.dart';
import 'package:rickandmorty/data/usecases/usecases.dart';
import 'package:rickandmorty/domain/entities/entities.dart';

import 'package:rickandmorty/domain/helpers/helpers.dart';

import '../../../resources/fake/character_factory.dart';
import 'remote_load_characters_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  late RemoteLoadCharactersUseCase sut;
  late MockHttpClient httpClient;
  late String url;
  late Map charactersList;

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
    sut = RemoteLoadCharactersUseCase(
      httpClient: httpClient,
      url: url
    );
    charactersList = CharacterFactory.makeResponseWithList();
    setDataForMockRequest(charactersList);
  });

  test('Deve fazer a requisição http com os parâmetros corretos.', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });

  test('Deve retorna uma lista de entidades se obter um http 200.', () async {
    final response = await sut.load();

    expect(response, [
      CharacterEntity(
        id: charactersList["results"][0]["id"], 
        name: charactersList["results"][0]["name"], 
        status: charactersList["results"][0]["status"], 
        gender: charactersList["results"][0]["gender"]
      ),
      CharacterEntity(
        id: charactersList["results"][1]["id"], 
        name: charactersList["results"][1]["name"], 
        status: charactersList["results"][1]["status"], 
        gender: charactersList["results"][1]["gender"]
      ),
    ]);
  });

  test('Deve lançar um erro inesperado se obter um http 500.', () {
    setErrorForMockRequest(HttpError.serverError);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}