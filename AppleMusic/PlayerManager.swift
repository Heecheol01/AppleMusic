import Foundation
import AVFoundation

extension Notification.Name {
    static let playerDidStartPlaying = Notification.Name("PlayerManager.playerDidStartPlaying")
    static let playerDidPause = Notification.Name("PlayerManager.playerDidPause")
    static let playerDidStop = Notification.Name("PlayerManager.playerDidStop")
    static let miniPlayerMetadataUpdate = Notification.Name("MiniPlayer.metadataUpdate")
}

final class PlayerManager {
    static let shared = PlayerManager()

    private let player: AVPlayer = AVPlayer()
    private var lastURL: URL?

    private init() {}

    var isPlaying: Bool = false

    private func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            print("Audio session configuration failed: \(error)")
        }
    }

    func play(url: URL) {
        configureAudioSession()
        lastURL = url
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        player.play()
        isPlaying = true
        NotificationCenter.default.post(name: .playerDidStartPlaying, object: nil)
    }

    func pause() {
        player.pause()
        isPlaying = false
        NotificationCenter.default.post(name: .playerDidPause, object: nil)
    }
    
    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            if player.currentItem != nil {
                player.play()
                isPlaying = true
                NotificationCenter.default.post(name: .playerDidStartPlaying, object: nil)
            } else if let url = lastURL {
                play(url: url)
            }
        }
    }
}
