//
//  SplashViewController.swift
//  Kavita Project 2
//
//  Created by apple  on 14/08/22.
//

import UIKit
import FirebaseAuth

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (FirebaseAuth.Auth.auth().currentUser != nil) {
            navigateToHome()
        } else {
            let loginVC = storyboard?.instantiateViewController(withIdentifier:"LoginViewController") as? LoginViewController
            navigationController?.pushViewController(loginVC!, animated: true)
        }
    }
    
    private func navigateToHome() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier:"HomeViewController") as? HomeViewController
        navigationController?.pushViewController(homeViewController!, animated: true)
    }
}
