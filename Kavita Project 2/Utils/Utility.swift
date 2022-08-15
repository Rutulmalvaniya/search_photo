//
//  Utility.swift
//  Kavita Project 2
//
//  Created by apple  on 14/08/22.
//

import Foundation
import UIKit

class Utility {
    static var shared = Utility()
    private init() {}
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var loadingView: UIView = UIView()
    
    func showActivityIndicator(context: UIViewController) {
        DispatchQueue.main.async {
            self.loadingView = UIView()
            self.loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
            self.loadingView.center = context.view.center
            self.loadingView.backgroundColor = UIColor(named: "#444444")
            self.loadingView.alpha = 0.7
            self.loadingView.clipsToBounds = true
            self.loadingView.layer.cornerRadius = 10

            self.spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
            self.spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
            self.spinner.center = CGPoint(x:self.loadingView.bounds.size.width / 2, y:self.loadingView.bounds.size.height / 2)

            self.loadingView.addSubview(self.spinner)
            context.view.addSubview(self.loadingView)
            self.spinner.startAnimating()
        }
    }

    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.loadingView.removeFromSuperview()
        }
    }
}
