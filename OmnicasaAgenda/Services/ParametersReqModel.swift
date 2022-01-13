//
//  ParametersReqModel.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/29/21.
//

import Foundation


protocol ParametersReqModel : Encodable {
    func getDicts() -> [String: Any]
}

extension ParametersReqModel {
    func getDicts() -> [String: Any] {
        let data = try! JSONEncoder.init().encode(self)
        let dictionary = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        return dictionary
    }
}
