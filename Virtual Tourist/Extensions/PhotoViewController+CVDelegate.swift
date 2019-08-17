//
//  PhotoViewController+CVDelegate.swift
//  Virtual Tourist
//
//  Created by Edward Morton on 8/1/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit

// MARK: PhotoViewController - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate

extension PhotoViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

	// MARK: - Properties

	var spaceBetween: CGFloat {
		return 5
	}

	// MARK: - Methods

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return fetchedResultsController?.sections?.count ?? 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return fetchedResultsController.sections?[section].numberOfObjects ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return spaceBetween
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return spaceBetween
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = UIScreen.main.bounds.width / 3 - spaceBetween
		let height = width

		return CGSize(width: width, height: height)
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoViewCell.self), for: indexPath) as! PhotoViewCell
		let photo = fetchedResultsController.object(at: indexPath)

		if let image = photo.image {
			cell.setUpImage(image)
		} else {
			cell.activityIndicator.isHidden = false
			cell.activityIndicator.startAnimating()

			DispatchQueue.global(qos: .userInteractive).async {
				do {
					let image: Data

					if let url = photo.url, !url.isEmpty {
						image = try Data(contentsOf: URL(string: url)!)
					} else {
						image = (UIImage(named: "placeholder")?.pngData())!
					}

					performUiUpdatesOnMain {
						photo.image = image
						cell.setUpImage(image)

						try? self.dataController.viewContext.save()
					}
				} catch {
					print("No Data/URL for image: \(error.localizedDescription)")
				}
			}
		}

		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let photo = fetchedResultsController.object(at: indexPath)

		dataController.viewContext.delete(photo)
		try? dataController.viewContext.save()
	}
}
