import UIKit
import ReactiveCocoa
import Rex

private var hidden: UInt8 = 0

extension UIView {
  public var meme_hidden: MutableProperty<Bool> {
    return associatedProperty(self, key: &hidden, initial: { [weak self] in self?.hidden ?? true }, setter: { [weak self] in self?.hidden = $0 })
  }
}