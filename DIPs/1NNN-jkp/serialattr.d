import std;
import extraMeta;

//----- Standard Traits -----
struct DB{}
struct WEB{}
struct Default{}

struct Ignore(T) {}

struct SerializeFunc(alias Func) { alias Call = Func; }

// https://youtu.be/rSY78Hu8DqI?t=2450
struct OnSerialize(T, alias f) {}

//----- Library Specific Traits -----
struct SerializerDB(T) {}

//----- Usage Example -----
@SerializerDB!DB
struct Example {
    @Ignore!DB
    int a;
    @Ignore!WEB
    @OnSerialize!(DB, SerializeFunc!(x => x + 4))
    int b;
    @OnSerialize!(WEB, SerializeFunc!(x => x + 4))
    int c;
}

//----- Playground of thoughts -----
void printAttributeProperties() {
    alias group = getUDAs!(Example, SerializerDB);
    static foreach(field; FieldNameTuple!(Example)) {
        writeln(mixin("getUDAs!(Example." ~ field ~ ", Ignore!"~firstTemplateArg!group~").stringof"));
    }

    writeln("---------");

    static foreach(field; FieldNameTuple!(Example)) {
        writeln(mixin("MygetUDAs!(Example." ~ field ~ ", OnSerialize"~"!(" ~ firstTemplateArg!group ~ ", SerializeFunc)"~").stringof"));
    }
}

string firstTemplateArg(alias t)() {
    return TemplateArgsOf!t[0].stringof;
}

void main() {
    printAttributeProperties();
}
