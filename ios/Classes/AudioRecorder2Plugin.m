#import "AudioRecorder2Plugin.h"
#import <audio_recorder2/audio_recorder2-Swift.h>

@implementation AudioRecorder2Plugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAudioRecorder2Plugin registerWithRegistrar:registrar];
}
@end
