

# Memento

### Description </br>
Lets you capture the object's internal state without exposing its internal structure, so that the object can be returned to this state later. </br>

### iOS/MacOS adaptation </br>
Memento pattern is implemented through the NSCoding protocol (object conforms to the protocol and works with an NSCoder object to produce a snapshot of its state). </br>

### Structure/UML*
--

### Rules of thumb*
--

### Why and where you should use the pattern*

### Pros </br>
Does not violate the originator's encapsulation. </br>
Simplifies the originator's code by allowing a caretaker to maintain the history of originator's state. </br>

### Cons </br>
May require lots of RAM if mementos are made frequently. </br>
Can not guarantee that the state within the memento stays untouched. </br>

### More
--
