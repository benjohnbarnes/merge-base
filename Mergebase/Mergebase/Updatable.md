#  Updatable

An Updatable is a tuple: `(S, D,  ∅, :, ;,  ⊕)` where:

* `S` is the set / type of possible states. It's the value we actually care about.
* `D` is the set / type of possible updates. It's the changes that can be made to a value `s ∊ S`.
* `:` is an operator to apply an update to a state. `s:d⟶t` were `s,t ∊ S` and `d ∊ D`.
* `∅ ∊ D` is the identity update that such `s:∅⟶s`.
* `;` is a sequential combiner for change such that `(s:d):e == s(d;e)`. `;` is a monoid with identity element `∅`.
* `⊕` is a parallel combiner for change. `⊕` is a commutative monoid, also with an identity element `∅`.

# Counting Updatable.

Defining the tuple `(Z, Z, 0, +, +, +)` provides a counter type that supports up and down counts. Counts can be sequentially and concurrently resolved. Similarly, another number type can be used.


# Any type as an Updatable.

Given some set / type T, define the tuple as `({T}, {T}, {}, ;, ;, ⋃)`. 

`∅` here is the empty set and represents the null change "don't make a change".
 
 Define `;` as follows:
* `a;b ⟶ b` where `b ≠ ∅`
* `a;∅ ⟶ a` where `b = ∅`

An unconflicted state is represented `{t}` – a set with caronality 1. Similarly a change to become unconflicted is represented `{t}` – a set with cardonality 1.

* Concurrent changes to become two different values `t` and `u`  is represented `{t} ⊕ {u}`, which is `{t} ⋃ {u}` which is `{t u}`. This resulting set with cardonality > 1 represents a change of a value in to a conflicted value. It equally represents a conflicted value itself.
* Concurrent changes to the same values `t` and `t`  is represented `{t} ⊕ {t}`, which is `{t} ⋃ {t}` which is `{t}`. This resulting set with cardonality = 1 represents a change of a value in to an unconflicted state. Equally, it represents an unconflicted value.
* Concurrent changes of `t` and `∅`  is `{t} ⊕ {}`, which is `{t} ⋃ {}` which is `{t}`. This resulting set with cardonality = 1 is a change to an unconflicted state. Equally, it represents an unconflicted value.
* Concurrent changes of of `∅` and `∅` is `{} ⊕ {}`, which is `{} ⋃ {}` which is `{}`. This resulting set of cardonality = 0 is the null change leaving a state as it is.
