import std;

struct DB{}

struct Ignore{}

struct Example {
    @Ignore
    int a;
    int b;
}

void printAttributeProperties() {
    Example e;
    static foreach(field; FieldNameTuple!(Example)) {
        writeln(mixin("getUDAs!(Example." ~ field ~ ", Ignore).stringof"));
    }
}

void main() {
    printAttributeProperties();
}
