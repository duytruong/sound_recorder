import Flutter
import UIKit
import AVFoundation

public class SwiftSoundRecorderPlugin: NSObject, FlutterPlugin, AVAudioRecorderDelegate {
    var isRecording = false
    var hasPermissions = false
    var mExtension = ""
    var mPath = ""
    var startTime: Date!
    var audioRecorder: AVAudioRecorder!

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "sound_recorder", binaryMessenger: registrar.messenger())
    let instance = SwiftSoundRecorderPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "start":
            print("start")
            let dic = call.arguments as! [String : Any]
            mExtension = dic["extension"] as? String ?? ""
            mPath = dic["path"] as? String ?? ""
            startTime = Date()
            if mPath == "" {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                mPath = documentsPath + "/" + String(Int(startTime.timeIntervalSince1970)) + ".m4a"
                print("path: " + mPath)
            }
            let settings = [
                AVFormatIDKey: getOutputFormatFromString(mExtension),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            do {
                if #available(iOS 10.0, *) {
                    try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [])
                } else {
                    // Set category with options (iOS 9+) setCategory(_:options:)
                    AVAudioSession.sharedInstance().perform(NSSelectorFromString("setCategory:withOptions:error:"), with: AVAudioSession.Category.playAndRecord, with:  [])
                    
                    // Set category without options (<= iOS 9) setCategory(_:)
                    AVAudioSession.sharedInstance().perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.Category.playAndRecord)
                }
                try AVAudioSession.sharedInstance().setActive(true)

                audioRecorder = try AVAudioRecorder(url: URL(string: mPath)!, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
            } catch {
                print("fail")
                result(FlutterError(code: "", message: "Failed to record", details: nil))
            }
            isRecording = true
            result(nil)
        case "stop":
            print("stop")
            audioRecorder.stop()
            audioRecorder = nil
            let duration = Int(Date().timeIntervalSince(startTime as Date) * 1000)
            isRecording = false
            var recordingResult = [String : Any]()
            recordingResult["duration"] = duration
            recordingResult["path"] = mPath
            recordingResult["audioOutputFormat"] = mExtension
            result(recordingResult)
        case "isRecording":
            print("isRecording")
            result(isRecording)
        case "hasPermissions":
            print("hasPermissions")
            switch AVAudioSession.sharedInstance().recordPermission {
            case AVAudioSession.RecordPermission.granted:
                NSLog("granted")
                hasPermissions = true
                break
            case AVAudioSession.RecordPermission.denied:
                NSLog("denied")
                hasPermissions = false
                break
            case AVAudioSession.RecordPermission.undetermined:
                NSLog("undetermined")
                AVAudioSession.sharedInstance().requestRecordPermission() { [unowned self] allowed in
                    DispatchQueue.main.async {
                        if allowed {
                            self.hasPermissions = true
                        } else {
                            self.hasPermissions = false
                        }
                    }
                }
                break
            default:
                break
            }
            result(hasPermissions)
        default:
            result(FlutterMethodNotImplemented)
        }
      }

        func getOutputFormatFromString(_ format : String) -> Int {
            switch format {
            case ".mp4", ".aac", ".m4a":
                return Int(kAudioFormatMPEG4AAC)
            default :
                return Int(kAudioFormatMPEG4AAC)
            }
        }
    }

