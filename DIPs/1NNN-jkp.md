# Standard Serialization Attributes

| Field           | Value                                                           |
|-----------------|-----------------------------------------------------------------|
| DIP:            | (number/id -- assigned by DIP Manager)                          |
| Review Count:   | 0 (edited by DIP Manager)                                       |
| Author:         | Jesse Phillips <Jesse.K.Phillips@gmail.com>                                |
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
serialization challenges.

## Prior Work
Required.

If the proposed feature exists, or has been proposed, in other languages, this is the place
to provide the details of those implementations and proposals. Ditto for prior DIPs.

If there is no prior work to be found, it must be explicitly noted here.

## Description
Required.

Detailed technical description of the new semantics. Language grammar changes
(per https://dlang.org/spec/grammar.html) needed to support the new syntax
(or change) must be mentioned. Examples demonstrating the new semantics will
strengthen the proposal and should be considered mandatory.

## Breaking Changes and Deprecations
This section is not required if no breaking changes or deprecations are anticipated.

Provide a detailed analysis on how the proposed changes may affect existing
user code and a step-by-step explanation of the deprecation process which is
supposed to handle breakage in a non-intrusive manner. Changes that may break
user code and have no well-defined deprecation process have a minimal chance of
being approved.

## Reference
Optional links to reference material such as existing discussions, research papers
or any other supplementary materials.

## Copyright & License
Copyright (c) 2019 by the D Language Foundation

Licensed under [Creative Commons Zero 1.0](https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt)

## Reviews
The DIP Manager will supplement this section with a summary of each review stage
of the DIP process beyond the Draft Review.
