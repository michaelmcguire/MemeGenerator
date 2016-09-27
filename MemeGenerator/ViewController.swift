import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var topTextField: UITextField!
  @IBOutlet weak var bottomTextField: UITextField!
  @IBOutlet weak var generateButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var memeImageView: UIImageView!
  @IBOutlet weak var networkActivityIndicatorView: UIActivityIndicatorView!

  let server = Server()
  var cancelToken: CancelationToken?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    updateUI()
    
    self.topTextField.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
    self.bottomTextField.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
  }
  
  @IBAction func generateTapped(sender: UIButton) {
  
    topTextField.resignFirstResponder()
    bottomTextField.resignFirstResponder()
    
    if let top = topTextField.text,
      let bottom = bottomTextField.text {
        
        cancelToken = server.generateMeme(top, bottom: bottom) { (image, error) -> Void in
          self.cancelToken = nil
          self.updateUI()
          
          if let image = image {
            self.memeImageView.image = image
          }
        }
        self.updateUI()
    }
  }
  
  @IBAction func cancelTapped(sender: UIButton) {
    
    topTextField.resignFirstResponder()
    bottomTextField.resignFirstResponder()
    
    self.cancelToken?()
    self.cancelToken = nil
    self.updateUI()
  }
  
  func textFieldDidChange(textField: UITextField) {
    updateUI()
  }
  
  func updateUI() {
    if topTextField.text?.characters.count >= 3
      && bottomTextField.text?.characters.count >= 4
      && server.isGenerating == false {
      generateButton.enabled = true
    } else {
      generateButton.enabled = false
    }
    
    networkActivityIndicatorView.hidden = !server.isGenerating
    memeImageView.hidden = server.isGenerating
    cancelButton.enabled = self.cancelToken != nil
  }
}

