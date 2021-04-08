[MODULE_ALIAS](https://lwn.net/Articles/47412/)
the Linux kernel has long had the capability to load modules on demand when external events make their presense necessary. In many cases, the kernel knows exactly which module is required, and can simply ask for it by name. So, for example, the IDE subsystem can call: 
request_module("ide-cd");