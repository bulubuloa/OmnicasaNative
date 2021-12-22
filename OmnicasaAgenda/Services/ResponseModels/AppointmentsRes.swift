//
//  AppointmentsRes.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/22/21.
//

import Foundation

struct AppointmentsRes {
    
}

struct AppointmentItem: Codable {
    let CombineSubject: String
    let Id: Double
    let StartTime: String
    let EndTime: String
    
    enum CodingKeys: String, CodingKey {
        case CombineSubject
        case Id
        case StartTime
        case EndTime
    }
}
