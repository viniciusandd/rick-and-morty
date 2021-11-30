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
  late Map bodyWithCharacters;
  late Map unexpectedBody;

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
    unexpectedBody = CharacterFactory.makeResponseWithUnexpectedBody();
    bodyWithCharacters = CharacterFactory.makeResponseWithList();
    setDataForMockRequest(bodyWithCharacters);
  });

  test('Deve fazer a requisição http com os parâmetros corretos.', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });

  test('Deve retorna uma lista de entidades se obter um http 200.', () async {
    final response = await sut.load();

    expect(response, [
      CharacterEntity(
        id: bodyWithCharacters["results"][0]["id"], 
        name: bodyWithCharacters["results"][0]["name"], 
        status: bodyWithCharacters["results"][0]["status"], 
        gender: bodyWithCharacters["results"][0]["gender"]
      ),
      CharacterEntity(
        id: bodyWithCharacters["results"][1]["id"], 
        name: bodyWithCharacters["results"][1]["name"], 
        status: bodyWithCharacters["results"][1]["status"], 
        gender: bodyWithCharacters["results"][1]["gender"]
      ),
    ]);
  });

  test('Deve lançar um erro inesperado se obter um http 200 com o body inesperado.', () {
    setDataForMockRequest(unexpectedBody);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Deve lançar um erro inesperado se obter um http 500.', () {
    setErrorForMockRequest(HttpError.serverError);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}