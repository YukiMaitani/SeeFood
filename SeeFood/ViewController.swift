//
//  ViewController.swift
//  SeeFood
//
//  Created by 米谷裕輝 on 2022/06/26.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[.originalImage] as? UIImage {
            imageView.image = userPickedImage
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("ciimageの作成に失敗しました")
            }
            detect(ciimage: ciimage)
        }
        imagePicker.dismiss(animated: true)
    }
    
    func detect(ciimage:CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3_2().model) else {
            fatalError("モデルの読み込みに失敗しました")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results else {
                fatalError("リクエストが失敗しました")
            }
            print(results)
        }
        
        let handler = VNImageRequestHandler(ciImage: ciimage)
        do {
            try handler.perform([request])
        }
        catch {
            print("画像解析に失敗しました\(error)")
        }
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true)
    }
    
}

