

# Class Cluster

### Description </br>
Groups a number of private, concrete subclasses under a public, abstract superclass (pattern based on Abstract Factory). Class cluster is actually a specific implementation of a factory but the initialiser is used instead of the Factory Method to decide what instance to return. Also Factories are used to create instances implementing a protocol while Class Cluster is only suitable for creation of subclasses of an Abstract Class. However Class Clusters can only be implemented in Objective-C. Unlike Objective-C (where we can just replace 'self' in init method, and return proper subclass object based on the input type) when we call init method of a class we get only instance of that particular class in Swift...so we can't rely on the init method to construct a Class Cluster. A substitution whould be to use a Factory instead. </br>

### iOS/MacOS adaptation </br>
Objective-C: NSNumber, NSString, NSArray, NSDictionary, NSData. </br>
Swift: None. </br>

### Structure/UML*
-- </br>

### Rules of thumb*
-- </br>

### Why and where you should use the pattern*
-- </br>

### Pros </br>
-- </br>

### Cons </br>
-- </br>

### More
-- </br>
