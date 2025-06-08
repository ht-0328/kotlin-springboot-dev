function fn() {
  var env = karate.env; // 例: wiremock, dev など
  karate.log('karate.env =', env);

  var config = {};

  if (env == 'dev') {
    config.baseUrl = 'http://localhost:8080';
  } else if (env == 'wiremock') {
    config.baseUrl = 'http://wiremock:8080';
  } else {
    karate.log('⚠️ 未知の環境です。baseUrlを dev に設定します。');
    config.baseUrl = 'http://localhost:8082';
  }

  return config;
}
