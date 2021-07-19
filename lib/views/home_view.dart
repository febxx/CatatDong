import 'package:flutter/material.dart';
import 'package:CatatDong/views/tambah_data.dart';
import 'package:CatatDong/views/hapus_data.dart';
import 'package:CatatDong/models/transaksi.dart';
import 'package:CatatDong/helpers/database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Transaksi>> transaksi;
  Future<List<Transaksi>> pemasukan;
  Future<List<Transaksi>> pengeluaran;
  var dbHelper;
  Future<double> totExp;
  Future<double> totInc;
  double totExpFix = 0.0;
  double totIncFix = 0.0;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      refreshList();
    });
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    refreshList();
  }
  
  refreshList() {
    setState(() {
      transaksi = dbHelper.getTransaction();
      pemasukan = dbHelper.getIncome();
      pengeluaran = dbHelper.getExpenses();
      totExp = dbHelper.getTotalExpenses();
      totExp.then((value) {totExpFix = value.toDouble();});
      totInc = dbHelper.getTotalIncome();
      totInc.then((value) {totIncFix = value.toDouble();});
    });
  }
  
  totalBalance() {
    double totBnc = totIncFix - totExpFix;
    return totBnc;
  }

  Future<void> _refreshData() async {
    await refreshList();
  }

  ListView dataTransaksi(List<Transaksi> transaksi) {
    return ListView(
      children: transaksi.reversed.map((data) => GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TransaksiDetail(data)),);
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black,width: 2,),
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black))
                ),
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${data.date}'),
                    data.txCategory == 'Pengeluaran' ? Text("Total : -${data.price.toInt().toString()}") : Text("Total : ${data.price.toInt().toString()}"),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(FontAwesomeIcons.signInAlt, size: 18,),
                                data.note == '' ? Text(' ${data.category}', style: TextStyle(fontSize: 16.0),) : Text(' ${data.note}', style: TextStyle(fontSize: 16.0),),
                              ],
                            ),
                            data.txCategory == 'Expenses' ? Text("-${data.price.toInt().toString()}", style: TextStyle(fontSize: 16.0),) : Text("${data.price.toInt().toString()}", style: TextStyle(fontSize: 16.0),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ),
      )).toList(),
    );
  }

  list(Future<List<Transaksi>> transaksi) {
    return Container(
      child: FutureBuilder(
        future: transaksi,
        builder: (context, snapshot) {
          if (null == snapshot.data || snapshot.data.length == 0) {
            return Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/notfound.png',
                    width: 300,
                    height: 300,
                  ),
                  Text('Data tidak ditemukan', style: TextStyle(fontSize: 20),)
                ],
              ),
            );
          }
          if (snapshot.hasData) {
            return dataTransaksi(snapshot.data);
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Catat Dong',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.yellow,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddData()),);
          },
          backgroundColor: Colors.yellow,
          child: Icon(FontAwesomeIcons.plus),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.black),
                    ),
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text("PEMASUKAN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),),
                        Text('Rp. ${totIncFix.toInt()}', style: TextStyle(fontSize: 14.0))
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.black),
                    ),
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text("PENGELUARAN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),),
                        Text('Rp. ${totExpFix.toInt()}', style: TextStyle(fontSize: 14.0))
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.black),
                    ),
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(FontAwesomeIcons.wallet, size: 14,),
                            Text(" SALDO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
                          ],
                        ),
                        Text('Rp. ${totalBalance().toInt()}', style: TextStyle(fontSize: 14.0))
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 10),
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.history, size: 16,),
                    Text(" Riwayat", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0),),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  border: Border.all(color: Colors.black),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.yellow
                  ),
                  labelPadding: EdgeInsets.all(1),
                  tabs: [
                    Tab(child: Text("SEMUA", style: TextStyle(color: Colors.black))),
                    Tab(child: Text("PEMASUKAN", style: TextStyle(color: Colors.black)),),
                    Tab(child: Text("PENGELUARAN", style: TextStyle(color: Colors.black)),),
                  ]
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    RefreshIndicator(
                      onRefresh: () => _refreshData(),
                      child: list(transaksi),
                    ),
                    list(pemasukan),
                    list(pengeluaran),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}