[What is RCU, Fundamentally?](https://lwn.net/Articles/262464/)

[Editor's note: this is the first in a three-part series on how the read-copy-update mechanism works. Many thanks to Paul McKenney and Jonathan Walpole for allowing us to publish these articles. The remaining two sections will appear in future weeks.]

// …

Introduction

Read-copy update(RCU) is a synchronization mechanism that was added to the Linux kernel in October of 2002. RCU achieves scalability improvements by allowing reads to occur concurrently with updates. In contrast with conventional locking primitives that ensure mutual exclusion among concurrent threads regardless of whether they be readers or updaters, or with reader-writer locks that allow concurrent reads but not in the presence of updates, RCU supports concurrency between a single updater and multiple readers.

// … 

Quick Quiz 1: But doesn't seqlock also permit readers and updaters to get work done concurrently?

This leads to the question "what exactly is RCU?", and perhaps also to the question "how can RCU possibly work?"(or, not infrequently, the assertion that RCU cannot possibly work). This document addresses these questions from a fundamental viewpoint; later installments look at them from usage and from API viewpoints. This last installment also includes a list of references.

RCU is made up of three fundamental mechanisms, the first being used for insertion, the second being used for deletion, and the third being used to allow readers to tolerate concurrent insertions and deletions.

