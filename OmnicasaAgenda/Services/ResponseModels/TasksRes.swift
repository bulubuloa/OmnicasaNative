//
//  TasksRes.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/24/21.
//

import Foundation

struct TasksModelItem : Codable {
    
    let id: Double
    let typeNameNL: String?
    let comment: String?
    let date: Date?
    let typeIconUrl: String?
    let isDone: Bool?
    let isDeleted: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case typeNameNL = "TypeNameNL"
        case comment = "Comment"
        case date = "Date"
        case typeIconUrl = "TypeIconUrl"
        case isDone = "IsDone"
        case isDeleted = "IsDeleted"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        var rawDate = try container.decode(String.self, forKey: .date)
        rawDate = rawDate.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        date = formatter.date(from: rawDate)
        
        id = try container.decode(Double.self, forKey: .id)
        typeNameNL = try? container.decode(String.self, forKey: .typeNameNL)
        comment = try? container.decode(String.self, forKey: .comment)
        typeIconUrl = try? container.decode(String.self, forKey: .typeIconUrl)
        isDone = try? container.decode(Bool.self, forKey: .isDone)
        isDeleted = try? container.decode(Bool.self, forKey: .isDeleted)
    }
}

struct TasksRes: Codable {
    let records: [TasksModelItem]
    
    enum CodingKeys: String, CodingKey {
        case records = "Records"
    }
}
