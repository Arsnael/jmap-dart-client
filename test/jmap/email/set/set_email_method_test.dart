import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_parser/http_parser.dart';
import 'package:jmap_dart_client/http/http_client.dart';
import 'package:jmap_dart_client/jmap/account_id.dart';
import 'package:jmap_dart_client/jmap/core/id.dart';
import 'package:jmap_dart_client/jmap/core/unsigned_int.dart';
import 'package:jmap_dart_client/jmap/jmap_request.dart';
import 'package:jmap_dart_client/jmap/mail/email/email.dart';
import 'package:jmap_dart_client/jmap/mail/email/email_address.dart';
import 'package:jmap_dart_client/jmap/mail/email/email_body_part.dart';
import 'package:jmap_dart_client/jmap/mail/email/email_body_value.dart';
import 'package:jmap_dart_client/jmap/mail/email/keyword_identifier.dart';
import 'package:jmap_dart_client/jmap/mail/email/set/set_email_method.dart';
import 'package:jmap_dart_client/jmap/mail/email/set/set_email_response.dart';
import 'package:jmap_dart_client/jmap/mail/mailbox/mailbox.dart';

void main() {
  group('test to json set email method', () {
    final expectedCreated = Email(
      EmailId(Id('29a7f870-0596-11ec-b153-2fef1ee78d9e')),
      blobId: Id('29a7f870-0596-11ec-b153-2fef1ee78d9e'),
      threadId: ThreadId(Id('29a7f870-0596-11ec-b153-2fef1ee78d9e')),
      size: UnsignedInt(657)
    );

    test('set email method and response parsing', () async {
      final baseOption  = BaseOptions(method: 'POST');
      final dio = Dio(baseOption)
        ..options.baseUrl = 'http://domain.com';
      final dioAdapter = DioAdapter(dio: dio);
      dioAdapter.onPost(
        '/jmap',
        (server) => server.reply(200, {
          "sessionState": "2c9f1b12-b35a-43e6-9af2-0106fb53a943",
          "methodResponses": [[
              "Email/set",
              {
                "accountId":"3ce33c876a726662c627746eb9537a1d13c2338193ef27bd051a3ce5c0fe5b12",
                "oldState":"234c9ee0-0596-11ec-b153-2fef1ee78d9e",
                "newState":"234c9ee0-0596-11ec-b153-2fef1ee78d9e",
                "created": {
                  "aa1234": {
                    "id":"29a7f870-0596-11ec-b153-2fef1ee78d9e",
                    "blobId":"29a7f870-0596-11ec-b153-2fef1ee78d9e",
                    "threadId":"29a7f870-0596-11ec-b153-2fef1ee78d9e",
                    "size": 657
                  }
                }
              },
              "c0"
            ]]
        }),
        data: {
          'using': [
            'urn:ietf:params:jmap:mail',
            'urn:ietf:params:jmap:core'
          ],
          'methodCalls': [[
            'Email/set',
            {
              'accountId': '3ce33c876a726662c627746eb9537a1d13c2338193ef27bd051a3ce5c0fe5b12',
              'create': {
                'aa1234': {
                  'id': 'ea12345',
                  'mailboxIds': {
                    'fe00a5c0-0584-11ec-b153-2fef1ee78d9e': true
                  },
                  'keywords': {
                    '\$seen': true
                  },
                  'subject': 'set email 3',
                  'sender': [{
                    'name: bob, email: bob@email'
                  }],
                  'from' : [{
                    'name': 'alice', 'email': 'alice@email'
                  }],
                  'to': [{
                    'name': 'dcu', 'email': 'dcu@email'
                  }],
                  'replyTo': [{
                    'name': 'bob', 'email': 'bob@email'
                  }],
                  'htmlBody': [{
                    'partId': 'a49d', 'type': 'text/html'
                  }],
                  'bodyValues': {
                    'a49d': {
                      'value': 'test html html',
                      'isEncodingProblem': false,
                      'isTruncated': false
                    }
                  }
                }
              }
            },
            'c0'
          ]
          ]
        },
        headers: {
          "accept": "application/json;jmapVersion=rfc-8621",
          "content-type": "application/json; charset=utf-8"
        }
      );

      final setEmailMethod = SetEmailMethod(AccountId(Id('3ce33c876a726662c627746eb9537a1d13c2338193ef27bd051a3ce5c0fe5b12')))
        ..addCreate(Id('aa1234'),
          Email(
            EmailId(Id('ea12345')),
            mailboxIds: {
              MailboxId(Id('fe00a5c0-0584-11ec-b153-2fef1ee78d9e')): true
            },
            keywords: {
              KeyWordIdentifier.emailSeen: true
            },
            replyTo: {EmailAddress('bob', 'bob@email')},
            from: {EmailAddress('alice', 'alice@email')},
            sender: {EmailAddress('bob', 'bob@email')},
            to: {EmailAddress('dcu', 'dcu@email')},
            subject: 'set email 3',
            htmlBody: {EmailBodyPart(partId: PartId('a49d'), type: MediaType.parse('text/html'))},
            bodyValues: {
              PartId('a49d'): EmailBodyValue('test html html', false, false)
            },
          )
        );

      final httpClient = HttpClient(dio);
      final requestBuilder = JmapRequestBuilder(httpClient, ProcessingInvocation());
      final setEmailInvocation = requestBuilder.invocation(setEmailMethod);
      final response = await (requestBuilder..usings(setEmailMethod.requiredCapabilities))
        .build()
        .execute();

      final setEmailResponse = response.parse<SetEmailResponse>(
        setEmailInvocation.methodCallId,
        SetEmailResponse.deserialize);

      expect(setEmailResponse!.created![Id('aa1234')], equals(expectedCreated));
    });
  });
}