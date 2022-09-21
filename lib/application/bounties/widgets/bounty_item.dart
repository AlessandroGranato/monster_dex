import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monster_dex/providers/bounty.dart';

class BountyItem extends StatefulWidget {
  final Bounty bounty;

  const BountyItem({Key? key, required this.bounty}) : super(key: key);

  @override
  State<BountyItem> createState() => _BountyItemState();
}

class _BountyItemState extends State<BountyItem> {
  String _formattedDate = '';
  bool _expanded = false;
  @override
  void initState() {
    _formattedDate =
        DateFormat('yyyy-MM-dd – hh:mm').format(widget.bounty.dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Expanded(
                child: Text(
                  'Bounty#${_formattedDate}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  
                ),
              ),
              trailing: IconButton(
                icon: _expanded
                    ? Icon(Icons.expand_less)
                    : Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            if (_expanded)
              Container(
                alignment: Alignment.centerLeft,
                height: min(widget.bounty.monsters.length * 20 + 50, 180),
                child: ListView(
                  children: widget.bounty.monsters.map((e) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            " - ${e.name}, \$${e.bounty}",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 10),
                        ]);
                  }).toList(),
                ),
              )
          ],
        ),
      ),
    );
  }
}
