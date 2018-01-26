

# Dependency Injection (DI)

### Description </br>
Technique whereby one object supplies the dependencies of another object. An injection is the passing of a dependency to a dependent object (a client) that would use it. </br>

Types: Method Injection, Property Injection, Initializer Injection. </br>

### iOS/MacOS adaptation </br>
UI(NS)AttributedString, UI(NS)ScrollView, UIDatePicker. </br>

### Structure/UML*
--

### Rules of thumb*
--

### Why and where you should use the pattern*

### Pros </br>
Follows Inversion of Control principle. </br>
Decreases coupling between a class and its dependency. </br>
Dependency injection allows a client the flexibility of being configurable. </br>
Allows a client to remove all knowledge of a concrete implementation that it needs to use. </br>

### Cons </br>
Dependency injection creates clients that demand configuration details be supplied by construction code. </br>
Dependency injection typically requires more upfront development effort since one can not summon into being something right when and where it is needed but must ask that it be injected and then ensure that it has been injected. </br>
Forces complexity to move out of classes and into the linkages between classes which might not always be desirable or easily managed.  </br>
Ironically, dependency injection can encourage dependence on a dependency injection framework. </br>

### More
--
