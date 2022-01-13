//
//  QueryViewController.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/31/21.
//

import UIKit
import Lottie
import RxRelay
import RxCocoa
import RxSwift
import LoadingShimmer

class RXXUISearchBarDelegateProxy : DelegateProxy<UISearchBar,UISearchBarDelegate>, UISearchBarDelegate, DelegateProxyType {
    weak private(set) var mapView: UISearchBar?
    
    init(mapview: ParentObject) {
        self.mapView = mapview
        super.init(parentObject: mapview, delegateProxy: RXXUISearchBarDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register {
            RXXUISearchBarDelegateProxy(mapview: $0)
        }
    }
    
//    static func currentDelegate(for object: UISearchBar) -> UISearchBarDelegate? {
//        return object.delegate
//    }
//
//    static func setCurrentDelegate(_ delegate: UISearchBarDelegate?, to object: UISearchBar) {
//        object.delegate = delegate
//    }
    
    
    
   
}

//class RXUISearchBarDelegateProxy : DelegateProxy<UISearchBar,UISearchBarDelegate>, UISearchBarDelegate,DelegateProxyType{
//
//    weak private(set) var searchBar: UISearchBar?
//
//    init(searchBar: ParentObject) {
//        self.searchBar = searchBar
//        super.init(parentObject: searchBar, delegateProxy: RXUISearchBarDelegateProxy.self)
//    }
//
//    static func registerKnownImplementations() {
//        self.register {
//            RXUISearchBarDelegateProxy(searchBar: $0)
//        }
//    }
//
//    static func currentDelegate(for object: UISearchBar) -> UISearchBarDelegate? {
//        return object.delegate
//    }
//
//    static func setCurrentDelegate(_ delegate: UISearchBarDelegate?, to object: UISearchBar) {
//        object.delegate = delegate
//    }
//}

public extension Reactive where Base : UISearchBar {
    var delegate: DelegateProxy<UISearchBar,UISearchBarDelegate> {
        return RXXUISearchBarDelegateProxy.proxy(for: base)
    }
    
    func setDelegate(_ delegate: UISearchBarDelegate) -> Disposable {
        RXXUISearchBarDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
    }
    
    var didSearchWithText : Observable<String?> {
        delegate
            .methodInvoked(#selector(UISearchBarDelegate.searchBarSearchButtonClicked(_:)))
            .map {
                item in
                return ""
            }
    }
}


class QueryViewController: AbstractUIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animationView: AnimationView!
    
    let viewModel = QueryViewModel()
    var module: APIRoute = .searchPerson
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupUI() {
        animationView.isHidden = true
        animationView.loopMode = .loop
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
    }
    
    override func setupBinding() {
        let parameterRelay = BehaviorRelay<QueryParameters?>(value: nil)

        searchBar.rx.searchButtonClicked
            .subscribe(
                onNext: { [weak self]
                    item in
                    let keyWord: String? = self?.searchBar.text
                    let parameter = QueryParameters(keyword: keyWord)
                    parameterRelay.accept(parameter) })
            .disposed(by: disposeBag)
        
        let displayAtIndex = tableView.rx.willDisplayCell
            .map {
                cellAt in
                return cellAt.indexPath.row }
            .asDriver(onErrorJustReturn: 0)
        
        let input = QueryViewModel.Input(searchParameter:parameterRelay, displayItemAtIndex: displayAtIndex, module: self.module)
        let output = viewModel.makeBinding(input: input)
        
        output.results
            .bind(to: tableView.rx.items(cellIdentifier: "TaskTableViewCell", cellType: TaskTableViewCell.self)) {
                row, element, cell in
                cell.txtType.text = element.name
                cell.txtComment.text = element.reference }
            .disposed(by: disposeBag)
        
        output.loading
            .skip(1)
            .do(
                onNext: { [weak self]
                    loadding in
                    if loadding {
                        LoadingShimmer.startCovering(self?.animationView, with: nil)
                    } else {
                        LoadingShimmer.stopCovering(self?.animationView)
                    }
                })
            .drive(animationView.rx.playAlsoHide)
            .disposed(by: disposeBag)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    deinit {
        print("Dispose QueryViewController")
    }
}
