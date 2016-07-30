//
//  CameraVC.swift
//  Capstone
//
//  Created by Angela Liu on 6/23/16.
//  Copyright © 2016 amliu. All rights reserved.
//

//
//  PhotoVC.swift
//  Abeo-Test
//
//  Created by Katherine Habeck on 6/28/16.
//  Copyright © 2016 Katherine Habeck. All rights reserved.
//

import Foundation


import UIKit
import MobileCoreServices

class CameraVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UI Elements
    @IBOutlet weak var tagContainer: UILabel! // Where the tag result feedback is shoved
    @IBOutlet weak var imageView: UIImageView! // Photo taken container
    @IBOutlet weak var contentStackView: UIStackView! // Main content stack view - append stuff to this
    
    var searchResultViews:[UIView] = [] // Appended search result nibs
    
    // Variables
    var newMedia: Bool?
    
    override func viewDidLoad() {
        bringUpCamera() // Comment this line out when testing with the simulator since it doesn't have a camera
        super.viewDidLoad()
    }

    func bringUpCamera() {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes = [kUTTypeImage as NSString as String]
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true,
                                       completion: nil)
            newMedia = true
        }
    }
    
    // Connect to button to allow user to go back to camera
    @IBAction func retakePhoto(sender: AnyObject) {
        tagContainer.text = ""
        
        // Clear old search results
        for searchResult in searchResultViews {
            searchResult.removeFromSuperview()
        }
        searchResultViews.removeAll()
        
        bringUpCamera()
    }

    // Brings up the camera roll to select an existing image to run recognition on
    // Currently not hooked up due to how we designed the UI
    @IBAction func useCameraRoll(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as NSString as String]
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true,
                                       completion: nil)
            newMedia = false
        }
    }
    
    @IBAction func backToHome(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            tagContainer.text = "Running image recognition..."
            
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
            
            // Convert image into PNG and resize to prep it for Clarifai POST request
            let imageToSend:NSData? = UIImagePNGRepresentation(Clarifai.resizeImage(pickedImage, newWidth: 640))
            
            // Send off our Clarifai API call
            Clarifai.getTagsForPhoto(imageToSend!, completionHandler:
                {response, data, error -> Void in
                    do { // Convert the JSON response into a dictionary
                        let convertedResponse = try NSJSONSerialization.JSONObjectWithData(response!, options: []) as! NSDictionary
                        do { // Unwrapping JSON in Swift is really tedious because it only ever converts the "outer most" stuff into a swift dictionary, and the data inside is still unprocessed
                            let results = try NSJSONSerialization.JSONObjectWithData(NSJSONSerialization.dataWithJSONObject(convertedResponse["results"]!, options: []), options: []) as! NSArray
                            let wrapped_result = try NSJSONSerialization.JSONObjectWithData(NSJSONSerialization.dataWithJSONObject(results[0], options: []), options: []) as! NSDictionary
                            let result = try NSJSONSerialization.JSONObjectWithData(NSJSONSerialization.dataWithJSONObject(wrapped_result["result"]!, options: []), options: [])
                            
                            let tag = try NSJSONSerialization.JSONObjectWithData(NSJSONSerialization.dataWithJSONObject(result["tag"]!!, options: []), options: []) as! NSDictionary
                            
                            let classes = tag["classes"] as! NSArray
                            let probs = tag["probs"] as! NSArray
                            
                            print(classes)
                            
                            let probableTags = self.getProbableTags(classes as! [String], probs: probs as! [Double])
                            let shortTags = self.clearShortTags(probableTags)
                            
                            let matchedPlaces = self.matchImages(shortTags)
                            
                            guard let db = try? SQLiteDatabase.open() else { return }
                            let matchedGuides = db.getGuideForTags(shortTags)
                            db.close()
                            
                            // To update the UI we need to get the main thread
                            dispatch_async(dispatch_get_main_queue()) {
                                self.tagContainer.text = "Is this what you're looking for?"
//                                 self.tagContainer.text = "Seeing: \(probableTags.joinWithSeparator(" ")))"
                                
                                if matchedPlaces.isEmpty && matchedGuides.isEmpty {
                                    self.tagContainer.text = "Could not find any matches"
                                }
                                
                                for place in (matchedPlaces) {
                                    if let searchCard = NSBundle.mainBundle().loadNibNamed("SearchResultCardView", owner: self, options: nil).first as? SearchResultCardView {
                                        searchCard.useData(place)
                                        self.searchResultViews.append(searchCard)
                                        self.contentStackView.addArrangedSubview(searchCard)
                                    }
                                }
                                
                                for guide in matchedGuides {
                                    if let searchCard = NSBundle.mainBundle().loadNibNamed("SearchResultCardView", owner: self, options: nil).first as? SearchResultCardView {
                                        searchCard.useData(guide)
                                        self.searchResultViews.append(searchCard)
                                        self.contentStackView.addArrangedSubview(searchCard)
                                    }
                                }
                                
                            }
                        } catch {
                            print(error)
                            self.tagContainer.text = "No response from Clarifai"
                        }
                    } catch {
                        print(error)
                        self.tagContainer.text = "No response from Clarifai"
                    }
                })
            } // Close Clarifai completion handler

        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                                          message: "Failed to save image",
                                          preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                                             style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                                       completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func matchImages(tags:[String])-> [Place]
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.placesManager.filterByTags(tags)
    }
    
    // Given a set of tags and probabilities, removes tags where the probability
    // is below 80% or is "no person"
    func getProbableTags(tags:[String], probs:[Double]) -> [String] {
        var counter = 0
        var tagsToSearch:[String] = []
        for tag in tags
        {
            if(probs[counter] > 0.80 && tag != "no person")
            {
                tagsToSearch.append(tag)
            }
            counter = counter + 1
        }
        return tagsToSearch
    }
    
    // just to ensure the wildcard matches work as necessary - since right now they are too greedy
    // removing short tags less than 4 characters helps since then we won't get a match like ice = nice
    // AGAIN Remove this once you have tags in its own table as it should be...
    func clearShortTags(tags:[String]) -> [String] {
        return tags.filter({ $0.characters.count >= 4 })
        
    }
    
}