import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

const BASE_REST_PATH = "https://23.83.246.26:7325";

class RestApi {
  Future<Map> login({email: String, password: String}) async {
    // var _client = new HttpClient();
    // _client.badCertificateCallback =
    //     (X509Certificate cert, String host, int port) => true;

    // var response = await _client
    //     .getUrl(Uri.parse(
    //         "https://23.83.246.26:7325/token?email=$email&password=$password"))
    //     .then((req) {
    //   req.headers.set("Accept", "application/json");
    //   return req.close();
    // }, onError: (e) {
    //   print("$e");
    // });

    // var completer = new Completer<String>();
    // var contents = new StringBuffer();

    // response.transform(utf8.decoder).listen((String data) {
    //   contents.write(data);
    // }, onDone: () {
    //   completer.complete(contents.toString());
    // });

    // return completer.future
    //     .then(json.decode)
    //     .then((j) {
    //   if (j["result"] == 0) {
    //     return j["data"];
    //   } else {
    //     throw new Exception(j["msg"]);
    //   }
    // });

    var url = "$BASE_REST_PATH/token?email=$email&password=$password";

    return get(url).then((j) {
      if (j["result"] == 0) {
        return j["data"];
      } else {
        throw new Exception(j["msg"]);
      }
    });
  }

  static Future get(String url) async {
    var _client = new HttpClient();
    _client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    var response = await _client.getUrl(Uri.parse(url)).then((req) {
      req.headers.set("Accept", "application/json");
      return req.close();
    }, onError: (e) {
      print("$e");
    });

    var completer = new Completer<String>();
    var contents = new StringBuffer();

    response.transform(utf8.decoder).listen((String data) {
      contents.write(data);
    }, onDone: () {
      completer.complete(contents.toString());
    });

    return completer.future.then(json.decode);
  }
}
