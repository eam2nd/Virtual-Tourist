//
//  PhotoViewController+MapDelegate.swift
//  Virtual Tourist
//
//  Created by Edward Morton on 8/1/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import MapKit

// MARK: PhotoViewController - MKMapViewDelegate

extension PhotoViewController: MKMapViewDelegate {

	// MARK: - Methods

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		let reuseId = "pin"
		var pin = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

		if pin == nil {
			pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			pin?.canShowCallout = false
			pin?.animatesDrop = true
		} else {
			pin?.annotation = annotation
		}

		return pin
	}
}
