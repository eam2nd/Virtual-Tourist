//
//  PhotoViewCell.swift
//  Virtual Tourist
//
//  Created by Edward Morton on 8/1/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit

// MARK: PhotoViewCell - UICollectionViewCell

class PhotoViewCell: UICollectionViewCell {

	// MARK: - Outlets

	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var imageView: UIImageView!

	// MARK: - Methods

	func setUpImage(_ data: Data) {
		let image = UIImage(data: data)

		self.imageView.image = image
		self.activityIndicator.stopAnimating()
		self.activityIndicator.isHidden = true
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		self.imageView.image = UIImage(named: "placeholder")
	}
}
