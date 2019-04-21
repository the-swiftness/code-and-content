//: [Previous](@previous)

struct Temperature {
    private var _celsius: Double = 0.0
    private var _fahrenheit: Double = 0.0
    
    var celsius: Double {
        get { return _celsius }
        set {
            _celsius = newValue
            _fahrenheit = 32 + (newValue * (9 / 5))
        }
    }
    
    var fahrenheit: Double {
        get { return _fahrenheit }
        set {
            _fahrenheit = newValue
            _celsius = (newValue - 32) * (5 / 9)
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

hotCoffee.fahrenheit = 99

print(hotCoffee.fahrenheit)
print(hotCoffee.celsius)

hotCoffee.celsius = 40

print(hotCoffee.fahrenheit)
print(hotCoffee.celsius)

//: [Next](@next)
