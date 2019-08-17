//
//  PhotoViewController.swift
//  Virtual Tourist
//
//  Created by Edward Morton on 8/1/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit
import MapKit
import CoreData

// MARK: PhotoViewController - UIViewController

class PhotoViewController: UIViewController {

	// MARK: - Properties

	var dataController: DataController!
	var fetchedResultsController: NSFetchedResultsController<Photo>!
	var pin: Pin!
	var maxPhotos: Int = 25
	var numPages: Int = 1
	var searchTask: URLSessionDataTask? = nil

	// MARK: - Outlets

	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var newCollectionButton: UIBarButtonItem!
	@IBOutlet weak var debugLabel: UILabel!

	// MARK: - Actions

	@IBAction func newCollection(_ sender: UIBarButtonItem) {
		deletePhotos()
		searchFlickr()
	}

	// MARK: - Methods

	fileprivate func setUpFetchResultController() {
		let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
		let predicate = NSPredicate(format: "pin = %@", pin)
		let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)

		fetchRequest.predicate = predicate
		fetchRequest.sortDescriptors = [sortDescriptor]
		fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
		fetchedResultsController.delegate = self

		do {
			try fetchedResultsController.performFetch()
		} catch {
			fatalError("The fetch could not be performed: \(error.localizedDescription)")
		}
	}

	func setUpMap() {
		let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
		let center = CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.lng)
		let region = MKCoordinateRegion(center: center, span: span)

		mapView.delegate = self
		mapView.setRegion(region, animated: true)
		displayPin(pin)
	}

	func displayPin(_ pin: Pin) {
		let annotation = MKPointAnnotation()

		annotation.coordinate = CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.lng)
		mapView.addAnnotation(annotation)
	}

	func toggleSpinner(_ show: Bool) {
		newCollectionButton.isEnabled = !show

		if show {
			Spinner.start(view)
		} else {
			Spinner.stop()
		}
	}

	func toggleDebugLabel(_ show: Bool){
		debugLabel.isHidden = !show
		collectionView.isHidden = show
	}

	func searchFlickr() {
		let client = FlickrClient.sharedInstance()
		let page = Int.random(in: 1...numPages)

		if let url = URL(string: client.getSearchUrl(pin.lat, pin.lng, page)) {
			toggleSpinner(true)
			toggleDebugLabel(false)

			searchTask = client.search(url) { response, error in
				performUiUpdatesOnMain {
					self.toggleSpinner(false)

					guard error == nil else {
						self.alert("Alert", "There was a problem loading photos:\n\n \(error!.localizedDescription)")
						return
					}

					self.numPages = response?.photos.pages ?? 0

					if let flickrPhotos = response?.photos.photo {
						self.savePhotos(flickrPhotos)
					} else {
						self.toggleDebugLabel(true)
					}
				}
			}
		}
	}

	func savePhotos(_ flickrPhotos: [FlickrPhoto]) {
		guard flickrPhotos.count > 0 else {
			self.toggleDebugLabel(true)
			return
		}

		var range = 0..<flickrPhotos.count

		// get a random range of photos, if possible
		if flickrPhotos.count > maxPhotos {
			let rand = Int.random(in: maxPhotos..<flickrPhotos.count + 1)
			range = (rand - maxPhotos)..<rand
		}

		let slice = flickrPhotos[range]

		for (index, flickrPhoto) in slice.enumerated() {
			guard index <= maxPhotos else {
				break
			}

			let photo = Photo(context: dataController.viewContext)

			photo.pin = pin
			photo.id = flickrPhoto.id
			photo.url = FlickrClient.sharedInstance().getPhotoUrl(flickrPhoto.farm, flickrPhoto.server, flickrPhoto.id, flickrPhoto.secret)
			photo.image = nil
			try? dataController.viewContext.save()
		}
	}

	func deletePhotos() {
		toggleSpinner(true)

		if let photos = fetchedResultsController.fetchedObjects {
			for photo in photos {
				dataController.viewContext.delete(photo)
				try? dataController.viewContext.save()
			}
		}

		toggleSpinner(false)
	}

	// MARK: - View Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		collectionView.dataSource = self
		collectionView.delegate = self

		setUpFetchResultController()
		setUpMap()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		setUpFetchResultController()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		if fetchedResultsController.fetchedObjects?.count == 0 {
			searchFlickr()
		} else {
			toggleDebugLabel(false)
		}
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		searchTask?.cancel()
		fetchedResultsController = nil
	}
}
