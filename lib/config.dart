const apiUrl =
    'http://192.168.50.208:8080/api/v1'; //'http://192.168.50.208:8080/api/v1'; // https://priorli.oa.r.appspot.com/api/v1

abstract class Config {
  // ignore: constant_identifier_names
  static const String API_URL = String.fromEnvironment(
    'API_URL',
    defaultValue: '',
  );
}
