//
//  LottieAnimationFile.swift
//  CloudWeather
//
//  Created by user141656 on 7/30/18.
//  Copyright © 2018 Ryan. All rights reserved.
//

import UIKit

class LottieAnimationFile: AnimationFile {

    private var ready: Bool = false

    override var readyToPlay: Bool { return self.ready }

    override func load(filePath: String, loaded: LoadedClosure ) {
        //setup and load
        ready = true
        loaded(true, nil)
    }

    override func play() {

    }

    override func stop() {

    }

    override func pause(auto: Bool = false) {

    }
}
