//
//  HMExeciseDetailCell.swift
//  SwequityVN
//
//  Created by Tung QT on 8/3/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import YoutubePlayerView

class HMExeciseDetailCell: UICollectionViewCell {

    @IBOutlet weak var videoView: YoutubePlayerView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var url: String? {
        didSet {
            videoView.delegate = self
            if let url = url, let id = url.youtubeID {
                setupVideo(videoId: id)
            }
        }
    }
    
    func setupVideo(videoId: String) {
        let playerVars: [String: Any] = [
            "controls": 1,
            "modestbranding": 1,
            "playsinline": 1,
            "autoplay": 0,
            "origin": "https://youtube.com"
        ]
        videoView.loadWithVideoId(videoId, with: playerVars)
    }
}

extension HMExeciseDetailCell: YoutubePlayerViewDelegate {
    
    func playerViewDidBecomeReady(_ playerView: YoutubePlayerView) {
        print("Ready")
        playerView.fetchPlayerState { (state) in
            print("Fetch Player State: \(state)")
        }
    }
    
    func playerView(_ playerView: YoutubePlayerView, didChangedToState state: YoutubePlayerState) {
        print("Changed to state: \(state)")
    }
    
    func playerView(_ playerView: YoutubePlayerView, didChangeToQuality quality: YoutubePlaybackQuality) {
        print("Changed to quality: \(quality)")
    }
    
    func playerView(_ playerView: YoutubePlayerView, receivedError error: Error) {
        print("Error: \(error)")
    }
    
    func playerView(_ playerView: YoutubePlayerView, didPlayTime time: Float) {
        print("Play time: \(time)")
    }
    
    func playerViewPreferredInitialLoadingView(_ playerView: YoutubePlayerView) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
}
