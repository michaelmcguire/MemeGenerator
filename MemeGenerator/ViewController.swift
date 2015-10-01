import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var topTextField: UITextField!
  @IBOutlet weak var bottomTextField: UITextField!
  @IBOutlet weak var generateButton: UIButton!
  @IBOutlet weak var memeImageView: UIImageView!
  @IBOutlet weak var networkActivityIndicatorView: UIActivityIndicatorView!

  let server = Server()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    enableOrDisableGenerateButton()
    
    self.topTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
    self.bottomTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
  }
  
  @IBAction func generateTapped(sender: UIButton) {
  
    topTextField.resignFirstResponder()
    bottomTextField.resignFirstResponder()
    
    if let top = topTextField.text,
      let bottom = bottomTextField.text {
        
        server.generateMeme(top, bottom: bottom) { (image, error) -> Void in
          if let image = image {
            self.memeImageView.image = image
          }
        }
    }
  }
  
  func textFieldDidChange(textField: UITextField) {
    enableOrDisableGenerateButton()
  }
  
  func enableOrDisableGenerateButton() {
    if self.topTextField.text?.characters.count >= 3 && self.bottomTextField.text?.characters.count >= 4 {
      generateButton.enabled = true
    } else {
      generateButton.enabled = false
    }
  }
}

