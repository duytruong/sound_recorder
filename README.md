# audio_recorder2

audio recorder plug-in

This is fork of audio_recorder by ZaraclaJ, please refer https://github.com/ZaraclaJ/audio_recorder for usgae instructions

(why this plugin? : ZaraclaJ seems inactive and I had urgent need to refactor plugin to swift 4.2)

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