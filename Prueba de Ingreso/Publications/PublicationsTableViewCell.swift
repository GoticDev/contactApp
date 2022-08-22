//
//  PublicationsTableViewCell.swift
//  Prueba de Ingreso
//
//  Created by Victor De la Torre on 21/08/22.
//

import UIKit

class PublicationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var publicationTitle: UILabel!
    @IBOutlet weak var publicationDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setInitialLabel()
    }

    func publicationData(data: PublicationsResponse) {
        publicationTitle.text = data.title
        publicationDescription.text = data.body
    }
    
    private func setInitialLabel() {
        publicationTitle.textColor = .blue
    }
     
}
