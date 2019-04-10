# Scratch notes on categorical schema

I'm hopeful that categorical database ideas might be useful.

Thought – Should IDs (and other _internal_ attributes) necessarily be defined by a schema? An entity has attributes and links with other entities. Is it necessary to describe how it is identified? I think it can be allowed to be an implementation detail. It's not something the schema has to lock down.

The domain of an Entity / Attribute should support variant typing (also sum type / coproduct / enum / algebraicly typed). This means they can be one of several things. The links available from the entity depend on which variant that specific entity instance is. Does this allow for nullability, if an entity's domain includes the null variant? This naturally allows the null value to _not_ have links, which is really encouraging! 

Does extending the allowable variants (eg, during a schema change) present difficulties?

