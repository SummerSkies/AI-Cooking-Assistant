//
//  AnimationController.swift
//  AI Cooking Assistant
//
//  Created by Zane Jones on 9/21/23.
//

import Foundation
import UIKit

class AnimationController {
    var imageView: UIImageView
    var images = [UIImage]()
    
    init(imageView: UIImageView) {
        self.imageView = imageView
        
        if let peachyFolderURL = Bundle.main.url(forResource: "Peachy-Flutter", withExtension: "gif"),
           let talkingGifData = try? Data(contentsOf: peachyFolderURL),
           let gifImage = UIImage.gif(data: talkingGifData) {
            images.append(gifImage)
        } else {
            fatalError("Failed to load gif")
        }
        
        if let peachyFolderURL = Bundle.main.url(forResource: "Peachy-Idle", withExtension: "gif"),
           let talkingGifData = try? Data(contentsOf: peachyFolderURL),
           let gifImage = UIImage.gif(data: talkingGifData) {
            images.append(gifImage)
        } else {
            fatalError("Failed to load gif")
        }
        
        if let peachyFolderURL = Bundle.main.url(forResource: "Peachy-LookAround", withExtension: "gif"),
           let talkingGifData = try? Data(contentsOf: peachyFolderURL),
           let gifImage = UIImage.gif(data: talkingGifData) {
            images.append(gifImage)
        } else {
            fatalError("Failed to load gif")
        }
        
        if let peachyFolderURL = Bundle.main.url(forResource: "Peachy-Stretch", withExtension: "gif"),
           let talkingGifData = try? Data(contentsOf: peachyFolderURL),
           let gifImage = UIImage.gif(data: talkingGifData) {
            images.append(gifImage)
        } else {
            fatalError("Failed to load gif")
        }
        
        if let peachyFolderURL = Bundle.main.url(forResource: "Peachy-Talk1x", withExtension: "gif"),
           let talkingGifData = try? Data(contentsOf: peachyFolderURL),
           let gifImage = UIImage.gif(data: talkingGifData) {
            images.append(gifImage)
        } else {
            fatalError("Failed to load gif")
        }
    }
    
    func setLastImage() {
        imageView.image = images.last
        imageView.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
    }
    
    func setRandomImage() {
        let index = Int.random(in: 0..<(images.count - 1))
        imageView.image = images[index]
    }
    
    
}
