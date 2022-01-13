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


class AgendaViewController: AbstractUIViewController {

    @IBOutlet weak var bttFilter: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animation: AnimationView!
    
    let viewModel = AgendaViewModel()
    
    override func setupUI() {
        animation.isHidden = true
        animation.loopMode = .loop
        
        tableView.register(UINib(nibName: "AppointmentTableViewCell", bundle: nil), forCellReuseIdentifier: "AppointmentTableViewCell_ID")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    override func setupBinding() {
        let input = AgendaViewModel.Input(textChange: searchBar.rx.text.orEmpty.asDriver())
        let output = viewModel.makeBinding(input: input)

        output.appointments.bind(to: tableView.rx.items(cellIdentifier: "AppointmentTableViewCell_ID", cellType: AppointmentTableViewCell.self)) {
            (index, element, cell) in
            cell.tfSub.text = element.CombineSubject
            cell.tfDate.text = element.StartTime + element.EndTime
        }.disposed(by: disposeBag)

        output.trackingRunning.drive(animation.rx.playAlsoHide).disposed(by: disposeBag)
        output.trackingRunning.drive(bttFilter.rx.isHidden).disposed(by: disposeBag)
    }
}


extension AgendaViewController {
    
}
