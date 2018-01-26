

# Decorator

### Description </br>
Decorator lets you attach new behaviors to objects by placing them inside wrapper objects that contain these behaviors. </br>

### iOS/MacOS adaptation </br>
UI(NS)AttributedString, UI(NS)ScrollView, UIDatePicker. </br>

### Structure/UML*
--

### Rules of thumb*
--

### Why and where you should use the pattern*

### Pros </br>
Allows adding and removing behaviors at runtime. </br>
Allows combining several additional behaviors by using multiple wrappers. </br>
Allows composing complex objects from simple ones instead of having monolithic classes that implement every variant of behavior. </br>

### Cons </br>
Additional classes. </br>
Hard to configure a multi-wrapped object. </br>

### More
--
