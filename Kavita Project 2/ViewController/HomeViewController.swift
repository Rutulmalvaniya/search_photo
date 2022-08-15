//
//  ViewController.swift
//  Kavita Project 2
//
//  Created by apple  on 09/08/22.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var notImageFoundLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var result: [Result] = []
    
    override func viewDidLoad(){
        super.viewDidLoad()
        topView.backgroundColor = K.AppColor.navigationBarColor
        view.backgroundColor = K.AppColor.background
        collectionView.backgroundColor = K.AppColor.background
        self.navigationController?.isNavigationBarHidden = true
        self.isShowMessageForNoImageLabel()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        searchBar.searchBarStyle = .minimal
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width/2, height: view.frame.size.width/2)
        collectionView.collectionViewLayout = layout
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            result = []
            collectionView.reloadData()
            fetchPhotos(query: text)
        }
        
    }
    
    func fetchPhotos(query: String) {
        Utility.shared.showActivityIndicator(context: self)
        let urlString = "https://api.unsplash.com/search/photos?page=100&query=\(query)&client_id=wsQ0JPx8UDIkVEvIbEEtM5wIaFRsHA74JHCocSDkU7c"
        
        guard let url = URL(string: urlString) else {return}
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
            Utility.shared.hideActivityIndicator()
            guard let strongSelf = self else {return}
            guard let data = data, error == nil else {return}
            print("Got data==> \(String(describing: strongSelf.dataToJSON(data: data)))")
            
            do {
                let result = try JSONDecoder().decode(PhotoAPIResponse.self, from: data)
                print(result.results.count)
                DispatchQueue.main.async {
                    strongSelf.result = result.results
                    strongSelf.collectionView.reloadData()
                }
                
            } catch {
                print(error)
            }
            strongSelf.isShowMessageForNoImageLabel()
        }
        task.resume()
    }
    
    @IBAction func logout(_ sender: Any) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            self.navigationController?.popViewController(animated: true)
        } catch {
            print("An error has occured")
        }
    }
    
    func dataToJSON(data: Data) -> Any? {
       do {
           return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
       } catch let myJSONError {
           print(myJSONError)
       }
       return nil
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageURLString = result[indexPath.row].urls.regular
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: imageURLString)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageVC = storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController
        imageVC?.imageUrlString = result[indexPath.row].urls.full
        imageVC?.imageTitle = searchBar.text ?? "Image"
        navigationController?.pushViewController(imageVC!, animated: true)
    }
    
    private func isShowMessageForNoImageLabel() {
        DispatchQueue.main.async {
            if self.result.isEmpty {
                self.notImageFoundLabel.isHidden = false
            } else {
                self.notImageFoundLabel.isHidden = true
            }
        }
    }
}

struct PhotoAPIResponse: Codable {
    let total: Int
    let total_pages: Int
    let results: [Result]
}

struct Result: Codable {
    let id: String
    let urls: URLS
}

struct URLS: Codable {
    let full: String
    let regular: String
}
