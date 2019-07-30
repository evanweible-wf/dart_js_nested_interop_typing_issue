# Repro: Typing Inconsistency With Nested JS Interop

This repo demonstrates an inconsistency between DDC and dart2js with how a JS
interop field is typed.

Given the following `package:js`-annotated class:

```dart
@JS()
@anonymous
class Node {
  external String get id;
  external List<Node> get children;
}
```

And the following JS that populates an instance of this class:

```js
root = {
    'id': 'root',
    'children': [
        {
            'id': 'child1',
            children: [],
        },
        {
            'id': 'child2',
            children: [],
        },
    ],
};
```

And Dart code that passes an instance of `Node.children` to a method expecting
something typed as `List<Node>`:

```dart
void printNodeIds(List<Node> nodes) {
  for (final node in nodes) {
    print('Node ID: ${node.id}');
  }
}
```

The resulting behavior differs depending on whether the code is compiled with
DDC or dart2js. With DDC, the code runs without issue and prints the IDs. With
dart2js, a type error is encountered:

```txt
TypeError: Instance of 'JSArray': type 'JSArray' is not a subtype of type 'List<Node0>'
```

However, the structure of the JS interop class instance is as expected in both
scenarios and operations can be made on items in the `Node.children` collection.

---

To reproduce the difference, clone this repo and run the following:

```bash
$ pub run build_runner test
# Test will pass on DDC.

$ pub run build_runner test -r
# Test will fail with the `TypeError` on dart2js.
```
