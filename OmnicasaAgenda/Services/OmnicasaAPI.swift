//
//  OmnicasaAPI.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/31/21.
//

import Foundation
import RxSwift

class OmnicasaAPIContext {
    static var rootAPI: String = "https://webapinew.omnicasa.com/13498.1.0"
}

enum APIRoute {
    case searchPerson
    case searchProperty
    case searchTask
}

extension APIRoute {
    var apiPath: String {
        switch self {
        case .searchPerson:
            return "/persons/search"
        case .searchProperty:
            return "/properties/search"
        case .searchTask:
            return "/tasks/search"
        }
    }
}


protocol IPersonService {
    func searchPerson(parameters: WebAPIRequest) -> Single<[PersonModel]>
}

protocol IPropertyService {
    func searchProperty(parameters: WebAPIRequest) -> Single<[PropertyModel]>
}

protocol ITaskService {
    func searchProperty(parameters: WebAPIRequest) -> Single<[TaskModel]>
}

struct PersonService : IPersonService {
    func searchPerson(parameters: WebAPIRequest) -> Single<[PersonModel]> {
        let ob: Single<WebAPIResponse<PersonModel>> = OmnicasaWebAPI().request(method: .post, enpoint: APIRoute.searchPerson.apiPath, requestModel: parameters)
        return ob.map {
            response in
            if let items = response.records {
                return items
            }
            return []
        }
    }
}
struct PropertyService : IPropertyService {
    func searchProperty(parameters: WebAPIRequest) -> Single<[PropertyModel]> {
        let ob: Single<WebAPIResponse<PropertyModel>> = OmnicasaWebAPI().request(method: .post, enpoint: APIRoute.searchProperty.apiPath, requestModel: parameters)
        return ob.map{
            response in
            if let items = response.records {
                return items
            }
            return []
        }
    }
}
