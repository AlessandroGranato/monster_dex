//Monster-detail-screen
import 'package:flutter/material.dart';
import 'package:monster_dex/application/bounties/widgets/bounty_item.dart';
import 'package:monster_dex/providers/bounties.dart';
import 'package:provider/provider.dart';

class BountiesScreen extends StatefulWidget {
  static const String routeName = '/bounties-screen';
  const BountiesScreen({Key? key}) : super(key: key);

  @override
  State<BountiesScreen> createState() => _BountiesScreenState();
}

class _BountiesScreenState extends State<BountiesScreen> {
  late Future _bountiesFuture;

  Future _obtainBountiesFuture() =>
      Provider.of<Bounties>(context, listen: false).fetchBounties();

  @override
  void initState() {
    _bountiesFuture = _obtainBountiesFuture();
    super.initState();
  }    

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text('Bounties')),
      body: FutureBuilder(
        future: _bountiesFuture,
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return Center(child: Text('An error occurred'));
            } else {
              return Consumer<Bounties>(
                builder: (context, bounties, child) => Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: bounties.itemCount(),
                        itemBuilder: (context, i) => BountyItem(
                          bounty: bounties.getBounties[i],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}
