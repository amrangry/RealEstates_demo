//
//  AdsTableViewCell.swift
//  RealEstate
//
//  Created by Amr ELghadban on 6/14/18.
//  Copyright © 2018 ADKA. All rights reserved.
//

import UIKit

class AdsTableViewCell: BaseTableViewCell {
    @IBOutlet var thumbnilImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func bindData(_ data: Displayable) {
        super.bindData(data)
        guard let ads = data as? AdRealEstate else {
            return
        }
        guard let imageName = ads.imagURl, let image = UIImage(named: imageName) else {
            return
        }

        thumbnilImageView.image = image
    }
}
