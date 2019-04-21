import Foundation

struct Temperature {
    var celsius: Double {
        didSet {
            fahrenheit = 32 + (celsius * (9 / 5))
        }
    }
    
    var fahrenheit: Double {
        didSet {
            celsius = (fahrenheit - 32) * (5 / 9)
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

//hotCoffee.fahrenheit = 99  💥

