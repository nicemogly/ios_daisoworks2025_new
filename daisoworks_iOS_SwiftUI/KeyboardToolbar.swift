//
//  KeyboardToolbar.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 2/25/25.
//
import SwiftUI
import UIKit

struct KeyboardToolbar: ViewModifier    {
    
    var onDone: () -> Void
    
    func body(content: Content) -> some View {
        content
            .background(ToobarView(onDone: onDone))
    }
    
    struct ToobarView: UIViewRepresentable {
        
        var onDone: () -> Void
        
        func makeUIView(context: Context) -> UIToolbar {
            let toolbar = UIToolbar()
            toolbar.items = [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(barButtonSystemItem: .done, target: context.coordinator, action: #selector(context.coordinator.doneTapped))
            ]
            toolbar.sizeToFit()
            return toolbar
        }
        
        func updateUIView(_ uiView: UIToolbar, context: Context) {}
        
        func makeCoordinator() -> Coordinator {
            Coordinator(onDone: onDone)
        }
        
        class Coordinator: NSObject {
            var onDone: () -> Void
            init(onDone: @escaping () -> Void){
                self.onDone = onDone
            }
            
            @objc func doneTapped() {
                onDone()
            }
        }
    }
    
}

extension View {
    func keyboardToolbar(onDone: @escaping () -> Void) -> some View {
        self.modifier(KeyboardToolbar(onDone: onDone))
    }
}
