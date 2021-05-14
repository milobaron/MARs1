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
import RMYouTubeExtractor

class ViewController: UIViewController, VoiceOverlayDelegate, YTPlayerViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
                let vidId = self.searchByKeyword(s: userWords)
                self.playerView.load(withVideoId: vidId, playerVars: ["playsinline" : 1])
            }
                
        }, errorHandler: { error in
            
        })
    }
    func searchByKeyword(s: String) {
        var results = YouTube.Search.list("id,snippet", {q; s; maxResults; 25})
        var item = results.items[0]
        var id = item.id.videoId
        return id
        }
    }
    

//
//    func performGetRequest(targetURL: NSURL!, completion: ((data: NSData?, HTTPStatusCode: Int, error: NSError?)) -> Void) {
//        let request = NSMutableURLRequest(URL: "www.google.com")
//        request.HTTPMethod = "GET"
//
//        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
//
//        let session = NSURLSession(configuration: sessionConfiguration)
//
//        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                completion(data: data, HTTPStatusCode: (response as! NSHTTPURLResponse).statusCode, error: error)
//            })
//        })
//
//        task.resume()
//    }
//
//
//    func getChannelDetails(useChannelIDParam: Bool) {
//
//        performGetRequest(targetURL, completion: { (data, HTTPStatusCode, error) -> Void in
//            if HTTPStatusCode == 200 && error == nil {
//                // Convert the JSON data to a dictionary.
//                let resultsDict = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! Dictionary<NSObject, AnyObject>
//
//                // Get the first dictionary item from the returned items (usually there's just one item).
//                let items: AnyObject! = resultsDict["items"] as AnyObject!
//                let firstItemDict = (items as! Array<AnyObject>)[0] as! Dictionary<NSObject, AnyObject>
//
//                // Get the snippet dictionary that contains the desired data.
//                let snippetDict = firstItemDict["snippet"] as! Dictionary<NSObject, AnyObject>
//
//                // Create a new dictionary to store only the values we care about.
//                var desiredValuesDict: Dictionary<NSObject, AnyObject> = Dictionary<NSObject, AnyObject>()
//                desiredValuesDict["title"] = snippetDict["title"]
//                desiredValuesDict["description"] = snippetDict["description"]
//                desiredValuesDict["thumbnail"] = ((snippetDict["thumbnails"] as! Dictionary<NSObject, AnyObject>)["default"] as! Dictionary<NSObject, AnyObject>)["url"]
//
//                // Save the channel's uploaded videos playlist ID.
//                desiredValuesDict["playlistID"] = ((firstItemDict["contentDetails"] as! Dictionary<NSObject, AnyObject>)["relatedPlaylists"] as! Dictionary<NSObject, AnyObject>)["uploads"]
//
//
//                // Append the desiredValuesDict dictionary to the following array.
//                self.channelsDataArray.append(desiredValuesDict)
//            }
//        })
//
//
//        func getChannelDetails(useChannelIDParam: Bool) {
//            ...performGetRequest(targetURL, completion: { (data, HTTPStatusCode, error) -> Void in
//                if HTTPStatusCode == 200 && error == nil {
//                    ...
//                }
//                else {
//                    println("HTTP Status Code = \(HTTPStatusCode)")
//                    println("Error while loading channel details: \(error)")
//                }
//            })
//        }
//
//        override func viewDidLoad() {
//            ...
//
//            getChannelDetails(false)
//        }
//
//
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if segDisplayedContent.selectedSegmentIndex == 0 {
//            // In this case the channels are the displayed content.
//            // The videos of the selected channel should be fetched and displayed.
//
//            // Switch the segmented control to "Videos".
//            segDisplayedContent.selectedSegmentIndex = 1
//
//            // Show the activity indicator.
//            viewWait.hidden = false
//
//            // Remove all existing video details from the videosArray array.
//            videosArray.removeAll(keepCapacity: false)
//
//            // Fetch the video details for the tapped channel.
//            getVideosForChannelAtIndex(indexPath.row)
//        }
//        else {
//
//        }
//    }
//
//
//    func getVideosForChannelAtIndex(index: Int!) {
//        ...
//
//        // Fetch the playlist from Google.
//        performGetRequest(targetURL, completion: { (data, HTTPStatusCode, error) -> Void in
//            if HTTPStatusCode == 200 && error == nil {
//            }
//            else {
//                println("HTTP Status Code = \(HTTPStatusCode)")
//                println("Error while loading channel videos: \(error)")
//            }
//
//            // Hide the activity indicator.
//            self.viewWait.hidden = true
//        })
//    }
//}
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        ...
//
//        // Get the results.
//        performGetRequest(targetURL, completion: { (data, HTTPStatusCode, error) -> Void in
//            if HTTPStatusCode == 200 && error == nil {
//                // Convert the JSON data to a dictionary object.
//                let resultsDict = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! Dictionary<NSObject, AnyObject>
//
//                // Get all search result items ("items" array).
//                let items: Array<Dictionary<NSObject, AnyObject>> = resultsDict["items"] as! Array<Dictionary<NSObject, AnyObject>>
//
//                // Loop through all search results and keep just the necessary data.
//                var i = 0
//                while i<items.count {
//                    let snippetDict = items[i]["snippet"] as! Dictionary<NSObject, AnyObject>
//
//                    // Gather the proper data depending on whether we're searching for channels or for videos.
//                    if self.segDisplayedContent.selectedSegmentIndex == 0 {
//
//                    }
//                    else {
//
//                    }
//                    ++i
//                }
//            }
//        })
//
//
//        return true
//    }
//
//
//}
