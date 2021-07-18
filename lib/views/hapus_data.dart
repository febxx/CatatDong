import 'package:CatatDong/helpers/database.dart';
import 'package:CatatDong/models/transaksi.dart';
import 'package:CatatDong/views/icon_category.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransaksiDetail extends StatefulWidget {

  final Transaksi transaksi;
  TransaksiDetail(this.transaksi);

  @override
  _TransaksiDetailState createState() => _TransaksiDetailState();
}

class _TransaksiDetailState extends State<TransaksiDetail> {
  var dbHelper;
  Future<List<Transaksi>> transaction;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    refreshList();
  }

  refreshList() {
    setState(() {
      transaction = dbHelper.getTransaction();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DETAIL', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.yellow,
          leading: GestureDetector(
            onTap: () {Navigator.pop(context);}, 
            child: Icon(FontAwesomeIcons.arrowLeft, color: Colors.black, size: 18,)
          ),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 1,),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.all(Radius.circular(30))
                      ),
                      child: setIcon(widget.transaksi.category),
                    ),
                    Padding(padding: EdgeInsets.only(right: 30),),
                    Text(widget.transaksi.category, style: TextStyle(fontSize: 20),),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 20),),
                Divider(height: 1, color: Colors.grey,),
                Padding(padding: EdgeInsets.only(top: 20),),
                
                rowBuilder('Nominal', widget.transaksi.price.toInt().toString()),
                rowBuilder('Tanggal', widget.transaksi.date),
                rowBuilder('Kategori', widget.transaksi.txCategory),
                rowBuilder('Catatan', widget.transaksi.note.length == 0 ? '-' : widget.transaksi.note),
              ],
            ),
          ),
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black
              ),
              onPressed: () {
                dbHelper.delete(widget.transaksi.id);
                refreshList();
                Navigator.pop(context);
              },
              child: Text('HAPUS'),
            )
          )
        ],
      ),
    );
  }

  Widget rowBuilder(String text, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            child: Text(text, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 16),),
          ),
          SizedBox(width: 15),
          Container(
            child: Text(value, style: TextStyle(fontSize: 16,),)
          ),
        ],
      ),
    );
  }
}