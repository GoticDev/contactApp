//
//  ContactListTableViewCell.swift
//  Prueba de Ingreso
//
//  Created by Victor De la Torre on 21/08/22.
//

import UIKit

class ContactListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactNumber: UILabel!
    @IBOutlet weak var contactEmail: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func contactData(data: ContactListResponse) {
        contactName.text = data.name
        contactNumber.text = data.phone
        contactEmail.text = data.email
    }
    
}
