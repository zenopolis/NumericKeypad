<!-- ![NumericKeypad Banner](https://github.com/user-attachments/assets/823f2e50-033e-4176-beda-811acf88334e) -->

# NumericKeypad

<div align="center">
  
![version](https://img.shields.io/badge/version-0.0.1_alpha-green) 
![package manager, swift PM](https://img.shields.io/badge/package_manager-Swift_PM-green)
![Apple Platforms, iOS 26+](https://img.shields.io/badge/Platforms-iOS_26+%20-blue.svg?style=flat&logo=apple&logoColor=white)
![swift 5](https://img.shields.io/badge/swift-5-blue)
![license MIT](https://img.shields.io/badge/license-MIT-lightgrey)

</div>

__NumericKeypad__ provides an accessibility compatible number picker for SwiftUI. The user can pick between two views: a number pad, and a system numeric keyboard with a text field. NumericKeypad will return to the last view the user chose when they invoke the picker again.  


![Three screenshots showing NumericKeypad in action. The first image shows the number pad and the accessible input field. The second image shows the keyboard view. The third image shows the number pad with Voice Control.](https://github.com/user-attachments/assets/c9faae3b-152a-40f7-8c1a-19e92a73b160)

## Content

1. [Accessibility Support](#accessibility-support)
2. [Requirements](#requirements)
    - [Current Limitations](#current-limitations)
3. [Installation](#installation)
    - [Swift Package Manager](#swift-package-manager)
    - [Manually](#manually)
4. [Usage Example](#usage-example)
5. [Author](#author)
6. [License](#license)

## Accessibility Support

 * VoiceOver
 * Voice Control
 * Larger Text
 * Dark Interface
 * Differentiate Without Color Alone
 * Sufficient Contrast
 * Reduced Motion

> __Note__: May not be suitable for Assistive Access.

## Requirements

- iOS 26+
- Swift 5+

### Current Limitations

This version of NumericKeypad is designed to work with positive integer values only. 

## Installation

### Swift Package Manager

You can use the [Swift Package Manager](https://docs.swift.org/latest/documentation/packagemanagerdocs/) to install `NumericKeypad` by adding it to your `Package.swift` file:

```swift
import PackageDescription

let package = Package(
    name: "NumericKeypad",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/zenopolis/NumericKeypad", from: "0.0.1"),
    ]
)
```

### Manually

To manually add this library in your project, drag the `Sources` folder into the project tree

## Usage example

``` swift
import NumericKeypad

struct ContentView: View {
        
    @State var value: Int = 0
    @State var newValue: Int? =  nil
    
    @State private var numericKeypad = NumericKeypad()
    
    var body: some View {
        VStack {
            Spacer()
            Text("[\(value)]")
                .font(.largeTitle.bold())
            Spacer()
            Button {
                newValue = value
                numericKeypad.activate()
            } label: {
                Text("Open Keypad")
            }
        }
        .sheet(isPresented: $numericKeypad.isActive) {
            numericKeypad.sheet(title: "Change Value", value: $newValue)
        }
        .onChange(of: numericKeypad.isActive) {
            if !numericKeypad.isActive {
                if let newValue {
                    value = newValue
                }
            }
        }
        Spacer()
    }
    
}
```

## Author
__NumericKeypad__ was created by [David Kennedy](https://zenopolis.com/contact/).

## License
__NumericKeypad__ is available under the MIT license. See the LICENSE file for more info.
