import 'package:flutter/material.dart';
import 'dart:math';

class ProsAndCons extends StatefulWidget {
  final String title;
  final List<String> elements;
  const ProsAndCons({
    Key? key,
    required this.title,
    required this.elements,
  }) : super(key: key);

  @override
  State<ProsAndCons> createState() => _ProsAndConsState();
}

class _ProsAndConsState extends State<ProsAndCons> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(
                widget.title,
                style: Theme.of(context).textTheme.headline6,
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
                height: min(widget.elements.length * 20 + 50, 180),
                child: ListView(
                  children: widget.elements.map((e) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            " - $e",
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