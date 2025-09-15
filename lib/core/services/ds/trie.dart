class TrieNode {
  Map<String, TrieNode> children = {};
  bool isEndOfWord = false;
  String? hostelId;
}

class Trie {
  final TrieNode root = TrieNode();

  void insert(String word, String hostelId) {
    TrieNode current = root;
    for (var char in word.toLowerCase().split('')) {
      current.children.putIfAbsent(char, () => TrieNode());
      current = current.children[char]!;
    }
    current.isEndOfWord = true;
    current.hostelId = hostelId;
  }

  List<String> search(String prefix) {
    TrieNode current = root;
    for (var char in prefix.toLowerCase().split('')) {
      if (!current.children.containsKey(char)) return [];
      current = current.children[char]!;
    }
    return _collectWords(current, prefix);
  }

  List<String> _collectWords(TrieNode node, String prefix) {
    List<String> results = [];
    if (node.isEndOfWord && node.hostelId != null) {
      results.add(prefix);
    }
    for (var entry in node.children.entries) {
      results.addAll(_collectWords(entry.value, prefix + entry.key));
    }
    return results;
  }
}