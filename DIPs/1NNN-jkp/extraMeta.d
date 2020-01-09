module extraMeta;
import std.traits;

private template isDesiredUDA(alias attribute)
{
    template isDesiredUDA(alias toCheck)
    {
        static if (is(typeof(attribute)) && !__traits(isTemplate, attribute))
        {
            static if (__traits(compiles, toCheck == attribute)) {
                pragma(msg, 1);
                enum isDesiredUDA = toCheck == attribute;
            }
            else {
                pragma(msg, 2);
                enum isDesiredUDA = false;
            }
        }
        else static if (is(typeof(toCheck)))
        {
            static if (__traits(isTemplate, attribute)) {
                pragma(msg, 3);
                enum isDesiredUDA =  isDesiredUDA!(attribute, typeof(toCheck));
            }
            else {
                pragma(msg, 4);
                enum isDesiredUDA = is(typeof(toCheck) == attribute);
            }
        }
        else static if (__traits(isTemplate, attribute)) {
                pragma(msg, 5);
            enum isDesiredUDA = isInstanceOf!(attribute, toCheck);
        }
        else
        {
            static if (isInstanceOf!(TemplateOf!attribute, toCheck)) {
                pragma(msg, 6);
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
        static if(!partialDesire2!(att, index, toCheck)) {
            enum partialDesire = false;
        }
    }
    enum partialDesire = true;
}

template MygetUDAs(alias symbol, alias attribute)
{
    import std.meta : Filter;

    alias MygetUDAs = Filter!(isDesiredUDA!attribute, __traits(getAttributes, symbol));
}