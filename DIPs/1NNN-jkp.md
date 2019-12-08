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

Within D:
* Steven Dconf 2019: https://youtu.be/Y-cgh-rwoC8
  * jsoniopipe: https://jsoniopipe.dpldocs.info/iopipe.json.serialize.html#members
* Ethan Dconf 2019: https://youtu.be/rSY78Hu8DqI
* vibe.d: https://vibed.org/api/vibe.data.serialization/
* darg (similar): https://darg.dpldocs.info/darg.Option.html
* painlessjson: https://code.dlang.org/packages/painlessjson
* Mir asdf: https://code.dlang.org/packages/asdf
* jsonize: https://code.dlang.org/packages/jsonizer


Other Languages:

* Java 
  * Jackson: https://dzone.com/articles/jackson-annotations-for-json-part-2-serialization
* C#
  * Newtonsoft: https://www.newtonsoft.com/json
  * System.text.json: https://docs.microsoft.com/en-us/dotnet/standard/serialization/system-text-json-how-to#customize-json-names-and-values
  * xml: https://docs.microsoft.com/en-us/dotnet/standard/serialization/attributes-that-control-xml-serialization
  * SOAP: https://docs.microsoft.com/en-us/dotnet/standard/serialization/attributes-that-control-encoded-soap-serialization

### Analysis 

These are the different ways the existing libraries provide control. 
I will explain and provide thoughts on each. 

The examples listed are destination encoding specific, usually json. 
Consideration should be made for the challenges which conflict or complicate
providing a general available attribute. 

#### Name Property
https://docs.microsoft.com/en-us/dotnet/standard/serialization/system-text-json-how-to#customize-individual-property-names

This is the most basic need, it changes what name is used in the serialization. 

In some approaches the property in and property out. 
http://docs.asdf.dlang.io/asdf_serialization.html#.serializationKeysIn

I do not generally see this type of flexibility, but conceptually it may be valuable
in managing serialization versioning. 

#### Ignore
https://vibed.org/api/vibe.data.serialization/ignore

This will skip the field for serialization. This may not be unnecessary with other
attributes which define a means of delegating translation to a function. 

While this could create multiple ways to achieve the same thing I believe it will
be good to provide the attribute for libraries to use this for their chosen design.

#### Name Policy
https://docs.microsoft.com/en-us/dotnet/api/system.text.json.jsonnamingpolicy?view=netcore-3.0

Languages have conventions for casing fields. Serialization is generally case sensitive. 
This attribute provides a way to generally specify a conversion (pascal, camel, underscore). 

I don't see this type of attribute, it relies on consistency which means if a conversion goes
wrong it can be harder to track down.

I believe writing the struct field to match the data exchange format to be preferable. 

It may be of value to ignore case. 

#### Array Like
http://docs.asdf.dlang.io/asdf_serialization.html#.serializationLikeArray

asdf tackles some specifics for D. Ranges translate well to arrays, however
this requires an output range. D allows for inspecting and determining the
range type. The serializer would need to determine what to do if it could only 
go one direction, I do not believe this proposal needs to specify the behavior. 

#### Enum String or Value
https://docs.microsoft.com/en-us/dotnet/standard/serialization/system-text-json-how-to#enums-as-strings

Enumeration has a value or name. It will be good to include this. 

#### To Json 

This provides a direct override to have the type handle serialization. 
This is probably the normal way serialization would work. 

Since this is destination specific I do not see a need for this. 

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
