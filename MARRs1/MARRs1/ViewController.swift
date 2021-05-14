//
//  ViewController.swift
//  mars2
//
//  Created by Mike Veson on 5/11/21.
//
import UIKit
import youtube_ios_player_helper
import InstantSearchVoiceOverlay

class ViewController: UIViewController, VoiceOverlayDelegate, YTPlayerViewDelegate {
    let voiceOverlay = VoiceOverlayController()
    @IBOutlet var playerView: YTPlayerView!
    @IBOutlet var button: UIButton!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        playerView.delegate = self
        playerView.load(withVideoId: "1InIKzeGKtY", playerVars: ["playsinline" : 1])
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
    }
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
    @IBAction func didTapButton(){
        voiceOverlay.delegate = self
        voiceOverlay.settings.autoStart=false
        voiceOverlay.settings.autoStop=true
        voiceOverlay.settings.autoStopTimeout=5
        voiceOverlay.start(on: self, textHandler: { text, final, _ in
            if final {
                print("Final text: \(text)")
                let userFrases = "\(text)"
                
                self.playerView.load(withVideoId: "oKtrHy0ERNA", playerVars: ["playsinline" : 1])
            }
                
        }, errorHandler: { error in
            
        })
    }
    func recording(text: String?, final: Bool?, error: Error?) {
    }
}
