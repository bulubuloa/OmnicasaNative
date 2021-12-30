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
    let headers = HTTPHeaders(["Authorization": "Bearer xKZ2nLqVcIT_LFVYqsaoabbbWyo73xVIgxDV-Q_LxH4.lGAlVB7rDcVqP72KGXI95GLGk0E6MuLUfSw6yNfDgGY"])
    
    func request<T: Codable>(method: WebAPIMethod, enpoint: String, requestModel: ParametersReqModel?) -> Observable<T> {
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
    func requestGet<T: Codable>(endpoint: String, query: [String: Any] = [:]) -> Observable<T> {
        do {
            return Observable<T>.create {
                observe in
                
                let disposable = Disposables.create()
                let url = "\(self.rootAPI)\(endpoint)"
                
                print("requestGet => \(url)")
                AF.request(url, parameters: query, headers: self.headers)
                    .responseDecodable(of: T.self, decoder: OmniAPIDecoder()) {
                        response in
                        guard let responseFinal = response.value else {
                            observe.onError(OmnicasaWebAPIError.jsonError)
                            return
                        }
                        
                        observe.onNext(responseFinal)
                        observe.onCompleted()
                    }
                
                return disposable
            }
        } catch {
            return Observable.empty()
        }
    }
    
    func requestPost<T: Codable>(endpoint: String, query: [String: Any] = [:]) -> Observable<T> {
        do {
            return Observable<T>.create {
                observe in
                
                let disposable = Disposables.create()
                let url = "\(self.rootAPI)\(endpoint)"
                
                print("requestPost => \(url)")
                
                AF.request(url, method: .post, parameters: query, encoding: JSONEncoding.default, headers: self.headers)
                    .responseDecodable(of: T.self, decoder: OmniAPIDecoder()) {
                        response in
                        guard let responseFinal = response.value else {
                            observe.onError(OmnicasaWebAPIError.jsonError)
                            return
                        }
                        
                        observe.onNext(responseFinal)
                        observe.onCompleted()
                    }
                
                return disposable
            }
        } catch {
            return Observable.empty()
        }
    }
    
    func requestGetString(endpoint: String, query: [String: Any] = [:]) -> Observable<String> {
        do {
            return Observable<String>.create {
                observe in
                
                let disposable = Disposables.create()
                let url = "\(self.rootAPI)\(endpoint)"
                
                print("requestGet => \(url)")
                AF.request(url, parameters: query, headers: self.headers)
                    .responseString() {
                        response in
                        guard let responseFinal = response.value else {
                            observe.onError(OmnicasaWebAPIError.jsonError)
                            return
                        }
                        
                        observe.onNext(responseFinal)
                        observe.onCompleted()
                    }
                
                return disposable
            }
        } catch {
            return Observable.empty()
        }
    }
}
