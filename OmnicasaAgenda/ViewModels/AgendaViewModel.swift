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
        let textChange: Observable<String?>
    }
    
    let api = OmnicasaWebAPI()
    let query = AppointmentsReq(UserIds: "109", From: Date.now.addingTimeInterval(-10*24*60*60))
    let appointmentCache = BehaviorRelay<[AppointmentItem]>(value: [])
    
    func makeBinding(input: Input) -> Output {
        
        let appointments = BehaviorRelay<[AppointmentItem]>(value: [])
        
        let observableTextSearch = input.textChange
            .asObservable()
            .distinctUntilChanged()
            .throttle(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
            .delay(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        
        let observableSearching = observableTextSearch.flatMap { [weak self]
            item -> Observable<[AppointmentItem]> in

            guard let selff = self else {
                return Observable.empty()
            }
            let keysearch = item ?? ""
            let keyFinal = keysearch.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if keyFinal.isEmpty {
                let getAppointments: Observable<[AppointmentItem]> = selff.api.request(method: .get, enpoint: OmnicasaWebAPIModules.appointments.rawValue, requestModel: selff.query)
                let result = getAppointments.map {
                    item in
                    return item.uniques(by: \.Id)
                }.do(
                    onNext: { [weak self]
                        items in
                        self?.appointmentCache.accept(items)
                    }
                )
                return result
            } else {
                return Observable.just(selff.appointmentCache.value.filter{
                    item1 in
                    return item1.CombineSubject.lowercased().contains(keyFinal.lowercased())
                })
            }
        }
        observableSearching.bind(to: appointments).disposed(by: disposeBag)
        
        let trackingRunning = Observable.merge (
            observableTextSearch.map { _ in true },
            observableSearching.map { _ in false }
        ).asDriver(onErrorJustReturn: false)
        
        return Output(trackingRunning: trackingRunning, appointments: appointments)
    }
}
