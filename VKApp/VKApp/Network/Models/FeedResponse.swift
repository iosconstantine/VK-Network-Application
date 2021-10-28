//
//  FeedResponse.swift
//  VKApp
//
//  Created by KONSTANTIN TISHCHENKO on 28.10.2021.
//

import Foundation

protocol ProfileRepresenatable {
    var id: Int { get }
    var name: String { get }
    var photo: String { get }
}

protocol PhotoRepresenatable {
    var height: Int { get }
    var width: Int { get }
    var scrImage: String { get }
}

struct FeedResponseWrapped: Decodable {
    let response: FeedResponse
}

struct FeedResponse: Decodable {
    let items: [FeedItem]
    let profiles: [Profile]
    let groups: [Group]
}

struct Profile: Decodable, ProfileRepresenatable {
    let id: Int
    let firstName: String
    let lastName: String
    let photo100: String
    
    var name: String { return firstName + " " + lastName}
    var photo: String { return photo100 }
}

struct Group: Decodable, ProfileRepresenatable {
    let id: Int
    let name: String
    let photo100: String
    var photo: String { return photo100 }
}

struct FeedItem: Decodable {
    let sourceId: Int
    let postId: Int
    let date: Int
    let text: String?
    let comments: CountableItem?
    let likes: CountableItem?
    let reposts: CountableItem?
    let views: CountableItem?
    let attachments: [Attachments]?
}

struct Attachments: Decodable {
    let photo: Photo?
}

struct Photo: Decodable, PhotoRepresenatable {
    let sizes: [PhotoSize]
    
    var height: Int {
        return getSize().height
    }
    
    var width: Int {
        return getSize().width
    }
    
    var scrImage: String {
        return getSize().url
    }
    
    private func getSize() -> PhotoSize {
        if let sizeX = sizes.first(where: { $0.type == "x" }) {
            return sizeX
        } else if let lastSize = sizes.last {
            return lastSize
        } else {
            return PhotoSize(url: "", type: "", height: 0, width: 0)
        }
    }
}

struct PhotoSize: Decodable {
    let url: String
    let type: String
    let height: Int
    let width: Int
}

struct CountableItem: Decodable {
    let count: Int
}
