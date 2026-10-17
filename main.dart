class Expense {
  final String title;
  final double amount;
  final String paidBy;
  final String category;
  final List<String> splitBetween;

  Expense({
    required this.title,
    required this.amount,
    required this.paidBy,
    required this.category,
    required this.splitBetween,
  });

  double get sharePerPerson => amount / splitBetween.length;
}

class ExpenseGroup {
  final List<String> members = [];
  final List<Expense> expenses = [];

  // Add a new group member
  void addMember(String name) {
    if (name.trim().isEmpty) {
      print('Error: Member name cannot be empty.');
      return;
    }

    if (members.contains(name)) {
      print('Error: Member already exists.');
      return;
    }

    members.add(name);
    print('$name added successfully.');
  }

  // Record a new expense
  void addExpense({
    required String title,
    required double amount,
    required String paidBy,
    required String category,
    required List<String> splitBetween,
  }) {
    if (amount <= 0) {
      print('Error: Amount must be positive.');
      return;
    }

    if (!members.contains(paidBy)) {
      print('Error: Payer is not a group member.');
      return;
    }

    if (splitBetween.isEmpty) {
      print('Error: Select at least one participant.');
      return;
    }

    for (String person in splitBetween) {
      if (!members.contains(person)) {
        print('Error: Unknown participant $person.');
        return;
      }
    }

    if (splitBetween.toSet().length != splitBetween.length) {
      print('Error: Duplicate participants are not allowed.');
      return;
    }

    expenses.add(
      Expense(
        title: title,
        amount: amount,
        paidBy: paidBy,
        category: category,
        splitBetween: splitBetween,
      ),
    );

    print('Expense "$title" added successfully.');
  }

  // Display all expenses
  void listExpenses() {
    print('\n--- ALL EXPENSES ---');

    for (Expense e in expenses) {
      print(
        '${e.title} | Rs.${e.amount} | Paid by: ${e.paidBy} '
        '| Category: ${e.category} | Split: ${e.splitBetween}',
      );
    }
  }

  // Filter expenses by member
  void filterByMember(String name) {
    print('\n--- EXPENSES FOR $name ---');

    for (Expense e in expenses) {
      if (e.paidBy == name || e.splitBetween.contains(name)) {
        print('${e.title} | Rs.${e.amount} | ${e.category}');
      }
    }
  }

  // Filter expenses by category
  void filterByCategory(String category) {
    print('\n--- $category EXPENSES ---');

    for (Expense e in expenses) {
      if (e.category.toLowerCase() == category.toLowerCase()) {
        print('${e.title} | Rs.${e.amount} | Paid by: ${e.paidBy}');
      }
    }
  }

  // Calculate and display balances
  void printBalances() {
    print('\n--- MEMBER BALANCES ---');

    for (String member in members) {
      double totalPaid = 0;
      double totalShare = 0;

      for (Expense e in expenses) {
        if (e.paidBy == member) {
          totalPaid += e.amount;
        }

        if (e.splitBetween.contains(member)) {
          totalShare += e.sharePerPerson;
        }
      }

      double balance = totalPaid - totalShare;

      print('$member:');
      print('  Total paid: Rs.${totalPaid.toStringAsFixed(2)}');
      print('  Share owed: Rs.${totalShare.toStringAsFixed(2)}');

      if (balance > 0) {
        print('  Should receive: Rs.${balance.toStringAsFixed(2)}');
      } else if (balance < 0) {
        print('  Owes: Rs.${(-balance).toStringAsFixed(2)}');
      } else {
        print('  Settled: No dues.');
      }
    }
  }
}

void main() {
  final group = ExpenseGroup();

  // Add members
  group.addMember('Asha');
  group.addMember('Ravi');
  group.addMember('Neha');
  group.addMember('Asha');

  // Add expenses
  group.addExpense(
    title: 'Dinner',
    amount: 900,
    paidBy: 'Asha',
    category: 'Food',
    splitBetween: ['Asha', 'Ravi', 'Neha'],
  );

  group.addExpense(
    title: 'Cab',
    amount: 300,
    paidBy: 'Ravi',
    category: 'Travel',
    splitBetween: ['Asha', 'Ravi', 'Neha'],
  );

  group.addExpense(
    title: 'Snacks',
    amount: 200,
    paidBy: 'Neha',
    category: 'Food',
    splitBetween: ['Asha', 'Neha'],
  );

  // Test invalid expenses
  group.addExpense(
    title: 'Invalid Amount',
    amount: -100,
    paidBy: 'Asha',
    category: 'Food',
    splitBetween: ['Asha'],
  );

  group.addExpense(
    title: 'Unknown Payer',
    amount: 100,
    paidBy: 'Priya',
    category: 'Food',
    splitBetween: ['Asha'],
  );

  group.addExpense(
    title: 'Empty Split',
    amount: 100,
    paidBy: 'Asha',
    category: 'Food',
    splitBetween: [],
  );

  group.addExpense(
    title: 'Unknown Participant',
    amount: 100,
    paidBy: 'Asha',
    category: 'Food',
    splitBetween: ['Priya'],
  );

  // Display results
  group.listExpenses();
  group.filterByMember('Asha');
  group.filterByCategory('Food');
  group.printBalances();
}
