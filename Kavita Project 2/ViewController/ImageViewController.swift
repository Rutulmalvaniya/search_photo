//
//  ImageViewController.swift
//  Kavita Project 2
//
//  Created by apple  on 14/08/22.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var imageUrlString = ""
    var imageTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.topView.backgroundColor = K.AppColor.navigationBarColor
        self.titleLabel.text = imageTitle
        self.navigationController?.navigationBar.prefersLargeTitles = false
        downLoadImage(with: imageUrlString)
    }
    
    func downLoadImage(with url: String) {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        guard let url = URL(string: url) else {return}
        Utility.shared.showActivityIndicator(context: self)
        URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
            Utility.shared.hideActivityIndicator()
            guard let strongSelf = self else {return}
            guard let data = data, error == nil else {return}
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                strongSelf.imageView.image = image
            }
        }.resume()
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
