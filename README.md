
Like `SQLite`, but with `git` semantics.


# About

It should be normal for user data to be retained in a store which is:

* Semantic
* Versioned
* Mergeable
* Distributed
* Linkable
* Extensible

Our manifesto is that users should expect all of their data to exist in this form. Data should not be siloed to applications, but shared among them, with applications providing query, view, and edit facilities. 

In particular, software should be stored in this form. Software tooling should be able to grow organically and provide new joins between user data. As an example, an IDE; a code review system (like github); a bug tracker; an academic paper on an algorithm; and some user chat between engineers, should all be sharing the same data. Affordances, the views and mutations of data available, should be uniform across these tools.

This project is an attempt to make this happen.


# Possible deliverables

SQLite is a popular embedded relational database used in many applications. If MergeBase existed similarly as a library, it could be widely integrated in to user applications. It would provide all these applications with merge facilities, distributed working, query capability, etc. It might comprise a great deal of the data "heavy lifting" for such applications. 

Applications would only need to worry about maintaining their schema, views over the data, and business rules. They wouldn't need to worry about network transport. They'd get offline working and online synchronisation of data with other users "for free". 

If such a library existed and gained traction, it seems like it might bootstrap the intended future point. 

The technology, and standards in such a library would hopefully provide a reference implementation of approaches that could then be widely used. Eg, having a schema for data becomes useful in all sorts of tools, such as an automated CRUD scaffolding of mutable views over the data. If it has a one (or more) transport layers, then the standardisation allows for friendly network cache.

# Is relational appropriate?

I feel a system like this should probably be something _similar_ to a relational model:

* Data should probably not be purely treelike. Trees favour a particular factoring of data that may not be appropriate. A relational approach allows for any desired structure to be queried out.
* Links should probably be implicit rather than explicit. An implicit link allows novel links in to data that hadn't been anticipated.

[Codd's Turing award paper](https://pdfs.semanticscholar.org/d206/89e9acfdb34326d21bd3ac339d9966cefae3.pdf) on what he was trying to do is inspiring here. In particular: "2. Motivation"

# Programming languages

Many programming languages are expressions representable as an abstract syntax tree. We should be able to represent programs like this, but I don't think tree based expressions are the only form programs might take. I suspect they are prevalent largely because programs are widely stored in text, and expressions and AST are a great formalism for text based programs.

Expressions aren't ideal in some respects, even where currently used. An example is when we'd prefer set like semantics to ordered semantics. For example, the functions in a text file are ordered. This is problematic for merging if they are moved. While the writen order may provide useful information, there's no particular reason to insist on a _single_ canonical function order. 

Language notations could also radically depart from expressions. Eg, [String Diagrams](http://chalkdustmagazine.com/features/linear-algebra-diagrams/) are much closer to a DAG and [might be better](https://graphicallinearalgebra.net/2017/04/24/why-string-diagrams/).

# Merging

With distributed and "network partitioned" work, changes are concurrent and only have a partial order. A "merge" facility to integrate changes is necessary. Changes that do not include conflicts should be merged without any requirement for user intervention. Where conflicts exist due to concurrent change, facilities should be provided so that a user (or automated rule) can resolve the conflict – this would probably include the history of the value, the independent changes, and context around the change.

Ben speculates that defining "functional dependency" in a schema is probably crucially important to supporting automatic merge.

# Related / Interesting Stuff

* There are ideas around [category theoretic databases](http://math.mit.edu/~dspivak/informatics/talks/CTDBIntroductoryTalk). I suspect these might be useful. 
* [Projectional Editor](https://martinfowler.com/bliki/ProjectionalEditing.html)
* [Intentional programming](https://en.wikipedia.org/wiki/Intentional_programming)
* [FoNC – fundamentals of new computing](https://www.quora.com/Why-isnt-Alan-Kays-FoNC-Fundamentals-of-New-Computing-project-more-discussed-or-replicated)
* [Jetbrains MSP](https://www.jetbrains.com/mps/)
* [BOXER – A RECONSTRUCTIBLE COMPUTATIONAL MEDIUM](https://web.media.mit.edu/~mres/papers/boxer.pdf)
* [Genera OS](https://en.wikipedia.org/wiki/Genera_(operating_system))
# Suggestions to move forward

* Can we find a kernel in here that we agree forms a useful and necessary step towards having software stored in a database? Personally, it's actually my secondary goal – I'm somewhat more interested in user ownership of their data, and I think the envisaged database is central to this. I think it's so desirable for software for similar reasons its so desirable for all user data.
* Are there areas where we can pin down some actual formal(ish) definitions, even if a bit handwavely? Eg, it might be useful to have a notation for what changes sets are, how they can compose, what conflicts are, etc.
* Is it reasonable to claim that expression based languages are semantically an algebraic data type?
* Do algebraic data types embed in to categorical relational databases?
* Would any of the categorical relational database people be interested in collaborating?
* My suspicion is that the "hard" thing might be finding all the necessary research. I'm hopeful that an actual implementation might be a moderate but achievable side project for a small group, particularly if building on top of stuff that exists (eg, sqlite, http, etc).
* Can we collect together pointers to relevant papers?
* Would more bits of vision be useful? And links to similar ideas in other places?


