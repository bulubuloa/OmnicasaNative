//
//  QueryViewModel.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/31/21.
//

import Foundation
import RxSwift
import RxCocoa

struct QueryPaging {
    var PageIndex: Int
    var PageSize: Int
}

struct QueryParameters {
    let keyword: String?
}

extension APIRoute {
    
}

class QueryViewModel : AbstractViewModel {
    deinit {
        print("Dispose QueryViewModel")
    }
    
    let defaultQueryParameter:WebAPIRequest = WebAPIRequest(PageIndex: 1, PageSize: 20)
    
    struct Input {
        let searchParameter: BehaviorRelay<QueryParameters?>
        let displayItemAtIndex: Driver<Int>
        let module: APIRoute
    }
    
    struct Output {
        let loading: Driver<Bool>
        let results: BehaviorRelay<[QueryModel]>
    }
    
    lazy var personService: IPersonService = {
        var service = PersonService()
        return service
    }()
    
    lazy var propertyService: IPropertyService = {
        var service = PropertyService()
        return service
    }()
    
    func makeBinding(input: Input) -> Output {
        let queryResult = BehaviorRelay<[QueryModel]>(value: [])
        let observableTrackingAvailableSource = BehaviorRelay<Bool>(value: true)
        let observableTrackingLoadingState = BehaviorRelay<Bool>(value: false)
        
        let observableTrackingQueryParameter = BehaviorRelay<WebAPIRequest>(value: defaultQueryParameter)
        
        input.searchParameter
            .map {
                rawParameters in
                var newQueryParameter = WebAPIRequest(PageIndex: 1, PageSize: 20)
                newQueryParameter.Condition = WebAPIRequestCondition(SearchText: rawParameters?.keyword)
                return newQueryParameter }
            .bind(to: observableTrackingQueryParameter)
            .disposed(by: disposeBag)
        
        let observableQueryItems = observableTrackingQueryParameter.flatMapLatest { [weak self]
            queryParameters -> Observable<[QueryModel]> in
            var getItems: Single<[QueryModel]>
            
            if let self = self {
                switch input.module {
                    case .searchProperty:
                        getItems = self.propertyService.searchProperty(parameters: queryParameters)
                            .retry(3)
                            .catchAndReturn([])
                            .map {
                                items in
                                let result = items.map { $0.queryModel() }
                                observableTrackingAvailableSource.accept(result.count > 0)
                                
                                if queryParameters.PageIndex == 1 {
                                    return result
                                } else {
                                    return queryResult.value + result
                                }
                            }
                    case .searchPerson:
                        getItems = self.personService.searchPerson(parameters: queryParameters)
                            .retry(3)
                            .catchAndReturn([])
                            .map {
                                items in
                                let result = items.map { $0.queryModel() }
                                observableTrackingAvailableSource.accept(result.count > 0)
                                
                                if queryParameters.PageIndex == 1 {
                                    return result
                                } else {
                                    return queryResult.value + result
                                }
                            }
                    default:
                        getItems = Observable.just([]).asSingle()
                 }
            } else {
                getItems = Observable.just([]).asSingle()
            }
            
            return getItems.asObservable()
        }.share()
        
        input.displayItemAtIndex
            .asObservable()
            .distinctUntilChanged()
            .filter {
                index in
                return index != 0 && index == queryResult.value.count - 3 }
            .filter {
                index in
                return !observableTrackingLoadingState.value && observableTrackingAvailableSource.value}
            .throttle(RxTimeInterval.milliseconds(200), scheduler: MainScheduler.instance)
            .map {
                index in
                var currentParameter = observableTrackingQueryParameter.value
                currentParameter.PageIndex += 1
                return currentParameter }
            .do( onDispose: { print("Request load dispose") } )
            .bind(to: observableTrackingQueryParameter)
            .disposed(by: disposeBag)
        
       observableQueryItems
            .bind(to: queryResult)
            .disposed(by: disposeBag)
        
        Observable.merge(
            observableTrackingQueryParameter.map { _ in true },
            observableQueryItems.map { _ in false })
            .bind(to: observableTrackingLoadingState)
            .disposed(by: disposeBag)
        
        return Output(
            loading: observableTrackingLoadingState.asDriver(),
            results: queryResult)
    }
}
