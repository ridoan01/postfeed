//
//  UserDetailViewController.swift
//  ThePosts
//
//  Created by Ridoan Wibisono on 31/07/21.
//

import UIKit


class UserDetailViewController: UIViewController {
	
	@IBOutlet weak var user_tbl : UITableView!
	
	
	var user = [UserModel]()
	var albums = [AlbumModel](){
		didSet{
			DispatchQueue.main.async {
				self.fecthPhoto()
			}
		}
	}
	var photos = [[PhotoModel]](){
		didSet{
			DispatchQueue.main.async {
				self.user_tbl.reloadData()
			}
		}
	}
		
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		user_tbl.delegate = self
		user_tbl.dataSource = self
		user_tbl.rowHeight = UITableView.automaticDimension
		user_tbl.estimatedRowHeight = 400
		
		fetchAlbum()
		
	}
	
	func fetchAlbum(){
		AlbumsRequest(userId: user[0].id).getAlbums(){ result in
			switch result{
			case .failure(let error) :
				print(error.localizedDescription)
			case .success(let albums):
				self.albums = albums
				
			}
		}
	}
	
	func fecthPhoto(){
		for i in albums{
			PhotosRequest(albumId: i.id).getPhotos(){ result in
				switch result{
				case .failure(let error) :
					print(error.localizedDescription)
				case .success(let photo):
					self.photos.append(photo)
					
				}
			}
		}
		
	}
	func moveOnPhotoDetails(tindex: Int, cindex: Int) {
		guard let vc = storyboard?.instantiateViewController(identifier: "PhotoDetailViewController") as? PhotoDetailViewController else {
			return
		}
		let item = [photos[tindex][cindex]]
		vc.photoDetail = item
		navigationController?.pushViewController(vc, animated: true)
		
	}
}




