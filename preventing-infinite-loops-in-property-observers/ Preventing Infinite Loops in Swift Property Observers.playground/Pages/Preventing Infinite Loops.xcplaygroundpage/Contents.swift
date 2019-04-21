//: [Previous](@previous)

import Foundation

struct Temperature {
    var celsius: Double {
        didSet {
            let properFahrenheit = 32 + (celsius * (9 / 5))
            
            if fahrenheit != properFahrenheit {
                fahrenheit = properFahrenheit
            }
        }
    }
    
    var fahrenheit: Double {
        didSet {
            let properCelsius = (fahrenheit - 32) * (5 / 9)
            
            if celsius != properCelsius {
                celsius = properCelsius
            }
        }
    }
    
    init(celsius: Double) {
        self.celsius = celsius
        self.fahrenheit = 32 + (celsius * (9 / 5))
    }
    
    init(fahrenheit: Double) {
        self.fahrenheit = fahrenheit
        self.celsius = (fahrenheit - 32) * (5 / 9)
    }
}


var hotCoffee = Temperature(celsius: 38)

print(hotCoffee.fahrenheit)
print(hotCoffee.celsius)

hotCoffee.fahrenheit = 120

print(hotCoffee.fahrenheit)
print(hotCoffee.celsius)

//: [Next](@next)
