//
//  GooglePlacesModel.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-09-22.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import Moya
import Alamofire

import ObjectMapper
import Moya_ObjectMapper

import ClassicClient

/*
 The Basic Data SKU is triggered when any of these fields are requested: address_component, adr_address, business_status, formatted_address, geometry, icon, name, permanently_closed, photo, type, url, utc_offset, vicinity
 */

struct GooglePlace : IdentifiableMappable {
    var id: Id!

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- (map["id"], Id.transform)

    }
}


class GooglePlacesRequest : CCRequest {    
    typealias ServiceResponse = GooglePlace
    typealias ServiceTarget = GooglePlacesTarget
    
    func getTarget() -> GooglePlacesTarget {
        return .getPlaces
    }
}

enum GooglePlacesTarget: CCTarget {
    case getPlaces
}

extension GooglePlacesTarget {
    var path: String {
        return "plants"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return Task.requestPlain
//        return Task.requestParameters(parameters: ["token" : API_KEY], encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
//            return ["token" : API_KEY]
        return nil
    }
}

extension GooglePlacesTarget {
    var API_KEY: String {
        return ""
    }
    
    var baseURL: URL {
        return URL(string: "")!
    }
}
