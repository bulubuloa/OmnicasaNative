//
//  AppointmentsReq.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/22/21.
//

import Foundation

struct AppointmentsReq : ParametersReqModel {
    let UserIds: String
    let From: Date
}
