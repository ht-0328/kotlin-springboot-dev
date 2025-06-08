Feature: 任意のサービスの疎通確認テンプレート

Scenario: /hello のGETリクエストで正常なレスポンスを確認する
  Given url baseUrl + '/hello'
  When method GET
  Then status 200
  And match response == { message: 'hello from wiremock' }