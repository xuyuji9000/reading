[Understanding “extern” keyword in C](https://www.geeksforgeeks.org/understanding-extern-keyword-in-c/)

Basically, the extern keyword extends the visibility of C variables and C functions. That's probably the reason why it was named extern.

Though most people probably undertand the difference between the "declaration" and the "definition" of a variable or function, for the sake of completeness, I would like to clarify them.

- Declartion of a variable or function simply declares that the variable or function exists somewhere in the program, but the memory is not allocated for them. The declaration of a variable or function serves an important role -- it tells the program what its type is going to be. In case of function declarations, it also tells the program the arguments, their data types, the order of those arguments, and the return type off the function. So that's all about the declaration.

- Coming to definition, when we define a variable or function, in addition to everything that a declaration does, it also allocates memory for that variable or function. Therefore, we can think of definition as a superset of the declaration(or decllaration as a subset of definition).

Since the extern keyword extends the function's visibility to the whole program, the function can be used(called) anywhere in any of the files of the whole program, provides those files contain a declaration of the function.(With the declaration of the function in place, the compiler knows the definition of the function exists somewhere else and it goes ahead and compiles the file).

