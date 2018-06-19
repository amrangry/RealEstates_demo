//
//  RealEstateTableViewCell.swift
//  RealEstate
//
//  Created by Amr ELghadban on 6/13/18.
//  Copyright © 2018 ADKA. All rights reserved.
//

import UIKit

typealias FavBtnPressed = (_ isPressed: Bool?) -> Void

class RealEstateTableViewCell: BaseTableViewCell {

    @IBOutlet var thumbnilImageView: UIImageView!
    @IBOutlet var activityThumbNilLoader: UIActivityIndicatorView!
    @IBOutlet var title: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var favouriteBtn: UIButton!

    var favBtnPressed: FavBtnPressed?
    var dataModel: RealEstate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbnilImageView.layer.borderColor = UIColor(red: 227 / 255, green: 227 / 255, blue: 229 / 255, alpha: 1).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func bindData(_ data: Displayable) {
        super.bindData(data)
        if let realEstate = data as? RealEstate {
            bindData(realEstate)
        } else if let realEstate = data as? RealEstateManaged {
            bindData(realEstate)
        }
    }

    func bindData(_ realEstate: RealEstateManaged) {
        title.text = realEstate.title
        price.text = "\(realEstate.price)"
        address.text = realEstate.location?.address
        dimissImageLoader()
        favouriteBtn.addTarget(self, action: #selector(favouriteBtnPressed(_:)), for: .touchUpInside)
    }
    func bindData(_ realEstate: RealEstate) {
        if let priceValue = realEstate.price {
            price.text = "\(priceValue)"
        } else {
            price.text = "Not Available"
        }

        if let addressValue = realEstate.location?.address {
            address.text = addressValue
        }

        if let titleValue = realEstate.title {
            title.text = titleValue
        }

        if let imageArr = realEstate.images, imageArr.isEmpty == false {
            guard let imageObj = imageArr.first else {
                dimissImageLoader()
                return
            }

            guard let imagePath = imageObj.url else {
                dimissImageLoader()
                return
            }

            displayImageLoader()
            thumbnilImageView.downloadedFrom(link: imagePath) { _ in
                self.dimissImageLoader()
            }
        }

        favouriteBtn.addTarget(self, action: #selector(favouriteBtnPressed(_:)), for: .touchUpInside)
    }

    @IBAction func favouriteBtnPressed(_ sender: Any) {
        if favBtnPressed != nil {
            favBtnPressed!(true)
        }
    }

    func updateFavouriteUIForSavedStatus(_ isSave: Bool) {
        var btnImage: UIImage
        if isSave {
            btnImage = #imageLiteral(resourceName: "icons8-heart-filled")
        } else {
            btnImage = #imageLiteral(resourceName: "icons8-heart-empty")
        }
        favouriteBtn.setImage(btnImage, for: .normal)
    }

    func dimissImageLoader() {
        DispatchQueue.main.async { () -> Void in
            self.activityThumbNilLoader.stopAnimating()
            self.activityThumbNilLoader.isHidden = true
        }
    }

    func displayImageLoader() {
        DispatchQueue.main.async { () -> Void in
            self.activityThumbNilLoader.startAnimating()
            self.activityThumbNilLoader.isHidden = false
        }
    }
}
