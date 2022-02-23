import 'dart:developer';
import 'package:example/video_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_editing_test/flutter_video_editing_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late XFile? video;

  final picker = ImagePicker();

  final videoEditing = VideoEditing();

  late XFile? imageForOverlay;

  @override
  void initState() {
    super.initState();
    grantPermission();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              imageForOverlay =
                  await picker.pickImage(source: ImageSource.gallery);
              log(imageForOverlay!.path.toString());
            },
            child: const Text('Select Image for Overlay'),
          ),
        ),
        floatingActionButton: IconButton(
          color: Colors.blue,
          icon: const Icon(Icons.add),
          onPressed: () async {
            video = await picker.pickVideo(source: ImageSource.gallery);
            // final outputPath = await videoEditing.editVideoWithTextOverlay(
            //     video!.path.toString(), "0", "0", "ArteevRaina");
            // videoEditing.editVideosWithImage(
            //     video!.path.toString(), imageForOverlay!.path.toString());
            // log(video!.path.toString());
            // log(outputPath);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => VideoPage(
            //       path: outputPath,
            //     ),
            //   ),
            // );
            await videoEditing.editWithPreset(video!.path);
            // await videoEditing.editVideoWithImageOverlay(
            //   video!.path,
            //   imageForOverlay!.path,
            //   "0",
            //   "0",
            // );
          },
        ),
      ),
    );
  }

  void grantPermission() async {
    await Permission.storage.request();
  }
}
