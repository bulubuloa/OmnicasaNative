//
//  TasksReq.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/24/21.
//

import Foundation

enum TaskOrderBy: String {
    case desc = "desc"
    case esc = "esc"
}

struct TasksReqCondition: ParametersReqModel {
    let UserIds: [Int]
}

struct TasksReq: ParametersReqModel {
    var PageIndex: Int
    let PageSize: Int
    let OrderBy: String
    let Condition: TasksReqCondition?
}
