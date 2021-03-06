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
import SafariServices
import CoreLocation


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
}




class CustomTabBarController: RAMAnimatedTabBarController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UISearchBarDelegate {
    private let newsTableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
        
    }()
    private let newsSearchVC = UISearchController(searchResultsController: nil)
    
    private var articles = [Article]()
    private var cryptoViewModels = [CryptoTableViewCellViewModel]()
    private var newsViewModels = [NewsTableViewCellViewModel]()
    var weatherViewModels = [DailyWeatherEntry]()

    private let weatherTableView: UITableView = {
        let table = UITableView()
        table.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
        table.register(HourlyTableViewCell.self, forCellReuseIdentifier: HourlyTableViewCell.identifier)
        return table
        
    }()
    
    //Location stuff
    let locationManager=CLLocationManager()
    var currentLocation: CLLocation?
    
    func setupLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty,currentLocation == nil{
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation(){
        guard let currentLocation = currentLocation else{
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        //add in stuff with url here
        
        //Validation
        
        //Convert data to models/some object
        
        //update use interface
        
        print ("\(long) | \(lat)")
    }
    //end location stuff
    
    let vc1 = UIViewController() // stocks
    let vc2 = UIViewController() // crypto
    let vc3 = UIViewController() // news
    let vc4 = UIViewController() // weather
    let vc5 = UIViewController() // music
    
    private let cryptoTableView: UITableView = {
        let cryptoTableView = UITableView(frame: .zero, style: .grouped)
        cryptoTableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: CryptoTableViewCell.identifier)
        return cryptoTableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureVC2()
        configureVC3()
        configureVC4()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.newsTableView{
            return newsViewModels.count
        }
        if tableView == self.cryptoTableView {
            return cryptoViewModels.count
        }
        if tableView == self.weatherTableView {
            return weatherViewModels.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.newsTableView{
            tableView.deselectRow(at: indexPath, animated: true)
            let article = articles[indexPath.row]
            
            guard let url = URL(string: article.url ?? "") else {
                return
            }
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.newsTableView{
            return 150
        }
        if tableView == self.cryptoTableView {
            return 70
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.newsTableView{
            guard let cell = newsTableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier,
                                                               for: indexPath
            ) as? NewsTableViewCell else {
                fatalError() 
            }
            cell.newsConfigure(with: newsViewModels[indexPath.row])
            return NewsTableViewCell()
        }
        if tableView == self.cryptoTableView {
            guard let cell = cryptoTableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifier, for: indexPath) as? CryptoTableViewCell else {
                fatalError()
            }
            cell.configure(with: cryptoViewModels[indexPath.row])
            return cell
        }
        if tableView == self.weatherTableView {
            let cell=tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
            cell.configure(with: weatherViewModels[indexPath.row])
            return cell
        }
        if tableView == self.newsTableView {
            return UITableViewCell()
        }
        if tableView == self.weatherTableView{
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cryptoTableView.frame = vc2.view.bounds
        newsTableView.frame = vc3.view.bounds
    }
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.allowsFloats = true
        formatter.formatterBehavior = .default
        formatter.numberStyle = .currency
        return formatter
    }()
    func createSearchBar(){
        vc3.navigationItem.searchController = newsSearchVC
        newsSearchVC.searchBar.delegate = self
        
    }
    func configureVC4(){
 //       weatherTableView.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
 //       weatherTableView.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
    }
    func configureVC3(){
        vc3.view.addSubview(newsTableView)
        NewsAPICaller.shared.getTopStories { [weak self] result in
            switch result {
            
            case .success (let articles):
                self?.articles = articles
                print("NEWS working so far")
                self?.newsViewModels = articles.compactMap ({
                    NewsTableViewCellViewModel(title: $0.title, subtitle: $0.description ?? "No Description", imageURL: URL(string: $0.urlToImage ?? ""))
                })
                
                DispatchQueue.main.async {
                    self?.newsTableView.reloadData()
                }
            case .failure(let error):
                print("NEWS RED ALERT MF \(error)")
            }
        }
        createSearchBar()
    }
    
    func configureVC2() {
        vc2.view.addSubview(cryptoTableView)
        APICaller.shared.getAllCryptoData{ [weak self] result in
            switch result {
            case .success(let models):
                print ("crypto works so far")
                self?.cryptoViewModels = models.compactMap({
                    var price = $0.price_usd ?? 0
                    if (price>70000){
                        print("greater than 1 mil")
                        price=0
                    }
                    let formatter = CustomTabBarController.numberFormatter
                    let priceString = formatter.string(from: NSNumber(value: price))
                    return CryptoTableViewCellViewModel(name: $0.name ?? "N/A", symbol: $0.asset_id, price: priceString ?? "N/A"
                    )
                })
                DispatchQueue.main.async {
                    self?.cryptoTableView.reloadData()
                }
            case .failure(let error):
                print("CRYPTO RED ALERT MF \(error)")
            }
        }
    }
    func configure() {
        vc1.view.backgroundColor = .init(red: 18/255.0, green: 190/255.0, blue: 93/255.0, alpha: 1.0)
        vc2.view.backgroundColor = .init(red: 234/255.0, green: 202/255.0, blue: 46/255.0, alpha: 1.0)
        vc3.view.backgroundColor = .systemBackground
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
        cryptoTableView.dataSource = self
        cryptoTableView.delegate = self
        // vc3 info
        newsTableView.dataSource = self
        newsTableView.delegate = self
        // vc4 info
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        // vc5 info
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        print(text)
    }
}
public extension UIView {
    //Round the corners
    func roundCorners(){
        let radius = bounds.maxX / 16
        layer.cornerRadius = radius
    }
    
}

//around 20 min mark in video
//basically just go in and create a bunch of struct objects that align with the arguments in the api
//currently, hourly, and daily types - each have a bunch of stuff, see 20-22 min on video
struct WeatherResponse: Codable {
    let currently: CurrentWeather
    let hourly: HourlyWeather
    let daily: DailyWeather
}
struct CurrentWeather: Codable {
    
}
struct DailyWeather: Codable {
    let data: [DailyWeatherEntry]
    //have array of data
}
struct DailyWeatherEntry: Codable {
    
}
struct HourlyWeather: Codable {
    //have array of data
}
struct HourlyWeatherEntry: Codable {
    
}
