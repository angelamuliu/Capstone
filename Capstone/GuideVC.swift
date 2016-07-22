
import UIKit

class GuideVC: UIViewController {
    
    var guide:Guide?
    var currentPage:Int = -1 // -1 is the intro view, 0 is the first step/page
    
    // UI Elements - intro card
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel! // # of pages / steps
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contentStackView: UIStackView!

    @IBOutlet weak var introView: UIScrollView! // The first "page" which is the guide intro and related spots, not a card view
    @IBOutlet weak var pagesView: UIView! // Holds all pages and the intro part
    
    // The custom pages views are dependant on bounds, which are determined in viewDidLayoutSubview, initialization of it is placed there
    // But we only want it to happen once per template using
    var pagesLoaded:Bool = false
    var stepViews: [UIView] = []// Holds the step views for this guide, and is cleaned out when the view is left
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Make category icon load from place
        
        if guide != nil {
            imageView.image = guide?.cardImage
            nameLabel.text = guide?.title
            categoryLabel.text = guide?.category
            stepLabel.text = guide?.pages != nil ? "\(guide!.pages.count) steps" : "0 steps"
            descriptionLabel.text = guide?.description
            
            // Present its places if it has any
            for place in (guide?.places)! {
                if let miniCard = NSBundle.mainBundle().loadNibNamed("MiniCardView", owner: self, options: nil).first as? MiniCardView {
                    miniCard.useData(place)
                    contentStackView.addArrangedSubview(miniCard)
                }
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        removePages()
        pagesLoaded = false
    }
    
    override func viewDidLayoutSubviews() {
        if !pagesLoaded {
            setupPage()
            pagesLoaded = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Loops through a guide's pages and inserts them into the view with their frames positioned
    */
    private func setupPage() {
        if guide != nil {
            for i in 0..<guide!.pages.count {
                let page = guide!.pages[i]
                page.guide = guide! // To ensure that the page's title is hooked up properly to card
                if i != guide!.pages.count - 1 { // Page
                    if let stepCard = NSBundle.mainBundle().loadNibNamed("StepCardView", owner: self, options: nil).first as? StepCardView {
                        stepCard.useData(page)
                        setupPagePositioning(i, card: stepCard)
                        pagesView.addSubview(stepCard)
                        stepViews.append(stepCard)
                    }
                } else { // The last page = the author
                    if let authorCard = NSBundle.mainBundle().loadNibNamed("StepCardAuthorView", owner: self, options: nil).first as? StepCardAuthorView {
                        authorCard.useData(page, guideVC: self)
                        setupPagePositioning(i, card: authorCard)
                        pagesView.addSubview(authorCard)
                        stepViews.append(authorCard)
                    }
                }
            }
        }
    }
    
    // Setups up positioning of the page cards so that the first one next to the intro peeks, and the rest are offscreen
    func setupPagePositioning(index:Int, card:UIView) {
        if index == 0 {
            card.frame = CGRect(x: pagesView.bounds.width - Constants.stepCard_peekWidth, y: Constants.stepCard_topLeftMargin, width: pagesView.bounds.width - Constants.stepCard_topLeftMargin*2, height: pagesView.bounds.height - Constants.stepCard_topLeftMargin - Constants.stepCard_bottomMargin)
        } else { // offscreen
            card.frame = CGRect(x: pagesView.bounds.width + Constants.stepCard_peekWidth, y: Constants.stepCard_topLeftMargin, width: pagesView.bounds.width - Constants.stepCard_topLeftMargin*2, height: pagesView.bounds.height - Constants.stepCard_topLeftMargin - Constants.stepCard_bottomMargin)
        }
    }
    
    /**
     Removes/cleans up the pages in order to prep for the next possible guide and its own pages
    */
    private func removePages() {
        for stepView in stepViews {
            stepView.removeFromSuperview()
        }
        stepViews.removeAll()
    }
    
    @IBAction func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func handleSwipe(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.Right:
            swipeLeftToRight()
        case UISwipeGestureRecognizerDirection.Left:
            swipeRightToLeft()
        default:
            break
        }
    }
    
    // Handles animation and view positioning when user goes back a step (left to right, from left edge)
    private func swipeLeftToRight() {
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut , animations: {
            if self.currentPage == -1 {
                // User tried to swipe back but was on the intro page
            } else {
                var viewToLeave: UIView? // The view that will be moved to the left edge
                var viewToEnter: UIView // The view that will be centered
                var viewToQueue: UIView // The view that will be moved to the right edge
                
                if self.currentPage == 0 { // User on page right before intro
                    viewToEnter = self.introView
                    viewToQueue = self.stepViews[0]
                } else if self.currentPage == 1 { // User was 2 pages from intro, need to put intro in left side
                    viewToLeave = self.introView
                    viewToEnter = self.stepViews[self.currentPage - 1]
                    viewToQueue = self.stepViews[self.currentPage]
                } else { // User swiping from a step to a previous one
                    viewToLeave = self.stepViews[self.currentPage - 2]
                    viewToEnter = self.stepViews[self.currentPage - 1]
                    viewToQueue = self.stepViews[self.currentPage]
                }
                self.movePeekedPages(self.currentPage+1)
                self.positionPages(viewToLeave, viewToEnter: viewToEnter, viewToQueue: viewToQueue)
                self.currentPage -= 1
            }
            }, completion: { finished in })
    }
    
    // Handles animation and view positioning when user advances a step (right to left, from right edge)
    private func swipeRightToLeft() {
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut , animations: {
            if self.currentPage == self.stepViews.count - 1 {
                // User tried to swipe beyound the last page
            } else {
                var viewToLeave: UIView // The view that will be moved to the left edge
                var viewToEnter: UIView // The view that will be centered
                var viewToQueue: UIView? // The view that will be moved to the right edge
                
                if self.currentPage == -1 { // User on intro page
                    viewToLeave = self.introView
                    viewToEnter = self.stepViews[0]
                    viewToQueue = self.stepViews[1]
                } else if self.currentPage == self.stepViews.count - 2 { // User only has 1 step left, no view to queue
                    viewToLeave = self.stepViews[self.currentPage]
                    viewToEnter = self.stepViews[self.currentPage + 1]
                } else { // User swiping between steps to the next one
                    viewToLeave = self.stepViews[self.currentPage]
                    viewToEnter = self.stepViews[self.currentPage + 1]
                    viewToQueue = self.stepViews[self.currentPage + 2]
                }
                self.positionPages(viewToLeave, viewToEnter: viewToEnter, viewToQueue: viewToQueue)
                self.currentPage += 1
            }
        }, completion: { finished in })
    }
    
    // Given pages, with the edges being possibly optional (if attempting to scroll from like an edge), positions them
    private func positionPages(viewToLeave:UIView?, viewToEnter:UIView, viewToQueue:UIView?) {
        if viewToLeave != nil {
            if viewToLeave is StepCardView || viewToLeave is StepCardAuthorView {
                viewToLeave!.frame.origin = CGPoint(x: -viewToLeave!.bounds.width + Constants.stepCard_peekWidth, y: Constants.stepCard_topLeftMargin)
            } else { // Avoid having the intro slide down awkwardly
                viewToLeave!.frame.origin = CGPoint(x: -viewToLeave!.bounds.width + Constants.stepCard_peekWidth, y: 0)
            }
        }
        if viewToEnter is StepCardView || viewToEnter is StepCardAuthorView {
            viewToEnter.frame.origin = CGPoint(x: Constants.stepCard_topLeftMargin, y: Constants.stepCard_topLeftMargin)
        } else { // The intro is about to enter - position  differently, match what we did in constraints
            viewToEnter.frame.origin = CGPoint(x: 12, y:0)
        }
        if viewToQueue != nil {
            if viewToQueue is StepCardView || viewToQueue is StepCardAuthorView {
                viewToQueue!.frame.origin = CGPoint(x: self.pagesView.bounds.width - Constants.stepCard_peekWidth, y: Constants.stepCard_topLeftMargin)
            } else {
                viewToQueue!.frame.origin = CGPoint(x: self.pagesView.bounds.width - Constants.stepCard_peekWidth, y:0)
            }
        }
    }
    
    // Given an index of the page to remove, ensures that a previously peeking screen is properly moved off
    // Used to fix a visual bug where swiping left to right made cards stack instead of shift
    // Right now we only account for swipe left to right - may need to extend in future to handle both but there's no visual bug with the other direction
    private func movePeekedPages(stepIndex: Int) {
        if stepIndex <= stepViews.count - 1 && stepIndex != -1 {
            let viewToMove = stepViews[stepIndex]
            viewToMove.frame.origin = CGPoint(x: pagesView.bounds.width + viewToMove.bounds.width - Constants.stepCard_peekWidth, y:Constants.stepCard_topLeftMargin)
        }
        
    }
    
    
}

