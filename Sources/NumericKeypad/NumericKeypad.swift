//
//  NumericKeypad.swift
//  NumericKeypad
//
//  Created by David Kennedy on 21/08/2026.
//

#if os(iOS)

import Foundation
import SwiftUI

extension String {
    static let defaultsKeyInputMethod = "NumericKeypadInputMethod"
}

@MainActor @Observable public class NumericKeypad: @unchecked Sendable {
    
    enum InputMethod: String, Identifiable, Sendable, RawRepresentable {
        case pad, keyboard
        public var id: Int { hashValue }
    }
    
    private var inputMethod: InputMethod? = nil {
        didSet {
            isActive = (inputMethod != nil)
            guard let inputMethod else { return }
            
            let defaults = UserDefaults.standard
            defaults.set(inputMethod.rawValue, forKey: .defaultsKeyInputMethod)
        }
    }
    
    public var isActive: Bool = false
    
    public func activate() {
        let defaults = UserDefaults.standard
        let string = defaults.string(forKey: .defaultsKeyInputMethod) ?? ""
        let defaultsInputMethod = InputMethod(rawValue: string)
        inputMethod = defaultsInputMethod ?? InputMethod.pad
    }
    
    public init() {}
    
    
    @MainActor @ViewBuilder
    public func sheet(title: String, value: Binding<Int?>) -> some View {
        
        @Bindable var numericKeypad = self
        
        NavigationStack {
            switch inputMethod {
            case .pad, .none:
                DigitPad($numericKeypad.inputMethod, title: title, value: value)
            case .keyboard:
                KeyboardView($numericKeypad.inputMethod, title: title, value: value)
            }
        }
    }
    
}

#endif

