//
//  FlickrResult.swift
//  Virtual Tourist
//
//  Created by Edward Morton on 8/1/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

// MARK: FlickrResult - Codable

struct FlickrResult: Codable {

	// MARK: - Properties

	let page: Int
	let pages: Int
	let perpage: Int
	let total: String
	let photo: [FlickrPhoto]

	// MARK: - CodingKeys - String, CodingKey

	enum CodingKeys: String, CodingKey {
		case page
		case pages
		case perpage
		case total
		case photo
	}
}
