import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/budget_providers.dart';
import '../../data/models/budget.dart';

class BudgetDashboardScreen extends ConsumerStatefulWidget {
  final String tripId;
  const BudgetDashboardScreen({super.key, required this.tripId});

  @override
  ConsumerState<BudgetDashboardScreen> createState() => _BudgetDashboardScreenState();
}

class _BudgetDashboardScreenState extends ConsumerState<BudgetDashboardScreen> {
  int _touchedIndex = -1;
  bool _showAddExpense = false;

  final _categoryColors = {
    'ACCOMMODATION': const Color(0xFF6C63FF),
    'FOOD': const Color(0xFFFF6584),
    'TRANSPORT': const Color(0xFF43D9A2),
    'ACTIVITY': const Color(0xFFFFBF69),
    'OTHER': const Color(0xFF9B9B9B),
  };

  final _categoryIcons = {
    'ACCOMMODATION': Icons.hotel,
    'FOOD': Icons.restaurant,
    'TRANSPORT': Icons.directions_car,
    'ACTIVITY': Icons.local_activity,
    'OTHER': Icons.receipt_long,
  };

  // Mock budget for UI demo when API not connected
  Budget get _mockBudget => Budget(
    id: 'demo',
    tripId: widget.tripId,
    totalBudget: 2000,
    totalSpent: 870,
    currency: 'USD',
    expenses: [
      Expense(id: '1', description: 'Hotel Djerba Palace', amount: 350, category: 'ACCOMMODATION', date: DateTime.now()),
      Expense(id: '2', description: 'Lunch at Medina', amount: 45, category: 'FOOD', date: DateTime.now()),
      Expense(id: '3', description: 'Airport Transfer', amount: 60, category: 'TRANSPORT', date: DateTime.now()),
      Expense(id: '4', description: 'Camel Ride Safari', amount: 120, category: 'ACTIVITY', date: DateTime.now()),
      Expense(id: '5', description: 'Souvenirs', amount: 85, category: 'OTHER', date: DateTime.now()),
      Expense(id: '6', description: 'Dinner Restaurant', amount: 55, category: 'FOOD', date: DateTime.now()),
      Expense(id: '7', description: 'Bus Tour', amount: 45, category: 'TRANSPORT', date: DateTime.now()),
      Expense(id: '8', description: 'Guided Museum Tour', amount: 110, category: 'ACTIVITY', date: DateTime.now()),
    ],
  );

  Map<String, double> _groupByCategory(List<Expense> expenses) {
    final Map<String, double> totals = {};
    for (final e in expenses) {
      totals[e.category] = (totals[e.category] ?? 0) + e.amount;
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    final budgetAsync = ref.watch(budgetProvider(widget.tripId));

    return budgetAsync.when(
      data: (budget) => _buildContent(budget),
      loading: () => _buildContent(_mockBudget), // show mock while loading
      error: (_, __) => _buildContent(_mockBudget), // fallback to mock
    );
  }

  Widget _buildContent(Budget budget) {
    final categoryTotals = _groupByCategory(budget.expenses);
    final spent = budget.totalSpent > 0 ? budget.totalSpent : budget.expenses.fold(0.0, (s, e) => s + e.amount);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        title: Text('Budget', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 22)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: Color(0xFF1E1E1E), size: 28),
            onPressed: () => setState(() => _showAddExpense = !_showAddExpense),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overview card
                _buildOverviewCard(budget, spent),
                const SizedBox(height: 24),

                // Doughnut Chart
                _buildPieChart(categoryTotals),
                const SizedBox(height: 24),

                // Legend
                _buildCategoryLegend(categoryTotals),
                const SizedBox(height: 24),

                // Expense list
                Text('Expenses', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...budget.expenses.map((e) => _buildExpenseItem(e)),
              ],
            ),
          ),
          // Add Expense Sheet
          if (_showAddExpense) _buildAddExpenseSheet(budget.tripId),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(Budget budget, double spent) {
    final remaining = budget.totalBudget - spent;
    final pct = budget.totalBudget > 0 ? (spent / budget.totalBudget).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Budget', style: GoogleFonts.inter(color: Colors.white60, fontSize: 14)),
          const SizedBox(height: 4),
          Text('\$${budget.totalBudget.toStringAsFixed(0)}', style: GoogleFonts.inter(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 10,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(
                pct > 0.8 ? Colors.redAccent : const Color(0xFF43D9A2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniStat('Spent', '\$${spent.toStringAsFixed(0)}', Colors.redAccent),
              _buildMiniStat('Remaining', '\$${remaining.toStringAsFixed(0)}', const Color(0xFF43D9A2)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(color: Colors.white60, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.inter(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPieChart(Map<String, double> categoryTotals) {
    if (categoryTotals.isEmpty) return const SizedBox();
    final entries = categoryTotals.entries.toList();
    final total = entries.fold(0.0, (s, e) => s + e.value);

    return Container(
      height: 220,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(touchCallback: (event, response) {
                  setState(() {
                    _touchedIndex = response?.touchedSection?.touchedSectionIndex ?? -1;
                  });
                }),
                sectionsSpace: 3,
                centerSpaceRadius: 48,
                sections: entries.asMap().entries.map((entry) {
                  final i = entry.key;
                  final cat = entry.value.key;
                  final val = entry.value.value;
                  final isTouched = i == _touchedIndex;
                  return PieChartSectionData(
                    color: _categoryColors[cat] ?? Colors.grey,
                    value: val,
                    radius: isTouched ? 60 : 50,
                    title: isTouched ? '\$${val.toInt()}' : '',
                    titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: entries.map((e) {
              final pct = total > 0 ? (e.value / total * 100).toStringAsFixed(0) : '0';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _categoryColors[e.key] ?? Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('$pct% ${e.key.substring(0, 3)}',
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.black87)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryLegend(Map<String, double> categoryTotals) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categoryTotals.entries.map((e) {
          final color = _categoryColors[e.key] ?? Colors.grey;
          final icon = _categoryIcons[e.key] ?? Icons.receipt;
          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.key, style: GoogleFonts.inter(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
                    Text('\$${e.value.toInt()}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExpenseItem(Expense expense) {
    final color = _categoryColors[expense.category] ?? Colors.grey;
    final icon = _categoryIcons[expense.category] ?? Icons.receipt;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expense.description, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15)),
                Text(expense.category, style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 12)),
              ],
            ),
          ),
          Text('-\$${expense.amount.toStringAsFixed(0)}', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.redAccent)),
        ],
      ),
    );
  }

  Widget _buildAddExpenseSheet(String tripId) {
    final descController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCategory = 'FOOD';

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add Expense', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(hintText: 'Description', filled: true, fillColor: const Color(0xFFF3F4F6), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'Amount (\$)', filled: true, fillColor: const Color(0xFFF3F4F6), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(filled: true, fillColor: const Color(0xFFF3F4F6), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                  items: ['ACCOMMODATION', 'FOOD', 'TRANSPORT', 'ACTIVITY', 'OTHER']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setSheetState(() => selectedCategory = val ?? 'FOOD'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(budgetRepositoryProvider).addExpense(tripId, {
                        'description': descController.text,
                        'amount': double.tryParse(amountController.text) ?? 0,
                        'category': selectedCategory,
                        'date': DateTime.now().toIso8601String(),
                      });
                      ref.invalidate(budgetProvider(tripId));
                      setState(() => _showAddExpense = false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E1E1E),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text('Save Expense', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
