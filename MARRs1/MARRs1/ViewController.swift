//
//  ViewController.swift
//  mars2
//
//  Created by Mike Veson on 5/11/21.

    import UIKit
    import youtube_ios_player_helper
    import InstantSearchVoiceOverlay
    import AVFoundation
    import GoogleAPIClientForREST
    import GoogleSignIn
    import RMYouTubeExtractor
    import RAMAnimatedTabBarController

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
    @IBOutlet var button1: UIButton!
    @IBOutlet weak var tblVideos: UITableView!
    @IBOutlet weak var segDisplayedContent: UISegmentedControl!
    @IBOutlet weak var viewWait: UIView!
        @IBOutlet weak var txtSearch: UITextField!
    
    override func viewDidLoad(){
        super.viewDidLoad()
//        playerView.delegate = self
        button1.roundCorners()
//        playerView.load(withVideoId: "1InIKzeGKtY", playerVars: ["playsinline" : 1])
    }
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
    // did press button method for tab bar
    @IBAction func didPressButton(){
        let tabBarVC = CustomTabBarController()
        present(tabBarVC, animated: true)
    }
    
    // did press button method for audio
    @IBAction func didTapButton(){
        voiceOverlay.delegate = self
        voiceOverlay.settings.autoStart=false
        voiceOverlay.settings.autoStop=true
        voiceOverlay.settings.autoStopTimeout=2
        voiceOverlay.start(on: self, textHandler: { text, final, _ in
            if final {
                print("Final text: \(text)")
                let userWords = "\(text)"
                self.playerView.load(withVideoId: "_S7r9MCc2ts", playerVars: ["playsinline" : 1])
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
class CustomTabBarController: RAMAnimatedTabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    func configure() {
        let vc1 = UIViewController()
        let vc2 = UIViewController()
        let vc3 = UIViewController()
        let vc4 = UIViewController()
        let vc5 = UIViewController()
        
        vc1.view.backgroundColor = .init(red: 18/255.0, green: 190/255.0, blue: 93/255.0, alpha: 1.0)
        vc2.view.backgroundColor = .init(red: 234/255.0, green: 202/255.0, blue: 46/255.0, alpha: 1.0)
        vc3.view.backgroundColor = .systemRed
        vc4.view.backgroundColor = .init(red: 86/255.0, green: 158/255.0, blue: 250/255.0, alpha: 1.0)
        vc5.view.backgroundColor = .green
        
        vc1.tabBarItem = RAMAnimatedTabBarItem(title: "Stocks", image: UIImage(systemName: "chart.bar.xaxis" ), tag: 1)
        (vc1.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMBounceAnimation()
        
        vc2.tabBarItem = RAMAnimatedTabBarItem(title: "Crypto", image: UIImage(systemName: "bitcoinsign.circle" ), tag: 1)
        (vc2.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMRotationAnimation()
        
        vc3.tabBarItem = RAMAnimatedTabBarItem(title: "News", image: UIImage(systemName: "newspaper" ), tag: 1)
        (vc3.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMBounceAnimation()
        
        vc4.tabBarItem = RAMAnimatedTabBarItem(title: "Weather", image: UIImage(systemName: "cloud" ), tag: 1)
        (vc4.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMBounceAnimation()

        vc5.tabBarItem = RAMAnimatedTabBarItem(title: "Music", image: UIImage(systemName: "music.note" ), tag: 1)
        (vc5.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMBounceAnimation()

        setViewControllers([vc1, vc2, vc3, vc4, vc5], animated: false)
        
    }
}
public extension UIView {
  //Round the corners
  func roundCorners(){
    let radius = bounds.maxX / 16
    layer.cornerRadius = radius
  }
}
