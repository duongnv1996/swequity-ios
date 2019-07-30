//
//  SwiftyCodeItemView.swift
//
//  Created by arturdev on 6/28/18.
//

import UIKit

open class SwiftyCodeItemView: UIView {

    @IBOutlet open weak var textField: SwiftyCodeTextField!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        textField.text = ""
        
        isUserInteractionEnabled = false
    }
    
    override open func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    override open func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
}
