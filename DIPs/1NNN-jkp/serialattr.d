import std;

struct DB{}
struct WEB{}

struct Ignore(T) {}

struct SerializerDB(T) {}

@SerializerDB!DB
struct Example {
    @Ignore!DB
    int a;
    @Ignore!WEB
    int b;
}

void printAttributeProperties() {
    alias group = getUDAs!(Example, SerializerDB);
    static foreach(field; FieldNameTuple!(Example)) {
        writeln(mixin("getUDAs!(Example." ~ field ~ ", Ignore!"~firstTemplateArg!group~").stringof"));
    }
}

string firstTemplateArg(alias t)() {
    return TemplateArgsOf!t[0].stringof;
}

void main() {
    printAttributeProperties();
}
