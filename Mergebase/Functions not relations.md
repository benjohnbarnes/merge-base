# Morph Base

I'm reviewing this on the 15/7/19 after writing last night. I've just realised what I've been thinking about seems to be a database where attributes are morphisms equipped with a set defining the domain elements where the morphism exists.

I think a morphism like this is **closed** in that if two are attached, you end up with a similar morphism from a key to an attribute with a domain set showing where it is defined. In this sense it composes. Queries are the same kinds of thing as the stored tables.

**Projection** is a morphism with a total function. A projection can be applied before or after a stored morphism, or any other morphism. If a projection is a bijection there will be no "data loss" when it is attached to another morphism at either the front or back and it can be thought of as a **rename**.

**Selection** is an identity morphism along with a predicate that selects the inputs (or outputs) to keep.

**Natural join** of two morphisms is function composition, possibly along with some mechanism to kind of collect up more stuff in the attribute domain.

**Cartesian product** seems to be the function product?

**Aggregation** It seems fine for keys or values to be sets. Aggregations can can be expressed as some kind of higher order operation on a morphism that describes the bucket in to which keys should add their value.

Think **transitive closure** can be expressed with some kind of higher order function on keys?

Morphisms here are (being morphisms), **profunctors**. Their value type maps covariantly, and their key type maps contravariantly. Perhaps its easier to just think of combining them together in a pipeline, though?

Suspect indexes might also be describable as a morphism too.

Maybe a nice feature – probably works out to allow a further decorator on a morphism to be an ordering on the key to be used for display?


# From last night
The DB idea I've got is that there aren't tables or relations. There are partial functions.

The partial functions are from a key value type to an attribute value type. They "know" the domain set they are defined for.

I feel this gives the appropriate emphasis to functional dependency. It also (I think) gives functional dependencies among candidate keys a much more solid basis by eliminating it as a possibility. 

For any situation I claim there is _some_ specific key type having _no_ functional dependencies to itself. Every value it can take on is valid, and no value it can't take on is valid. Any key types exhibiting this behaviour are equivalent up to isomorphism (Can category theory "universal construction" be used to show this?)

When such a key has "foreign keys" to other maps, then these are simply _total_ functions from the key to other keys. 

As a relevant example, this admits having a _set_ as a key, or a _list_ as a key without recourse to a surrogate or synthetic key. This is particularly important for merging: it's certainly useful and perhaps necessary that parties can independently use the same key without having agreed on a surrogate before hand. 

It's useful to model, for example, a friendship, where a friendship among `(a,b)` is the same as the friendship among `(b,a)`. There should be a single key in the domain for the friendship.

In a database like this, perhaps the attributes that exist are more important than the entities. The attributes tell us the information the database is able to attach on to keys. 

Attributes may quite reasonably be generic. Eg… "description" seems like a fairly reasonable thing to attach to absolutely any type of key.

Perhaps the key entities are one half of the system, and attributes attached to them are another.

It _might_ make sense for some attributes to only be allowed on keys that conform to a type class. Such type classes might also describe how that entity key is related to other entities' keys.

