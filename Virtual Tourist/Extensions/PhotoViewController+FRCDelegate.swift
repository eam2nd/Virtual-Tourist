//
//  PhotoViewController+FRCDelegate.swift
//  Virtual Tourist
//
//  Created by Edward Morton on 8/1/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import CoreData

// MARK: PhotoViewController - NSFetchedResultsControllerDelegate

extension PhotoViewController: NSFetchedResultsControllerDelegate {

	// MARK: - Methods

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		toggleDebugLabel(fetchedResultsController.fetchedObjects?.count == 0)
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			collectionView.insertItems(at: [newIndexPath!])
			break
		case .delete:
			collectionView.deleteItems(at: [indexPath!])
			break
		case .update:
			collectionView.reloadItems(at: [indexPath!])
			break
		default:
			break
		}
	}
}
