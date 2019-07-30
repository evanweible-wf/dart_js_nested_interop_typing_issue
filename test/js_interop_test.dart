@JS()
library js_interop_test;

import 'package:js/js.dart';
import 'package:test/test.dart';

@JS()
@anonymous
class Node {
  external String get id;
  external List<Node> get children;
}

@JS()
external Node get root;

void main() {
  test('nested JS interop typing', () {
    expect(root, isNotNull);
    expect(root.id, 'root');
    expect(root.children, isNotEmpty);

    // This call works with DDC but fails with dart2js with a type error:
    // TypeError: Instance of 'JSArray': type 'JSArray' is not a subtype of type 'List<Node0>'
    // If you comment out this line, the assertions at the end of this test
    // pass because the collection is still structured correctly despite being
    // typed as a JSArray.
    printNodeIds(root.children);

    expect(root.children[0].id, 'child1');
    expect(root.children[1].id, 'child2');
  });
}

void printNodeIds(List<Node> nodes) {
  for (final node in nodes) {
    print('Node ID: ${node.id}');
  }
}