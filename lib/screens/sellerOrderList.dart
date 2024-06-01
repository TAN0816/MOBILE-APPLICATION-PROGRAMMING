import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SellerOrderList extends StatefulWidget {
  const SellerOrderList({super.key});

  @override
  State<SellerOrderList> createState() => _SellerOrderListState();
}

class _SellerOrderListState extends State<SellerOrderList>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  void fetchSellerOrder () async {
    
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Sales'),
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(text: 'Current Order'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Container(
            color: Colors.white,
            child: currentOrderList(),
          ),
          Container(
            color: Colors.amber[50],
            child: Center(child: Text("Completed")),
          ),
          Container(
            color: Colors.blue[100],
            child: Center(child: Text("Cancelled")),
          )
        ],
      ),
    );
  }

  Widget currentOrderList() {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: index < 4
                  ? const Border(
                      bottom: BorderSide(
                        color: Color.fromARGB(255, 223, 223, 223),
                        width: 1,
                      ),
                    )
                  : null,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.description_outlined),
                        Text(
                          'Order No: ',
                          style: TextStyle(
                            fontWeight: FontWeight
                                .bold, // or use FontWeight.w700 for a specific weight
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Order Status",
                          style: TextStyle(
                              color: Color.fromARGB(255, 68, 208, 32)),
                        )
                      ],
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    children: [
                      Image(
                        height: 80,
                        width: 80,
                        image: AssetImage('assets/images/hci.jpg'),
                      ),
                      Expanded(
                        child: Container(
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text("Title"), Text("Qty: 1")],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
