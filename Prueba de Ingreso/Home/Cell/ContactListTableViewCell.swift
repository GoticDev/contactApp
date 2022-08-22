//
//  ContactListTableViewCell.swift
//  Prueba de Ingreso
//
//  Created by Victor De la Torre on 21/08/22.
//

import UIKit
import CoreData

class ContactListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactNumber: UILabel!
    @IBOutlet weak var contactEmail: UILabel!
    @IBOutlet weak var showPublicationsLabel: UILabel!
    @IBOutlet weak var phoneIcon: UIImageView!
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var contentCell: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setIcons()
        setInitialSetup()
        roundCell()
    }
    
    func contactData(data: ContactListResponse) {
        contactName.text = data.name
        contactNumber.text = data.phone
        contactEmail.text = data.email
    }
    
    func contactStorageData(data: ContactsStorage) {
        contactName.text = data.name
        contactNumber.text = data.phone
        contactEmail.text = data.email
    }
    
    private func setIcons() {
        phoneIcon.image = UIImage(systemName: "phone.fill")
        emailIcon.image = UIImage(systemName: "envelope.fill")
    }
    
    private func setInitialSetup() {
        contactName.textColor = .principalColor
        contactName.font = .PI1
        contactNumber.font = .PI2
        contactEmail.font = .PI2
        showPublicationsLabel.textColor = .principalColor
        showPublicationsLabel.font = .PI3
    }
    
    private func roundCell() {
        contentCell.layer.cornerRadius = 4
        contentCell.dropShadow(color: .gray, offSet: CGSize(width: 2, height: 1))
    }
}
