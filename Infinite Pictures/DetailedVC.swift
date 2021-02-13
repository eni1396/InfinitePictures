//
//  DetailedVC.swift
//  Infinite Pictures
//
//  Created by Nikita Entin on 12.02.2021.
//

import UIKit

class DetailedVC: UIViewController {
    
    var image: UIImage?
    var pixelHeightForVC: String?
    var pixelWidthForVC: String?
    
    
    @IBOutlet weak var detailedPictureView: UIImageView!
    @IBOutlet weak var firstMetaLabel: UILabel!
    @IBOutlet weak var secondMetaLabel: UILabel!
    @IBOutlet weak var dateOfLoad: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailedPictureView.image = image
        firstMetaLabel.text = pixelHeightForVC
        secondMetaLabel.text = pixelWidthForVC
        dateOfLoad.text = "Дата скачивания: \(getCurrentDate())"
        
        writeToPhotoAlbum(image: detailedPictureView.image!)
    }
    
    private func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
    
    private func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        let result = formatter.string(from: date)
        return result
    }
}
