//
//  SignUpViewController.swift
//  Kavita Project 2
//
//  Created by apple  on 12/08/22.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = K.AppColor.background
        createAccountButton.layer.cornerRadius = 5.0
        createAccountButton.backgroundColor = K.AppColor.buttonBackground
        createAccountButton.setTitleColor(K.AppColor.appBlack, for: .normal)
        emailTextField.backgroundColor = K.AppColor.textFieldBackground
        passwordTextField.backgroundColor = K.AppColor.textFieldBackground
        confirmPasswordTextField.backgroundColor = K.AppColor.textFieldBackground
        self.navigationController?.navigationBar.backgroundColor = K.AppColor.navigationBarColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    @IBAction func createAccountButtonAction(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else {
            self.alertPopup(msg: "Please enter email.");
            return
        }
        
        guard (email.isValidEmail()) else {
            self.alertPopup(msg: "Please enter valid email.");
            Utility.shared.hideActivityIndicator()
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            self.alertPopup(msg: "Please enter password.");
            return
        }
        
        guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            self.alertPopup(msg: "Please enter confirm password.");
            return
        }
        
        if password != confirmPassword {
            self.showToast(string: "Confirm password does not match.")
        }
        Utility.shared.showActivityIndicator(context: self)
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let strongSelf = self else {
                Utility.shared.hideActivityIndicator()
                return
            }
            
            guard error == nil else {
                strongSelf.alertPopup(msg: "Something went wrong.")
                Utility.shared.hideActivityIndicator()
                return
            }
            Utility.shared.hideActivityIndicator()
            strongSelf.navigationController?.popViewController(animated: true);
            strongSelf.showToast(string: "User created successfully.")
        }
    }
}
