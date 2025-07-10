class CartItem {
  final int? id;
  final String name;
  final int price;
  final int quantity;

  CartItem({
    this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  // Konversi objek ke Map
  Map<String, dynamic> toMap() {
    return {"id": id, "name": name, "price": price, "quantity": quantity};
  }

  // Konversi dari Map ke objek
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map["id"],
      name: map["name"],
      price: map["price"],
      quantity: map["quantity"],
    );
  }
}
