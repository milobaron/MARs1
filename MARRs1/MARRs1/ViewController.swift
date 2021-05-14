//
//  ViewController.swift
//  mars2
//
//  Created by Mike Veson on 5/11/21.
//
    import UIKit
    import youtube_ios_player_helper
    import InstantSearchVoiceOverlay
    import AVFoundation
    import GoogleAPIClientForREST
    import GoogleSignIn
    import RMYouTubeExtractor

class ViewController: UIViewController, VoiceOverlayDelegate, YTPlayerViewDelegate, GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    }
    
    func recording(text: String?, final: Bool?, error: Error?) {
    }
    
    var videosArray: Array<Dictionary<NSObject, AnyObject>> = []
   
    var apiKey = "AIzaSyDyomRq-6lS5Y9a0j6LLx6pH_8h_YboWt8"
     
    var desiredChannelsArray = ["Apple", "Google", "Microsoft"]
     
    var channelIndex = 0
     
    var channelsDataArray: Array<Dictionary<NSObject, AnyObject>> = []

    let voiceOverlay = VoiceOverlayController()
    @IBOutlet var playerView: YTPlayerView!
    @IBOutlet var button: UIButton!
    @IBOutlet weak var tblVideos: UITableView!
    @IBOutlet weak var segDisplayedContent: UISegmentedControl!
    @IBOutlet weak var viewWait: UIView!
        @IBOutlet weak var txtSearch: UITextField!
    
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
                let userWords = "\(text)"
                // _S7r9MCc2ts
//                let vidId = self.searchByKeyword(s: userWords)
                self.playerView.load(withVideoId: userWords, playerVars: ["playsinline" : 1])
            }
                
        }, errorHandler: { error in
            
        })
    }
//    func searchByKeyword(s: String) -> String {
//        var results = YouTube.Search.list("id,snippet", {q; s; maxResults; 25})
//        var item = results.items[0]
//        var id = item.id.videoId
//        return item.id.videoId
//        }
    }

