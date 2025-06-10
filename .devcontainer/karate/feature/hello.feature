Feature: 任意のサービスの疎通確認テンプレート

Scenario: /hello のGETリクエストで正常なレスポンスを確認する
  Given url baseUrl + '/hello'
  And param message = 'hello from karate'
  When method GET
  Then status 200
  And match response == 'メッセージ: hello from karate'