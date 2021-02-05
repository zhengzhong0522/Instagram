//
//  ViewController.swift
//  Instagram
//
//  Created by zhong zheng on 2/4/21.
//  Copyright © 2021 ZHONG ZHENG. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var tableView: UITableView!
     var posts: [PFObject] = []
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myRefreshControl.addTarget(self, action: #selector(loadPost), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        tableView.dataSource = self
        tableView.delegate = self
        loadPost()
       
    }
    @objc func loadPost(){
           let query = PFQuery(className: "MyPosts")
           query.includeKey("author")
           query.limit = 20
           
           query.findObjectsInBackground { (posts, error) in
               if posts != nil {
                   self.posts = posts!
                   self.tableView.reloadData()
               }
           }
           
           
       }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           loadPost()
       }
    
   

    @IBAction func signout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
                      dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
          let post = posts[indexPath.row]
          let user = post["author"] as! PFUser
          cell.nameLabel.text = user.username
          cell.captionField.text = post["caption"] as! String
          let imageFile = post["image"] as! PFFileObject
          let urlString = imageFile.url!
          let url = URL(string: urlString)
          cell.postImage!.af_setImage(withURL: url!)
          return cell

       }
    
}

