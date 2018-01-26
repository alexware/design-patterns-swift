

# Factory Method (Factory / Class Factory Method / Virtual Constructor)

### Description </br>
Used when there are several classes that implement a common protocol or share a common base class. This pattern allows implementation subclasses to provide specializations without requiring the components that rely on them to know any details of those classes and how they relate to each other. </br>


### iOS/MacOS adaptation </br>
Convenience class-methods in NSNumber. </br>

### Structure/UML*
--

### Rules of thumb*
--

### Why and where you should use the pattern*

### Pros </br>
Simplifies code due to moving all creational code to one place. </br>
Avoids tight coupling between concrete products and code that uses them. </br>
Follows the Open/Closed Principle. </br>

### Cons </br>
Requires extra classes. </br>

### More
--
