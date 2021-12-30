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
    let api = OmnicasaWebAPI()
    
    override init() {
        super.init()
    }
}
