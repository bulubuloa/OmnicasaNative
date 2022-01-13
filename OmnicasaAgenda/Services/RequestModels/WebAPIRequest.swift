//
//  WebAPIRequest.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 1/10/22.
//

import Foundation

struct WebAPIRequestCondition: Codable {
    var SearchText: String?
}

struct WebAPIRequest: ParametersReqModel {
    var PageIndex: Int
    var PageSize: Int
    var Condition: WebAPIRequestCondition?
}

//extension WebAPIRequest {
//    func getDicts() -> [String: Any] {
//        let data = try! JSONEncoder.init().encode(self)
//        let dictionary = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
//        return dictionary
//    }
//}
