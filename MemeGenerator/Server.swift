import Foundation
import UIKit

class Server {
  typealias RequestCallback = (UIImage?, NSError?) -> Void
  
  var isGenerating = false
  
  func generateMeme(top: String, bottom: String, completion:RequestCallback) -> Void {
    
    isGenerating = true
    
    // Please don't write this sort of code
    let url = NSURL(string: "http://apimeme.com/meme?meme=Ermahgerd+Berks&top=\(top)&bottom=\(bottom)")!;
    
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in
      
      if let error = error {
        dispatch_async(dispatch_get_main_queue()) {
          self.isGenerating = false
          completion(nil, error)
        }
      } else if let data = data {
        let image = UIImage(data: data)
        dispatch_async(dispatch_get_main_queue()) {
          self.isGenerating = false
          completion(image, nil)
        }
      }
    }
    
    task.resume()
  }
}
