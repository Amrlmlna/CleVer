import 'dart:convert';

import 'package:clever/data/datasources/remote_library_datasource.dart';
import 'package:clever/data/datasources/remote_cv_datasource.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  // ApiConfig.baseUrl reads dotenv.env, which throws NotInitializedError
  // before load() — mirror the app's own initialization order.
  setUpAll(() async {
    await dotenv.load(fileName: '.env');
  });

  late Uri? capturedUrl;
  late String? capturedMethod;
  late String? capturedBody;
  late int responseStatus;
  late String responseBody;

  late RemoteLibraryDataSource dataSource;

  setUp(() {
    capturedUrl = null;
    capturedMethod = null;
    capturedBody = null;
    responseStatus = 200;
    responseBody = '{}';

    dataSource = RemoteLibraryDataSource(
      httpClient: MockClient((request) async {
        capturedUrl = request.url;
        capturedMethod = request.method;
        capturedBody = request.body;
        return http.Response(responseBody, responseStatus);
      }),
    );
  });

  group('drafts', () {
    test('listDrafts GETs /cv/drafts and parses the list', () async {
      responseBody = jsonEncode({
        'drafts': [
          {'id': 'd1', 'createdAt': '2026-10-31T00:00:00.000Z'},
        ],
      });

      final drafts = await dataSource.listDrafts();

      expect(capturedMethod, 'GET');
      expect(capturedUrl!.path, '/api/cv/drafts');
      expect(drafts.single['id'], 'd1');
    });

    test('saveDraft PUTs the draft under its id', () async {
      final draft = {
        'id': 'd1',
        'userProfile': {'fullName': 'Budi'},
        'createdAt': '2026-10-31T00:00:00.000Z',
      };

      await dataSource.saveDraft('d1', draft);

      expect(capturedMethod, 'PUT');
      expect(capturedUrl!.path, '/api/cv/drafts/d1');
      expect(jsonDecode(capturedBody!)['id'], 'd1');
    });

    test('deleteDraft DELETEs /cv/drafts/:id', () async {
      await dataSource.deleteDraft('d1');

      expect(capturedMethod, 'DELETE');
      expect(capturedUrl!.path, '/api/cv/drafts/d1');
    });
  });

  group('completed CVs', () {
    test('listCompleted GETs /cv/completed and parses the list', () async {
      responseBody = jsonEncode({
        'completedCvs': [
          {'id': 'cv-1', 'jobTitle': 'Backend Dev'},
        ],
      });

      final cvs = await dataSource.listCompleted();

      expect(capturedMethod, 'GET');
      expect(capturedUrl!.path, '/api/cv/completed');
      expect(cvs.single['jobTitle'], 'Backend Dev');
    });

    test('deleteCompleted DELETEs /cv/completed/:id', () async {
      await dataSource.deleteCompleted('cv-1');

      expect(capturedMethod, 'DELETE');
      expect(capturedUrl!.path, '/api/cv/completed/cv-1');
    });
  });

  group('profile + FCM', () {
    test('getProfile GETs /user/profile', () async {
      responseBody = jsonEncode({'fullName': 'Budi', 'wallet': {}});
      final profile = await dataSource.getProfile();
      expect(capturedUrl!.path, '/api/user/profile');
      expect(profile['fullName'], 'Budi');
    });

    test('updateProfile PUTs the profile json', () async {
      await dataSource.updateProfile({'fullName': 'Budi', 'email': 'b@ex.com'});
      expect(capturedMethod, 'PUT');
      expect(capturedUrl!.path, '/api/user/profile');
      expect(jsonDecode(capturedBody!)['fullName'], 'Budi');
    });

    test('updateFcmToken PUTs token + platform', () async {
      await dataSource.updateFcmToken(token: 'tok', platform: 'android');
      expect(capturedUrl!.path, '/api/user/fcm-token');
      final body = jsonDecode(capturedBody!);
      expect(body['fcmToken'], 'tok');
      expect(body['platform'], 'android');
    });
  });

  test('non-200 responses throw ApiException with the status code', () async {
    responseStatus = 401;
    responseBody = jsonEncode({'error': 'Unauthorized'});

    await expectLater(
      dataSource.listDrafts(),
      throwsA(
        isA<ApiException>()
            .having((e) => e.statusCode, 'statusCode', 401)
            .having((e) => e.errorCode, 'errorCode', null),
      ),
    );
  });
}
