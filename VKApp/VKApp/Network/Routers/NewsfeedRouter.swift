//
//  NewsfeedRouter.swift
//  VKApp
//
//  Created by KONSTANTIN TISHCHENKO on 28.10.2021.
//

import Foundation
import Alamofire

enum NewsfeedRouter: URLRequestConvertible {
    case getNews
    
    private var baseURL: URL {
        return URL(string: "https://api.vk.com/method")!
    }
    
    private var method: HTTPMethod {
        switch self {
        case .getNews: return .get
        }
    }
    
    private var path: String {
        switch self {
        case .getNews: return "/newsfeed.get"
        }
    }
    
    private var parameters: Parameters {
        switch self {
        case .getNews: return [
            "filters": "post, photo",
            "start_from": "next_from",
            "count" : 20,
            "access_token": Session.shared.token,
            "v": String(Session.shared.versionApi)]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
