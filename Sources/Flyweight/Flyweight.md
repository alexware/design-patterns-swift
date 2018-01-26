

# Flyweight

### Description </br>
Flyweight is an optimization pattern that lets you fit more objects into the available amount of memory by sharing cached object state among multiple objects, instead of keeping it in each object. </br>


### iOS/MacOS adaptation </br>
NSString, NSNumber (they implement technique that many languages apply to string values, using a process known as 'string interning' that reduces the amount of RAM used to store values and that speeds up comparison). </br>

### Structure/UML*
--

### Rules of thumb*
--

### Why and where you should use the pattern*

### Pros </br>
Saves memory, thus allowing a program to support much more objects. </br>

### Cons </br>
Increases overall code complexity (extra classes). </br>
Wastes CPU time on searching or calculating the context.

### More
--
