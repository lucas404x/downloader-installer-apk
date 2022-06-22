import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

const urlDownload = '';

invokeApkDownloader(
  void Function(int receivedLength, int contentLength) onProgressChanged, {
  void Function(List<int> chunk)? onBytesReceived,
  VoidCallback? onDone,
}) async {
  final client = Client();
  final response = await client.send(Request("GET", Uri.parse(urlDownload)));
  var contentLength = response.contentLength!;
  var receivedLength = 0;

  response.stream.listen((chunk) {
    receivedLength += chunk.length;
    onProgressChanged(receivedLength, contentLength);
    onBytesReceived?.call(chunk);
  }).onDone(() {
    client.close();
    onDone?.call();
  });
}
