//
//  ViewController.swift
//  PeakyChats
//
//  Created by Nishant  Kushwaha on 14/05/21.
//

import UIKit
import FirebaseAuth
class ConvoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .red
        
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        validateAuth()
      
        
    }
    
    private func validateAuth(){
        
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
           
        }
    }


}

