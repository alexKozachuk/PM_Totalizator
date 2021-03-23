//
//  ImageLoader.swift
//  PMProject
//
//  Created by Sasha on 20/03/2021.
//

import UIKit

class ImageLoader {
    
    private static let imageCache = NSCache<NSString, UIImage>()
    
    func loadImage(urlString: String,
                   _ placeholderImage: UIImage,
                   queue: DispatchQueue = .main,
                   completion: @escaping (UIImage) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        let nsUrlString = NSString(string: urlString)
        
        if let imageFromCache = ImageLoader.imageCache.object(forKey: nsUrlString) {
            queue.async {
                completion(imageFromCache)
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            queue.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                    DispatchQueue.global(qos: .background).async {
                        ImageLoader.imageCache.setObject(image, forKey: nsUrlString)
                    }
                } else {
                    completion(placeholderImage)
                    DispatchQueue.global(qos: .background).async {
                        ImageLoader.imageCache.setObject(placeholderImage, forKey: nsUrlString)
                    }
                }
            }
        }.resume()
        
    }

}
