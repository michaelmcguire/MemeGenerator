import UIKit
import ReactiveCocoa

class ViewController: UIViewController {

  @IBOutlet weak var topTextField: UITextField!
  @IBOutlet weak var bottomTextField: UITextField!
  @IBOutlet weak var generateButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var memeImageView: UIImageView!
  @IBOutlet weak var networkActivityIndicatorView: UIActivityIndicatorView!
  
  let server = Server()
  
  @IBAction func generateTapped(sender: UIButton) {
    
    server.generateMeme(topTextField.text!, bottom: bottomTextField.text!)
      .observeOn(UIScheduler())
      .startWithNext { image in
        self.memeImageView.image = image
      }
    
  }
  
  
}

