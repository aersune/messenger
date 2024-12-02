import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ListWood extends StatefulWidget {
  const ListWood({super.key});

  @override
  State<ListWood> createState() => _ListWoodState();
}

class _ListWoodState extends State<ListWood> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  final Map<String, GlobalKey> _messageKeys = {};



  Future scrollToItem(int index) async {
    await _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(seconds: 1),
      alignment: .5,
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
     WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToItem(20);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScrollablePositionedList.builder(
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
      itemCount: 20,
      itemBuilder: (context, index) {
        final messageId = 'message_$index';

        GlobalKey key = GlobalKey();
        _messageKeys[messageId] = key;

        return ListTile(
          key: key,
          onTap: () {
            scrollToItem(5);
          },
          title: Text('Item ${index + 1}'),
          subtitle: Text('index $index'),
          leading: const Icon(Icons.person),
          trailing: const Icon(Icons.arrow_forward_ios),
        );
      },
    ));
  }
}
