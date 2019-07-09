Is it possible to isolate the key structure – which holds identities, from the values, which are facts about keys?

Either – Every attribute about a key must have a default value, or every attribute must be provide when a key is inserted.

> Some attributes can be about "compound" keys. If a key is inserted which exists in a compound, every non defaulting attribute for that compound needs to be provided. This might be zero, or many, if the other keys in the compound are populated.

This is incorrect, I think… A compound key like this has attributes about it. If it is inserted, those attributes must be given values. That's it, though. It's fine for an attribute to be a key on something else.

It should be possible to perform merge on all attributes associated with a key. The keys, which provide identity, are the parts that can't be merged.

What happens when there are FDs "within" a key, such as ? These _do_ seem to be un-mergeable. 

A: No key is ever mergeable. Keys are immutable.

--

It'd be nice to be able to describe facts about the database – entities that don't have any key at all.

Some entities have their own key

Some entities don't have their own key – they only have foreign keys.

… I'm beginning to think keys in the sense of identities should be completely separate from entities.

One way to do this: define keys, and FDs from key sets to attributes (which may be values or keys or key sets).

Another way: define keys, entities (which have a set of zero or more keys), and attributes on entities (which are values or entities).

The latter seems like it maybe deals with existence better. An entity either exists or does not. Given it exists, all of its attributes are available (they may allow a `.none` case). The entity has zero or more keys which may be in common with other entities, or not.

--

```
keys

  # A key cannot be an entity (I think), but can in principle be an
  # algebraic type of any primitive in the system.
  key-name: ValueType

entities

  # Every entity has a (possibly empty) set of `key-name`s. These
  # form the identifier of the entity.
  EntityName: {key-name}

attributes

  # a ValueEntityType is an algebraic data type with primitives that 
  # include the types of the system and entity names.
  attribute-name: EntityName -> ValueEntityType

```


What are the major points?

* Non prime attributes are mergeable.
* Non prime attributes can be an arbitrary ADT with primitive elements including foreign keys. NB – An ADT case allows for .none / nullity.
* It (may) make sense to nominate a default value for non prime attributes. This is arbitrary, but is could be the .none case of an optional.
* Within the prime attributes are the identifier of an entity.

Is it sensible to think of the primitive stored thing as being a (mutable / updatable) map from a key (domain) to a value (codomain) where there is a default value? 

Question here about the inverse's answer to "which keys have the default value", unless the key is "bound" by being known to exist in some way.

--

Attributes are available on an entity. I think I've been confusing an entity with it's key. They are not the same. 

Taking `Friendship` as an example, its key is a pair of `Person`. The attributes of `Friendship` aren't available on any pair of people, because **that is not the domain of an attribute on `Friendship`**. The domain of an attribute on `Friendship` are exactly the set of `Friendship`.

Similarly, a `Friendship`'s two `Person` are _not_ `PeopleId`s. They _are_ `Person`, that is their domain. Arbitrary `PersonId` will not do at all.

Part of the confusion of this might be from thinking about FDs. With an FD it is normal to consider the left hand attributes on which the right side is dependent. This naturally introduces the idea of the FD being a function for which the domain is a tuple of the left attributes, and the codomain is the right attribute. But this is a mistaken idea when applying it to an entity. 

It seems to follow from this that there might not be complex "existence" questions with an attribute and an entity. It's _just_ a map from the entity domain to the attribute value domain.

Think it may make sense for an entity like Friendship to think about its foreign keys as being immutable and time invariant attributes. Other attributes are immutable but time variant, such as an attribute that sums other attributes. The third class of attribute is mutable (and by implication, time variant), which are those that can be written to. 

Does this imply complexity for trying to delete entities? A `Person` can't be trivially deleted because to do so, any `Friendship` that includes that `Person` must also be deleted. 

Having a `deleted` attribute might be tempting, but doesn't really seem to solve the issue.

Similarly, if some other entity has a `Friendship` in its key, this propagates the same kind of problem further.

Another example of domains like this would be `Person` and `Employee`. All `Employee` are a `Person` but not all `Person` are `Employee`. This seems to model something distinct from an optional attribute with an optional variant.

--

Given this, from where is the set of an entity available? This is important for querying.

It is tempting to have a single point of truth with all facts about an Entity, which will provide the set of entities. But any mutable attribute of an entity needs a store associated with commits.

Alternatively, attributes are a map from an Entity to a value. If they're independent like this, it seems like they would want to be able to have a default value. This would need there to be some source of truth for the entity domain.

--

# Plan!

Do have a single point of truth about a given Entity type. Store a single value for it at each time point. Have an associated delta type that is used to encode changes. The delta type may allow for collapsing many delta in to a single delta, but this is optional. For a product type, the delta can be a sum type of changes to its elements. But for a sequence type, it could be something like a CRDT.

Insertions in to the element set might be representable by deltas too – not sure about this though, but maybe the database itself has a composite delta?

--

I can probably define a protocol for Entity. It needs to include the key type, the data type, and the delta.

--

I feel like I've made a few quanta of progress, but a lot is still unclear.

So – I feel I've got a pretty good handle on entities and keys.

# Entities & Keys
* A class of Entity has a key.
* Keys are immutable. 
* Keys are the identifier of an instance of an entity.
* An entity has a "key set", of the set of entity instances that exist.
* Insertion and removal of entities is something I'm not very sure about – I think it is a change at a level up.
* The type of a key will probably have a larger domain than the keys that are in use. These identifiers do not key entity instances. It is meaningless to think of them as doing so.
* For in use keys, "the key" "is" "the instance" in some sense… Yeah.
* A key K1's domain may be one or more other entity keys, K2. Here, the domain of K1 is the K2s, to the type of K2's key. The actual occupancy of K1 is a subset of the domain.

# Attributes

* Identified things have a type. 
* The type may be some entity.
* The type may be an algebraic type.
* The type can be a collection, etc.
* The type Must supports deltas. 
* The delta of a type is not, in general, the same type (but it may be).
* Deltas are a bi-monoid.
* Deltas can be composed in sequence and in concurrence (two two monoid operations).
* The unit of a delta is the same for both composition operations (?).
* Some types may include a "conflicted" state within their domain.


# Querying

It is queries that should support relational / logical kinds of operation. 

--

# API

I think trying to find a way to express this in a statically typed way is getting in my way, in this case. Is there a way to step around this?

It was my original idea entities would have hand written types with hand written deltas. I've also got the idea of an API for records where there's a first class generic that represents a specific attribute of an entity. Can these fit together?

How to construct an entity like this? Need to know that every attribute it has is initialised – or otherwise, attributes must provide a default value to be initialised with. After this, it seems like it should be fairly easy to actually query and update properties.

```
struct Record<T> {
  struct Attribute<T> {
  }
}


```

# Snap Structure – take 1

The client needs to be able to compute snap content (the value associated with a snap) from the snap graph.

3 kinds of snap:

* **Empty** – the initial empty snap with no parent or applied patch.
* **Update** – has 1 parent snap with 1 applied patch.
* **Merge** – has (trivially) 1 or more parent snaps, but no snap has a patch applied.

Patches don't necessarily need to be a distinct entities and could just be associated with update snaps. Snap keys could be used for this.

It would work something like… 
* The client builds a writable snap. 
* To do this it builds a new snap key and constructs a writable snap instance holding it.
* It sets up the snap value as being an update pointing to the parent.
* The snap instance knows that to look up values it should look in the parent and apply the patch on top of that.
* Writes go in to the patch associated to the snap key.

A non writable snap will first look for a "materialisation" of the snap. If it can find one, it will use it. Otherwise it will materialise it based on whether the snap is an update or a merge (or 0, which terminates recursion).


# Merging

To merge 2 (or more) snaps, find their common root. The merge result is the common root, followed by the concurrent combine of the patches from it to the snaps.

Given a quick algorithm to determine the delta patch to a patch from one of its single roots, this computation can be pretty quick. In general, finding these patches requires working back to the common root and stepping away from it building up the patches.


```
func mergeSnaps(snaps: Set<Snap>) -> Snap? {
  guard !snaps.isEmpty else { return 0 }
  guard snaps.count > 1 else { return snaps.first! }
  find furthest snap
  
}
```

# LWWS

Is the `Updatable` protocol too general? While it would be excellent to get a no conflict sequence in, if everything could be much simpler with just last write wins behaviour, perhaps this is preferable. A kind of last write wins map could expose the same conflict behaviour. It might not require a mechanism to obtain the deltas so that merging could be on present values and not need to find the common root.

# Snap Structure – take 2

An even simpler way to structure the snap and patch graph is:

* There is a single root snap with no parents.
* Every other snap has a set of at least 1 parents.
* Every snap (including the root) has its own (possibly empty) patch.
* A snap's content is the parallel merge of its parents' content with the snap's own changes in sequence after that.


# A different way

I have in mind that the primary mechanism are frozen snapshots and collaboration and merging happen on top of this.

Is an alternative approach that the primary mechanism is collaboration and automatic merging, and snapshots are constructed on top of this?


# OMG – Automerge

Automerge is amazing.

Maybe, then, have something akin to a JSON doc extended to support: Both atomic and composite arrays (an atomic array doesn't support insert or remove); a dictionary (where keys are immutable and are presumably any of the allowed types).

"Attributes" can just be a field in a document pointing to a dictionary from attribute key to attribute value.

Interesting to think about how conflicts are surfaced, though – only happens when exactly the same thing is concurrently changed?
