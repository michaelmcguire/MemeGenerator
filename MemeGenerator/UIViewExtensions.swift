import UIKit
import ReactiveCocoa
import Rex

private var hidden: UInt8 = 0

extension UIView {
  public var rac_hidden: MutableProperty<Bool> {
    return associatedProperty(self, key: &hidden, initial: { [weak self] in self?.hidden ?? true }, setter: { [weak self] in self?.hidden = $0 })
  }
}

extension UITextField {
  func rac_textSignalProducer() -> SignalProducer<String, NoError> {
    return self.rac_textSignal().toSignalProducer()
      .map { textValue in textValue as! String }
      .flatMapError { _ in return SignalProducer<String,NoError>.empty }
  }
}