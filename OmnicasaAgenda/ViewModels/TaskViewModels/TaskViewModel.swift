//
//  TaskViewModel.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/23/21.
//

import Foundation
import RxRelay
import RxCocoa
import RxSwift
import RxDataSources
import Alamofire

extension Date {
    func justDate() -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            return self
        }
        return date
    }
}

struct TaskGroup: SectionModelType {
    var header: String
    var date: Date
    var items: [TasksModelItem]
}

extension TaskGroup {
    typealias Item = TasksModelItem
    
    init(original: TaskGroup, items: [TasksModelItem]) {
        self = original
        self.items = items
    }
}

class TaskViewModel : AbstractViewModel {
    var defaultParameters = TasksReq(PageIndex: 1, PageSize: 50, OrderBy: TaskOrderBy.desc.rawValue,Condition: TasksReqCondition(UserIds: [107]))
    
    struct Input {
        let userIds: BehaviorRelay<[Int]>
        let indexOfItem: Driver<Int>
    }
    
    struct Output {
        let tasks: BehaviorRelay<[TaskGroup]>
        let moreItems: Driver<Bool>
        let loading: Driver<Bool>
    }
    
    func makeBinding(input: Input) -> Output {
        let taskResults = BehaviorRelay<[TaskGroup]>(value: [])
        
        let observableTrackingAvailableSource = BehaviorRelay<Bool>(value: true)
        let observableTrackingLoadingStatus = BehaviorRelay<Bool>(value: false)
        
        let observableTrackingParameters = BehaviorRelay<TasksReq>(value: defaultParameters)
        let observableTrackingUserIds = input.userIds.map {
            userIds -> TasksReq in
            self.defaultParameters = TasksReq(PageIndex: 1, PageSize: 50, OrderBy: TaskOrderBy.desc.rawValue,Condition: TasksReqCondition(UserIds: userIds))
            return self.defaultParameters
        }
                
        let observableGetTasks = Observable.merge(
            observableTrackingParameters.asObservable().skip(1),
            observableTrackingUserIds.skip(1))
            .flatMapLatest {
                feetchParameters -> Observable<[TaskGroup]> in
                
                let getTask: Single<TasksRes> = self.api.request(method: .post, enpoint: OmnicasaWebAPIModules.tasks.rawValue, requestModel: feetchParameters)
                    //.delay(RxTimeInterval.seconds(5), scheduler: MainScheduler.instance)
                    .catchAndReturn(TasksRes(records: []))
                
                let results = getTask
                    .map {
                        item in
                        return item.records }
                    .map {
                        items -> [TaskGroup] in
                        let group = Dictionary.init(grouping: items, by: { $0.date?.justDate() })
                        var result = [TaskGroup]()
                        for item in group {
                            let head = TaskGroup(header: "", date: item.key!, items: item.value)
                            result.append(head)
                        }
                        return result.sorted { a,b in a.date > b.date }
                    }
                return results.asObservable()
            }
            .share()
        
        
        observableGetTasks
            .map {  items in
                    self.defaultParameters.PageIndex == 1 ? items : taskResults.value + items }
            .bind(to: taskResults)
            .disposed(by: disposeBag)
        
        observableGetTasks
            .map {  items in
                    return items.count > 0 }
            .bind(to: observableTrackingAvailableSource)
            .disposed(by: disposeBag)

        Observable
            .merge( observableTrackingParameters.asObservable().map { _ in true },
                    observableTrackingUserIds.map { _ in true },
                    observableGetTasks.map { _ in false })
            .bind(to: observableTrackingLoadingStatus).disposed(by: disposeBag)
        
        input.indexOfItem
            .asObservable()
            .distinctUntilChanged()
            .filter{    index in
                        return index == taskResults.value.count - 3 && index != 0 }
            .filter{    index in
                        return !observableTrackingLoadingStatus.value && observableTrackingAvailableSource.value }
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(
                onNext: {   index in
                            self.defaultParameters.PageIndex += 1
                            observableTrackingParameters.accept(self.defaultParameters)})
            .disposed(by: disposeBag)
        
        return Output(
            tasks: taskResults,
            moreItems: observableTrackingAvailableSource.asDriver(onErrorJustReturn: false),
            loading: observableTrackingLoadingStatus.asDriver(onErrorJustReturn: false))
    }
}
