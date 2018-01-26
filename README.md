![alt text](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Art/art_title_image.png)

![](https://img.shields.io/badge/Licence-MIT-blue.svg) ![](https://img.shields.io/badge/Swift-4.0-orange.svg)

An open-source repo of design pattern implementations in Swift programming language. </br> 
All examples are located [HERE](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources). Check out the table below for convenience.

### Table of Implementations
👮🏼 Behavioural              | 👷🏼 Creational      | 👨🏼‍🏭 Structural    | 👨🏼‍🎓 Non-GOF | 👨🏻‍🔬 Functional |
------------            | -------------   | ------------- | ------------- |  ------------- 
[Chain of Responsibility](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/ChainOfResponsibility/ChainOfResponsibility.playground/Contents.swift) |[Factory Method](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/FactoryMethod/FactoryMethod.playground/Contents.swift) | [Facade](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/Facade/Facade) | [Dependency Injection](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/DependencyInjection/DependencyInjection.playground/Contents.swift) | Monad
[Strategy](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/Strategy/Strategy.playground/Contents.swift) |[Abstract Factory](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/AbstractFactory/AbstractFactory.playground/Contents.swift) | [Decorator](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/Decorator/Decorator.playground/Contents.swift)     |  [Object Pool](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/ObjectPool/ObjectPool.playground/Contents.swift) | Promise
[Command](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/Command/Command) |[Singleton](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/Singleton/Singleton.playground/Contents.swift)        | [Proxy](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/Proxy/Proxy.playground/Contents.swift)         |  Class Cluster | Factory Kit
[State](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/State/State.playground/Contents.swift)                   |[Builder](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/Builder/Builder.playground/Contents.swift)|[Adapter](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/Adapter/Adapter.playground/Contents.swift)| [Private Class Data](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/PrivateClassData/PrivateClassData.playground/Contents.swift) | Callback
[Observer](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/Observer/Observer.playground/Contents.swift)|[Prototype](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/Prototype/Prototype.playground/Contents.swift)|[Flyweight](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/Flyweight/Flyweight.playground/Contents.swift)| [Delegate](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/Delegate/Delegate.playground/Contents.swift) | Functor
[Memento](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/Memento/Memento.playground/Contents.swift)|                 |Bridge        |  [Multicast Delegate](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/MulticastDelegate/MulticastDelegate.playground/Contents.swift) | Applicative Functor
[Iterator](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/Iterator/Iterator.playground/Contents.swift)|                 |       Composite        |  [DataSource](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/DataSource/DataSource.playground/Contents.swift)
Template Method |  |  | [Lazy Loading](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/LazyLoading/LazyLoading.playground/Contents.swift)
[Mediator](https://github.com/oleh-zayats/design-patterns-swift/tree/master/Sources/Mediator/Mediator/Mediator) |  |  | 
Interpreter |  |  | 
[Visitor](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/Visitor/Visitor.playground/Contents.swift)  |  |  | 

### Overview 
Each pattern is overviewed in a separate Markdown file which contains description, structure, UML, advantages/disadvantages etc. Click on a pattern title to see more.

👮🏼 Behavioural </br> 
> Design patterns that identify common communication patterns between objects and realize these patterns. By doing so, these patterns increase flexibility in carrying out this communication.

[Chain of Responsibility](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/ChainOfResponsibility/ChainOfResponsibility.md) </br> 
[Strategy](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/Strategy/Strategy.md) </br> 
[Command](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/Command/Command.md) </br> 
[State](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/State/State.md) </br> 
[Observer](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/Observer/Observer.md) </br> 
[Iterator](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/Iterator/Iterator.md) </br> 
[Memento](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/Memento/Memento.md) </br> 
Template Method </br> 
[Mediator](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/Mediator/Mediator.md) </br> 
Interpreter</br> 
[Visitor](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/Visitor/Visitor.md) </br> 

👷🏼 Creational </br> 
> Design patterns that deal with object creation mechanisms, trying to create objects in a manner suitable to the situation. 

[Factory Method](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/FactoryMethod/FactoryMethod.md) </br> 
[Abstract Factory](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/AbstractFactory/AbstractFactory.md) </br> 
[Singleton](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/Singleton/Singleton.md) </br> 
[Builder](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/Builder/Builder.md) </br> 
[Prototype](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/Prototype/Prototype.md) </br> 
[Class Cluster](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/Class%20Cluster/ClassCluster.md) </br> 

👨🏼‍🏭 Structural </br> 
> Design patterns that ease the design by identifying a simple way to realize relationships between entities.

[Facade](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/Facade/Facade.md) </br> 
[Decorator](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/Decorator/Decorator.md) </br> 
[Proxy](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/Proxy/Proxy.md) </br> 
[Adapter](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/Adapter/Adapter.md) </br> 
[Flyweight](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/Flyweight/Flyweight.md) </br> 
Bridge </br> 
Composite </br> 

👨🏼‍🎓 Non-GOF </br> 
> Design patterns that are not described in the GOF book.

[Dependency Injection](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/DependencyInjection/DependencyInjection.md) </br> 
[Object Pool](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/ObjectPool/ObjectPool.md) </br> 
[Private Class Data](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/PrivateClassData/PrivateClassData.md) </br> 
[Delegate](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/Delegate/Delegate.md) </br> 
[Multicast Delegate](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/MulticastDelegate/MulticastDelegate.md) </br> 
[DataSource](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/DataSource/DataSource.md) </br> 
[Lazy Loading](https://github.com/oleh-zayats/design-patterns-swift/blob/master/Sources/LazyLoading/LazyLoading.md) </br> 

👨🏻‍🔬 Functional </br> 
> Design patterns that come from functional programming.

Monad </br> 
Promise </br> 
Factory Kit </br> 
Callback </br> 
Functor </br> 
Applicative Functor </br> 
