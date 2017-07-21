import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_proxy/shelf_proxy.dart';
import 'package:shelf/src/message.dart' show getBody;

main() async {
  _startPubServe();
  var server = await serve(handler, 'localhost', 9080);
  print('Proxying at http://${server.address.host}:${server.port}');
}

handler(Request request) {
  // redirects all the `api` calls to the third party server
//  print('request.url.path: ${request.url.path}');
  if (request.url.path.startsWith('api')) {
//    print('proxying to: http://localhost:3333/api');
    return proxyHandler('http://localhost:3333/api')(request);
  }

  // redirects all files to default `pub serve` path
  var handler = proxyHandler('http://localhost:8080');
  if (new RegExp(r'\.(css|dart|html|png|ttf|otf|TTF|js)$').hasMatch(request.url.path)) {
//    print('proxyiing to: http://localhost:8080');
    return handler(request);
  }

  // redirect all the routes to `index.html`
//  print('proxying to: http://localhost:8080/index.html');
  return handler(new Request(
      request.method,
      Uri.parse('http://localhost:8080/index.html'),
      protocolVersion: request.protocolVersion,
      headers: request.headers,
      handlerPath: request.handlerPath,
      body: getBody(request),
      encoding: request.encoding,
      context: request.context));
}

// starts `pub serve` when running this server
_startPubServe() async {
  String executable = Platform.isWindows ? 'pub.bat' : 'pub';
  var process = await Process.start(executable, ['serve', '--port', '8080']);
  process.stdout.transform(UTF8.decoder).listen(print);
}