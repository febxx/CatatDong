class Transaksi {
   int id;
   String date;
   String note;
   String txCategory;
   String category;
   double price;
   

   Transaksi({
     this.id, this.date, this.note, this.txCategory, this.category, this.price,
   });

   Map<String, dynamic> toMap() {
     var map = <String, dynamic>{
       'id': id,
       'date': date,
       'note': note,
       'txCategory': txCategory,
       'category': category,
       'price': price
     };
     return map;
   }

   Transaksi.fromMap(Map<String, dynamic> map) {
     id = map['id'];
     date = map['date'];
     note = map['note'];
     txCategory = map['txCategory'];
     category = map['category'];
     price = map['price'];
   }
}