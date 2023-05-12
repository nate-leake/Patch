//
//  CurrencyField.swift
//  Patch
//
//  Courtesy of Javier Trinchero https://github.com/jtrinc/swiftui-currency-field
//
//  MIT License
//
//  Copyright (c) 2022 Javier Trinchero
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import SwiftUI
import UIKit

public struct CurrencyField: View {
    @Binding var value: Int
    var formatter: NumberFormatter
    
    private var label: String {
        let mag = pow(10, formatter.maximumFractionDigits)
        return formatter.string(for: Decimal(value) / mag) ?? ""
    }
    
    public init(value: Binding<Int>, formatter: NumberFormatter) {
        self._value = value
        self.formatter = formatter
    }
    
    public init(value: Binding<Int>) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.locale = .current
        
        self.init(value: value, formatter: formatter)
    }
    
    public var body: some View {
        ZStack {
            // Text view to display the formatted currency
            // Set as priority so CurrencyInputField size doesn't affect parent
            Text(label).layoutPriority(1)
            
            // Input text field to handle UI
            CurrencyInputField(value: $value, formatter: formatter)
        }
    }
}

// Sub-class UITextField to remove selection and caret
class NoCaretTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        []
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        .null
    }
}

struct CurrencyInputField: UIViewRepresentable {
    @Binding var value: Int
    var formatter: NumberFormatter
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> NoCaretTextField {
        let textField = NoCaretTextField(frame: .zero)
        
        // Assign delegate
        textField.delegate = context.coordinator
        
        // Set keyboard type
        textField.keyboardType = .numberPad
        
        // Make visual components invisible
        textField.tintColor = .clear
        textField.textColor = .clear
        textField.backgroundColor = .clear
        
        // Add editing changed event handler
        textField.addTarget(
            context.coordinator,
            action: #selector(Coordinator.editingChanged(textField:)),
            for: .editingChanged
        )
        
        // Set initial textfield text
        context.coordinator.updateText(value, textField: textField)
        
        return textField
    }
    
    func updateUIView(_ uiView: NoCaretTextField, context: Context) {}
    
    class Coordinator: NSObject, UITextFieldDelegate {
        // Reference to currency input field
        private var input: CurrencyInputField
        
        // Last valid text input string to be displayed
        private var lastValidInput: String? = ""
        
        init(_ currencyTextField: CurrencyInputField) {
            self.input = currencyTextField
        }
        
        func setValue(_ value: Int, textField: UITextField) {
            // Update input value
            input.value = value
            
            // Update textfield text
            updateText(value, textField: textField)
        }
        
        func updateText(_ value: Int, textField: UITextField) {
            // Update field text and last valid input text
            textField.text = String(value)
            lastValidInput = String(value)
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // If replacement string is empty, we can assume the backspace key was hit
            if string.isEmpty {
                // Resign first responder when delete is hit when value is 0
                if input.value == 0 {
                    textField.resignFirstResponder()
                }
                
                // Remove trailing digit
                setValue(Int(input.value / 10), textField: textField)
            }
            return true
        }
        
        @objc func editingChanged(textField: NoCaretTextField) {
            // Get a mutable copy of last text
            guard var oldText = lastValidInput else {
                return
            }
            
            // Iterate through each char of the new string and compare LTR with old string
            let char = (textField.text ?? "").first { next in
                // If old text is empty or its next character doesn't match new
                if oldText.isEmpty || next != oldText.removeFirst() {
                    // Found the mismatching character
                    return true
                }
                return false
            }
            
            // Find new character and try to get an Int value from it
            guard let char = char, let digit = Int(String(char)) else {
                // New character could not be converted to Int
                // Revert to last valid text
                textField.text = lastValidInput
                return
            }
            
            // Multiply by 10 to shift numbers one position to the left, revert if an overflow occurs
            let (multValue, multOverflow) = input.value.multipliedReportingOverflow(by: 10)
            if multOverflow {
                textField.text = lastValidInput
                return
            }
            
            // Add the new trailing digit, revert if an overflow occurs
            let (addValue, addOverflow) = multValue.addingReportingOverflow(digit)
            if addOverflow {
                textField.text = lastValidInput
                return
            }
            
            // If new value has more digits than allowed by formatter, revert
            if input.formatter.maximumFractionDigits + input.formatter.maximumIntegerDigits < String(addValue).count {
                textField.text = lastValidInput
                return
            }
            
            // Update new value
            setValue(addValue, textField: textField)
        }
    }
}
