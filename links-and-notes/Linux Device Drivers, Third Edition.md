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

Page 24

make -C ~/kernel-2.6 M=`pwd` modules

this command starts by changes its directory to the one provided with the -C option (that is, your kernel source directory). There it finds the kernel's top-level makefile. The M= option causes the makefile to move back into your module source directory before trying to build the modules target. thiis target, in turn, refers to the list of modules found in the obj-m variable, which we've set to module.o in our examples.

Typing the previous make command can get tiresome after a while, so the kernel developers have developed a sort of makefile idiom, which makes life easier for those building modules outside of the kernel tree. The trick is to write your makefile as follows.

once again, we are seeing the extended GNU make syntax in action. This makefile is read twice on a typical build. When the makefile is invoked from the command line, it notices that the KERNELRELEASE variable has not been set. It locates the kernel source directory by taking advantage of the fact that the symbolic link build in the installed modules directory points back at the kernel build tree. If you are not actually running the kernel that you are building for, you can supply a KERNELDIR= option on the command line, set the KERNELDIR environment variable, or rewrite the line that sets KERNELDIR in the makefile.

Page 26

Platform Dependency

Each computer platform has its peculiarities, and kernel designers are free to explot alll the peculiarities to achieve better performance in the target object file.

For example, the IA32 (x86) architecture has been subdivided into several different processor types. The old 80386 processor is still supported (for now), even though its instruction set is, by modern standards, quite limited.


Page 30 

Preliminaries 

We are getting closer to looking at some actual module code. But first, we need to look at some other things that need to appear in your module source files. The kernel is a unique environment, and it imposes its own requirements on code that would interface with it.

//...

There are a few that are specific to modules, and must appear in every loadable module. Thus, just about all module code has the following:

    #include <linux/module.h>
    #include <linux/init.h>



Page 35

Module parameters

Several parameters that a driver needs to know can change from system to system. These can vary from the device number to use (as we'll see in the next chapter) to numerous aspects of how the driver should operate.


Page 302 

Chapter 12 PCI Drivers

While chapter 9 introduced the lowest levels of hardware control, this chapter provides an overview of the higher-level bus architecture. A bus is made up of both an electrical interface and a programming interface. In this chapter, we deal with the programming interface.

This chapter covers a number of bus architectures. However, the primary focus is on the kernel functions that access Peripheral component interconnect (PCI) peripherals, because these days the PCI bus is the most commonly used peripheral bus on desktops and bigger computers. The bus iis the one that is best supported by the kernel. ISA is still common for electronic hobbyist and is described later, although it is pretty much a bare-metal kind of bus, and there isn't much to say in addition to what is covered in Chapters 9 and 10.

The PCI interface

Although many computer users think PCI as a way of laying out electrical wires, it is actually a complete set of specifications defining low different parts of a computer should interact.

The PCI specification covers most issues related to computer interfaces. We are not going to cover it all here; in this section, we are mainly cnocerned with how a PCI driver can find its harware and gain access to it. The probing techniques dicussed in the sections "Module Parameters" in Chapter 2 and "Autodetecting the IRQ Number" in Chapter 10 can be used with PCI devices, but the specification offers an alternative that is preferabke to probing.

The PCI architecture was designed as a replacement for the ISA standard, with three main goas: to get better performance when transferring data between the computer and its peripherals, to be as platform independent as possible, and to simplify adding and removing peripherals to the system.









Page Chapter 14

The Linux Device Model

One of the stated goals for the 2.5 development cycle was the creation of a unified device model for the kernel. Previous kernels had no single data structure to which they  could trun to obtain information about how the system is put together. Despite this lack of information, things worked well for some time. The demand of newer systems, with their more complicated topologies and need to support features such as power management, made it clear, however, that a general abstraction describing the structure of the system was needed.

The 2.6 device model provides that abstration. It is now used within the kernel to support a wide variety of tasks, including:
- Power management and system shutdown
    These requires an understanding of the system's structure. For example, a USB host adaptor cannot be shut down before dealing with all of the devices connected to that adaptor. The device model ebables a traveral of the system's hardware in the right order.











































Chapter 17: Network Drivers

Page 497

Having discussed char and device drivers, we are now ready to move on to the world of networking. Network interfaces are the third standard class of Linux devices, and this chapter describes how they interact with the rest of the kernel.

The role of a network interface within the system is similar to that of a mounted block device. A block device registers its disks and methods with the kernel, and then "transmits" and "receives" blocks on request, by means of its request function. Similarly, a network interface must register itself within specific kernel data structures in order to be invoked when packets are exchanged with the outside world.

There are few important differences between mounted disks and packet-delivery interfaces. To begin with, a disk exists as a special file in the /dev directory, whereas a network interface has no such entry point. The normal file operations (read, write, and so on) do not make sense when applied to network interfaces, so it is not possible to apply the Unix "everything is a file"


Page 498

This section dicusses the design concepts that led to the snull network interface. Although this information might appear to be of marginal use, failing to understand it might lead to problems when you play with the sample code.

Page 499

Assigning IP Numbers

The snull module creates two interfaces. These interfaces are different from a simple loopback, in that whatever you transmit through one of the interfaces loops back to the other one, not to itself. It looks like you have two external links, but actually yoour computer is replying to itself.

Unfortunately, this effect can't be accomplished through IP number assignments alone, because the kernel wouldn't send out a packet through interface A that was directed to its own interface B. 




























































Page 546

TTY drivers

a tty device gets its name from the very old abbreviation of teletypewriter and was originally associated with the physical or virtual terminal connection to a Unix machine. Over time, the name also come to mean any serial port style device, as terminal connections could also be created over such a connection. Some examples of physical tty devices are serial ports, USB-to-serial-port converters, and some types of modems that need special processing to work properly.





































