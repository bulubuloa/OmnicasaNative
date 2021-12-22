//
//  AgendaViewController.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/22/21.
//

import UIKit
import RxSwift
import Lottie
import RxRelay
import RxCocoa

class AgendaViewModel: AbstractViewModel {
    
}

class AgendaViewController: AbstractUIViewController {

    @IBOutlet weak var bttFilter: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animation: AnimationView!
    
    var appointments = BehaviorRelay<[AppointmentItem]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        animation.loopMode = .loop
        animation.play()
        
        tableView.register(UINib(nibName: "AppointmentTableViewCell", bundle: nil), forCellReuseIdentifier: "AppointmentTableViewCell_ID")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        
        let api = OmnicasaWebAPI()
        let query = AppointmentsReq(UserIds: "109", From: Date.now.addingTimeInterval(-14*24*60*60))
        let getAppointments: Observable<[AppointmentItem]> = api.request(method: .get, enpoint: OmnicasaWebAPIModules.appointments.rawValue, requestModel: query)
        
        getAppointments.subscribe (
            onNext: {
                result in
                let filters = result.uniques(by: \.Id)
                print(filters.map { $0.CombineSubject })
                self.animation.stop()
                self.appointments.accept(filters)
            }
        ).disposed(by: disposeBag)
        
        appointments.bind(to: tableView.rx.items(cellIdentifier: "AppointmentTableViewCell_ID", cellType: AppointmentTableViewCell.self)) {
            (index, element, cell) in
            
            cell.tfSub.text = element.CombineSubject
            cell.tfDate.text = element.StartTime + element.EndTime
        }.disposed(by: disposeBag)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
