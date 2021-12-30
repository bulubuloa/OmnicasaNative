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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupUI() {
        bttClose.titleLabel?.font = UIFont.fontAwesome(ofSize: 22, style: .brands)
        bttClose.setTitle(String.fontAwesomeIcon(name: .github), for: .normal)
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
