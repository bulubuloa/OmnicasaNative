//
//  WebAPIResponse.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 1/10/22.
//

import Foundation

struct WebAPIPagination: Codable {
    let pageIndex: Int
    let pageSize: Int
    let pageCount: Int
    let totalRecords: Int
    
    enum CodingKeys: String, CodingKey {
        case pageIndex = "PageIndex"
        case pageSize = "PageSize"
        case pageCount = "PageCount"
        case totalRecords = "TotalRecords"
    }
}


struct WebAPIResponse<T: Codable>: Codable {

    typealias recordItems = [T]
    
    let pagination: WebAPIPagination?
    let records: recordItems?

    enum CodingKeys: String, CodingKey {
        case pagination = "Pagination"
        case records = "Records"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pagination = try? container.decode(WebAPIPagination.self, forKey: .pagination)
        records = try? container.decode(recordItems.self, forKey: .records)
    }
}
