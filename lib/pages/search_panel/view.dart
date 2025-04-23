import 'package:flutter/cupertino.dart';

class SearchPanel extends StatefulWidget {
  const SearchPanel({super.key, this.keyword});
  final String? keyword;
  @override
  State<SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.keyword ?? ''),
    );
  }
}
