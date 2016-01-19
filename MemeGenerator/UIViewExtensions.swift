import UIKit
import ReactiveCocoa
import Rex

private var hidden: UInt8 = 0

extension UITextField {
  func rac_textSignalProducer() -> SignalProducer<String, NoError> {
    return self.rac_textSignal().toSignalProducer()
      .map { textValue in textValue as! String }
      .flatMapError { _ in return SignalProducer<String,NoError>.empty }
  }
}