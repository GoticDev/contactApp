//
//  BaseViewController.swift
//  Prueba de Ingreso
//
//  Created by Victor De la Torre on 22/08/22.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .backgroundPrueba
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem?.tintColor = .white
        self.navigationController?.navigationBar.backgroundColor = .principalColor
    }
}
