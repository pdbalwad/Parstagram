//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Priyanka Balwadkar on 10/24/20.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var user = PFUser()
    var posts = [PFObject]()
    let myRefreshControl = UIRefreshControl()
    var numberOfPosts: Int!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        numberOfPosts = 10
        tableView.delegate = self
        tableView.dataSource = self
        
        loadPosts()
        
        myRefreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        
        tableView.refreshControl = myRefreshControl
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func loadPosts()
    {
        let query = PFQuery(className:"Posts")
        query.includeKey("author")
        
        query.limit = 10
        
        query.findObjectsInBackground {(posts, error) in
        if posts != nil{
         
            self.posts = posts!.reversed()
            self.tableView.reloadData()
               
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPosts()
        //self.tableView.reloadData()
    }
    
    
    @IBAction func onLogoutButton(_ sender: Any) {
        
        //let user = posts[0]["author"] as PFUser!
        PFUser.logOut()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        user = post["author"] as! PFUser
       
        cell.usernameLabel.text = user.username
        cell.captionLabel.text = post["caption"] as? String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.postView.af_setImage(withURL: url)
        
        return cell
        
    }
    
    
    
    @objc func onRefresh()
    {
        let query = PFQuery(className:"Posts")
        query.includeKey("author")
        
        query.limit = 10
        
        query.findObjectsInBackground {(posts, error) in
            if posts != nil {
                self.posts = posts!.reversed()
                
                self.tableView.reloadData()
                self.myRefreshControl.endRefreshing()
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if indexPath.row + 1 == posts.count{
            loadMorePosts()
        }
    }
    
    
    func loadMorePosts(){
        
        numberOfPosts = numberOfPosts + 10
        let query = PFQuery(className:"Posts")
        query.includeKey("author")
        query.limit = numberOfPosts
    
        query.findObjectsInBackground {(posts, error) in
            if posts != nil {
                
                self.posts.removeAll()
                self.posts = posts!.reversed()
                self.tableView.reloadData()
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
