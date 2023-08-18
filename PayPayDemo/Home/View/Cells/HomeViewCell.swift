//
//  HomeViewCell.swift
//  CurrencyConverter
//
//  ""
//

import UIKit

final class HomeViewCell: UITableViewCell {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var fullFormLabel: UILabel!
    @IBOutlet weak var shortLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setData(_ data: HomeListData?) {
        guard let data = data else {return}
        self.amountLabel.text = "\(data.currencyRate)"
        self.fullFormLabel.text = data.fullName
        self.shortLabel.text = data.shortName
    }
    
}
