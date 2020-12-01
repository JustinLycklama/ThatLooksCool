//
//  FourSquareModel.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2020-09-23.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import Moya
import Alamofire

import ObjectMapper
import Moya_ObjectMapper

import TLCModel
import ClassicClient

struct FSEnvelope<T: Mappable>: EnvelopeType {
    var responseList: [T]?
    
    
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        // For now, force the selection of the first element. Won't be like that in the future.
        responseList <- map["data"]
    }
}

struct FSPlace : IdentifiableMappable {
    var id: Id!

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- (map["id"], Id.transform)
    }
}


class FSPlacesRequest : CCRequest {
    typealias ServiceEnvelope = FSEnvelope<FSPlace>
    typealias ServiceResponse = FSPlace
    typealias ServiceTarget = FSPlacesTarget
    
    let coordinate: Coordinate
    
    init(coordinate: Coordinate) {
        self.coordinate = coordinate
    }
    
    func getTarget() -> FSPlacesTarget {
        return .getPlaces(coordinate)
    }
}

enum FSPlacesTarget: CCTarget {
    case getPlaces(_ coordinates: Coordinate)
}


/*
 client_id='CLIENT_ID',
 client_secret='CLIENT_SECRET',
 v='20180323',
 ll='40.7243,-74.0018',
 query='coffee',
 limit=1
 */

extension FSPlacesTarget {
    var path: String {
        return "venues/explore"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        var defaultHeaders = ["client_id" : CLIENT_ID, "client_secret" : CLIENT_SECRET, "v" : VERSION]
        
        if let optionalHeaders = headers {
            defaultHeaders.merge(optionalHeaders) { (a: String, b: String) -> String in
                return a + b
            }
        }

        return Task.requestParameters(parameters: defaultHeaders, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        switch  self {
        case .getPlaces(let coordinate):
            return ["ll" : "\(coordinate.latitude), \(coordinate.longitude)", "radius" : "250"] // TODO: Reduce Radius
        }
    }
}

extension FSPlacesTarget {
    var CLIENT_ID: String {
        return "QOMKNXLQZ2WEKRWXMWOJSCTMVEKCQRFQXYE4SQX5AMJCHSZG"
    }
    
    var CLIENT_SECRET: String {
        return "OX0P234BVN4CXVM5Z0VDL43VCWSH3QRFHSUWCXINP5G5WZFE"
    }
    
    // v=YYYYMMDD Keep it updated to development dates, not the current date
    var VERSION: String {
        return "20200923"
    }
    
    var baseURL: URL {
        return URL(string: "https://api.foursquare.com/v2/")!
    }
}
