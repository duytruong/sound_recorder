#import "SoundRecorderPlugin.h"
#import <audio_recorder2/audio_recorder2-Swift.h>

@implementation SoundRecorderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSoundRecorderPlugin registerWithRegistrar:registrar];
}
@end
