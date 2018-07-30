//
//  AnimationView.swift
//  CloudWeather
//
//  Created by user141656 on 7/30/18.
//  Copyright © 2018 Ryan. All rights reserved.
//

import UIKit

public typealias LoadedClosure = (Bool, Error?) -> Void

public enum AnimationViewError: Error {
    case fileTypeError(String)
}

//will be private when moved to framework
class AnimationFile {
    var readyToPlay: Bool { assert(false, "should be sub-classed"); return false }

    func load(filePath: String, owner: UIView, loaded: LoadedClosure) {
        assert(false, "should be sub-classed")
        loaded(false, AnimationViewError.fileTypeError("abstract class used"))
    }

    func play() { assert(false, "should be sub-classed") }
    func pause(auto: Bool = false) { assert(false, "should be sub-classed") }
    func stop() { assert(false, "should be sub-classed") }

}

public class AnimationView: UIView {

    @IBInspectable public var loop: Bool = false
    @IBInspectable public var fileName: String = "" {
        didSet {
            loadFile()
        }
    }
    @IBInspectable public var autoPlay: Bool = false {
        willSet {
            if newValue == true {
                play()
            }
        }
    }

    private var animationFile: AnimationFile?

    private var readyToPlay: Bool {
        return animationFile?.readyToPlay ?? false
    }

    private var playing = false

    func play() {
        //need some error reporting could throw (but might leak up the stack) or enum return value?
        guard readyToPlay == true, playing == false else { return }
        animationFile?.play()
    }

    func pause() {
        animationFile?.pause()
    }

    func stop() {
        animationFile?.stop()
    }

    private func loadFile() {
        //local copy incase we need threadding to load and the name changes.
        let fileName = self.fileName

        //search the Apps main bundle over the XCAssets as animations can be large and we don't want them auto caching
        let bundle = Bundle.main

        //search for lottie files (.json)
        if let filePath = bundle.path(forResource: fileName, ofType: "json") {
            animationFile = LottieAnimationFile()
            animationFile?.load(filePath: filePath, owner: self) { [unowned self] (success, _) in
                if success, self.autoPlay {
                    animationFile?.play()
                }
            }
            return
        }

        //search for .mp4's and .mov's
        for fileType in  ["mp4", "m4p", "mov"] {
            if let filePath = bundle.path(forResource: fileName, ofType: fileType) {
                animationFile = MovieAnimationFile()
                animationFile?.load(filePath: filePath, owner: self) { [unowned self] (success, _) in
                    if success, self.autoPlay {
                        animationFile?.play()
                    }
                }
                break
            }
        }
    }
}
