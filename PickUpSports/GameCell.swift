//
//  GameCell.swift
//  PickUpSports
//
//  Created by Taylor Boren on 7/9/15.
//  Copyright (c) 2015 Taylor Boren. All rights reserved.
//

import UIKit
import MaterialKit

class GameCell: MKTableViewCell {

    @IBOutlet weak var gameSubview: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var playersLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    func formatGame(game:Game){
        var image = UIImage(named: game.sport.name.lowercaseString+"_game")
        if let img = image{
            gameImage.image = img
        }
        else{
            gameImage.image = UIImage(named: "sports")
        }
        self.rippleLayerColor = GlobalStorage.successColor
        gameImage.contentMode = UIViewContentMode.ScaleAspectFit
        if (game.joined! == true){
            gameSubview.layer.borderColor = GlobalStorage.successColor.CGColor
        }
        else{
            gameSubview.layer.borderColor = GlobalStorage.errorColor.CGColor
        }
        gameSubview.layer.borderWidth = 2
        self.backgroundColor = UIColor.clearColor()
        titleLabel.text = game.title
        dateLabel.text = game.datetime.string()
        locationLabel.text = "\(game.location)"
        gameSubview.backgroundColor = UIColor.MKColor.Grey
        playersLabel.text = "Players: "+String(game.players!.count)
    }
    
    func getSportImage(sport:String) -> UIImage{
        switch sport.lowercaseString{
            case "basketball":
                return UIImage(named: "basketball_game")!
            case "football":
                return UIImage(named: "football_game")!
            default:
                return UIImage(named: "sports")!
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
