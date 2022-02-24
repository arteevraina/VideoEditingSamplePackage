import 'dart:developer';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/log.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/return_code.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/session.dart';
import 'package:path_provider/path_provider.dart';

class VideoEditing {
  Future<Directory> createDirectory() async {
    final extDirectory = await getExternalStorageDirectory();
    final videoDirectoryPath = "${extDirectory!.path}/Videos";
    return await Directory(videoDirectoryPath).create(recursive: true);
  }

  Future<void> executeCommand(String command) async {
    await FFmpegKit.executeAsync(
      command,
      (Session session) async {
        // Called when session is executed.
        final returnCode = await session.getReturnCode();

        if (ReturnCode.isSuccess(returnCode)) {
          // If everything goes fine. Log success.
          print("success");
        } else if (ReturnCode.isCancel(returnCode)) {
          // TODO: Add a function call for cancelling the execution.
          // If execution has been cancelled. Log cancel.
          log("cancel");
        } else {
          // If there is an error while execution, Log error.
          print("error");
        }
      },
      (Log logs) {
        // This is necessary for printing log while execution.
        print(logs.getMessage());
      },
      (statistics) {
        // TODO: No idea why this callback is there for.
      },
    );
  }

  Future<String> editVideoWithTextOverlay(
      String pathOfVideo, String x, String y, String textToBeOverlayed) async {
    final videoDirectory = await createDirectory();
    // TODO: Add x & y position here.
    // You also need to provide path to font in the system.
    String command =
        '-y -i $pathOfVideo -vf "drawtext=fontfile=/system/fonts/Roboto-Regular.ttf:text=\'$textToBeOverlayed\':x=(w-text_w)/2:y=(h-text_h)/2:fontsize=24:fontcolor=white " -vcodec libx264 -vpre ultrafast -c:a copy ${videoDirectory.path}/output.mp4';

    await executeCommand(command);

    return "${videoDirectory.path}/file.mp4";
  }

  /// X and Y is the number of pixels from the top-left corner of the video
  /// where you want to place the top-left corner of the image.
  Future<void> editVideoWithImageOverlay(
      String pathOfVideo, String pathOfImage, String x, String y) async {
    final videoDirectory = await createDirectory();

    String command =
        '-y -i $pathOfVideo -i $pathOfImage -filter_complex "[0:v][1:v] overlay=20:20" -vcodec libx264 -preset ultrafast -c:a copy -s 852x480 ${videoDirectory.path}/output.mp4';

    await executeCommand(command);
  }

  Future<void> editWithPreset(String pathOfVideo) async {
    final videoDirectory = await createDirectory();
    String command =
        '-y -i $pathOfVideo -vcodec libx264 -preset ultrafast -c:a copy -s 852x480 ${videoDirectory.path}/output.mp4';

    await executeCommand(command);
  }
}
