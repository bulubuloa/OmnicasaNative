//
//  TaskEditorViewController.swift
//  OmnicasaAgenda
//
//  Created by Omnimobile on 12/30/21.
//

import UIKit
import FontAwesome_swift

class TaskEditorViewController: AbstractUIViewController {

    @IBOutlet weak var bttClose: UIButton!
    @IBOutlet weak var bttSave: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    lazy var bttChoosePerson: UIButton = {
        let btt = UIButton()
        btt.setTitle("Choose person", for: .normal)
        return btt
    }()

    lazy var stackPerson: UIStackView = {
        let subviews: [UIView] = [bttChoosePerson]
        let view = UIStackView(arrangedSubviews: subviews)
        view.axis = .vertical
        view.spacing = 5
        view.backgroundColor = .red
        return view
    }()
    
    override func setupUI() {
        bttClose.titleLabel?.font = UIFont.fontAwesome(ofSize: 22, style: .brands)
        bttClose.setTitle(String.fontAwesomeIcon(name: .github), for: .normal)
        
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(stackPerson)
        //bttChoosePerson = UIButton(frame: CGRect(x: 0,y: 0, width: stackView.frame.width, height: 50))
        //stackView.addArrangedSubview(bttChoosePerson)
    }
    
    override func setupBinding() {
        self.bttChoosePerson.rx.tap.subscribe(
            onNext: { [self]
                item in
                self.openSearchPerson()
            }
        )
    }
    
    @objc func openSearchPerson() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "QueryViewController") as! QueryViewController
        vc.module = .searchProperty
        
        self.present(vc, animated: true, completion: nil)
    }
}
