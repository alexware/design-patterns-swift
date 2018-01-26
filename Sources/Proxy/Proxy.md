

# Proxy

### Description </br>
Proxy lets you provide a substitute or placeholder for another object to control access to it. </br>

### iOS/MacOS adaptation </br>
NSProxy (Objective-C only). Attempting to derive a Swift class from NSProxy will generate a compiler error because it is impossible to call super.init from the derived class (because NSProxy doesn’t define an initializer). </br>

### Structure/UML*
--

### Rules of thumb*
--

### Why and where you should use the pattern*

### Pros </br>
Controls access to objects without clients noticing. </br>
Manages the lifecycle of a service object even when clients do not care. </br>

### Cons </br>
Delays the response. </br>

### More
--
