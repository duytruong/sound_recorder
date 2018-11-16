# audio_recorder2

audio recorder plug-in

This is fork of audio_recorder by ZaraclaJ, please refer https://github.com/ZaraclaJ/audio_recorder for usgae instructions

(why this plugin? : ZaraclaJ seems inactive and I had urgent need to refactor plugin to swift 4.2)

## Usage

// Import package
import 'package:audio_recorder/audio_recorder.dart';

// Check permissions before starting
bool hasPermissions = await AudioRecorder.hasPermissions;

// Get the state of the recorder
bool isRecording = await AudioRecorder.isRecording;

// Start recording
await AudioRecorder.start(path: _controller.text, audioOutputFormat: AudioOutputFormat.AAC);

// Stop recording
Recording recording = await AudioRecorder.stop();
print("Path : ${recording.path},  Format : ${recording.audioOutputFormat},  Duration : ${recording.duration},  Extension : ${recording.extension},");