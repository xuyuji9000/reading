[Linux Device Drivers, Third Edition](https://raw.githubusercontent.com/xuyuji9000/linux-playground/master/Linux-Device-Drivers-Third-Edition.pdf)

Xi 

CHAPTER 1 An Introduction toDevice Drivers

Page 1

Page 5
//…
Networking 
Networking must be managed by the operating system, because most network operations are not specific to a process: incoming packets are asynchronous events. The packets must be collected, identified and dispatched before a process can take care of tem. The system is in charge of delivering data packets across program and network interfaces, and it must control the execution of programs according to their network activity. Additionally, all the routing and addressing resolution issues are implemented within the kernel.


Page 12

// …
Overview of the Book
From here on, we enter the world of kernel programming. Chapter 2 introduces modularization, explaining the secrets of the art and showing the code for running modules. Chapter 3 talks about char drivers and shows the complete for a 

Page 13
memory-based device driver that can be read and written for fun. Using memory as the hardware base for the device allows for anyone to run the sample code without the need to acquire special hardware.

Debugging techniques are vital tools for the programmer and are introduced in Chapter 4. Equally important for those who would hack on contemporary kernels in the management of concurrency and race conditions. Chapter 5 concerns itself with the problems posed by concurrent access to resources and introduces the Linux mechanism for controlling concurrency.

With debugging and concurrency management skills in place, we move to advanced features of char drivers, such as blocking operations, the use of select, and the important ioctl call; these topics are the subject of Chapter 6.

Before dealing with hardware management, we dissect a few more of the kernel's software interfaces: Chapter 7 shows how time is managed in the kernel, and Chapter 8 explains memory allocation.

Next we focus on hardware. Chapter 9 describes the management of I/O ports and memory buffers that live on the device; after that comes interrupt handling, in chapter 10. Unfortunately, not everyone is able to run the sample code for these chapters, because some hardware support is actually needed to test the software interface interrupts. 
//…

Chapter 11 covers the use of data types in the kernel and the writing of portable code.

The second half of the book is dedicated to more advanced topics. We start by getting deeper into the hardware and, in particular, the functioning of specific peripheral buses. Chapter 112 covers the details of writing drivers for PCI devices, and Chapter 13 examines the API for working with USB devices.

With an understanding of peripheral buses in place, we can take a detailed look at the Linux device model, which is the abstraction layer used by the kernel to describe the hardware and software resources it is managing. Chapter 14 is a bottom-up look at the device model infrastructure, starting with the kobject type and working up from there. It covers the integration of the device model with real hardware; it then uses that knowledge to cover topics like hot-pluggable devices and power management.

In chapter 15, we take a diversion into Linux memory management. This chapter shows how to map kernel memory into user space( the mmap system call), map user memory into kernel space(ith get_user_pages), and how to map either kind of memory into device space(to perform direct memory access[DMA] operations).

Page 14


Our understanding of memory will be useful for the following two chapters, which cover the other major driver classes. Chapter 16 introduces block drivers and shows how they are different from the char drivers we have worked with so far. Then chapter 17 gets into the writing of network drivers. We finish up with a discussion of serial drivers(Chapter 18) and a bibliography. 
























Page 15 
CHAPTER 2 Building and Running Modules
It's almost time to begin programming. This chapter introduces all the essential concepts about modules and kernel programming. In these few pages, we build and run a complete(if relatively useless) module, and look at some of the basic code shared by all modules. Developing such expertise is an essential foundation for any kind of modularized driver. To avoid throwing in too many concepts at once, this chapter talks only about modules, without referring to any specific device class.
All the kernel items(functions, variables, header files, and macros) that are introduced here and described in a reference section at the end of the chapter.

Setting up your test system

Starting with this chapter, we present example modules to demonstrate programming concepts. Building, loading, and modifying these examples are a good way to improve your understanding of how drivers work and interact with the kernel.

The example modules should work with almost any 2.6.x kernel, including those provided by distribution vendors. However, we recommend that you obtain a "main-line" kennel directly from the kernel.org mirror network, and install it on your system. Vendor kernels can be heavily patched and divergent from the mainline; at times, vendor kernels can change the kernel API as seen by device drivers. If you are writing a driver that must work on a particular distribution, you will certainly want to build and test against the relevant kernels. But, for the purpose of learning about driver writing, a standard kernel is best.

Regardless of the origin of your kernel, building modules for 2.6.x requires that you have a configured and built kernel tree on your system. This requirement is a change from previous versions of the kernel, where a current set of header files was sufficient. 2.6 modules are linked against object files found in the kernel source tree; the result is a more robust module loader, but also the requirement that those object files be available. 


Page 18

// …
Kernel Modules versus applications
Before we go further, it's worth underlining the various differences between a kernel module and an application.

While most small and medium-sized applications perform a single task from beginning to end, every kernel module just registers itself in order to serve future requests, and its initialization function terminates immediately. In other words, the task of the module's initialization function is to prepare for later invocation of the module's functions; it's as though the module were saying, "Here I am, and this is what I can do.". The module's exit function gets invoked just before the module is unloaded. It should  tell the kernel, "I'm not there anymore; don't ask me to do anything else.". This kind of approach to programming is similar to event-driven programming, but while not all applications are event-driven, each and every kernel module is. Another major difference between event-driven applications and kernel code is in the exit function: whereas an application that terminates can be lazy in releasing resources or avoids clean up altogether, the exit function of a module must carefully undo everything the init function built up, or the pieces remain around until the system is rebooted.

Incidentally, the ability to unload a module is of the features of modularization that you'll most appreciate, because it helps cut down development time; you can test successive versions of your new driver without going through the lengthy shutdown/reboot cycle each time.



Page 19



































Page 19 

Function "blk_init_queue" mentioned in the diagram has been removed from kernel since v5.0






























Chapter 17: Network Drivers

Page 497

Having discussed char and device drivers, we are now ready to move on to the world of networking. Network interfaces are the third standard class of Linux devices, and this chapter describes how they interact with the rest of the kernel.

The role of a network interface within the system is similar to that of a mounted block device. A block device registers its disks and methods with the kernel, and then "transmits" and "receives" blocks on request, by means of its request function. Similarly, a network interface must register itself within specific kernel data structures in order to be invoked when packets are exchanged with the outside world.

There are few important differences between mounted disks and packet-delivery interfaces. To begin with, a disk exists as a special file in the /dev directory, whereas a network interface has no such entry point. The normal file operations (read, write, and so on) do not make sense when applied to network interfaces, so it is not possible to apply the Unix "everything is a file"


Page 498

The network subsystem of the Linux kernel is designed to be completely protocol-independent. This applies to both networking protocols(IP, IPX or other protocols) and hardware protocols (Ethernet versus token ring, etc). Interaction between a network driver and the kernel properly deals with one network packet at a time; this allows protocol issues to be hidden neatly from the driver and the physical transmission to be hidden from the protocol.

This chapter describes how the network interfaces fit in with the rest of the Linux kernel and provides example in the form of a memory-based modularized network interface, which is called snull.








































