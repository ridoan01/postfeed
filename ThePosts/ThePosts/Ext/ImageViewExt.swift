//
//  ImageViewExt.swift
//  ThePosts
//
//  Created by Ridoan Wibisono on 01/08/21.
//

import Foundation
import UIKit

extension UIImageView {
	func load(url: URL) {
		DispatchQueue.global().async { [weak self] in
			if let data = try? Data(contentsOf: url) {
				if let image = UIImage(data: data) {
					DispatchQueue.main.async {
						self?.image = image
					}
				}
			}
		}
	}
}
