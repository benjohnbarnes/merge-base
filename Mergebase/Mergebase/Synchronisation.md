#  Synchronisation

* A client has a synch task queue of follow up actions it should take that are run in priority order (priority being highest from the leaves of the clock hierarchy and lowest for the root). 
* Tasks might have a delay on them to give time for a response to come from somewhere else.
* Tasks might be cancelable by some other task or event having occurred.

* If a peer makes a change, it will send the new parent hash to some peers.
* If a peer recieves a hash differing from a hash it has
    * and the hash has small cardonality – it will send a data request for that key to the originator.
    * and the hash has large cardonality – it will send a  
* If a peer recieves a hash the same as its own hash – it does nothing.

… I could make loads of rules, and it would be lots of fun, I guess. 

I think a better approach to this is to be able to simulate a peer network under _lots_ of different kinds of situation. Peers can then have all sorts of programmed behaviour. They can "sense" their own state and get cues about other nodes in the network from messages they hear, response times, etc. Peer behaviour can be evaluated for various metrics under the differnt scenarios. It's then possible to check that actual implemented behaviour works correctly and evaluate how well it works. In principle, any parameters can be automatically optimised.

# User feedback

As a user, I'd like to know whether changes I have made have "settled" with a peer (possibly a specific one). 

# Priority, faulting, multiple store

Some parts of the store might be a higher priority to sync, such as getting peer tables initially.

To allow for download on demand, does it make sense for a client to be able to "fault" some of the store? It would need to have the hash tree locally, but could decide not to pull down the underlying data?

There's an option to simply use more than one store to provide isolation.
