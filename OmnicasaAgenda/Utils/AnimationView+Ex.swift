//
//  AnimationView+Ex.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/23/21.
//

import Foundation
import Lottie
import RxSwift

extension Reactive where Base : AnimationView {
    var playing: Binder<Bool> {
        Binder(base) {
            animationView, play in
            if play {
                animationView.play()
            } else {
                animationView.stop()
            }
        }
    }
}
