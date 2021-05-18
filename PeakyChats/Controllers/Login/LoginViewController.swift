//
//  LoginViewController.swift
//  PeakyChats
//
//  Created by Nishant  Kushwaha on 14/05/21.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    private let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        
        
        return scrollView
    }()
    
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailField:UITextField = {
        let field=UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemBlue.cgColor
        field.placeholder = " Email"
        field.leftView=UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        
        return field
    }()
    
    
    private let passwordField:UITextField = {
        let field=UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemBlue.cgColor
        field.placeholder = " Password"
        field.leftView=UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    
    private let loginButton:UIButton = {
        
        let button=UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize:20,weight:.bold)
        return button
    }()
    private let facebookLoginButton:FBLoginButton = {
        let button = FBLoginButton()
        
        button.permissions = ["public_profile", "email"]
        
        return button
    }()
    
    private let googleLogInButton = GIDSignInButton()
    
    private var loginObserver: NSObjectProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification,
                                                               object: nil,
                                                               queue: .main,
                                                               using: {[weak self] _ in
                                                                
                                                                guard let strongSelf = self else {
                                                                    return
                                                                }
                                                                
                                                                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                                                                
                                                               })
        
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().presentingViewController = self
        
        
        title="Log in"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem=UIBarButtonItem(title: "Register",
                                                          style: .done,
                                                          target: self,
                                                          action: #selector(didTapRegister))
        
        loginButton.addTarget(self,
                              action: #selector(loginButtonTapped),
                              for: .touchUpInside)
        
        emailField.delegate=self
        passwordField.delegate=self
        
        facebookLoginButton.delegate=self
        
        
        
        //Adding subview
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(facebookLoginButton)
        scrollView.addSubview(googleLogInButton)
        
        
    }
    
    deinit {
        if let observer = loginObserver{
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        scrollView.frame=view.bounds
        let size = scrollView.width/3
        
        imageView.frame=CGRect(x: (scrollView.width-size)/2,
                               y: 20,
                               width: size,
                               height: size)
        emailField.frame=CGRect(x: 30,
                                y: imageView.bottom+50,
                                width: scrollView.width-60,
                                height: 52)
        passwordField.frame=CGRect(x: 30,
                                   y: emailField.bottom+10,
                                   width: scrollView.width-60,
                                   height: 52)
        loginButton.frame=CGRect(x: 30,
                                 y: passwordField.bottom+50,
                                 width: scrollView.width-60,
                                 height: 52)
        facebookLoginButton.frame=CGRect(x: 30,
                                 y: loginButton.bottom+10,
                                 width: scrollView.width-60,
                                 height: 52)
        googleLogInButton.frame=CGRect(x: 30,
                                 y: facebookLoginButton.bottom+10,
                                 width: scrollView.width-60,
                                 height: 52)
        
    }
    
    @objc private func loginButtonTapped(){
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text ,let password=passwordField.text,
              !email.isEmpty,!password.isEmpty,password.count>=6 else{
            alertUserLoginError()
            return
        }
        //Firebase Login
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self]authResult ,error in
            guard let strongSelf = self else{
                return
            }
            guard let result=authResult,error == nil else{
                print("Failed to Sign in : \(email)")
                return
            }
            
            let user = result.user
            print("Logged in ",user)
            
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            
        })
    }
    
    func alertUserLoginError()
    {
        let alert = UIAlertController(title: "woops",
                                      message: "Please enter all info",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
        
    }
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        
        vc.title="Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension LoginViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField==emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField==passwordField{
            loginButtonTapped()
        }
        return true
    }
}

extension LoginViewController: LoginButtonDelegate{
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // Not required as we will change view and log out will be through in app button
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token=result?.token?.tokenString else {
            print("User Failed to login with Facebook")
            return
        }
        
        let facebookRequest=FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                       parameters: ["fields":"email, name"],
                                                       tokenString:token,
                                                       version: nil,
                                                       httpMethod: .get)
        
        facebookRequest.start(completionHandler: {connection, result,error in
            guard let result = result as?[String: Any] ,
                  error == nil else{
                print("Failed to make fb graph request")
                return
            }
            
            print("\(result)")
            
            guard let userName = result["name"] as?String,
                  let email = result["email"] as?String else{
                
                print("Failed to get name and email")
                return
            }
            
            let nameComponent = userName.components(separatedBy: " ")
            guard nameComponent.count==2 else{
                return
            }
            
            let firstName = nameComponent[0]
            let secondName = nameComponent[1]
            
            DatabaseManager.shared.userExists(with: email, completion: {exists in
                
                if !exists{
                    DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName,
                                                                        lastName: secondName,
                                                                        emailId: email))
                }
            })
            
            
            
            
            let credential=FacebookAuthProvider.credential(withAccessToken: token)
            FirebaseAuth.Auth.auth().signIn(with: credential, completion: {[weak self]authResult,error in
                guard let strongSelf = self else{
                    return
                }
                
                
                guard authResult != nil ,error==nil else{
                    if let error=error
                    {
                        print("FB Cred login failed , MFA maybe needed - \(error)")

                    }
                    return
                }
                print("Logged in ")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
        
        
        
        
        
    }
    
    
}
