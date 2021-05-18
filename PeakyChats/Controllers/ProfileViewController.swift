//
//  ProfileViewController.swift
//  PeakyChats
//
//  Created by Nishant  Kushwaha on 14/05/21.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
class ProfileViewController: UIViewController {
    
    
    @IBOutlet var tableView: UITableView!
    
    let data=["Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")

        // Do any additional setup after loading the view.
        tableView.delegate=self
        tableView.dataSource=self
        
        
    }
}
    
    extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
            cell.textLabel?.text=data[indexPath.row]
            cell.textLabel?.textAlignment = .center
            return cell
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let actionSheet = UIAlertController(title: "Are you sure ?",
                                          message: "",
                                          preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Yes,Log out",
                                          style: .destructive,
                                          handler: {[weak self]_ in
                                            guard let strongSelf = self else{
                                               return
                                            }
                                            
                                            
                                            // FB LogOut
                                            
                                            FBSDKLoginKit.LoginManager().logOut()
                                            
                                            //Google LogOut
                                            
                                            GIDSignIn.sharedInstance()?.signOut()
                                            do{
                                                    try FirebaseAuth.Auth.auth().signOut()
                                                
                                                let vc = LoginViewController()
                                                let nav = UINavigationController(rootViewController: vc)
                                                nav.modalPresentationStyle = .fullScreen
                                                strongSelf.present(nav, animated: true)
                                               
                                         
                                            }
                                            catch
                                            {
                                                print("Failed to log out")
                                            }
                                        
                                        
                                            
                                          }))
            
            
            actionSheet.addAction(UIAlertAction(title: "No",
                                                style: .cancel,
                                                handler: nil))
            
            present(actionSheet, animated: true)
            
            
    }
}
