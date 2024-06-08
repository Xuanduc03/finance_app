class Transaction {
  int id;
  String name;
  String category;
  String amount;
  String type;
  //String action;
  DateTime dateTime;

  Transaction({
    this.id = 0,
    required this.name,
    required this.category,
    required this.amount,
    required this.type,
    required this.dateTime,
  });

  // Chuyển đối tượng AddData thành map để chuyển thành JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'amount': amount,
        'type': type,
        'dateTime': dateTime.toIso8601String(),
      };

  // Tạo đối tượng AddData từ map
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      amount: json['amount'],
      type: json['type'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
}
