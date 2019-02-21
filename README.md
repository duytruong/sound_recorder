# sound_recorder

A Flutter sound recorder plugin. This is a fork of [audio_recorder2](https://github.com/Apurv2017/audioRecorder2) (and audio_recorder2 is a fork of [audio_recorder](https://github.com/ZaraclaJ/audio_recorder)), please refer https://github.com/ZaraclaJ/audio_recorder for usage instructions

This fork add more supported audio output formats.

## Usage

```
// Import package
import 'package:audio_recorder2/audio_recorder2.dart';

// Check permissions before starting
bool hasPermissions = await AudioRecorder2.hasPermissions;

// Get the state of the recorder
bool isRecording = await AudioRecorder2.isRecording;

// Start recording
await AudioRecorder2.start(path: _controller.text, audioOutputFormat: AudioOutputFormat.AAC);

// Stop recording
Recording recording = await AudioRecorder2.stop();
print("Path : ${recording.path},  Format : ${recording.audioOutputFormat},  Duration : ${recording.duration},  Extension : ${recording.extension},");
```