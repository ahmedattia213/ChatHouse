//
//  UserCell.swift
//  ChatHouse
//
//  Created by Ahmed Amr on 2/13/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserCell: UITableViewCell {
    static let cellID = "cellid"

    var message: Message? {
        didSet {
            setupPartnerNameAndProfileImage()
            setupTime()
        }
    }

    private func setupPartnerNameAndProfileImage() {
        let chatPartnerId = message?.chatPartnerId()
        if let id = chatPartnerId {
            FirebaseHelper.fetchUserWithUid(id) { (user) in
                self.textLabel?.text = user.name
                self.profileImageView.retrieveDataFromUrl(urlString: user.profileImageUrl!)
                self.detailTextLabel?.text = self.message?.text != nil ? self.message!.text : "Sent an Image.."
            }
        }
    }

    private func setupTime() {
        if let seconds = message?.timestamp?.doubleValue {
            let timestampdate = NSDate(timeIntervalSince1970: seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateLabel.text = dateFormatter.string(from: timestampdate as Date)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: profileImageView.frame.maxX + 10, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: profileImageView.frame.maxX + 10, y: detailTextLabel!.frame.origin.y + 0.5, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }

    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()

    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(dateLabel)
        profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true

        dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        dateLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
