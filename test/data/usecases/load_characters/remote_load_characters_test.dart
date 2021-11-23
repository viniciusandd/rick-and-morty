import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rickandmorty/data/http/http_client.dart';
import 'package:rickandmorty/data/usecases/load_characters/load_characters.dart';

import 'remote_load_characters_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  late RemoteLoadCharactersUseCase sut;
  late MockHttpClient httpClient;
  late String url;

  PostExpectation mockRequest() => 
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method')
    ));
  
  void setDataForMockRequest() {
    mockRequest().thenAnswer((_) async => {});
  }

  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpsUrl();
    sut = RemoteLoadCharactersUseCase(
      httpClient: httpClient,
      url: url
    );
  });

  test('Deve fazer a requisição http com os parâmetros corretos.', () async {
    setDataForMockRequest();

    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });
}