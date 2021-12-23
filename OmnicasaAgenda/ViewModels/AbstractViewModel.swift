//
//  AbstractViewModel.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/22/21.
//

import Foundation
import RxSwift

class AbstractViewModel: NSObject {
    var disposeBag = DisposeBag()
    
    override init() {
        super.init()
    }
}
