Understanding Linux Network Internals

The performance of a pure software-based product that uses Linux cannot compete with commercial products that can count on the help of the specialized hardware. This of course is not a criticism of software; it is a simple recognition of the consequence of the speed difference between dedicated hardware and general-purpose CPUs. 

xviii 

Organization of the material 

Some aspects of networking code requires as many as seven chapters, while for other aspects one chapter is sufficient. When the topic is complex or big enough to span different chapters, the part of the book devoted to the topic always starts with a concept chapter that covers the theory necessary to understand the implementation, which is described in another chapter. All of the reference and secondary material is usually located in one miscellaneous chapter at the end of the part. No matter how big the topic is, the same scheme is used to organize its presentation.

For each topic, the implementation description includes:
The big picture, which shows where the described kernel component falls in the network stack.
A brief description of the main data structures and a figure that shows how they relate to each other
A description of which other kernel features the component interfaces with -- for example, by means of notification chains or data structure cross-references. The firewall is an example of such a kernel feature, given the numerous hooks it has all over the networking code.
Extensive use of flow charts and figures to make it easier to go through the code and extract the logic from big and seemingly complex functions.

The reference material always includes:
A detailed description of the most important data structures, field by field
A table with a brief description of all functions, macros, and data structures, which you can use as a quick reference
A list of the files mentioned in the chapter, with their location in the kernel source tree.
A description of the interface between the most common user-space tools used to configure the topic of the chapter and the kernel.
A description of any file in /proc that is exported
//…

For example, given any feature, you need to take the following points into consideration:

xix
How do you design the data structure and the locking semantics?
Is there a need for a user-space configuration tool? If so, is it going to interact with the kernel via an existing system call, an ioctl command, a /proc file , or the netlink socket?
Is there any need for a new notification chain, and is there a need to register to an already existing chain?
What is the relationship with the firewall?
Is there any need for a cache, a garbage collection mechanism, statistics, etc.?

Here is the list of topics covered in the book:
Interface between user space and kernel
    In chapter 3, you will get a brief overview of the mechanisms that networking configuration tools use to interact with their counterparts inside the kernel. It will not be a detailed discussion, but it will help you to understand certain parts of the kernel code.

System initialization
    Part II describes the initialization of key components of the networking code, and how network devices are registered and initialized.

Interface between device drivers and protocol handlers
    Part III offers a detailed description of how ingress(incoming or received) packets are handed by the device drivers to the upper-layer protocols, and vice versa.

Bridging
    Part IV describes transparent bridging and the Spanning Tree Protocol, the L2 counterpart of routing at L3.

Internet Protocol Version 4(IPv4)
    Part V describes how packets are received, transmitted, forwarded, and delivered locally at the IPv4 layer.

Page 1

Part I General Background

The information in this part of the book represents the basic knowledge you need to understand the rest of the book comfortably. If you are already familiar with the Linux kernel, or you are an experienced software engineer, you will be able to go pretty quick through these chapters. For other readers, I suggest getting familiar with this material before proceeding with the following parts of the book:

Chapter 1, Introduction
The bulk of this chapter is devoted to introducing a few of the common programming patterns and tricks that you'll often meet in the networking code.
Chapter 2, Critical data structures
In this chapter, you can find a detailed description of two of the most important data structures used by the networking code: the socket buffer sk_buff and the network device net_device

Chapter 3, User-Space-to-Kernel Interface
The discussion of each feature in this book ends with a set of sections that shows how user-space configuration tools and kernel communicate. The information in this chapter can help you understand those sections better.











Page 3

Chapter 1 introduction

To do research in the source code of a large project is to enter a strange, new land with its own customs and unspoken expectations. 

// …
I'll also describe some tools that let you find your way gracefully through the enormous kernel code. Finally, I'll explain briefly why a kernel feature may not be integrated into the official kernel releases, even if it is widely used in the Linux community.


Page 8

Page 9

// …
Function pointers have one main drawback: they make browsing the source code a little harder. While going through a given code path, you may end up focusing on a function pointer call. In such cases, before proceeding down the code path, you need to find out how the function pointer has been initialized. It could depend on different factors.
When the selection of the routine to assign to a function pointer is based on a particular piece of data, such as the protocol handling the data or the device driver a given packet is received from, it is easier to derive the routine. For example, if a given device is managed by the ./drivers/net/3c59x.c device driver, you can derive the routine to which a given function pointer of the net_device data 

Page 10

structure is initialized by reading the device initialization routine provided by the device driver.
When the selection of the routine is based instead on more complex logic, such as the state of the resolution of an L3-to-L2 address mapping, the routine used at any time depends on external events that cannot be predicted.

// ...

Page 11

Conditional directives

//…
They appear for different reasons, but the ones we are interested in are those used to check whether a given feature is supported by the kernel. Configuration tools such as make xconfig determine whether the feature is compiled in, not supported at all, or loadable as a module.


Page 13

Compile-Time optimization for condition Checks

Most of the time, when the kernel compares a variable against some external value to see whether a given condition is met, the result is extremely likely to be predictable. This is pretty common, for example, with code that enforces sanity check. The kernel uses the likely and unlikely macros, respectively, to wrap comparisons that are likely to return a true(1) or false(0) result. Those macros take advantage of a feature of the gcc compiler that can optimize the compilation of the code based on that information.

Page 14

Mutual Exclusion

// …
Spin locks
This is a lock that can be held by one thread of execution at a time. An attempt to acquire the lock by another thread of execution makes the latter loop until the lock is released. 

Page 17
Statistics 

It is a good habit for a feature to collect statistics about the occurrence of specific conditions, such as cache lookup successes and failures, memory allocation successes and failures, etc. For each networking feature that collects statistics, this book lists and describes each counter.



























Page 22

Chapter 22 Critical Data Structures

// …
This chapter introduces the following data structure, and mentions some of the functions and macros that manipulate them:

Struct sk_buff

    This is where a packet is stored. The structure is used by all the network layers to store their headers, information about the user data(the payload), and other information needed internally for coordinating their work.

Struct net_device
    Each network device is represented in the linux kernel by this data structure, which contains information about both its hardware and its software configuration. See chapter 8 for details on when and how net_device data structures are allocated.

Another critical data structure for linux networking is struct sock, which stores the networking information for sockets. Because this book does not cover sockets, I have not included sock in this chapter.

The socket buffer: sk_buff structure
This is probably the most important data structure in the linux networking code, 



Page 43

net_device structure
The net_device data structure stores all information specifically regarding a network device. There is one such structure for each device, both real ones(such as Ethernet NICs) and virtual ones(such as bonding or VLAN). 

// …

Network devices can be classified into types such as ethernet cards and Token Ring cards. While certain fields of the net_device structure are set to the same value for all devices of the same type, some fields must be set differently by each model of device. 






Page 48
Statistics 
Instead of providing a collection of fields to keep statistics, the net_device structure includes a pointer named priv that is set by the driver to point to a private data structure storing information about the interface.



Page 58

Chapter 3 user-space-to-kernel interface 

In this chapter, I'll briefly introduce the main mechanisms that user-space applications can use to communicate with the kernel or read information exported by it. We will not look at the details of their implementations, because each mechanism would deserve a chapter of its own. The purpose of this chapter is to give you enough pointers to the code and to external documentation so that you can further investigate the topic if interested. For example, with this chapter, you can have the information you need to find how and where a given directory is added to /proc, kernel handler which processes a given ioctl command, and when functions are provided by netlink, currently the preferred interface for user-space network configuration.

This chapter focuses only on the mechanisms that I will often mention in the book when talking about the interface between the user-space configuration commands such as ifconfig and route and the kernel handlers that apply the requested configurations.

// ...

Overview

The kernel exports internal information to user space via different interfaces. Besides the classic set of system calls the application programmer can use to ask for specific information, there are three special interfaces, two of which are virtual filesystems:

Procfs (/proc filesystem)

This is a virtual filesystem, usually mounted in /proc, that allows the kernel to export internal information to user space in the form of files. The files don't actually exist on disk, but they can be read through cat or more 

Sysctl (/proc/sys directory)
This interface allows user space to read and modify the value of kernel variables. You cannot use it for every kernel variable: the kernel has to explicitly say what variables are visible through this interface. 

Sysfs (/sys filesystem)
Procfs and sysctl have been abused over the years, and this has led to the introduction of a newer filesystem: sysfs. Sysfs exports plenty of information in a very clean and organized way. You can expect part of the information currently exported with sysctl to migrate to sysfs.

Ioctl system call
The ioctl (input/output control) system call operates on a fille and is usually used to implement operations needed by special devices that are not provided by the standard filesystem calls. 

Page 67

The name of the ioctl commands in the figure is parsed (split into components) for your convenience. For example, the command used to add a route to a routing table,SIOCADDRT, is shown as SIOC ADD RT to emphasize the two interesting components: 
ADD, which says you are adding something
And RT, which says a route is what you are adding.


Page 73

Part II
System initialization
In this part of the book, we will see how and when network devices are initialized and registered with the kernel. I'll put special emphasis on Peripheral Component Interconnect devices, both because they are interestingly common and because they have special requirements.
Many tasks related to the network interface card(NIC) have to be accomplished before getting a network up and running. First key kernel components need to be initialized. Then device drivers must initialize and register and the devices they are responsible for and allocate the resources the kernel will use to communicate with them (IRQ, IO port, etc).

It's important to distinguish between two kinds of registration. First, when a device is discovered, it is registered with the network stack as a network device. For example, a PCI ethernet card is registered both as a generic PCI device with the PCI layer, and as an Ethernet card(where the device gets the name such as eth0) with the network stack. The first kind of registration is covered in Chapter 6 and the second in Chapter 8.

Here is what is covered in each chapter:

Chapter 4, Notification Chains
    The mechanism that kernel components use to notify each other about specific events.

Chapter 5, Network Device initialization 
    How network devices are initialized

Chapter 6, the PCI layer and network interface card
How PCI device drivers register with the kernel, and how PCI devices are identified and associated with their drivers.

Chapter 7, Kernel infrastructure for Component initialization
The kernel mechanism that ensures that the necessary initialization functions are invoked at boot time or module load time. We'll learn how initialization routines can be tagged with special macros to optimize memory usage and therefore reduce the size of the kernel image. We will also see how the kernel can be passed boot options and how these can be used to configure NICs.


Page 175

Part III
Transmission and Reception

The aim of these five chapters is to put into context all the features that can influence the path of a packet inside the kernel, and give you an idea of the big picture. You will see what each subsystem is supposed to do and when it comes into the picture. This chapter will not touch upon routing, which has a large chapter of its own, or firewalling, which is beyond the scope of this book.

In general usage, the term transmission is often used to refer to communications in any direction. But in kernel discussions, transmission refers only to sending frames outward, whereas reception refers to frames coming in. In some places, I use the term ingress for reception and egress for transmission.

Forwarded packets -- which both originate and terminate in remote systems but use the local system for routing -- constitute yet another category that combines elements of receptions nad transmission. Some aspects of forwarding are presented in Chapter 10; a more thorough discussion appears in Parts V and VII.

We saw in Chapter 1 the differences between the term frame, datagram, and the packet. Because the chapters in Part III discuss the interface between L2 and L3, both the terms frame and packet would be correct in most cases. Even though I'll mostly use the term frame, I may sometimes use a packet when referring to a data unit with no reference to any particular layer. The word packet is he one most commonly seen in the code we are discussing.

Here is what we will see in each chapter of Part III:

Chapter 9, Interrupts and network drivers
In this chapter, you will be given an overview on both bottom half handlers and kernel synchronization mechanisms.

Chapter 10, frame reception
    This chapter goes on to describe the path through the L2 layer of a received frame.

Chapter 11, Frame Transmission
    Chapter 11 does the same as Chapter 10, but a transmitted (outgoing) frame.

Chapter 12, General Reference Material about interrupts
    This is a repository of reference material for the previous chapters.

Chapter 13, Protocol handlers
This chapter will conclude this part of the book with a discussion of how ingress frames are handed to the right L3 protocol receive routines.



Page 177

Interrupts and network drivers

The previous chapters gave an overview of how the initialization of core components in the networking code is taken care of. The remainder of the book offers a feature-by-feature or subsystem-by-subsystem analysis of how networking is implemented, why features were introduced, and, when meaningful, how they interact with each other.

This chapter begins an explanation of how packets travel between the L2 or driver layer and IP or network layer described in detail in Part V. I'll be referring a lot to the data structures introduced in Chapters 2 and 8, so you should be ready to turn back to those chapters as needed.

Even before the kernel is ready to handle the frame that is coming from or going to the L2 layer, it must deal with the subtle and complex system of interrupts set up to make the handling of thousands of frames per second possible. That is the subject of this chapter.

A couple of other general issues affect the discussion in this chapter:
When the linux kernel is compiled with support for symmetric multiprocessing(SMP) and runs on a multiprocessor system, the code for 

Page 275

Part IV
Bridging

At the L3 layer, protocols such as IPv4 connect different networks through the routing subsystem laid out in Part VII. In this part of the book, we will look at the link layer or L2 counterpart of routing: bridging. In particular:

Chapter 14, bridging: concepts
    Introduces the concepts of transparent learning and selective forwarding.
Chapter 15, Bridging: The spanning tree protocol
    Show how the spanning tree protocol(STP) solves most of bridging's limitations, and concludes with an overview of the latest STP enhancements (not yet available for Linux).

Chapter 16, Bridging: Linux implementation
    Show how Linux implements bridging and STP

Chapter 17, Bridging: Miscellaneous Topics
    Concludes with an overview of how the bridging code interacts with other networking subsystems and a detailed description of the data structures used by the bridging code.


Page 407

Part V

Internet Protocol Version 4(IPv4)

The linux kernel supports many layer three (L3) protocols, such as AppleTalk, DECnet, and IPX, but this book talks just about the one that dominates modern networking: IP.  While IPv4 will be described in detail, IPv6 will only briefly mentioned as needed. I will not spend much time on the theory behind these protocols, with which you should be somewhat familiar, but I will describe the implementation in Linux. I will focus on aspects of the design that are not obvious or that differ substantially from other operating systems. I will also explain the main drawbacks of version 4 of the IP protocol and show how IPv6 tries to address them. Therefore, while there is both some background theory and some code, I expect the reader to be familiar with the basic IP protocol behavior. Here is what is covered in each chapter:

Chapter 18, Internet Protocol Version 4(IPv4): Concepts
    Introduces the major tasks of the IP layers, and the strategies used.

Chapter 19, Internet Protocol Version 4(IPv4): Linux foundations and features
Show how the IP-layer reception routine processes ingress packets, and how IP options are taken care of.

Chapter 20, Internet Protocol Version 4(IPv4): forwarding the local delivery
Shows how ingress IP packets are delivered locally to the L4 protocol handler, or are forwarded when the destination IP address does not belong to the local host but the host has enabled forwarding.

Chapter 21, Internet Protocol Version 4(IPv4): transmission
    Shows how L4 protocols interface to the IP layer to request transmission.

Chapter 22, Internet Protocol Version 4(IPv4): Handling fragmentation
    Shows how fragmentation and defragmentation are handled.

Chapter 23, internet protocol version 4(IPv4), miscellaneous topics
Shows how configuration tools such as those in the IPROUTE2 package interface to the kernel, shows how the IP header's ID field is initialized on egress packets, and provides a detailed description of the data structures used at the IP layer.

Chapter 24, Layer Four Protocol and Row IP Handling
    Shows how L4 protocols register a handler for ingress traffic.

Chapter 25, internet control message protocol(ICMPv4)
    Describes the implementation of the ICMP protocol



Page 623

Part VI
Neighboring subsystem

Packets use a layer three protocol such as IP to reach a LAN, and then a Layer two protocol such as Ethernet to go from the router on the local network to the system where the endpoint application is running. But a step is missing in this scenario. How do the router and the application host know who each other are? In more technical terms, how can a host find the L2 address (such as a MAC address) that corresponds to a given IP address? The action of finding the L2 address associated with a given L3 address is referred to as "resolving the L3 address." the missing piece is filled in by a neighbouring protocol.

The most familiar neighboring protocol is address resolution protocol(ARP), and chapter 28 describes it in general terms. The corresponding protocol used in IPv6 is neighbor discovery(ND). But the key principles and tasks of a neighbouring protocol, and a neighboring subsystem within a operating system, can be generalized.

Here is what each chapter discusses:

Chapter 26, Neighboring subsystem: concept
    Describes why and when a neighboring protocol is used and lay out its major tasks.

Chapter 27, neighboring subsystem: infrastructure
    Discusses the infrastructure that is common to all neighboring protocols.

Chapter 28, neighboring subsystem: address resolution protocol(ARP)
Describes how ARP, the most common neighboring protocol and the one readers are most likely to have interacted with, uses the infrastructure.
Chapter 29, neighboring subsystem: Miscellaneous Topics
    Covers the command-line and user-space interface (including the neighboring subsystem's directories in the /proc filesystem).

Page 775

Part VII

Routing

Layer three protocols, such as IP, must find out how to reach the system that is supposed to receive each packet. The recipient could be in the cubicle next door or halfway around the world. When more than one network is involved, the L3 layer is responsible for figuring out the most efficient route(so far as that is feasible) and for directing the message toward the next system along the route, also called the next hop. This process is called routing, and it plays a central role in the linux networking code. Here is what is covered in each chapter.

Chapter 30, Routing: Concepts
Introduces the functionality that a basic router, and therefore the Linux kernel, must provide

Chapter 31, Routing: Advanced
Introduces optional features the user can enable to configure routing in more complex scenarios. Among them we will see policy routing and multipath routing. We will also look at the other subsystems routing interacts with.

Chapter 32, Routing: Linux Implementation
Gives you an overview of the main data structures used by the routing code, describes the initialization of the routing subsystem, and shows the interactions between the routing subsystem and other kernel subsystems.

Chapter 33, Routing: The routing cache
    Describes the routing cache, including the protocol-independent cache(destination cache, or DST). the description covers how elements are inserted and deleted from the cache, along with the garbage collection and lookup algorithms.

Chapter 34, routing: Routing tables
Describes the structure of the routing table, and how routes are added to and deleted from it.

Chapter 35, Routing: lookups
Describe the routing table lookups, for both ingress and egress traffic, with and without policy routing.

Chapter 36, Routing: Miscellaneous Topics
    Concludes this part of the book with a detailed description of the data structures introduced in chapter 32, and a description of the interfaces between user space and kernel. This includes a description of the old and new generation of administrative tools, namely the net-tools and IPROUTE2 packages.















































