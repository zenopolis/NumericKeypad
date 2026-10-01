//
//  KeyboardView.swift
//  NumericKeypad
//
//  Created by David Kennedy on 21/08/2026.
//

#if os(iOS)

import SwiftUI

/// Useful resource:
/// * __Fatbobman's Blog__:  [SwiftUI TextField Advanced — Events, Focus, and Keyboard](https://fatbobman.com/en/posts/textfield-event-focus-keyboard/)

struct KeyboardView: View {
    
    // MARK: - Constants
    
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.roundingMode = .ceiling
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    // MARK: - State
    
    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var isFocused: Bool
    @State private var text: String = ""
    @State private var selection: TextSelection?
    
    // MARK: - Parameters
    
    var title: String
    @Binding var value: Int?
    @Binding var activeInputMethod: NumericKeypad.InputMethod?
    
    // MARK: - Lifecycle
    
    init(_ activeInputMethod: Binding<NumericKeypad.InputMethod?> = .constant(nil), title: String, value: Binding<Int?>) {
        self.title = title
        self._value = value
        self._activeInputMethod = activeInputMethod
    }

    // MARK: - View - Body

    var body: some View {
        ZStack  {
            Color(uiColor: .secondarySystemBackground).edgesIgnoringSafeArea(.all)
            VStack {
                TextField("", text: $text, selection: $selection)
                    .focused($isFocused)
                    .padding()
                    .padding(.horizontal, 6)
                    .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 24))
                    .keyboardType(.numbersAndPunctuation)
                    .autocorrectionDisabled()
                    .multilineTextAlignment(.trailing)
                    .submitLabel(.done)
                    .accessibilityLabel("")
                    .accessibilityValue(accessibilityValue)
                    .accessibilityAdjustableAction { direction in
                        switch direction {
                        case .decrement:
                            decrementValue()
                        case .increment:
                            incrementValue()
                        default:
                            break
                        }
                    }
                    .accessibilityAction(named: "Edit without keyboard") {
                        activeInputMethod = .pad
                    }
                    .safeAreaPadding()
                    .presentationCompactAdaptation(.none)
                    .presentationDetents([.height(150)])
                    .navigationTitle(title)
                    .toolbarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem {
                            Button(role: .close) {
                                dismiss()
                            }
                            .accessibilityLabel("Done")
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("", systemImage: "keyboard.chevron.compact.down") {
                                activeInputMethod = .pad
                            }
                            .accessibilityLabel("Dismiss keyboard")
                        }
                    }
                    .onAppear {
                        syncTextFromValue()
                        isFocused = true
                    }
                    .onChange(of: text) {
                        syncValueFromText()
                    }
                    .onChange(of: isFocused) {
                        
                        if isFocused { // select text on appear
                            
                            selection = TextSelection(range: text.startIndex..<text.endIndex)
                            
                        } else { // synchronise and close
                            
                            syncValueFromText()
                            activeInputMethod = nil
                        }
                        
                    }
                Spacer()
            }
        }
    }
    
    private func syncValueFromText() {
        
        /// When tested, NumberFormatter rounding did not work as expected,
        /// so we do the rounding here...
        
        guard let number = formatter.number(from: text)?.doubleValue else { value = nil; return }
        let integral = number.rounded(.toNearestOrAwayFromZero)
        
        let integer = Int(truncating: integral as NSNumber)

        value = integer
    }
    
    private func syncTextFromValue() {
        text = formatter.string(from: NSNumber(value: value ?? 0)) ?? ""
    }
    
    // MARK: Accessibility

    private var accessibilityValue: String {
        text.isEmpty ? "empty" : text
    }

    private func incrementValue() {
        guard let value else { return }
        self.value = value + 1
        syncTextFromValue()
    }
    
    private func decrementValue() {
        guard let value, value > 0 else { return }
        self.value = value - 1
        syncTextFromValue()
    }

    
}

#Preview("Sheet") {
    
    @Previewable @State var presentSheet = true
    @Previewable @State var value: Int? = 42

    Button {
        presentSheet.toggle()
    } label: {
        Text("Present Sheet")
    }
    .buttonStyle(.bordered)
    .sheet(isPresented: $presentSheet) {
        NavigationStack {
            KeyboardView(title: "Keyboard", value: $value)
        }
    }
    
}


#Preview("Fullscreen") {
    
    @Previewable @State var value: Int? = 42

    NavigationStack {
        ZStack {
            Color.init(uiColor: UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            KeyboardView(title: "Keyboard", value: $value)
        }
    }

}

#endif
