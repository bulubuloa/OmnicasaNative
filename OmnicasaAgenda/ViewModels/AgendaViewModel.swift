//
//  AgendaViewModel.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/22/21.
//

import Foundation
import UIKit
import RxSwift
import Lottie
import RxRelay
import RxCocoa

class AgendaViewModel : AbstractViewModel {
    
    struct Output {
        let trackingRunning: Driver<Bool>
        let appointments: BehaviorRelay<[AppointmentItem]>
    }
    
    struct Input {
        let textChange: Driver<String>
    }
    
    let api = OmnicasaWebAPI()
    let query = AppointmentsReq(UserIds: "109", From: Date.now.addingTimeInterval(-10*24*60*60))
    let appointmentCache = BehaviorRelay<[AppointmentItem]>(value: [])
    
    func makeBinding(input: Input) -> Output {
        
        let appointments = BehaviorRelay<[AppointmentItem]>(value: [])
        
        let observableTextSearch = input.textChange
            .skip(1)
            .asObservable()
            .distinctUntilChanged()
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            
        let flatKeyToSearch = observableTextSearch.flatMapLatest {
            item -> Observable<[AppointmentItem]> in
            let keySearch = item.trimmingCharacters(in: .whitespacesAndNewlines)
            if keySearch.isEmpty {
                
                let getAppointments: Observable<[AppointmentItem]> = self.api.request(method: .get, enpoint: OmnicasaWebAPIModules.appointments.rawValue, requestModel: self.query)
                let result = getAppointments.map {
                    item in
                    return item.uniques(by: \.Id)
                    
                }.do(
                    onNext: {
                        item in
                        self.appointmentCache.accept(item)
                    }
                )
                
                return result
           } else {
               return Observable.just(self.appointmentCache.value.filter {
                   item1 in
                   return item1.CombineSubject.lowercased().contains(keySearch.lowercased())
                })
            }
        }.share(replay: 1, scope: .forever)
         
        //<-- that it facking shit
        flatKeyToSearch.bind(to: appointments).disposed(by: disposeBag)

        let trackingRunning = Observable.merge (
            observableTextSearch.map { _ in true },
            flatKeyToSearch.map { _ in false }
        ).asDriver(onErrorJustReturn: false)
        
        return Output(trackingRunning: trackingRunning, appointments: appointments)
    }
}
