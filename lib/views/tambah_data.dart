import 'package:CatatDong/views/icon_category.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:CatatDong/models/transaksi.dart';
import 'package:CatatDong/helpers/database.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class AddData extends StatefulWidget {
  @override
  _AddDataState createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  Future<List<Transaksi>> transaksi;
  TextEditingController controller = TextEditingController();
  TextEditingController noteController = TextEditingController();

  String _selectedCategory;
  String note;
  double nominal;
  int curId;
  DateTime selectedDate;
  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  String inex;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    selectedDate = DateTime.now();
  }

  refreshList() {
    setState(() {
      transaksi = dbHelper.getTransaction();
    });
  }
  
  clearName() {
    controller.text = '';
    noteController.text = '';
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      _tabScope.tabIndex == 0 ? inex = 'Pengeluaran' : inex = 'Pemasukan';
      String date = DateFormat("dd/MM/yyyy").format(selectedDate);
      Transaksi e = Transaksi(id: null, date: date, note: note, txCategory: inex, category: _selectedCategory, price: nominal);
      dbHelper.save(e);
    }
    clearName();
  }
  
  form() {
    return Form(
      key: formKey,
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Nominal',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    validator: (val) => val.length == 0 ? 'Masukkan nominal' : null,
                    onSaved: (val) => nominal = double.parse(val),
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 15),),
                Flexible(
                  child: DateTimeField(
                    decoration: InputDecoration(
                      labelText: 'Tanggal',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    format: DateFormat("dd/MM/yyyy"),
                    onSaved: (val) => setState(() => selectedDate = val),
                    keyboardType: TextInputType.datetime,
                    onChanged: (DateTime newValue) {
                      setState(() {
                        selectedDate = newValue;
                      });
                    },
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(2000, 1),
                          initialDate: DateTime.now(),
                          lastDate:  DateTime(2101)
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 15),),
            Flexible(
              child: TextFormField(
                controller: noteController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Catatan',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                onSaved: (val) => note = val,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 15),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow
                  ),
                  onPressed: validate,
                  child: Text('TAMBAH', style: TextStyle(color: Colors.black),),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black
                  ),
                  onPressed: () {
                    clearName();
                    Navigator.pop(context);
                  },
                  child: Text('CANCEL'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  TabScope _tabScope = TabScope.getInstance();
  
  @override
  Widget build(BuildContext context) {
    
    return DefaultTabController(
      length: 2,
      initialIndex: _tabScope.tabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Text('TAMBAH DATA', style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.yellow,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            }, 
            child: Icon(FontAwesomeIcons.arrowLeft, color: Colors.black, size: 18,)
          ),
        ),
        body: Container(
          // padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.all(10.0),
                child: TabBar(
                  indicatorColor: Colors.yellow,
                  onTap: (index) => _tabScope.setTabIndex(index),
                  tabs: [
                    Tab(child: Text("PENGELUARAN", style: TextStyle(color: Colors.black))),
                    Tab(child: Text("PEMASUKAN", style: TextStyle(color: Colors.black))),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    GridView.count(
                      crossAxisCount: 4,
                      children: [
                        buildCategory('Makanan'),
                        buildCategory('Game'),
                        buildCategory('Belanja'),
                        buildCategory('Rumah'),
                        buildCategory('Kesehatan'),
                        buildCategory('Telepon'),
                        buildCategory('Pendidikan'),
                        buildCategory('Lainnya'),
                      ]
                    ),
                    GridView.count(
                      crossAxisCount: 4,
                      children: [
                        buildCategory('Gaji'),
                        buildCategory('Investasi'),
                        buildCategory('Lotre'),
                        buildCategory('Lainnya'),
                      ]
                    )
                  ],
                )
              ),
              _selectedCategory != null ? form() : SizedBox(),
            ]
          ),
        ),
      ),
    );
  }
  
  Widget buildCategory(String catText) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = catText;
        });
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.all(Radius.circular(30))
            ),
            child: setIcon(catText),
          ),
          Text(catText)
        ],
      ),
    );
  }
}

class TabScope{ // singleton class
  static TabScope _tabScope;
  int tabIndex = 0;

  static TabScope getInstance(){
    if(_tabScope == null) _tabScope = TabScope();

    return _tabScope;
  }
  void setTabIndex(int index){
    tabIndex = index;
  }
}