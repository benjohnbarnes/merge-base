#  Commit Based

* A commit based system would have a semi-lattice of commits.
* Commits would include a hash of the complete system state at that time (and a hash of the system history?).
* It should be possible for chunks of both state and history to be **faulted** and not locally stored. In such a case its necessary to have a "stand in" for their hash.
* It is acceptable to delete history, but if this is done globally, it's no longer possible to merge a commit that has becomes orphaned. A commit is orphaned when its meet with known commits is not stored – although can partial information about history be sufficient to allow a merge? 
* The value associated to a key can be conflicted (or not).
* Conflicts propagate between commits.
* Conflicts can merge in to larger conflicts when commits are merged.
* A conflict is repaired by a subsequent commit overwriting it.

# Algorithms
Need a seriously efficient method to map from a key and a commit to a vlaue.
