//
//  Loopable.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/22/21.
//

import Foundation


protocol Loopable {
    func allProperties() throws -> [String: Any]
    func jsonProperties() throws -> String
}

extension Loopable {
    func allProperties() throws -> [String: Any] {
        var result: [String: Any] = [:]
        
        let mirror = Mirror(reflecting: self)
        guard let typeOf = mirror.displayStyle, typeOf == .struct || typeOf == .class else {
            throw NSError()
        }
        
        for child in mirror.children {
            guard let property = child.label else {
                continue
            }
            
            let mirrorChild = Mirror(reflecting: child)
            if type(of: child.value) == Date.self {
                let dateFormmat = DateFormatter()
                dateFormmat.dateFormat = "yyyy-MM-dd"
                result[property] = dateFormmat.string(from:  child.value as! Date)
            } else {
                result[property] = child.value
            }
        }
        
        return result
    }
}
