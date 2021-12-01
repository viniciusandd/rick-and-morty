import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:faker/faker.dart';

import 'package:rickandmorty/data/http/http.dart';
import 'package:rickandmorty/data/usecases/usecases.dart';

import 'remote_load_episodes_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  late RemoteLoadEpisodesUseCase sut;
  late MockHttpClient httpClient;
  late String url;
  
  PostExpectation mockRequest() => 
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method')
    ));
  
  void setDataForMockRequest(data) {
    mockRequest().thenAnswer((_) async => data);
  }

  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpsUrl();
    sut = RemoteLoadEpisodesUseCase(httpClient: httpClient, url: url);
    setDataForMockRequest({});
  });

  test('Deve fazer a requisição http com os parâmetros corretos.', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });
}