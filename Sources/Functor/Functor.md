
# Functor

### Description </br>
Functor is a structure preserving map between categories. </br>
In Swift a Functor is some type 'A' it could be a Collection like Array, Dictionary etc. or Enumeration or even a Promise which contains value of type 'B' and can transform it via map function. </br>


### iOS/MacOS adaptation </br>
Any type that implements 'map' in Swift will be a functor. </br>

### Structure/UML
A<B> -> A<C>, map(B -> C) </br>

fmap :: (a -> b) -> fa -> fb

### Rules of thumb
--

### Why and where you should use the pattern

### Pros </br>

### Cons </br>

### More
http://www.mokacoding.com/blog/functor-applicative-monads-in-pictures/
