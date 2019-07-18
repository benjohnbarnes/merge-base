#  Node Based

A statically typed attribute system seems hard to use in a user application without a great deal of work. It seems to require a portable static typing system, which definitely seems like boiling the ocean territory.

A simpler option is to use a single type of node for keys and value that supports a dynamic type.

Types can be described, and Attributes can know the type of their key and value. This allows UI to find which attributes make sense to display for a particular type of key.

Which seems nice. Yeah.

While `Node` itself wouldn't be typed as stored in a table, the client App will probably find it useful to have a `TypedNode` that has a `Node` and a `NodeType` so that it can determine the appropriate properties for a `TypedNode`, and its affodances.
