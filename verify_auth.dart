import 'dart:developer';
import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  try {
    final response = await dio.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyD6dIlZN2rRJTJ-CNHbyMg-IXsJ5N2jTVI',
      data: {'email': 'test@example.com', 'password': 'testpassword123', 'returnSecureToken': true},
    );
    log(response.data.toString());
  } on DioException catch (e) {
    log(e.response?.data.toString() ?? e.toString());
  }
}
