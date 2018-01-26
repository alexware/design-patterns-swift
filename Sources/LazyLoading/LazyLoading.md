

# Lazy Loading (Lazy Initialization)

### Description </br>
A technique for delaying the creation of an object or some other expensive process until it’s needed. </br>

### iOS/MacOS adaptation </br>
Swift added direct support for it with the 'lazy' attribute. </br>

### Structure/UML
--

### Rules of thumb
--

### Why and where you should use the pattern
When the initial value for a property is not known until after the object is initialized or computationally intensive.

### Pros </br>
Can contribute to efficiency in the program's operation if properly and appropriately used. </br>

### Cons </br>
Can cause retain cycles. </br>

### More
--
