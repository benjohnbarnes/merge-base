#  Updatable

An Updatable is a tuple: `(S, D,  ∅, :, ;,  ⊕)` where:

* `S` is the set / type of possible states. It's the value we actually care about.
* `D` is the set / type of possible updates. It's the changes that can be made to a value `s ∊ S`.
* `:` is an operator to apply an update to a state. `s:d ⟶ t` were `s,t ∊ S` and `d ∊ D`.
* `∅ ∊ D` is the identity update that such `s:∅ ⟶ s`.
* `;` is a sequential combiner for change such that `(s:d):e = s(d;e)`. `;` is a monoid with identity element `∅`.
* `⊕` is a parallel combiner for change. `⊕` is a commutative monoid, also with an identity element `∅`.

# Counting Updatable.

Defining the tuple `(Z, Z, 0, +, +, +)` provides a counter type that supports up and down counts. Counts can be sequentially and concurrently resolved. Similarly, another number type can be used. More generally, any type that has an operator `+` and an identity element is suitable. So, vectors and fields are good to go.


# Value holding box as an Updatable.

Given some set / type T, we'd like a box to store a most recent value. Define the tuple `({T}, {T}, {}, ;, ;, ⋃)`. 

* `∅` (the empty set) represents the null change "don't make a change". A box `{}` represents not having a value assigned yet. 
* A set of cardonality 1 `{t}` represents both a box holding an unconflicted value, and also a change to bring a box in to an unconflicted state.
* A set of cardonality > 1 represents a box holding a conflicted value, and also a change that brings a box in to a conflicted state.

Consideration should be given when T itself includes a null value. The meaning of `{}` and `{null}` as the state of a box or a change are distinct:

* For a box `{}` means that the box has never had a value associated to it. This might be meaningless within a particular use, in which case the box state should be initialised with a value and the box type can be restricted to sets of at least one element. The tuple would then be `({T}/>1, {T}, {}, ;, ;, ⋃)`  
* For a box, `{null}` means that the box is holding the null value.
* For a change, `{}` means "no change".
* For a change, `{null}` is the change that makes a box hold the null value.

 Define `;` as follows:
* `a;b ⟶ b` where `b ≠ ∅`
* `a;∅ ⟶ a` where `b = ∅`

As shown in the tuple, `⊕` is set union: `⋃`.

* Concurrent changes to become two different values `t` and `u`  is represented `{t} ⊕ {u}`, which is `{t} ⋃ {u}` which is `{t u}`. This resulting set with cardonality > 1 represents a change of a value in to a conflicted value. It equally represents a conflicted value itself.
* Concurrent changes to the same values `t` and `t`  is represented `{t} ⊕ {t}`, which is `{t} ⋃ {t}` which is `{t}`. This resulting set with cardonality = 1 represents a change of a value in to an unconflicted state.
* Concurrent changes of `t` and `∅`  is `{t} ⊕ {}`, which is `{t} ⋃ {}` which is `{t}`. This resulting set with cardonality = 1 is a change to an unconflicted state. 
* Concurrent changes of of `∅` and `∅` is `{} ⊕ {}`, which is `{} ⋃ {}` which is `{}`. This resulting set of cardonality = 0 is the null change leaving a state as it is.

