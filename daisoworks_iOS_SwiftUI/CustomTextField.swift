//
//  CustomTextField.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 2/25/25.
//
import SwiftUI
import UIKit 

struct CustomTextField: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextField
        
        init(parent: CustomTextField){
            self.parent = parent
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange , replacementString string: String) -> Bool {
            //숫자만 입력하도록 제한
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            parent.onDone()
            return true
        }
    }
    
    var placeholder: String
    var text: Binding<String>
    var onDone: () -> Void
    
 
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.keyboardType = .numberPad
        textField.delegate = context.coordinator
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: context.coordinator, action: #selector(Coordinator.doneTapped))
        toolbar.items = [UIBarButtonItem.flexibleSpace(),  doneButton]
        textField.inputAccessoryView = toolbar
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text.wrappedValue
    }
}

extension CustomTextField.Coordinator {
    @objc func doneTapped() {
        parent.onDone()
    }
}
