//
//  PostsViewController.swift
//  ThePosts
//
//  Created by Ridoan Wibisono on 31/07/21.
//

import UIKit

class PostsViewController: UIViewController {
	@IBOutlet weak var posts_tbl: UITableView!
	
	var posts = [PostModel]()
	var users = [UserModel]()
	var selectedRow = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		posts_tbl.delegate = self
		posts_tbl.dataSource = self
		posts_tbl.rowHeight = UITableView.automaticDimension
		posts_tbl.estimatedRowHeight = 300
		
		fecthData()
	}
	
	
	func fecthData(){
		let group = DispatchGroup()
		group.enter()
		PostsRequest().getPosts(){ result in
			switch result{
			case .failure(let error) :
				print(error.localizedDescription)
			case .success(let post):
				self.posts = post
				group.leave()
			}
		}
		
		group.enter()
		UsersRequest().getUsers(){ result in
			switch result{
			case .failure(let error) :
				print(error.localizedDescription)
			case .success(let user):
				self.users = user
			}
			group.leave()
		}
		
		group.notify(queue: .main){
			// gather results
			self.posts_tbl.reloadData()
		}
	}
	
}


extension PostsViewController : UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return posts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath  as IndexPath) as! PostTableViewCell
		
		cell.title_lbl.text = posts[indexPath.row].title
		cell.body_lbl.text = posts[indexPath.row].body
		cell.username_btn.setTitle(users[posts[indexPath.row].userId - 1].name
								   , for: .normal)
		cell.company_lbl.text = users[posts[indexPath.row].userId - 1].company.name
		cell.actionBlock = {
			self.selectedRow = indexPath.row
			self.performSegue(withIdentifier: "userDetail", sender: self)
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedRow = indexPath.row
		performSegue(withIdentifier: "postDetail", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "postDetail" {
			let viewController = segue.destination as! PostDetailViewController
			viewController.user = [self.users[self.posts[selectedRow].userId - 1]]
			viewController.post = [self.posts[selectedRow]]
		}
		
		if segue.identifier == "userDetail" {
			let viewController = segue.destination as! UserDetailViewController
			viewController.user = [self.users[self.posts[selectedRow].userId - 1]]
			
		}
		
	}
}


class PostTableViewCell: UITableViewCell {
	@IBOutlet weak var title_lbl: UILabel!
	@IBOutlet weak var body_lbl: UILabel!
	@IBOutlet weak var company_lbl: UILabel!
	@IBOutlet weak var username_btn: UIButton!
	
	
	var actionBlock: (() -> Void)? = nil
	
	@IBAction func toUser(_ sender: Any) {
		actionBlock?()
	}
	
}
