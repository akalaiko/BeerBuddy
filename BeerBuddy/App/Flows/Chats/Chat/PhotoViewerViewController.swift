//
//  PhotoViewerViewController.swift
//  BeerBuddy
//
//  Created by Tim on 28.01.2023.
//

import UIKit

class PhotoViewerViewController: UIViewController {
    
    private let url: URL
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(with url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)

        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .black
        StorageManager.shared.downloadImage(from: url) { [weak self] imageData in
            DispatchQueue.main.async {
                self?.imageView.image = UIImage(data: imageData)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
    }
    
    
}
