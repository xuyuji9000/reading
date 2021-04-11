[Namespaces in operation, part 7: Network namespaces](https://lwn.net/Articles/580893/)

as the name would imply, network namespaces partition the use of the network -- devices, addresses, ports, routes, firewall rules, etc -- into separate boxes, essentially virtualizing the network within a single running kernel instance. Network namespaces entered the kernel in 2.6.24, almost exactly five years ago; it took something approaching a year before they were ready for prime time. Since then, they have been largely ignored by many developers.

// ...

Network namespace configuration

New network namespace will have a loopback device but no other network devices. Aside from the loopback device, each network device (physical or virtual interfaces, bridges, etc.) can only be present in a single network namespace. In addition, physical devices (those connected to real hardware) cannnot be assigned to namespaces other than the root. Instead, virtul network devices (e.g. virtual ethernet or veth) can be created and assigned to a namespace. These virtual devices allow processes inside the namespace to communicate over the network; it is the configuration, routing, and so on that determin who they can communicate with.
