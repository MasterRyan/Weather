//
//  LottieAnimationFile.swift
//  CloudWeather
//
//  Created by user141656 on 7/30/18.
//  Copyright © 2018 Ryan. All rights reserved.
//

import UIKit
import Lottie

class LottieAnimationFile: AnimationFile {

    private var ready: Bool = false
    override var readyToPlay: Bool { return self.ready }

    var lottieView = LOTAnimationView()
    var owner: UIView?

    override func load(filePath: String, owner: UIView, loaded: LoadedClosure ) {
        lottieView = LOTAnimationView(filePath: filePath)
        lottieView.frame = owner.bounds
        owner.addSubview(lottieView)

        self.owner = owner
        ready = true
        loaded(true, nil)
    }

    override func play() {
        guard owner != nil, ready else { return }
        lottieView.play { [weak self] (finished) in
            if finished, self?.loop ?? false {
                self?.play()
            }
        }
    }

    override func stop() {
        lottieView.stop()
    }

    override func pause(auto: Bool = false) {
        lottieView.pause()
    }

    override func resize() {
        guard let bounds = owner?.bounds else { return }
        lottieView.frame = bounds
    }
}
