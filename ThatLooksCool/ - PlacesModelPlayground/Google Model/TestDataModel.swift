//
//  TestDataModel.swift
//  ThatLooksCool
//
//  Created by Justin Lycklama on 2021-01-28.
//  Copyright © 2021 Justin Lycklama. All rights reserved.
//

import Moya
import Alamofire

import ObjectMapper
import Moya_ObjectMapper

import ClassicClient

/*
 The Basic Data SKU is triggered when any of these fields are requested: address_component, adr_address, business_status, formatted_address, geometry, icon, name, permanently_closed, photo, type, url, utc_offset, vicinity
 */

//struct GooglePlace : IdentifiableMappable {
//    var id: Id!
//
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//        id <- (map["id"], Id.transform)
//
//    }
//}


class TestRequest : CCRequest {
    typealias ServiceResponse = GooglePlace
    typealias ServiceTarget = TestTarget
    
    func getTarget() -> TestTarget {
        return .test
    }
}

enum TestTarget: CCTarget {
    case test
}

extension TestTarget {
    var path: String {
        return ""
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

extension TestTarget {
    var API_KEY: String {
        return ""
    }
    
    var baseURL: URL {
        return URL(string: "https://goo.gl/maps/WD3ZsR5zqGVgahcq8")!
    }
}
