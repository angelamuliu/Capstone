//
//  Clarifai.swift
//  Clarifai
//
//  Created by Angela Liu on 7/12/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import UIKit
import Foundation

/**
 Allows access to clarifai API calls
 https://developer.clarifai.com/account/application?id=25861
 https://developer.clarifai.com/guide/tag
 
 // See for about NSURLSession and why we use it for HTTP requests
 // https://www.raywenderlich.com/110458/nsurlsession-tutorial-getting-started
 */
struct Clarifai {
    
    // In the real world these wouldn't be here
    // To bad ... we're living in a digital future ....
    static let clientId = "OBEX2pl0svoMjuP8cMViW0lGfZdyyJKQaNYD1Cyz"
    static let clientSecret = "ZLIumLeO8ZJodTrNz8ujTdTmFjBt-3jGrDPJreJD"
    
    static let tokenEndpoint = "https://api.clarifai.com/v1/token"
    static let endpoint = "https://api.clarifai.com/v1/tag"
    
    // Expires in 48 hours so we keep having to get new ones
    // TODO: Right now I'll just grab a new one every time the app launches ... proper implementation would be to only grab one if it's older than 2 days and save it with NSUserDefaults or something
    static var accessToken = ""
    
    /**
     Access tokens expire in 48 hours so we can grab a new one if ours is too old
     */
    static func refreshAccessToken() {
        let url = accessTokenStringURL()
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request, completionHandler: {response, data, error -> Void in
            do {
                let result = try NSJSONSerialization.JSONObjectWithData(response!, options: []) as! NSDictionary
                Clarifai.accessToken = result["access_token"] as! String
            } catch { print(error) }
        })
        task.resume()
    }
    
    private static func accessTokenStringURL() -> NSURL? {
        return NSURL(string: "\(Clarifai.tokenEndpoint)/?client_id=\(Clarifai.clientId)&client_secret=\(Clarifai.clientSecret)&grant_type=client_credentials")
    }
    
    /**
     Just is a test call - the simpliest possible, with the provided example image and GET
     */
    static func testCall() {
        let url = NSURL(string: "\(Clarifai.endpoint)/?url=https://samples.clarifai.com/metro-north.jpg")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.setValue("Bearer \(Clarifai.accessToken)", forHTTPHeaderField: "Authorization")
        
        // NSURLSession was made for HTTP requests and handles starting/stopping tasks (with requests), etc...
        // See for overview: https://www.raywenderlich.com/110458/nsurlsession-tutorial-getting-started
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request, completionHandler: {response, data, error -> Void in
            print(data)
            do { // Converting the JSON response into a dictionary
                let result = try NSJSONSerialization.JSONObjectWithData(response!, options: []) as! NSDictionary
                print(result)
            } catch {
                print(error)
            }
            return
        })
        task.resume() // All tasks start suspended - calling resume will actually fire it off asynchonously
    }
    
    /**
     Given the NSData for a photo that was just taken, sends off the request
     Also takes in a completion handler so it knows what to do with the response when it comes back
     */
    static func getTagsForPhoto(imgData: NSData, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        let url = NSURL(string: "\(Clarifai.endpoint)")
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue("Bearer \(Clarifai.accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // We have to encode the image before sending it as part of the request and it gets ugly
        // See: http://www.kaleidosblog.com/how-to-upload-images-using-swift-2-send-multipart-post-request
        let boundary = "Boundary-\(NSUUID().UUIDString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        
        let fileName = "abeo-image.png"
        let mimeType = "image/png"
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"encoded_data\"; filename=\"\(fileName)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Type: \(mimeType)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(imgData)
        body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody = body
        
        // Sending off our request - First we make a task object
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request, completionHandler: completionHandler)
        task.resume() // All tasks start suspended - calling resume will actually fire the task off asynchonously
    }
    
    
    // Code from:
    // http://stackoverflow.com/questions/31966885/ios-swift-resize-image-to-200x200pt-px
    // Resizes an image given a new width, preserves scale
    static func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        // Starting a drawing environment where we'll dump the image and make it smaller then export
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}