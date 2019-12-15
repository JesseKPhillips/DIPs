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
  @name!Default("class")
  int _class;
  @required!DB 
  int id;
  @OnSerialize!(Web, SerializeFunc!(x => x.encode)) 
  string text;
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
binary data (xml, json, protocol buffer, etc). On top of these implementation is the desire to 
write and retrieve the data directly from/to a class or a struct. 

By providing a standard set of attributes, and easy means to retrieve them, we make it easier to
Switch serialization libraries, reduce attributes for serializing in different domains.

Protocol Buffer utilizes code generation off a specification. I believe generative libraries will
become more common and it would be nice to have it generate serialization attributes other
libraries also use.

### Considerations 

The standard attributes should avoid complicating the effort to utilize the attributes. 
This way users of serialization libraries can expect some portions of the attributes to exist. 

This means the does not mean every usage is guaranteed to remain conflict free.

The attribute library should make recommendations on use to guide more consistency. 

#### Defaults 

I will utilize @optional and @required as an example. The question is which does an implementation
default to? Does an implementation need to provide a means to specify the default.

By having this library specify the expected default the ability of the library to make the best 
choices for its situation is either prohibited or causes the library to implement a more complex 
logic to escape from the default, along with every implementation which does not want to modify 
the default. 

#### Versions

Versioning an API is a challenging undertaking. I have not seen existing implementations which
tackle this challenge. 

Based on the way protocol buffer handle version support the serialization library will need/want
to provide their own attributes. 

Protocol Buffer assigns a field number which is expected to be immutable field can be depreciated 
however new fields should not reuse that number. It also recommends all members be optional (noting
this is a wire protocol). 

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

The library will provide two main components. 

1. Target specific attribute properties
2. Attribute retrieval methods to assist library writers

### Attributes 

Target identifiers. These are arbitrary attributes serialization can 
be associated with. These items are provided for end-users to specify 
common targets, but any symbol could be used to identify the target. 

* Default 
* Web
* Database 
* Wire
* Disk

Default is the only one with special meaning. It defines a behavior 
when a specific target behavior is not defined. Again these are 
arbitrary and only for end-user communication. 

#### ignore

Do not serialize or deserialize this field. 

#### optional 

Do no throw an exception or produce any form of failure if the data
or field is missing. 

#### required

Throw an exception when data is missing from this field during serialization.

It is recommended that during deserialization no exception or failure is produced. 
Providing an indication of missing required fields would be appropriate. 

https://softwareengineering.stackexchange.com/questions/12401/be-liberal-in-what-you-accept-or-not

#### name

This specifies the name of the field as it is encoded in the target.

#### onSerialize

Defines a function to utilize when serializing. 
Should have the opposite operation onDeserialize. 

#### onDeserialize

Defines a function to utilize when deserialization completed. 
Should have the opposite operation onSerialize. 

This attribute can be added the type, allowing for modifying ignored
fields. 

#### useEnumName

This could be added to the type or field and causes the enum to be
converted to the name rather than the value. 

### Retrieval

An implementation is not required to support targeted specific selection. 
However these meta functions should make it trivial to support. 

#### Serial Fields 

A function which returns the fields to serialize with the given target. 

D provides property methods, since these methods do not have hidden fields 
(as seen in C#) they are ignored. Users will be expected to us onDe/Serialize 
to forward as needed. 

Private fields will not be ignored by default. 

#### Serial Tuple Name Value

Here the type and field would be provided and a tuple with the type, name and value 
Would be returned from the given target. 

This function would not check if the field is to be ignored for the target. 
 

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
