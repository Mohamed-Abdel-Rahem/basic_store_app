class Constants {
  Constants._();
  // for auth api In local
  static const String authBaseUrl = 'http://192.168.1.3:3000';
  static const String loginEndPoint = '/auth/login';
  static const String registerEndPoint = '/auth/signup';
  // for weather api
  static const String weatherUrl = 'https://api.openweathermap.org/data/2.5/';
  static const String weatherEndPoint = 'weather';
  static const apiKey = 'd5600cf96e0852733bddc5fa3aeac070';
  static const String imageUrl = 'https://openweathermap.org/img/wn/';
  static const String lastImageSegment = '@2x.png';
}
