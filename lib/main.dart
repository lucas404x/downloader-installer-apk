import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'download.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APK Downloader & Installer Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'APK Downloader & Installer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double progress = 0.0;
  void onProgressChanged(int receivedLength, int contentLength) {
    setState(() {
      progress = receivedLength / contentLength;
      print(progress);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: CircularProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Directory tmpDir = await getTemporaryDirectory();
          File appFile = File('${tmpDir.path}/app.apk');

          if (await appFile.exists()) {
            await appFile.delete();
          }

          IOSink out = appFile.openWrite();

          invokeApkDownloader(
            onProgressChanged,
            onBytesReceived: (chunk) {
              // print(chunk);
              out.add(chunk);
            },
            onDone: () async {
              out.close();
              await OpenFile.open(appFile.path);
            },
          );
        },
        tooltip: 'Download',
        child: const Icon(Icons.download),
      ),
    );
  }
}


// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: FutureBuilder<ByteStream>(
//           future: downloadApk(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.done) {
//               int received = 0;
//               int length = snapshot.data!.contentLength!;

//               return StreamBuilder<List<int>>(
//                 stream: snapshot.data!,
//                 builder: (context, streamSnapshot) {
//                   received += streamSnapshot.data?.length ?? 0;
//                   var result = (received / length);
//                   print((result * 100).toStringAsFixed(2));
//                   return CircularProgressIndicator(value: result);
//                   // return Text(((received / length) * 100).toStringAsFixed(2));
//                 },
//               );
//             }

//             return const CircularProgressIndicator();
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           // // Directory tmpDir = await getTemporaryDirectory();
//           // // print(tmpDir.path);
//           // var result = await downloadApk();
//           // print('fromBtn: ${result.contentLength}');
//         },
//         tooltip: 'Download',
//         child: const Icon(Icons.download),
//       ),
//     );
//   }
// }
