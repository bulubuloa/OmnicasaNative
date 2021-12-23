//
//  AbstractViewController.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/22/21.
//

import Foundation
import UIKit
import Alamofire
import RxSwift

class AbstractUIViewController : UIViewController {
    let disposeBag = DisposeBag()
    
    func setupUI() {
        
    }
    
    func setupBinding() {
        
    }
    
    override func viewDidLoad() {
        setupUI()
        setupBinding()
    }
}
