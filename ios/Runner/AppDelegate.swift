import UIKit
import Flutter
import AVFoundation
import MediaPlayer

@main
@objc class AppDelegate: FlutterAppDelegate {
    private var nowPlayingChannel: FlutterMethodChannel?
    private var nowPlayingInfo: [String: Any] = [:]
    private var currentArtworkURL: String?
    private var remoteCommandsConfigured = false
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        GeneratedPluginRegistrant.register(with: self)
        
        // 获取 FlutterViewController
        if let controller = window?.rootViewController as? FlutterViewController {
            let clipboardChannel = FlutterMethodChannel(
                name: "app.clipboard",
                binaryMessenger: controller.binaryMessenger
            )
            
            clipboardChannel.setMethodCallHandler { [weak self] (call, result) in
                if call.method == "copyImage" {
                    if let args = call.arguments as? [String: Any],
                       let imageData = args["imageData"] as? FlutterStandardTypedData {
                        self?.copyImageToClipboard(data: imageData.data)
                        result("success")
                    } else {
                        result(FlutterError(code: "INVALID_ARGUMENT", message: "No image data provided", details: nil))
                    }
                } else {
                    result(FlutterMethodNotImplemented)
                }
            }

            nowPlayingChannel = FlutterMethodChannel(
                name: "app.now_playing",
                binaryMessenger: controller.binaryMessenger
            )
            nowPlayingChannel?.setMethodCallHandler { [weak self] (call, result) in
                self?.handleNowPlayingCall(call, result: result)
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func copyImageToClipboard(data: Data) {
        if let image = UIImage(data: data) {
            UIPasteboard.general.image = image
        }
    }

    private func handleNowPlayingCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "configure":
            configureAudioSession()
            configureRemoteCommands()
            result(nil)
        case "update":
            configureAudioSession()
            configureRemoteCommands()
            updateNowPlayingInfo(call.arguments as? [String: Any] ?? [:])
            result(nil)
        case "updatePlayback":
            updatePlaybackInfo(call.arguments as? [String: Any] ?? [:])
            result(nil)
        case "clear":
            clearNowPlayingInfo()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .moviePlayback, options: [.allowAirPlay])
            try session.setActive(true)
            UIApplication.shared.beginReceivingRemoteControlEvents()
        } catch {
            NSLog("Failed to configure audio session: \(error)")
        }
    }

    private func configureRemoteCommands() {
        guard !remoteCommandsConfigured else { return }
        remoteCommandsConfigured = true

        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.skipForwardCommand.isEnabled = true
        commandCenter.skipBackwardCommand.isEnabled = true
        commandCenter.skipForwardCommand.preferredIntervals = [NSNumber(value: 15)]
        commandCenter.skipBackwardCommand.preferredIntervals = [NSNumber(value: 15)]

        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.nowPlayingChannel?.invokeMethod("play", arguments: nil)
            return .success
        }
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.nowPlayingChannel?.invokeMethod("pause", arguments: nil)
            return .success
        }
        commandCenter.togglePlayPauseCommand.addTarget { [weak self] _ in
            self?.nowPlayingChannel?.invokeMethod("togglePlayPause", arguments: nil)
            return .success
        }
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let positionEvent = event as? MPChangePlaybackPositionCommandEvent else {
                return .commandFailed
            }
            self?.nowPlayingChannel?.invokeMethod(
                "seekTo",
                arguments: ["position": positionEvent.positionTime]
            )
            return .success
        }
        commandCenter.skipForwardCommand.addTarget { [weak self] event in
            let interval = (event as? MPSkipIntervalCommandEvent)?.interval ?? 15
            self?.nowPlayingChannel?.invokeMethod("skip", arguments: ["offset": interval])
            return .success
        }
        commandCenter.skipBackwardCommand.addTarget { [weak self] event in
            let interval = (event as? MPSkipIntervalCommandEvent)?.interval ?? 15
            self?.nowPlayingChannel?.invokeMethod("skip", arguments: ["offset": -interval])
            return .success
        }
    }

    private func updateNowPlayingInfo(_ args: [String: Any]) {
        if let title = args["title"] as? String, !title.isEmpty {
            nowPlayingInfo[MPMediaItemPropertyTitle] = title
        }
        if let artist = args["artist"] as? String, !artist.isEmpty {
            nowPlayingInfo[MPMediaItemPropertyArtist] = artist
        }

        let duration = doubleValue(args["duration"])
        if duration > 0 {
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        } else {
            nowPlayingInfo.removeValue(forKey: MPMediaItemPropertyPlaybackDuration)
        }
        nowPlayingInfo[MPNowPlayingInfoPropertyMediaType] = MPNowPlayingInfoMediaType.video.rawValue
        applyPlaybackValues(args)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        updateArtwork(args["artworkUrl"] as? String)
    }

    private func updatePlaybackInfo(_ args: [String: Any]) {
        let duration = doubleValue(args["duration"])
        if duration > 0 {
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        }
        applyPlaybackValues(args)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    private func applyPlaybackValues(_ args: [String: Any]) {
        let position = max(0, doubleValue(args["position"]))
        let isPlaying = boolValue(args["isPlaying"])
        let playbackRate = doubleValue(args["playbackRate"])

        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = position
        nowPlayingInfo[MPNowPlayingInfoPropertyDefaultPlaybackRate] = 1.0
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? (playbackRate > 0 ? playbackRate : 1.0) : 0.0

        if #available(iOS 13.0, *) {
            MPNowPlayingInfoCenter.default().playbackState = isPlaying ? .playing : .paused
        }
    }

    private func updateArtwork(_ artworkURL: String?) {
        guard let artworkURL = artworkURL, !artworkURL.isEmpty else {
            currentArtworkURL = nil
            nowPlayingInfo.removeValue(forKey: MPMediaItemPropertyArtwork)
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            return
        }
        guard artworkURL != currentArtworkURL else { return }
        currentArtworkURL = artworkURL

        let normalizedURL = artworkURL.hasPrefix("//") ? "https:\(artworkURL)" : artworkURL
        guard let url = URL(string: normalizedURL) else { return }
        var request = URLRequest(url: url)
        request.setValue(
            "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148",
            forHTTPHeaderField: "User-Agent"
        )
        request.setValue("https://www.bilibili.com", forHTTPHeaderField: "Referer")

        URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
            guard
                let self = self,
                self.currentArtworkURL == artworkURL,
                let data,
                let image = UIImage(data: data)
            else {
                return
            }

            DispatchQueue.main.async {
                let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in
                    return image
                }
                self.nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
                MPNowPlayingInfoCenter.default().nowPlayingInfo = self.nowPlayingInfo
            }
        }.resume()
    }

    private func clearNowPlayingInfo() {
        currentArtworkURL = nil
        nowPlayingInfo.removeAll()
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        if #available(iOS 13.0, *) {
            MPNowPlayingInfoCenter.default().playbackState = .stopped
        }
    }

    private func doubleValue(_ value: Any?) -> Double {
        if let value = value as? Double {
            return value
        }
        if let value = value as? Int {
            return Double(value)
        }
        if let value = value as? NSNumber {
            return value.doubleValue
        }
        if let value = value as? String {
            return Double(value) ?? 0
        }
        return 0
    }

    private func boolValue(_ value: Any?) -> Bool {
        if let value = value as? Bool {
            return value
        }
        if let value = value as? NSNumber {
            return value.boolValue
        }
        if let value = value as? String {
            return value == "true" || value == "1"
        }
        return false
    }
}
