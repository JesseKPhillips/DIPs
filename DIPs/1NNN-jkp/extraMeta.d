module extraMeta;
import std.traits;

private template isDesiredUDA(alias attribute)
{
    template isDesiredUDA(alias toCheck)
    {
        static if (is(typeof(attribute)) && !__traits(isTemplate, attribute))
        {
            static if (__traits(compiles, toCheck == attribute)) {
                enum isDesiredUDA = toCheck == attribute;
            }
            else {
                enum isDesiredUDA = false;
            }
        }
        else static if (is(typeof(toCheck)))
        {
            static if (__traits(isTemplate, attribute)) {
                enum isDesiredUDA =  isDesiredUDA!(attribute, typeof(toCheck));
            }
            else {
                enum isDesiredUDA = is(typeof(toCheck) == attribute);
            }
        }
        else static if (__traits(isTemplate, attribute)) {
            enum isDesiredUDA = isInstanceOf!(attribute, toCheck);
        }
        else
        {
            static if (isInstanceOf!(TemplateOf!attribute, toCheck)) {
                enum isDesiredUDA = partialDesire!(attribute, toCheck);
            }
                else
            enum isDesiredUDA = is(toCheck == attribute);
        }
    }
}

template partialDesire2(alias attribute, alias index, alias toCheck) {
    alias isDesired = isDesiredUDA!attribute;
    alias checkArgs = TemplateArgsOf!toCheck;
    alias check = checkArgs[index];
    enum partialDesire2 = isDesired!(check);
}


template partialDesire(alias attribute, alias toCheck) {
    import std.traits;
    alias attArgs = TemplateArgsOf!attribute;
    alias checkArgs = TemplateArgsOf!toCheck;
    static foreach(index, att; attArgs) {
        static if (!is(typeof(partialDesire) == bool)) // if not yet defined
        static if(!partialDesire2!(att, index, toCheck)) {
            enum partialDesire = false;
        }
    }

    static if (!is(typeof(partialDesire) == bool)) // if not yet defined
        enum partialDesire = true;
}

template MygetUDAs(alias symbol, alias attribute)
{
    import std.meta : Filter;

    alias MygetUDAs = Filter!(isDesiredUDA!attribute, __traits(getAttributes, symbol));
}
