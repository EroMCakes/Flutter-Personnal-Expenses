import 'package:expensez_app/Widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Models/transaction.dart';
import 'Widgets/transaction_list.dart';
import './Widgets/new_transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expenses App',
      theme: ThemeData(
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                subtitle1: TextStyle(
                  fontFamily: 'Opensans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
          appBarTheme: AppBarTheme(
              toolbarTextStyle: ThemeData.light()
                  .textTheme
                  .copyWith(
                      subtitle1: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ))
                  .bodyText2,
              titleTextStyle: ThemeData.light()
                  .textTheme
                  .copyWith(
                      subtitle1: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ))
                  .headline6),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
              .copyWith(secondary: Colors.cyan)),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Trasaction> _userTransactions = [
    // Trasaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 99.99,
    //   date: DateTime.now(),
    // ),
    // Trasaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 19.23,
    //   date: DateTime.now(),
    // ),
  ];

  bool _showChart = false;

  List<Trasaction> get _recentTransaction {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime pickedDate) {
    final newTx = Trasaction(
        title: txTitle,
        amount: txAmount,
        date: pickedDate,
        id: DateTime.now().toString());

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _StartAddNewTransaction(BuildContext Ctx) {
    showModalBottomSheet(
      context: Ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _isLandscape =
        (MediaQuery.of(context).orientation == Orientation.landscape);
    final appBar = AppBar(
      title: Text('Personnal Expenses'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _StartAddNewTransaction(context),
        )
      ],
    );

    final txListWidget = Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (_isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show Chart'),
                  Switch(
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      }),
                ],
              ),
            if (!_isLandscape)
              Container(
                  child: Chart(_recentTransaction),
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.3),
            if (!_isLandscape) txListWidget,
            if (_isLandscape)
              _showChart
                  ? Container(
                      child: Chart(_recentTransaction),
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.7)
                  : txListWidget,
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _StartAddNewTransaction(context),
      ),
    );
  }
}
