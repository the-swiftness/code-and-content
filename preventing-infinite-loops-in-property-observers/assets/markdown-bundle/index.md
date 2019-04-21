# Preventing Infinite Loops in Swift Property Observers

From validations to notifications to logging invocations, Swift’s [property observers](https://docs.swift.org/swift-book/LanguageGuide/Properties.html#ID262) — the `willSet` and `didSet` hooks available on the properties of structs, classes, and enums — are endlessly useful. 

Playing with such fire, however, runs the risk of getting burned — particularly, by creating infinite loops. 
---- 
## The Initial Trap


Consider a `Temperature` struct that holds different representations of  degrees  — allowing users to use their unit system of choice. 

In a world without property observers (but still with multiple temperature standards), we might make something like this:

```swift
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

hotCoffee.fahrenheit = 99

print(hotCoffee.celsius) // 37.22222222222222
```



Even for two variables, though, keeping everything in sync with corresponding `private` variables begins to feel unwieldy. 

So, instead of dealing such manual bookkeeping, why not just use `didSet` to trigger those changes for us?

```swift
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

```


Brilliant! And so clean! Now, we can change `fahrenheit` or `celsius` whenever we want and automatically g…

![](Screen%20Shot%202019-03-16%20at%206.16.23%20PM.png "Xcode Crash Image")

Ouch 🔥.

What’s going on here? Quite simply, an infinite loop: Each `Temperature`  property’s `didSet` sets the other… which sets the other… which sets the other… which sets the other… onwards until the [heat death of the Universe](https://en.wikipedia.org/wiki/Heat_death_of_the_universe). 


![](spiderman-pointing-at-spiderman.png)

---- 
## Licking our Wounds


Making this kind of mistake can be disheartening. In turn, such disparagement can dissuade us from our attempt at good design: Perhaps the manual bookkeeping approach is better after all. Perhaps we were getting a bit too clever. Perhaps we [flew a bit too close to the sun](http://www.mythweb.com/encyc/entries/icarus.html). 

Shame 😔.

How could we have been so… 💡… wait a minute! 

Rather than going backwards, we can prevent this kind of error with _one more step forward_ — one more bit of logic inside of `didSet`:

```swift
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
```


As it turns out, we can tame `didSet` by ensuring that it only performs updates _if_ the property it’s concerned about is out of sync. If so, it mutates once. If not, it refrains — breaking the cycle full stop. 
---- 
## Alternative Approaches

Whenever we catch ourselves introducing side-effects to our code, it could be a hint that there’s a better approach to the problem altogether. I could certainly envision making separate structs for `Fahrenheit` and `Celsius` — allowing them to be first-class types — and then having static unit conversion methods on each. 

This approach would allow us to compute a converted temperature _as needed_, while saving us from performing potentially wasted updates otherwise. It would also improve testability, since we can now test each struct in isolation. Furthermore, we’d have a clear template to follow when we decide to add another unit, such as `Kelvin`.

All that being said, though, I still think it’s useful to detect this kind of problem — and know how to fix it directly. We may not have complete control over the design of our codebase; we may be dealing with a less trivial struct than the aforementioned `Temperature`; or we may simply need to implement a hotfix, saving the larger refactor for later. 

Ideally 🔜 🙂. 
---- 
