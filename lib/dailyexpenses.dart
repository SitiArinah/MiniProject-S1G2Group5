import 'package:daily_expenses/login.dart';
import 'package:flutter/material.dart';
import 'package:daily_expenses/Controller/request_controller.dart';
import 'Model/expense.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daily_expenses/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:daily_expenses/firebase_options.dart';
import 'package:daily_expenses/info_screen.dart';


void main() {
  runApp(DailyExpensesApp(username: ''));
}

class DailyExpensesApp extends StatelessWidget {
  final String username;

  DailyExpensesApp({required this.username});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExpenseList(username: username),
    );
  }
}

class ExpenseList extends StatefulWidget {
  final String username;

  ExpenseList({required this.username});

  @override
  _ExpenseListState createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  final List<Expense> expenses = [];
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController txtDateController = TextEditingController();
  double totalAmount = 0;

  void _addExpense() async {
    String description = descriptionController.text.trim();
    String amount = amountController.text.trim();

    if (description.isNotEmpty && amount.isNotEmpty) {
      Expense exp =
      Expense(double.parse(amount), description, txtDateController.text);

      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

      var firestoredb = FirebaseFirestore.instance;
      firestoredb.collection("expenses").add(exp.toJson());

      if (await exp.save()) {
        setState(() {
          expenses.add(exp);
          descriptionController.clear();
          amountController.clear();
          calculateTotalAmount();  // Update the totalAmount here
        });
      } else {
        _showMessage("Failed to save Expense data");
      }
    }
  }

  void calculateTotalAmount() {
    totalAmount = 0;
    for (Expense ex in expenses) {
      totalAmount += ex.amount;
    }
    totalAmountController.text = totalAmount.toString();
  }


  void _removeExpense(int index) {
    totalAmount -= expenses[index].amount;
    setState(() {
      expenses.removeAt(index);
      totalAmountController.text = totalAmount.toString();
    });
  }

  // function display error message
  void _showMessage(String msg) {
    if (mounted) {
      // make sure this context is still mounted/exist
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
        ),
      );
    }
  }

  void _editExpense(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditExpensesScreen(
          expense: expenses[index],
          onSave: (editedExpense) {
            setState(() {
              totalAmount = totalAmount - expenses[index].amount + editedExpense.amount;
              expenses[index] = editedExpense;
              totalAmountController.text = totalAmount.toString();
            });
          },
        ),
      ),
    );
  }


  _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedDate != null && pickedTime != null) {
      setState(() {
        txtDateController.text =
        "${pickedDate.year}-${pickedDate.month}"
            "${pickedTime.hour}:${pickedTime.minute}:00";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _showMessage("Welcome ${widget.username}  !!");

      RequestController req = RequestController(
        path: "/api/timezone/Asia/Kuala_Lumpur",
        server: "http://worldtimeapi.org",
      );
      req.get().then((value) {
        dynamic res = req.result();
        txtDateController.text =
            res["datetime"].toString().substring(0, 19).replaceAll('T', '');
      });
      expenses.addAll(await Expense.loadAll());

      setState(() {
        calculateTotalAmount();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shoppenses'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Welcome, ${widget.username}'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Amount (RM)',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                keyboardType: TextInputType.datetime,
                controller: txtDateController,
                readOnly: true,
                onTap: _selectDate,
                decoration: const InputDecoration(labelText: 'Date'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: totalAmountController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Total Spend (RM)',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _addExpense,
              child: Text('Add'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent, //sets the button's text color
                backgroundColor: Colors.lightBlueAccent,
                padding: EdgeInsets.all(10), //sets the button's padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), //sets the button's border radius
                ),
                elevation: 5, //sets the button's elevation
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
              child: Text('Profile'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent, //sets the button's text color
                backgroundColor: Colors.lightBlueAccent,
                padding: EdgeInsets.all(10), //sets the button's padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), //sets the button's border radius
                ),
                elevation: 5, //sets the button's elevation
              ),
            ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InfoScreen(),
              ),
            );
          },
          child: const Text('Info'),
          style: ElevatedButton.styleFrom(
            primary: Colors.blueAccent, //sets the button's text color
            backgroundColor: Colors.lightBlueAccent,
            padding: const EdgeInsets.all(10), //sets the button's padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), //sets the button's border radius
            ),
            elevation: 5, //sets the button's elevation
          ),
        ),
            Container(
              child: _buildListView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(expenses[index].amount.toString()), // Convert double to String
          background: Container(
            color: Colors.red,
            child: Center(
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          onDismissed: (direction) {
            _removeExpense(index);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Item dismissed')));
          },
          child: Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(expenses[index].desc),
              subtitle: Row(children: [
                Text('Amount: ${expenses[index].amount.toString()}'), // Convert double to String
                const Spacer(),
                Text('Date: ${expenses[index].dateTime}')
              ]),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _removeExpense(index),
              ),
              onLongPress: () {
                _editExpense(index);
              },
            ),
          ),
        );
      },
    );
  }
}

class EditExpensesScreen extends StatefulWidget {
  final Expense expense;
  final Function(Expense) onSave;

  EditExpensesScreen({required this.expense, required this.onSave});

  @override
  _EditExpensesScreenState createState() => _EditExpensesScreenState();
}

class _EditExpensesScreenState extends State<EditExpensesScreen> {
  final TextEditingController descController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    descController.text = widget.expense.desc;
    amountController.text = widget.expense.amount.toString();
    //new
    dateTimeController.text = widget.expense.dateTime;
  }

  //new
  _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    //new
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedDate != null && pickedTime != null) {
      setState(() {
        dateTimeController.text =
        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')} "
            "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}:00";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Expense'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Amount (RM)',
              ),
            ),
          ),
          //neww
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: dateTimeController,
              readOnly: true,
              onTap: _selectDateTime,
              decoration: const InputDecoration(labelText: 'Date'),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              double editedAmount = double.parse(amountController.text);

              // Update date and time in the Expense object
              Expense editedExpense = Expense(
                editedAmount,
                descController.text,
                dateTimeController.text,
              );

              // Call the onSave callback to update the expense in the parent widget
              widget.onSave(editedExpense);

              // Perform the update to the remote MySQL database
              if (await editedExpense.update()) {
                Navigator.pop(context); // Navigate back after successful update
              } else {
                // Handle update failure
                // You can show an error message or handle it as needed
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to update Expense data'),
                  ),
                );
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
