enum TransactionType { deposit, withdrawal }

class InsufficientFundsException implements Exception {
  final String message;
  InsufficientFundsException(this.message);

  @override
  String toString() => 'InsufficientFundsException: $message';
}

class Transaction {
  final TransactionType type;
  final double amount;
  final DateTime date;

  Transaction({required this.type, required this.amount})
    : date = DateTime.now();

  @override
  String toString() {
    final typeStr = type == TransactionType.deposit ? 'DEPOSIT' : 'WITHDRAWAL';

    final d =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final t =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';

    return '[$typeStr] ${amount.toStringAsFixed(1)} грн - $d $t';
  }
}

class BankAccount {
  final String accountNumber;
  final String ownerName;

  double _balance;
  final List<Transaction> _transactions = [];

  BankAccount({
    required this.accountNumber,
    required this.ownerName,
    double initialBalance = 0.0,
  }) : _balance = initialBalance;

  double get balance => _balance;

  List<Transaction> get transactions => List.unmodifiable(_transactions);

  double getBalance() => _balance;

  void deposit(double amount) {
    if (amount <= 0) throw ArgumentError('Amount must be positive');

    _balance += amount;

    _transactions.add(
      Transaction(type: TransactionType.deposit, amount: amount),
    );

    print(
      '✅ Додано ${amount.toStringAsFixed(1)} грн. Баланс: ${_balance.toStringAsFixed(1)} грн',
    );
  }

  void withdraw(double amount) {
    if (amount <= 0) throw ArgumentError('Amount must be positive');

    if (amount > _balance) {
      throw InsufficientFundsException(
        'Недостатньо коштів. Баланс: $_balance, запит: $amount',
      );
    }

    _balance -= amount;

    _transactions.add(
      Transaction(type: TransactionType.withdrawal, amount: amount),
    );

    print(
      '✅ Знято ${amount.toStringAsFixed(1)} грн. Баланс: ${_balance.toStringAsFixed(1)} грн',
    );
  }
}

List<Transaction> filterByAmount(List<Transaction> txs, double min) =>
    txs.where((t) => t.amount > min).toList();

List<Transaction> filterByType(List<Transaction> txs, TransactionType type) =>
    txs.where((t) => t.type == type).toList();

double calculateTotalByType(List<Transaction> txs, TransactionType type) =>
    filterByType(txs, type).fold(0.0, (sum, t) => sum + t.amount);

({double totalDeposits, double totalWithdrawals, int count}) getStatistics(
  BankAccount account,
) {
  final txs = account.transactions;

  final totalDeposits = calculateTotalByType(txs, TransactionType.deposit);
  final totalWithdrawals = calculateTotalByType(
    txs,
    TransactionType.withdrawal,
  );

  return (
    totalDeposits: totalDeposits,
    totalWithdrawals: totalWithdrawals,
    count: txs.length,
  );
}

void printStatistics(BankAccount account) {
  print('\n=== Історія транзакцій ===');

  for (var i = 0; i < account.transactions.length; i++) {
    print('${i + 1}. ${account.transactions[i]}');
  }

  print('\n=== Аналіз ===');

  final stats = getStatistics(account);

  print(
    'Великі транзакції (>1000 грн): ${filterByAmount(account.transactions, 1000.0).length}',
  );

  print(
    'Загальна сума депозитів: ${stats.totalDeposits.toStringAsFixed(1)} грн',
  );

  print(
    'Загальна сума знять: ${stats.totalWithdrawals.toStringAsFixed(1)} грн',
  );

  print('Кількість транзакцій: ${stats.count}');
}

Future<double> checkBalanceFromServer(String accountNumber) async {
  print('⏳ Запит до банківського серверу...');

  await Future.delayed(const Duration(seconds: 2));

  return 5500.0;
}

Future<void> verifyBalance(BankAccount account) async {
  print('\nПеревірка балансу через API...');

  try {
    final serverBalance = await checkBalanceFromServer(account.accountNumber);

    if (serverBalance == account.balance) {
      print('✅ Баланс з сервера: $serverBalance грн');
    } else {
      print(
        '⚠️ Розбіжність! Сервер: $serverBalance грн, Локально: ${account.balance} грн',
      );
    }
  } catch (e) {
    print('❌ Помилка при перевірці балансу: $e');
  }
}

void main() async {
  print('=== Bank Account Manager ===\n');

  var account = BankAccount(
    accountNumber: 'UA992777',
    ownerName: 'Андрощук Роман',
    initialBalance: 0.0,
  );

  print(
    '✅ Рахунок створено: ${account.accountNumber} (${account.ownerName})\n',
  );

  print('Внесення коштів');
  account.deposit(5000);

  print('Зняття коштів');
  account.withdraw(1500);

  print('Внесення коштів');
  account.deposit(2000);

  print('Спроба зняти більше ніж є...');
  try {
    account.withdraw(10000);
  } catch (e) {
    if (e is InsufficientFundsException) {
      print('❌ Помилка: ${e.message}');
    } else {
      print('❌ Невідома помилка: $e');
    }
  }

  printStatistics(account);

  await verifyBalance(account);
}
