//
//  FlickrResponse.swift
//  Virtual Tourist
//
//  Created by Edward Morton on 8/1/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

// MARK: FlickrResponse - Codable

struct FlickrResponse: Codable {

	// MARK: - Properties

	let photos: FlickrResult
	let stat: String
}
