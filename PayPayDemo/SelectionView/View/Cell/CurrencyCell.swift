

import UIKit

final class CurrencyCell: UITableViewCell {

    @IBOutlet weak var shortLabel: UILabel!
    @IBOutlet weak var fullFormLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ data: Currency?) {
        guard let data = data else {return}
        shortLabel.text = data.short
        fullFormLabel.text = data.fullFormCountry
    }
    
}
