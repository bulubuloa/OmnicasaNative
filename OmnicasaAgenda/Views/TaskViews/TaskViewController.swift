//
//  TaskViewController.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/23/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxDataSources

class TaskViewController: AbstractUIViewController {

    @IBOutlet weak var bttUsers: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var txtCount: UILabel!
    @IBOutlet var txtFull: UIView!
    @IBOutlet weak var txtFeetching: UILabel!
    
    @IBOutlet weak var txtMore: UILabel!
    let viewModel = TaskViewModel()
    let userIds = BehaviorRelay<[Int]>(value: [])
    
    override func setupUI() {
        tableView.register(UINib(nibName: "AppointmentTableViewCell", bundle: nil), forCellReuseIdentifier: "AppointmentTableViewCell_ID")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    override func setupBinding() {
        
        let indexOfItem = tableView.rx.willDisplayCell.map {
            item -> Int in
            return item.indexPath.section
        }.asDriver(onErrorJustReturn: 0)
        
        let input = TaskViewModel.Input(userIds: userIds, indexOfItem: indexOfItem)
        let output = viewModel.makeBinding(input: input)
        
        let dataSources = RxTableViewSectionedReloadDataSource<TaskGroup>(
            configureCell: {
                dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentTableViewCell_ID") as! AppointmentTableViewCell
                cell.tfSub.text = item.typeNameNL
                cell.tfDate.text = item.comment
                return cell
            },
            titleForHeaderInSection: {
                dataSource, index in
                return ISO8601DateFormatter().string(from:  dataSource.sectionModels[index].date)
            }
        )
        
        output.tasks.bind(to: tableView.rx.items(dataSource: dataSources)).disposed(by: disposeBag)
            
        output.tasks.map {
            item in
            let total = item.flatMap {
                group in
                return group.items
            }
            return "\(total.count)"
        }.bind(to: txtCount.rx.text).disposed(by: disposeBag)
        
        output.moreItems.map { item in !item }.drive(txtMore.rx.isHidden).disposed(by: disposeBag)
            
        bttUsers.rx.tap.subscribe(
            onNext: {
                item in
                self.openUsers()
            }
        ).disposed(by: disposeBag)
        
        userIds.map {
            userIds in
            userIds.map { String($0) }.joined(separator: ",")
        }.bind(to: bttUsers.rx.title()).disposed(by: disposeBag)
        
        self.rx.vi
    }
    
    func openUsers() {
        let alert = UIAlertController(title: "Users", message: "Please Select an Option", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "107", style: .default , handler:{ (UIAlertAction)in
                self.userIds.accept([107])
            }))
            
            alert.addAction(UIAlertAction(title: "109", style: .default , handler:{ (UIAlertAction)in
                self.userIds.accept([109])
            }))

            self.present(alert, animated: true, completion: {
                print("completion block")
            })
    }
}
