import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';

@internal
abstract class Node<T extends Node<T>> {
  static const HashCodeLength = 32;
  static const BitPartitionSize = 5;
  static const BitPartitionMask = (1 << BitPartitionSize) - 1;
  static final MaxDepth = (HashCodeLength.toDouble() / BitPartitionSize).ceil();
  static const BranchingFactor = 1 << BitPartitionSize;

  static int maskFrom(int hash, int shift) =>
      (hash >>> shift) & BitPartitionMask;

  static int bitposFrom(int mask) => 1 << mask;

  static int indexFrom(int bitmap, int bitpos) =>
      Integer.bitCount(bitmap & (bitpos - 1));

  static int indexFromMask(int bitmap, int mask, int bitpos) =>
      bitmap == -1 ? mask : indexFrom(bitmap, bitpos);

  int getHash(int index);

  T getNode(int index);

  dynamic getPayload(int index);

  bool get hasNodes;

  bool get hasPayload;

  int get nodeArity;

  int get payloadArity;

  int get cachedDartKeySetHashCode;

  @protected
  Array<int> removeElement(Array<int> arr, int ix) {
    if (ix < 0) throw arrayIndexOutOfBounds(arr, ix);
    if (ix > arr.length - 1) throw arrayIndexOutOfBounds(arr, ix);

    final result = Array.ofDim<int>(arr.length - 1);

    Array.arraycopy(arr, 0, result, 0, ix);
    Array.arraycopy(arr, ix + 1, result, ix, arr.length - ix - 1);

    return result;
  }

  @protected
  Array<dynamic> removeAnyElement(Array<dynamic> arr, int ix) {
    if (ix < 0) throw arrayIndexOutOfBounds(arr, ix);
    if (ix > arr.length - 1) throw arrayIndexOutOfBounds(arr, ix);

    final result = Array.ofDim<dynamic>(arr.length - 1);

    Array.arraycopy(arr, 0, result, 0, ix);
    Array.arraycopy(arr, ix + 1, result, ix, arr.length - ix - 1);

    return result;
  }

  @protected
  Array<int> insertElement(Array<int> arr, int ix, int elem) {
    if (ix < 0) throw arrayIndexOutOfBounds(arr, ix);
    if (ix > arr.length) throw arrayIndexOutOfBounds(arr, ix);

    final result = Array.ofDim<int>(arr.length + 1);

    Array.arraycopy(arr, 0, result, 0, ix);
    result[ix] = elem;
    Array.arraycopy(arr, ix, result, ix + 1, arr.length - ix);

    return result;
  }

  @protected
  Array<dynamic> insertAnyElement(Array<int> arr, int ix, int elem) {
    if (ix < 0) throw arrayIndexOutOfBounds(arr, ix);
    if (ix > arr.length) throw arrayIndexOutOfBounds(arr, ix);

    final result = Array.ofDim<dynamic>(arr.length + 1);

    Array.arraycopy(arr, 0, result, 0, ix);
    result[ix] = elem;
    Array.arraycopy(arr, ix, result, ix + 1, arr.length - ix);

    return result;
  }

  RangeError arrayIndexOutOfBounds(Array<dynamic> arr, int ix) =>
      RangeError('$ix is out of bounds (min 0, max ${arr.length - 1}');
}

@internal
abstract class ChampBaseIterator<A, T extends Node<T>> extends RibsIterator<A> {
  @protected
  int currentValueCursor = 0;
  @protected
  int currentValueLength = 0;
  @protected
  T? currentValueNode;

  var _currentStackLevel = -1;
  Array<int>? _nodeCursorsAndLengths;
  late Array<T> _nodes;

  ChampBaseIterator(T rootNode) {
    if (rootNode.hasNodes) _pushNode(rootNode);
    if (rootNode.hasPayload) _setupPayloadNode(rootNode);
  }

  @override
  bool get hasNext =>
      (currentValueCursor < currentValueLength) || _searchNextValueNode();

  void _initNodes() {
    if (_nodeCursorsAndLengths == null) {
      _nodeCursorsAndLengths = Array.ofDim<int>(Node.MaxDepth * 2);
      _nodes = Array.ofDim<T>(Node.MaxDepth);
    }
  }

  void _setupPayloadNode(T node) {
    currentValueNode = node;
    currentValueCursor = 0;
    currentValueLength = node.payloadArity;
  }

  void _pushNode(T node) {
    _initNodes();
    _currentStackLevel = _currentStackLevel + 1;

    final cursorIndex = _currentStackLevel * 2;
    final lengthIndex = _currentStackLevel * 2 + 1;

    _nodes[_currentStackLevel] = node;
    _nodeCursorsAndLengths![cursorIndex] = 0;
    _nodeCursorsAndLengths![lengthIndex] = node.nodeArity;
  }

  void _popNode() {
    _currentStackLevel = _currentStackLevel - 1;
  }

  bool _searchNextValueNode() {
    while (_currentStackLevel >= 0) {
      final cursorIndex = _currentStackLevel * 2;
      final lengthIndex = _currentStackLevel * 2 + 1;

      final nodeCursor = _nodeCursorsAndLengths![cursorIndex]!;
      final nodeLength = _nodeCursorsAndLengths![lengthIndex]!;

      if (nodeCursor < nodeLength) {
        _nodeCursorsAndLengths![cursorIndex] =
            _nodeCursorsAndLengths![cursorIndex]! + 1;

        final nextNode = _nodes[_currentStackLevel]!.getNode(nodeCursor);

        if (nextNode.hasNodes) _pushNode(nextNode);
        if (nextNode.hasPayload) {
          _setupPayloadNode(nextNode);
          return true;
        }
      } else {
        _popNode();
      }
    }

    return false;
  }
}
