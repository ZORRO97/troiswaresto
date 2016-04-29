//
//  RestoCell.swift
//  troiswaresto
//
//  Created by etudiant-11 on 25/04/2016.
//  Copyright © 2016 francois. All rights reserved.
//

import UIKit

class RestoCell : UITableViewCell {
    @IBOutlet var cellImageView : UIImageView!
    @IBOutlet var nameLabel: UILabel!
    // @IBOutlet var rateLabel: UILabel! // on remplace par 5 étoiles en fonction des notes obtenues
    @IBOutlet var star1ImageView: UIImageView!
    @IBOutlet var star2ImageView: UIImageView!
    @IBOutlet var star3ImageView: UIImageView!
    @IBOutlet var star4ImageView: UIImageView!
    @IBOutlet var star5ImageView: UIImageView!
    @IBOutlet var priceRangeLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
}
