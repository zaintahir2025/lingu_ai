import 'dart:io';

void main() async {
  final url = 'https://translate.google.com/translate_tts?ie=UTF-8&tl=es-ES&client=tw-ob&q=Hola';
  final client = HttpClient();
  final request = await client.getUrl(Uri.parse(url));
  final response = await request.close();
  print('Status: ${response.statusCode}');
}
