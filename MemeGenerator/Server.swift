import Foundation
import UIKit
import ReactiveCocoa
import Result

struct MemeParameters {
  let top: String
  let bottom: String
}

class Server {
  
  func generateMeme(top: String, bottom: String) -> SignalProducer<UIImage, NSError> {
    
    // Please don't write this sort of code
    let url = NSURL(string: "http://apimeme.com/meme?meme=Ermahgerd+Berks&top=\(top)&bottom=\(bottom)")!;
    let urlRequest = NSURLRequest(URL: url)
          
    return NSURLSession.sharedSession()
      .rac_dataWithRequest(urlRequest)
      .retry(2)
      .attemptMap { (data, URLResponse) -> Result<UIImage, NSError> in
        if let image = UIImage(data: data) {
          return .Success(image)
        } else {
          return .Failure(NSError(domain: "MemeGenerator.Server", code: 1, userInfo: nil))
        }
    }

  }
}
