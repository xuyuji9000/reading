[The Noise Protocol Framework](https://noiseprotocol.org/noise.html#introduction)

Introduction

Noise is a framework for crypto protocols based on Diffie-Hellman key agreement. Noise can describe protocols that consist of a single message as well as interactive protocols.

2.2 Overview of the handshake state machine

The core of Noise is a set of variables maintained by each party during a handshake, and rules for sending and receiving handshake messages by sequentially processing the tokens from a message pattern.

Each party maintains the following variables:

- s, e: The local party's static and ephemeral key pairs (which may be empty).

- rs, re: The remote party's static and ephemeral public keys (which may be empty).

- h: A handshake hash value that hashes all the handshake data that's been sent and received.

- ck: A chaining key that hashes all previous DH outputs. Once the handshake completes, the chaining key will be used to derive the encryption keys for transport messages.

- k, n: An encryption key k(which may be empty) and a counter-based nonce n. Whenever a new DH output causes a new ck to be calculated, a new k is also calculated. The key k and nonce n are used to encrypt static public keys and handshake payloads.



















