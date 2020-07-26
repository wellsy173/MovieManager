//
//  LoginViewController.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginViaWebsiteButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        setLoggingIn(true)
        TMDBClient.getRequestToken(completion: handleRequestTokenResponse(success:error:))
    }
    
    @IBAction func loginViaWebsiteTapped() {
        setLoggingIn(true)
        TMDBClient.getRequestToken { (success, error) in
            if success {
                DispatchQueue.main.async {
                UIApplication.shared.open(TMDBClient.Endpoints.webAuth.url, options: [:], completionHandler: nil)
                
            }
    }
    }
    }
    func handleRequestTokenResponse(success: Bool, error: Error?) {
        if success {
            print(TMDBClient.Auth.requestToken)
                TMDBClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: self.handleLoginResponse(success:error:))
            } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
                
        }
    }

    func handleLoginResponse(success: Bool, error: Error?) {
        print (TMDBClient.Auth.requestToken)
        if success {
            TMDBClient.createSessionId(completion: handleSessionReponse(success:error:))
        }else{
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
}
    func handleSessionReponse(success:Bool, error: Error?) {
        setLoggingIn(false)
        if success {
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
        }else{
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
        func setLoggingIn(_ loggingIn: Bool) {
            if loggingIn {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
            emailTextField.isEnabled = !loggingIn
            passwordTextField.isEnabled = !loggingIn
            loginButton.isEnabled = !loggingIn
            loginViaWebsiteButton.isEnabled = !loggingIn
        }
        
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
}
