//
//  PicturesViewController.swift
//  Infinite Pictures
//
//  Created by Nikita Entin on 12.02.2021.
//

import UIKit
import ImageIO


class PicturesViewController: UICollectionViewController {
    
    private var pictures = PicturesModel(message: [URL](), status: String())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseJSON()
    }
    
    private func parseJSON() {
        
        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random/50") else { return }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil, (response as? HTTPURLResponse)?.statusCode == 200 {
                do {
                    guard let receivedData = try? Data(contentsOf: url) else { return }
                    let parsedData = try JSONDecoder().decode(PicturesModel.self, from: receivedData)
                    self.pictures.message += parsedData.message
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } catch let error as NSError {
                    print(error.userInfo)
                }
            }
        }
        dataTask.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "someSegue" {
            let cell = sender as! CustomCell
            let vc = segue.destination as! DetailedVC
            vc.image = cell.pictureView.image
            vc.pixelHeightForVC = cell.pixelHeight
            vc.pixelWidthForVC = cell.pixelWidth
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pictures.message.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        DispatchQueue.global().async {
            let urlString = self.pictures.message[indexPath.item]
            let data = try? Data(contentsOf: urlString)
            if let imageData = data {
                DispatchQueue.main.async {
                    cell.pictureView.image = UIImage(data: imageData)
                }
            }
            if let imageSource = CGImageSourceCreateWithURL(urlString as CFURL, nil) {
                let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil)
                if let dict = imageProperties as? [String: Any] {
                    cell.pixelHeight = "Pixel Height : \(dict["PixelHeight"] ?? "")"
                    cell.pixelWidth = "Pixel Width : \( dict["PixelWidth"] ?? "")"
                }
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == pictures.message.count - 1  {
            parseJSON()
        }
    }
}

extension PicturesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero
        }
        let itemsPerRow: CGFloat = 2
        let totalSpaceBetweenItems = 20 * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - totalSpaceBetweenItems
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}




