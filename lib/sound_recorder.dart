import 'dart:async';
import 'dart:io';

import 'package:file/local.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

class SoundRecorder {
  static const MethodChannel _channel = const MethodChannel('sound_recorder');

  /// use [LocalFileSystem] to permit widget testing
  static LocalFileSystem fs = LocalFileSystem();

  static Future start(
      {String path, AudioOutputFormat audioOutputFormat}) async {
    String extension;
    if (path != null) {
      if (audioOutputFormat != null) {
        if (convertStringToAudioOutputFormat(p.extension(path)) !=
            audioOutputFormat) {
          extension = convertAudioOutputFormatToString(audioOutputFormat);
          path += extension;
        } else {
          extension = p.extension(path);
        }
      } else {
        if (isAudioOutputFormat(p.extension(path))) {
          extension = p.extension(path);
        } else {
          extension = ".m4a"; // default value
          path += extension;
        }
      }
      File file = fs.file(path);
      if (await file.exists()) {
        throw new Exception("A file already exists at the path :" + path);
      } else if (!await file.parent.exists()) {
        throw new Exception("The specified parent directory does not exist");
      }
    } else {
      extension = ".m4a"; // default value
    }
    return _channel
        .invokeMethod('start', {"path": path, "extension": extension});
  }

  static Future<Recording> stop() async {
    Map<String, Object> response =
    Map.from(await _channel.invokeMethod('stop'));
    Recording recording = new Recording(
        duration: new Duration(milliseconds: response['duration']),
        path: response['path'],
        audioOutputFormat:
        convertStringToAudioOutputFormat(response['audioOutputFormat']),
        extension: response['audioOutputFormat']);
    return recording;
  }

  static Future<bool> get isRecording async {
    bool isRecording = await _channel.invokeMethod('isRecording');
    return isRecording;
  }

  static Future<bool> get hasPermissions async {
    bool hasPermission = await _channel.invokeMethod('hasPermissions');
    return hasPermission;
  }

  static AudioOutputFormat convertStringToAudioOutputFormat(String extension) {
    switch (extension) {
      case ".mp4":
      case ".aac":
      case ".m4a":
        return AudioOutputFormat.AAC;
      case ".awb":
        return AudioOutputFormat.AMR_WB;
      default:
        return null;
    }
  }

  static bool isAudioOutputFormat(String extension) {
    switch (extension) {
      case ".mp4":
      case ".aac":
      case ".m4a":
      case ".awb":
        return true;
      default:
        return false;
    }
  }

  static String convertAudioOutputFormatToString(
      AudioOutputFormat outputFormat) {
    switch (outputFormat) {
      case AudioOutputFormat.AAC:
        return ".m4a";
      case AudioOutputFormat.AMR_WB:
        return ".awb";
      default:
        return ".m4a";
    }
  }
}

enum AudioOutputFormat {
  AAC,
  AMR_WB
}

class Recording {
  // File path
  String path;
  // File extension
  String extension;
  // Audio duration in milliseconds
  Duration duration;
  // Audio output format
  AudioOutputFormat audioOutputFormat;

  Recording({this.duration, this.path, this.audioOutputFormat, this.extension});
}
