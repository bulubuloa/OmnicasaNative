//
//  OmnicasaWebAPI.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/22/21.
//

import Foundation
import RxSwift
import Alamofire

enum OmnicasaWebAPIModules: String {
    case appointments = "/appointments"
    case properties = "/properties"
    case tasks = "/tasks/search"
}

enum OmnicasaWebAPIError: Error {
    case inValidParameters
    case inValidURL
    case jsonError
    case expired
    case unknow
}

enum WebAPIMethod {
    case get
    case post
    case patch
}

extension DateFormatter {
  static let iso8601Omni: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}

class OmniAPIDecoder: JSONDecoder {
    
    override init() {
        super.init()
        dateDecodingStrategy = .iso8601
        keyDecodingStrategy = .convertFromSnakeCase
    }
}

class OmnicasaWebAPI {
    
    let rootAPI: String = "https://webapinew.omnicasa.com/13498.1.0"
    let headers = HTTPHeaders(["Authorization": "Bearer 5zTfRd4krojTaF7YMkMrIUH2PMMv9xY3pcgh2acnDE4.EXrpixeEgeEmNMoVs0XdJYsXJHRbDcs-UGxP_K3YpbA"])
    
    func request<T: Codable>(method: WebAPIMethod, enpoint: String, requestModel: ParametersReqModel?) -> Single<T> {
        var parameters: [String: Any] = [:]
        if let query = requestModel {
            parameters = try! query.getDicts()
        }

        switch method {
            case .get:
                return requestGet(endpoint: enpoint, query: parameters)
            case .post:
                return requestPost(endpoint: enpoint, query: parameters)
            case .patch:
                return requestGet(endpoint: enpoint, query: parameters)
        }
    }
    
    /*
     
     
    
     */
    func requestGet<T: Codable>(endpoint: String, query: [String: Any] = [:]) -> Single<T> {
        let singleReturn = Single<T>.create {
            single in
            
            let url = "\(self.rootAPI)\(endpoint)"
            print("requestGet => \(url)")
            let request = AF.request(url, parameters: query, headers: self.headers)
                .responseDecodable(of: T.self, decoder: OmniAPIDecoder()) {
                    response in
                    
                    guard let requestRespose = response.response else {
                        single(.failure(OmnicasaWebAPIError.unknow))
                        return
                    }
                    
                    switch requestRespose.statusCode {
                        case 200:
                            if let responseFinal = response.value {
                                single(.success(responseFinal))
                            } else {
                                single(.failure(OmnicasaWebAPIError.jsonError))
                            }
                        case 401:
                            single(.failure(OmnicasaWebAPIError.expired))
                        default:
                            single(.failure(OmnicasaWebAPIError.unknow))
                    }
                }
                
            return Disposables.create() {
                request.cancel()
            }
        }
        return singleReturn
    }
    
    func requestPost<T: Codable>(endpoint: String, query: [String: Any] = [:]) -> Single<T> {
        return Single<T>.create {
            single in
            
            let url = "\(self.rootAPI)\(endpoint)"
            print("requestPost => \(url)")
            let request = AF.request(url, method: .post, parameters: query, encoding: JSONEncoding.default, headers: self.headers)
                .responseDecodable(of: T.self, decoder: OmniAPIDecoder()) {
                    response in
                    guard let requestRespose = response.response else {
                        single(.failure(OmnicasaWebAPIError.unknow))
                        return
                    }
                    
                    switch requestRespose.statusCode {
                        case 200:
                            if let responseFinal = response.value {
                                single(.success(responseFinal))
                            } else {
                                single(.failure(OmnicasaWebAPIError.jsonError))
                            }
                        case 401:
                            single(.failure(OmnicasaWebAPIError.expired))
                        default:
                            single(.failure(OmnicasaWebAPIError.unknow))
                    }
                }
            
            return Disposables.create() {
                request.cancel()
            }
        }
    }
}
