import 'dart:async';
import 'package:finance_app/app_event/add_transaction_event.dart';
import 'package:finance_app/app_event/update_transaction_event.dart';
import 'package:finance_app/model/transaction.dart';
import 'package:finance_app/model/data_service.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/helpers/global.dart';

class UpdateTransaction extends StatefulWidget {
  final Transaction data; // Nhận đối số dữ liệu cần chỉnh sửa

  const UpdateTransaction({Key? key, required this.data}) : super(key: key);

  @override
  State<UpdateTransaction> createState() => _UpdateTransactionState();
}

class _UpdateTransactionState extends State<UpdateTransaction> {
  DataService dataService = DataService();
  late Transaction _loadedData;

  DateTime date = DateTime.now();
  String? selectedItem;
  String? selectedItemi;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  FocusNode nameFocus = FocusNode();
  FocusNode amountFocus = FocusNode();
  final List<String> _item = [
    'Đồ ăn',
    'Giải trí',
    'Sức khỏe',
    'Giáo dục',
    'Quà tặng',
    'Tạp phẩm',
    'Lương',
    'Cổ phiếu',
    'Upwork'
  ];
  final List<String> _itemi = ['Chi phí', 'Thu nhập'];

  @override
  void initState() {
    super.initState();
    nameFocus.addListener(() {
      setState(() {});
    });
    _loadData();
  }

  void _loadData() {
    // Sử dụng dữ liệu truyền vào để cập nhật các trường nhập liệu
    _loadedData = widget.data;
    nameController.text = _loadedData.name;
    amountController.text = _loadedData.amount;
    selectedItem = _loadedData.category;
    selectedItemi = _loadedData.type;
    date = _loadedData.dateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            background_container(context),
            Positioned(
              top: 120,
              child: main_container(),
            ),
          ],
        ),
      ),
    );
  }

  Container main_container() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      height: 550,
      width: 340,
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          selected_category(),
          SizedBox(
            height: 30,
          ),
          input_name(),
          SizedBox(
            height: 30,
          ),
          amount_input(),
          SizedBox(
            height: 30,
          ),
          choose_method(),
          SizedBox(
            height: 30,
          ),
          date_time(),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () async {
              Transaction newData = Transaction(
                  id: _loadedData.id,
                  name: nameController.text,
                  category: selectedItem!,
                  amount: amountController.text,
                  type: selectedItemi!,
                  dateTime: date);

              await dataService.updateData(newData);

              eventBus.fire(UpdateTransactionEvent());

              Navigator.of(context).pop(newData); // Trả về dữ liệu đã cập nhật
              // In ra console các giá trị nhập vào
              print('Tên giao dịch: ${nameController.text}');
              print('Số tiền: ${amountController.text}');
              print('Danh mục: ${selectedItem}');
              print('Thu/Chi: ${selectedItemi}');
              print('Ngày: ${date.toIso8601String()}');
            },
            child: Container(
              width: 150,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 30, 130, 82)),
              child: Text(
                'Cập nhật',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container date_time() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2, color: Colors.grey.shade400),
      ),
      width: 300,
      child: TextButton(
        child: Text(
          'Ngày: ${date.day}/ ${date.month}/${date.year}',
          style: TextStyle(color: Colors.grey, fontSize: 17),
        ),
        onPressed: () async {
          DateTime? newDate = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2003),
              lastDate: DateTime(2100));
          if (newDate == null) return;
          setState(() {
            date = newDate;
          });
        },
      ),
    );
  }

  Padding choose_method() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: 320,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2, color: Color(0xffc5c5c5))),
        child: DropdownButton<String>(
            value: selectedItemi,
            onChanged: (value) {
              setState(() {
                selectedItemi = value!;
              });
            },
            items: _itemi
                .map((e) => DropdownMenuItem(
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              child: Image.asset('./assets/image/${e}.png'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              e,
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      value: e,
                    ))
                .toList(),
            selectedItemBuilder: (BuildContext context) => _itemi
                .map((e) => Row(
                      children: [
                        Container(
                          width: 42,
                          child: Image.asset('./assets/image/${e}.png'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          e,
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ))
                .toList(),
            hint: Text(
              'Chọn thu, chi',
              style: TextStyle(color: Colors.grey),
            ),
            underline: Container(),
            isExpanded: true),
      ),
    );
  }

  Padding amount_input() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: TextField(
        keyboardType: TextInputType.number,
        focusNode: amountFocus,
        controller: amountController,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            labelText: "Số tiền",
            labelStyle: TextStyle(fontSize: 17, color: Colors.grey),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 2, color: Colors.grey.shade400)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 2, color: Colors.green))),
      ),
    );
  }

  Padding input_name() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        focusNode: nameFocus,
        controller: nameController,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            labelText: "Tên của giao dịch",
            labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 2, color: Colors.grey.shade400)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 2, color: Colors.green))),
      ),
    );
  }

  Padding selected_category() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: 320,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2, color: Color(0xffc5c5c5))),
        child: DropdownButton<String>(
            value: selectedItem,
            onChanged: (value) {
              setState(() {
                selectedItem = value!;
              });
            },
            items: _item
                .map((e) => DropdownMenuItem(
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              child: Image.asset('./assets/image/${e}.png'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              e,
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      value: e,
                    ))
                .toList(),
            selectedItemBuilder: (BuildContext context) => _item
                .map((e) => Row(
                      children: [
                        Container(
                          width: 42,
                          child: Image.asset('./assets/image/${e}.png'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          e,
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ))
                .toList(),
            hint: Text(
              'Chọn danh mục',
              style: TextStyle(color: Colors.grey),
            ),
            underline: Container(),
            isExpanded: true),
      ),
    );
  }

  Column background_container(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 240,
          decoration: BoxDecoration(
            color: Color(0xff368983),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Chỉnh sửa giao dịch",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.attach_file_outlined,
                      size: 25,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
