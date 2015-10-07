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
  
    let executing = request.executing.producer
    let notExecuting = request.executing.producer.map { !$0 }
    
    generateButton.rex_enabled <~
      combineLatest(notExecuting, self.topTextField.rac_textSignalProducer(), self.bottomTextField.rac_textSignalProducer())
      .map {(notExecuting, topText, bottomText) in
        return (notExecuting
          && (topText.characters.count >= 3)
          && (bottomText.characters.count >= 4))
      }
    cancelButton.rex_enabled <~ executing
    networkActivityIndicatorView.rac_hidden <~ notExecuting
    memeImageView.rac_hidden <~ executing
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

