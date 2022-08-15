//
//  ImageCollectionViewCell.swift
//  Kavita Project 2
//
//  Created by apple  on 13/08/22.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "ImageCollectionViewCell"
    @IBOutlet weak var imageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(with url: String) {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        guard let url = URL(string: url) else {return}
        URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
            guard let strongSelf = self else {return}
            guard let data = data, error == nil else {return}
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                strongSelf.imageView.image = image
            }
        }.resume()
    }
}
