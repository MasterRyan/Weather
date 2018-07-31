//
//  MovieAnimationFile.swift
//  CloudWeather
//
//  Created by user141656 on 7/30/18.
//  Copyright © 2018 Ryan. All rights reserved.
//

import UIKit
import AVKit

class MovieAnimationFile: AnimationFile {

    private var ready: Bool = false
    override var readyToPlay: Bool { return self.ready }

    var player = AVPlayer()
    var videoLayer = AVPlayerLayer()
    weak var owner: UIView?

    var playing = false

    override func load(filePath: String, owner: UIView, loaded: LoadedClosure) {
        //create video
        let url = URL(fileURLWithPath: filePath)
        player = AVPlayer(url: url)
        videoLayer = AVPlayerLayer(player: player)

        //add video layer
        videoLayer.frame = owner.bounds
        owner.layer.addSublayer(videoLayer)

        self.owner = owner
        ready = true
        loaded(true, nil)
    }

    override func play() {
        guard ready == true, owner != nil else { return }
        player.play()
        playing = true
    }

    override func stop() {
        player.pause()
        playing = false
    }

    override func pause(auto: Bool = false) {
        player.pause()
        if auto == true { return }
        playing = false
    }

    override func resize() {
        guard let bounds = owner?.bounds else { return }
        videoLayer.frame = bounds
    }
}
