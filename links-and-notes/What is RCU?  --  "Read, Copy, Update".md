[What is RCU?  --  "Read, Copy, Update"](https://www.kernel.org/doc/Documentation/RCU/whatisRCU.txt)

[What is RCU? -- "Read, Copy, Update"](https://01.org/linuxgraphics/gfx-docs/drm/RCU/whatisRCU.html)

What is RCU?
RCU is a synchronization mechanism that was added to the Linux kernel during the 2.5 development effort that is optimized for read-mostly situations. Although RCU is actually quite simply once you understand it, getting there can sometimes be a challenge. Part of the problem is that most of the past descriptions of RCU have been written with the mistaken assumption that there is "one true way" to describe RCU. Instead, the experience has been that different people must take different paths to arrivev at the understanding of RCU. THis document provides sevveral different paths, as follows:

1. RCU overview
2. What is RCU's core API?
3. What are some example uses of core RCU API?
4. What if my updating thread cannot block?
5. what are some simple implementations of RCU?
6. Analogy with reader-writer locking
7. full list of rcu apis
8. answers to quick quizzes

