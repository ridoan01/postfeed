//
//  PhotoDetailViewController.swift
//  ThePosts
//
//  Created by Ridoan Wibisono on 01/08/21.
//

import UIKit

class PhotoDetailViewController: UIViewController,UIScrollViewDelegate {
	
	@IBOutlet weak var title_lbl : UILabel!
	@IBOutlet weak var photo_img : UIImageView!
	@IBOutlet weak var scroll_sv : UIScrollView!
	
	var photoDetail = [PhotoModel]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
				
		scroll_sv.delegate = self
		scroll_sv.minimumZoomScale = 1.0
		scroll_sv.maximumZoomScale = 10.0
		
		title_lbl.text = photoDetail[0].title
		photo_img.load(url: URL(string: photoDetail[0].url)!)
		
		
	}
	
	func viewForZooming( in scroll_sv: UIScrollView) -> UIView? {
		return photo_img
	}
	
}
