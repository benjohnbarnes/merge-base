# Scratch notes on categorical schema

I'm hopeful [categorical database](http://math.mit.edu/~dspivak/informatics/talks/CTDBIntroductoryTalk) ideas might be useful.

A [category theory tutorial](https://arxiv.org/pdf/1803.05316.pdf) and [another one](http://www.cs.man.ac.uk/~hsimmons/zCATS.pdf)

The schema shows the paths and links available between objects. It doesn't necessarily show what they "store", or what updates to the structure are available. Eg – all of the arrows out could literally be functions. All the associated values might be an `int`.


# Variants

The domain of an Entity / Attribute should support variant typing (also sum type / coproduct / enum / algebraicly typed). This means they can be one of several things. The links available from the entity depend on which variant that specific entity instance is. Does this allow for nullability, if an entity's domain includes the null variant? This naturally allows the null value to _not_ have links, which is really encouraging! 

Does extending the allowable variants (eg, during a schema change) present difficulties?

Are datatype declarations needed as a distinct thing from attributes? They are domains. Can a datatype just be an attribute without any links? 

Generics and type classes?
