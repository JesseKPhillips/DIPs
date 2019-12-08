# Standard Serialization Attributes

| Field           | Value                                                           |
|-----------------|-----------------------------------------------------------------|
| DIP:            | (number/id -- assigned by DIP Manager)                          |
| Review Count:   | 0 (edited by DIP Manager)                                       |
| Author:         | Jesse Phillips <Jesse.K.Phillips@gmail.com>                     |
| Implementation: | (links to implementation PR if any)                             |
| Status:         | Will be set by the DIP manager (e.g. "Approved" or "Rejected")  |

## Abstract

Introduce into Phobos a new model (std.serialize.attribute) which will provide
standard attributes that can describe serialization behavior of struct and class. 

```dlang 
struct Foo {
  @name("class")
  int _class;
}
```

## Contents
* [Rationale](#rationale)
* [Prior Work](#prior-work)
* [Description](#description)
* [Breaking Changes and Deprecations](#breaking-changes-and-deprecations)
* [Reference](#reference)
* [Copyright & License](#copyright--license)
* [Reviews](#reviews)

## Rationale

Serialization provides a translation of the application memory into a machine independent disk
storage or wire communication. Exact representation for this translation could be strings or
binary data (xml, json, protocol buffer, etc). 

On top of these implementation is the desire to write and retrieve the data directly from/to a 
class or a struct.

This proposal is to bring forth a defined standard/shared set of attributes to address common
serialization challenges. It does not address preventing incompatibility across serialization 
libraries. It will provide the ability for libraries to be designed to be compatible with
other libraries without the libraries needing to include the other.

We want libraries to make liberal use of the attributes, to achieve this the standard attributes
should avoid complicating the effort to utilize the attributes. 

I will utilize @optional and @required as an example. The question is which does an implementation
default to? Does an implementation need to provide a means to specify the default.

By having this library specify the expected default the ability of the library to make the best 
choices for its situation is either prohibited or causes the library to implement a more complex 
logic to escape from the default, along with every implementation which does not want to modify 
the default. 

The attribute library should make recommendations on use to guide more consistency. 

## Prior Work
Required.

If the proposed feature exists, or has been proposed, in other languages, this is the place
to provide the details of those implementations and proposals. Ditto for prior DIPs.

If there is no prior work to be found, it must be explicitly noted here.

## Description
Required.

Todo 

## Breaking Changes and Deprecations

This has no breaking change. It would be preferable for existing libraries to
update with the standard but even this could be done without breaking. 

## Reference

## Copyright & License
Copyright (c) 2019 by the D Language Foundation

Licensed under [Creative Commons Zero 1.0](https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt)

## Reviews
The DIP Manager will supplement this section with a summary of each review stage
of the DIP process beyond the Draft Review.
