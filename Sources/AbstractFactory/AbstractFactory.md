

# Abstract Factory

### Description </br>
The abstract factory pattern provides a way to encapsulate a group of individual factories that have a common theme without specifying their concrete classes. </br>
In normal usage, the client software creates a concrete implementation of the abstract factory and then uses the generic interface of the factory to create the concrete objects that are part of the theme. The client doesn't know (or care) which concrete objects it gets from each of these internal factories, since it uses only the generic interfaces of their products. This pattern separates the details of implementation of a set of objects from their general usage and relies on object composition, as object creation is implemented in methods exposed in the factory interface. </br>

### iOS/MacOS adaptation </br>
Not sure which classes adopt the pattern (many adopt the Class Cluster which is very similar but can only be implemented in Objective-C though).</br>

### Structure/UML*
--

### Rules of thumb*
--

### Why and where you should use the pattern*

### Pros </br>
Use of this pattern makes it possible to interchange concrete implementations without changing the code that uses them, even at runtime. </br>
Divides responsibilities between multiple classes. </br>
Avoids tight coupling between concrete products and code that uses them. </br>
Follows the Open/Closed Principle. </br>

### Cons </br>
Increases overall code complexity by creating multiple additional classes. </br>
Higher levels of separation and abstraction can result in systems that are more difficult to debug and maintain. </br>

### More
--
