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
        button1.roundCorners()
       
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
    class CustomTabBarController: RAMAnimatedTabBarController, UITableViewDelegate, UITableViewDataSource  {
        let vc1 = UIViewController()
        let vc2 = UIViewController()
        let vc3 = UIViewController()
        let vc4 = UIViewController()
        let vc5 = UIViewController()
        
        override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: CryptoTableViewCell.identifier)
        return tableView
    }()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = vc2.view.bounds
    }
        @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
        @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifier, for: indexPath) as? CryptoTableViewCell else {
            fatalError()
        }
        cell.textLabel?.text = "Hello World"
        return cell
    }
    func configure() {
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
        
        
        // vc1 info
        
        
        // vc2 info
        tableView.dataSource = self
        tableView.delegate = self
        
        // vc3 info
        vc3.title = "News"
        // vc4 info
        
        // vc5 info
    }
}
public extension UIView {
  //Round the corners
  func roundCorners(){
    let radius = bounds.maxX / 16
    layer.cornerRadius = radius
  }
}
