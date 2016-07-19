
import UIKit

class GuideVC: UIViewController {
    
    // UI Elements
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel! // # of pages / steps
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contentStackView: UIStackView!

    
    var guide:Guide?
    
    
    @IBAction func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Make category icon load from place
        // TODO: Add in description to guide DB SCHEMA
        
        if guide != nil {
            imageView.image = guide?.cardImage
            nameLabel.text = guide?.title
            categoryLabel.text = guide?.category
            stepLabel.text = guide?.pages != nil ? "\(guide!.pages.count) steps" : "0 steps"
            descriptionLabel.text = "Lorem Ipsum"
            
            // Present its places if it has any
            for place in (guide?.places)! {
                if let miniCard = NSBundle.mainBundle().loadNibNamed("MiniCardView", owner: self, options: nil).first as? MiniCardView {
                    miniCard.useData(place)
                    contentStackView.addArrangedSubview(miniCard)
                }
            }

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

