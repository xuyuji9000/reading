[Kernel Stack and User Space Stack](https://www.baeldung.com/linux/kernel-stack-and-user-space-stack)
Overview 
The kernel stack and user stack are implemented using the stack data structure, taken together, serve as a call stack. 


Stack 
The stack data structure can be useful in expression evaluation/conversion, syntax checking, order reversing, backtracking, and function calls. 

As we follow the program execution, we need to save states for the transfer of control among functions. For this purpose, we use a call stack that is based on the stack data structure. Certain architecture-dependent conventions define what states are saved by caller and callee during execution.

Within a call stack, we can find a series of stack frames. A stack frame consists of data relevant to a particular function. It usually includes function arguments, the return address, and local data. 

Kernel space and user space

User and Kernel stacks

The kernel stack is part of the kernel space. Hence, it is not directly accessible from a user process. Whenever a user process uses syscall, the CPU mode witches to kernel mode. During the syscall, the kernel stack of the running process is used.



























