//
//  LoginViewController.swift
//  Kavita Project 2
//
//  Created by apple  on 11/08/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var singupButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = K.AppColor.background
        loginButton.backgroundColor = K.AppColor.buttonBackground
        loginButton.setTitleColor(K.AppColor.appBlack, for: .normal)
        emailTextField.backgroundColor = K.AppColor.textFieldBackground
        passwordTextField.backgroundColor = K.AppColor.textFieldBackground
        self.navigationController?.navigationBar.backgroundColor = K.AppColor.navigationBarColor
        singupButton.underline()
        loginButton.layer.cornerRadius = 5.0
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    @IBAction func loginButtonAction(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else {
            self.alertPopup(msg: "Please enter email.");
            return
        }
        
        guard (email.isValidEmail()) else {
            self.alertPopup(msg: "Please enter valid email.");
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            self.alertPopup(msg: "Please enter password.");
            return
        }
        Utility.shared.showActivityIndicator(context: self)
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let strongSelf = self else {
                Utility.shared.hideActivityIndicator()
                return
            }
            
            guard error == nil else {
                strongSelf.alertPopup(msg: "User does not exist.")
                Utility.shared.hideActivityIndicator()
                return
            }
            Utility.shared.hideActivityIndicator()
            strongSelf.navigateToHome()
        }
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier:"SignUpViewController") as? SignUpViewController
        navigationController?.pushViewController(homeViewController!, animated: true)
    }
    
    private func navigateToHome() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier:"HomeViewController") as? HomeViewController
        navigationController?.pushViewController(homeViewController!, animated: true)
    }
}
