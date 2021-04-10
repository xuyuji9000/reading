[Generic Netlink HOW-TO based on Jamal's original doc](https://lwn.net/Articles/211209/)


2. Generic Netlink By example

This section deals with the generic netlink subsystem in the Linux kernel and provides a simple example of how in-kernel users can make use of the Generic Netlink API. Don't forget to review section #5, "Recommendations", before writing any code as it could save you, and the people who review your code, lots of time!

The first section explains how to register a Generic Netlink family which is required for Generic Netlink users who wish to act as servers, listening over the Generic Netlink "bus". The second section explains how to send and receive Generic Netlink messages in the kernel. Finally, the third section provides a brief introduction to using Generic Netlink in userspace.

2.1 Registering a Family

Registering a Generic Netlink family is a simple four step process: define the family, deffine the operations, register the family, register the operations. In order to help demonstrate these steps below is a simple example broken down and explained in detail.


