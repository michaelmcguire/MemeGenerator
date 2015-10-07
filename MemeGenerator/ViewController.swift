import UIKit
import ReactiveCocoa
import Rex

class ViewController: UIViewController {

  @IBOutlet weak var topTextField: UITextField!
  @IBOutlet weak var bottomTextField: UITextField!
  @IBOutlet weak var generateButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var memeImageView: UIImageView!
  @IBOutlet weak var networkActivityIndicatorView: UIActivityIndicatorView!
  
  let server = Server()
  var lastRequest: Disposable?
  
  lazy var request: Action<(String, String), UIImage, NSError> = Action { [unowned self] (top, bottom) in
    return self.server.generateMeme(top, bottom: bottom).observeOn(UIScheduler())
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    generateButton.rex_enabled <~ request.executing.producer.map { !$0 }
    cancelButton.rex_enabled <~ request.executing
  }
  
  @IBAction func generateTapped(sender: UIButton) {
    lastRequest = self.request.apply((topTextField.text!, bottom: bottomTextField.text!))
      .startWithNext { image in
        self.memeImageView.image = image
      }
  }
  
  @IBAction func cancelTapped(sender: UIButton) {
    lastRequest?.dispose()
    lastRequest = nil
  }
  
}

