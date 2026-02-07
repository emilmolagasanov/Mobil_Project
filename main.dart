import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MainApp());
}

// 📦 Ürün Veri Modeli - Detaylı
class Product {
  final String id;
  final String name;
  final String category;
  int quantity;
  final DateTime expiryDate;
  final DateTime arrivalDate;
  final double buyPrice;
  final double salePrice;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.expiryDate,
    required this.arrivalDate,
    required this.buyPrice,
    required this.salePrice,
  });

  int get daysUntilExpiry {
    return expiryDate.difference(DateTime.now()).inDays;
  }

  bool get isCritical {
    return daysUntilExpiry <= 7 && daysUntilExpiry >= 0;
  }

  bool get isExpired {
    return daysUntilExpiry < 0;
  }

  double get profit {
    return (salePrice - buyPrice) * quantity;
  }
}

// 👨‍💼 Personel Veri Modeli
class Employee {
  final String id;
  final String name;
  final String position;
  final double salary;
  final DateTime salaryDate;
  final DateTime hireDate;
  final String insurance; // Sigorta türü
  final String workHours; // Çalışma saatleri
  final String avatar; // Avatar rengi

  Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.salary,
    required this.salaryDate,
    required this.hireDate,
    required this.insurance,
    required this.workHours,
    required this.avatar,
  });

  int get daysUntilSalary {
    DateTime nextSalary = DateTime(salaryDate.year, salaryDate.month, salaryDate.day);
    if (nextSalary.isBefore(DateTime.now())) {
      nextSalary = DateTime(nextSalary.year, nextSalary.month + 1, nextSalary.day);
    }
    return nextSalary.difference(DateTime.now()).inDays;
  }

  bool get isSalaryDue => daysUntilSalary <= 3;
}

// 🏪 Ana Uygulamalar
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MOURA STORE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// 🔐 Giriş Ekranı
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController(text: 'admin@mourastore.com');
  final passwordController = TextEditingController(text: '123456');
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepOrange.shade700, Colors.deepOrange.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15, spreadRadius: 5)],
                  ),
                  child: const Icon(Icons.store, size: 100, color: Colors.deepOrange),
                ),
                const SizedBox(height: 32),
                const Text(
                  'MOURA STORE',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Text(
                  'Bakkal Yönetim Sistemi',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 48),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Şifre',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                              }
                            },
                            child: const Text('GİRİŞ YAP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

// 🏠 Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? selectedCategory;
  late List<Product> products = _generateProducts();
  late List<Employee> employees = [
    Employee(id: '1', name: 'Mehmet Yıldız', position: 'Satış Danışmanı', salary: 25000, salaryDate: DateTime(2026, 2, 10), hireDate: DateTime(2023, 1, 15), insurance: 'SGK', workHours: '08:00 - 17:00', avatar: 'FF6B35'),
    Employee(id: '2', name: 'Ayşe Kaya', position: 'Kasa', salary: 22000, salaryDate: DateTime(2026, 2, 15), hireDate: DateTime(2023, 6, 20), insurance: 'SGK', workHours: '09:00 - 18:00', avatar: 'F7931E'),
    Employee(id: '3', name: 'İbrahim Demir', position: 'Stok Sorumlusu', salary: 24000, salaryDate: DateTime(2026, 2, 8), hireDate: DateTime(2022, 3, 10), insurance: 'Bağkur', workHours: '07:00 - 16:00', avatar: 'FFC107'),
    Employee(id: '4', name: 'Zeynep Şahin', position: 'Temizlik Personeli', salary: 18000, salaryDate: DateTime(2026, 2, 1), hireDate: DateTime(2023, 11, 1), insurance: 'SGK', workHours: '06:00 - 14:00', avatar: 'FF1493'),
    Employee(id: '5', name: 'Mustafa Çelik', position: 'Tezgah Sorumlusu', salary: 23000, salaryDate: DateTime(2026, 2, 12), hireDate: DateTime(2022, 9, 5), insurance: 'SGK', workHours: '08:30 - 17:30', avatar: '00BCD4'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛒 MOURA STORE'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        actions: [IconButton(icon: const Icon(Icons.logout), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())))],
      ),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Ürünler'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Personel'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
      floatingActionButton: _selectedIndex == 1
        ? FloatingActionButton(onPressed: _showAddProductDialog, child: const Icon(Icons.add))
        : _selectedIndex == 2
          ? FloatingActionButton(onPressed: _addEmployee, child: const Icon(Icons.add))
          : null,
    );
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildProductsList();
      case 2:
        return _buildEmployeesList();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    int totalProducts = products.fold(0, (sum, p) => sum + p.quantity);
    int criticalCount = products.where((p) => p.isCritical || p.isExpired).length;
    double totalValue = products.fold(0, (sum, p) => sum + (p.salePrice * p.quantity));
    double totalProfit = products.fold(0, (sum, p) => sum + p.profit);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepOrange.shade800, Colors.deepOrange.shade500, Colors.amber.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.deepOrange.withAlpha(100), blurRadius: 20, spreadRadius: 5)],
            ),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(200),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.store, size: 70, color: Colors.deepOrange),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MOURA STORE',
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const Text('Kaliteli Bakkal Ürünleri', style: TextStyle(fontSize: 14, color: Colors.white70)),
                      const SizedBox(height: 8),
                      const Text('📍 Bakırköy, İstanbul', style: TextStyle(fontSize: 12, color: Colors.white)),
                      const Text('⏰ 08:00 - 21:00', style: TextStyle(fontSize: 12, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildSummaryCard('Toplam Ürün', '$totalProducts', Icons.inventory, Colors.blue),
                const SizedBox(width: 12),
                _buildSummaryCard('Kritik Ürün', '$criticalCount', Icons.warning, Colors.red),
                const SizedBox(width: 12),
                _buildSummaryCard('Toplam Değer', '₺${(totalValue / 1000).toStringAsFixed(0)}K', Icons.attach_money, Colors.green),
                const SizedBox(width: 12),
                _buildSummaryCard('Kâr', '₺${(totalProfit / 1000).toStringAsFixed(0)}K', Icons.trending_up, Colors.purple),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('📂 Kategoriler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildCategoryGrid(),
          const SizedBox(height: 24),
          const Text('⚠️ Acil Dikkat Gereken Ürünler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildCriticalProductsList(),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    final filteredProducts = selectedCategory == null
        ? products
        : products.where((p) => p.category == selectedCategory).toList();
    
    return Column(
      children: [
        if (selectedCategory != null)
          Container(
            color: Colors.deepOrange.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(child: Text('Seçili: $selectedCategory', style: const TextStyle(fontWeight: FontWeight.bold))),
                TextButton(
                  onPressed: () => setState(() => selectedCategory = null),
                  child: const Text('Tümünü Göster'),
                )
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) => _buildProductCard(filteredProducts[index], index),
          ),
        )
      ],
    );
  }

  Widget _buildEmployeesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: employees.length,
      itemBuilder: (context, index) => _buildEmployeeCard(employees[index], index),
    );
  }
  
  void _addEmployee() {
    final textName = TextEditingController();
    final textPosition = TextEditingController();
    final textSalary = TextEditingController();
    final textInsurance = TextEditingController();
    final textWorkHours = TextEditingController();
    String selectedAvatar = 'FF6B35';
    final avatarColors = ['FF6B35', 'F7931E', 'FFC107', 'FF1493', '00BCD4', '4CAF50', '2196F3', '9C27B0'];
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Personel Ekle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: textName, decoration: const InputDecoration(label: Text('Ad Soyadı'))),
                const SizedBox(height: 8),
                TextField(controller: textPosition, decoration: const InputDecoration(label: Text('Pozisyon'))),
                const SizedBox(height: 8),
                TextField(controller: textSalary, keyboardType: TextInputType.number, decoration: const InputDecoration(label: Text('Maaş'))),
                const SizedBox(height: 8),
                TextField(controller: textInsurance, decoration: const InputDecoration(label: Text('Sigorta (SGK/Bağkur)'))),
                const SizedBox(height: 8),
                TextField(controller: textWorkHours, decoration: const InputDecoration(label: Text('Çalışma Saatleri (08:00 - 17:00)'))),
                const SizedBox(height: 12),
                Wrap(spacing: 8, children: avatarColors.map((color) => GestureDetector(
                  onTap: () => setDialogState(() => selectedAvatar = color),
                  child: CircleAvatar(backgroundColor: Color(int.parse('FF$color', radix: 16)), radius: 20, child: selectedAvatar == color ? const Icon(Icons.check, color: Colors.white) : null),
                )).toList()),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
            TextButton(
              onPressed: () {
                if (textName.text.isNotEmpty && textPosition.text.isNotEmpty) {
                  setState(() {
                    employees.add(Employee(
                      id: DateTime.now().toString(),
                      name: textName.text,
                      position: textPosition.text,
                      salary: double.tryParse(textSalary.text) ?? 20000,
                      salaryDate: DateTime.now(),
                      hireDate: DateTime.now(),
                      insurance: textInsurance.text.isEmpty ? 'SGK' : textInsurance.text,
                      workHours: textWorkHours.text.isEmpty ? '08:00 - 17:00' : textWorkHours.text,
                      avatar: selectedAvatar,
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Ekle'),
            )
          ],
        ),
      ),
    );
  }
  
  void _editEmployee(int index) {
    final employee = employees[index];
    final textName = TextEditingController(text: employee.name);
    final textPosition = TextEditingController(text: employee.position);
    final textSalary = TextEditingController(text: employee.salary.toString());
    final textInsurance = TextEditingController(text: employee.insurance);
    final textWorkHours = TextEditingController(text: employee.workHours);
    String selectedAvatar = employee.avatar;
    final avatarColors = ['FF6B35', 'F7931E', 'FFC107', 'FF1493', '00BCD4', '4CAF50', '2196F3', '9C27B0'];
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Personel Düzenle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: textName, decoration: const InputDecoration(label: Text('Ad Soyadı'))),
                const SizedBox(height: 8),
                TextField(controller: textPosition, decoration: const InputDecoration(label: Text('Pozisyon'))),
                const SizedBox(height: 8),
                TextField(controller: textSalary, keyboardType: TextInputType.number, decoration: const InputDecoration(label: Text('Maaş'))),
                const SizedBox(height: 8),
                TextField(controller: textInsurance, decoration: const InputDecoration(label: Text('Sigorta'))),
                const SizedBox(height: 8),
                TextField(controller: textWorkHours, decoration: const InputDecoration(label: Text('Çalışma Saatleri'))),
                const SizedBox(height: 12),
                Wrap(spacing: 8, children: avatarColors.map((color) => GestureDetector(
                  onTap: () => setDialogState(() => selectedAvatar = color),
                  child: CircleAvatar(backgroundColor: Color(int.parse('FF$color', radix: 16)), radius: 20, child: selectedAvatar == color ? const Icon(Icons.check, color: Colors.white) : null),
                )).toList()),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
            TextButton(
              onPressed: () {
                if (textName.text.isNotEmpty) {
                  setState(() {
                    employees[index] = Employee(
                      id: employee.id,
                      name: textName.text,
                      position: textPosition.text,
                      salary: double.tryParse(textSalary.text) ?? employee.salary,
                      salaryDate: employee.salaryDate,
                      hireDate: employee.hireDate,
                      insurance: textInsurance.text.isEmpty ? 'SGK' : textInsurance.text,
                      workHours: textWorkHours.text.isEmpty ? '08:00 - 17:00' : textWorkHours.text,
                      avatar: selectedAvatar,
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Güncelle'),
            )
          ],
        ),
      ),
    );
  }
  
  void _deleteEmployee(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Personeli Sil'),
        content: Text('${employees[index].name} silinecek. Emin misiniz?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          TextButton(
            onPressed: () {
              setState(() => employees.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(colors: [color.withAlpha(200), color.withAlpha(100)]),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Colors.white),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 11), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = {
      'Yiyecek': (Icons.restaurant, Colors.orange),
      'Et': (Icons.set_meal, Colors.red),
      'Tavuk': (Icons.fastfood, Colors.deepOrange),
      'Peynir': (Icons.emoji_food_beverage, Colors.amber),
      'Şarkuteri': (Icons.lunch_dining, Colors.brown),
      'Temizlik': (Icons.cleaning_services, Colors.blue),
      'Atıştırma': (Icons.local_dining, Colors.purple),
      'Kişisel': (Icons.spa, Colors.pink),
    };

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: categories.entries.map((entry) {
        int count = products.where((p) => p.category == entry.key).length;
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [entry.value.$2.withAlpha(100), entry.value.$2.withAlpha(200)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: InkWell(
              onTap: () => setState(() {
                selectedCategory = entry.key;
                _selectedIndex = 1;
              }),
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(entry.value.$1, size: 36, color: entry.value.$2),
                  const SizedBox(height: 6),
                  Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11), textAlign: TextAlign.center),
                  Text('$count', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCriticalProductsList() {
    final criticalProducts = products.where((p) => p.isCritical || p.isExpired).toList();
    if (criticalProducts.isEmpty) {
      return Card(
        color: Colors.green.shade50,
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 32),
              SizedBox(width: 12),
              Expanded(child: Text('✅ Kritik durumdaki ürün yok', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
            ],
          ),
        ),
      );
    }
    return Column(children: criticalProducts.take(5).map((p) => _buildProductCard(p, products.indexOf(p))).toList());
  }

  Widget _buildProductCard(Product product, int index) {
    final isExpired = product.isExpired;
    final isCritical = product.isCritical && !isExpired;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: isExpired || isCritical ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isExpired ? Colors.red : isCritical ? Colors.orange : Colors.grey.shade300, width: isExpired || isCritical ? 3 : 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Container(width: 70, height: 70, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.qr_code_2, size: 45)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isExpired ? Colors.red : isCritical ? Colors.orange : Colors.black)),
                      Text(product.category, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text('Stok: ${product.quantity} • Alış: ₺${product.buyPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('₺${product.salePrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                    Text('Kâr: ₺${product.profit.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11, color: Colors.green)),
                    if (isExpired || isCritical) Icon(Icons.warning_amber_rounded, color: isExpired ? Colors.red : Colors.orange, size: 24),
                  ],
                ),
              ],
            ),
            const Divider(height: 12, thickness: 1),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gelişi: ${DateFormat('dd/MM/yyyy').format(product.arrivalDate)}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      Text(
                        product.isExpired ? '❌ Geçmiş: ${product.daysUntilExpiry.abs()} gün' : product.isCritical ? '⚠️ SKT: ${product.daysUntilExpiry} gün' : '✅ SKT: ${product.daysUntilExpiry} gün',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isExpired ? Colors.red : isCritical ? Colors.orange : Colors.green),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(child: const Text('💰 Satış Yap'), onTap: () => _makeSale(product, index)),
                    PopupMenuItem(child: const Text('Stok Artır'), onTap: () => _showStockDialog(product, true)),
                    PopupMenuItem(child: const Text('Stok Azalt'), onTap: () => _showStockDialog(product, false)),
                    PopupMenuItem(child: const Text('Sil'), onTap: () => setState(() => products.removeAt(index))),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(Employee employee, int index) {
    final isSalaryDue = employee.isSalaryDue;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: isSalaryDue ? 8 : 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: isSalaryDue ? Colors.red : Colors.grey.shade300, width: isSalaryDue ? 3 : 1)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSalaryDue ? Colors.red.shade50 : Colors.grey.shade50,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Color(int.parse('FF${employee.avatar}', radix: 16)),
                  child: Text(employee.name[0], style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(employee.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(employee.position, style: const TextStyle(fontSize: 13, color: Colors.deepOrange, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.shield, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(employee.insurance, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Çalışma Saatleri', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 16, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(employee.workHours, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Maaş', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
                    Text('₺${employee.salary.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Maaş Tarihi', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
                    Text(
                      DateFormat('dd/MM').format(employee.salaryDate),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSalaryDue ? Colors.red : Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info, color: Colors.blue, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Kalan Gün: ${employee.daysUntilSalary} gün',
                      style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            if (isSalaryDue) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red.shade400, width: 2)),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Expanded(child: Text('⚠️ Maaş ödenmesi gerekiyor!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12))),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _editEmployee(index),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Düzenle'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _deleteEmployee(index),
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text('Sil'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _makeSale(Product product, int index) {
    final controller = TextEditingController(text: '1');
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('💰 Satış Yap'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                onChanged: (_) => setDialogState(() {}),
                decoration: InputDecoration(
                  labelText: 'Satılan Miktar',
                  prefixIcon: const Icon(Icons.shopping_cart),
                  helperText: 'Stok: ${product.quantity}',
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ürün: ${product.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Satış Fiyatı: ₺${product.salePrice}', style: const TextStyle(fontSize: 12)),
                    const Divider(height: 12),
                    int.tryParse(controller.text) != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Toplam Gelir: ₺${(product.salePrice * (int.tryParse(controller.text) ?? 1)).toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                              const SizedBox(height: 4),
                              Text('Toplam Kar: ₺${((product.salePrice - product.buyPrice) * (int.tryParse(controller.text) ?? 1)).toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                            ],
                          )
                        : const Text('Miktar girin'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
            ElevatedButton(
              onPressed: () {
                int quantity = int.tryParse(controller.text) ?? 0;
                if (quantity > 0 && quantity <= product.quantity) {
                  setState(() {
                    product.quantity -= quantity;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('✅ ${product.name} x$quantity satıldı! Gelir: ₺${(product.salePrice * quantity).toStringAsFixed(2)}'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('❌ Yeterli stok yok!'), backgroundColor: Colors.red),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Satışı Tamamla'),
            ),
          ],
        ),
      ),
    );
  }

  void _showStockDialog(Product product, bool isIncrease) {
    final controller = TextEditingController(text: '1');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isIncrease ? 'Stok Artır' : 'Stok Azalt'),
        content: TextField(controller: controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Miktar', prefixIcon: Icon(isIncrease ? Icons.add : Icons.remove))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () {
              int quantity = int.tryParse(controller.text) ?? 0;
              setState(() {
                if (isIncrease) {
                  product.quantity += quantity;
                } else {
                  product.quantity = (product.quantity - quantity).clamp(0, double.infinity).toInt();
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Onayla'),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog() {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final quantityController = TextEditingController(text: '1');
    final buyPriceController = TextEditingController();
    final salePriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Ürün Ekle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Ürün Adı')),
              const SizedBox(height: 12),
              TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Kategori')),
              const SizedBox(height: 12),
              TextField(controller: quantityController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stok')),
              const SizedBox(height: 12),
              TextField(controller: buyPriceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Alış Fiyatı (₺)')),
              const SizedBox(height: 12),
              TextField(controller: salePriceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Satış Fiyatı (₺)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && buyPriceController.text.isNotEmpty && salePriceController.text.isNotEmpty) {
                setState(() {
                  products.add(
                    Product(
                      id: DateTime.now().toString(),
                      name: nameController.text,
                      category: categoryController.text.isEmpty ? 'Yiyecek' : categoryController.text,
                      quantity: int.parse(quantityController.text),
                      expiryDate: DateTime.now().add(const Duration(days: 30)),
                      arrivalDate: DateTime.now(),
                      buyPrice: double.parse(buyPriceController.text),
                      salePrice: double.parse(salePriceController.text),
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  static List<Product> _generateProducts() {
    final now = DateTime.now();
    return [
      Product(id: '1', name: 'Süt (1L)', category: 'Yiyecek', quantity: 15, expiryDate: now.add(const Duration(days: 5)), arrivalDate: now.subtract(const Duration(days: 2)), buyPrice: 8.50, salePrice: 12.99),
      Product(id: '2', name: 'Ekmek Beyaz', category: 'Yiyecek', quantity: 25, expiryDate: now.add(const Duration(days: 1)), arrivalDate: now.subtract(const Duration(hours: 6)), buyPrice: 1.80, salePrice: 3.50),
      Product(id: '3', name: 'Ekmek Esmer', category: 'Yiyecek', quantity: 20, expiryDate: now.add(const Duration(days: 1)), arrivalDate: now.subtract(const Duration(hours: 6)), buyPrice: 2.20, salePrice: 4.00),
      Product(id: '4', name: 'Yoğurt (500g)', category: 'Yiyecek', quantity: 18, expiryDate: now.add(const Duration(days: 7)), arrivalDate: now.subtract(const Duration(days: 1)), buyPrice: 4.50, salePrice: 7.99),
      Product(id: '5', name: 'Çikolata', category: 'Atıştırma', quantity: 40, expiryDate: now.add(const Duration(days: 180)), arrivalDate: now.subtract(const Duration(days: 30)), buyPrice: 2.00, salePrice: 3.99),
      Product(id: '6', name: 'Tavuk Göğsü (500g)', category: 'Tavuk', quantity: 12, expiryDate: now.add(const Duration(days: 3)), arrivalDate: now.subtract(const Duration(days: 1)), buyPrice: 15.00, salePrice: 24.99),
      Product(id: '7', name: 'Tavuk Butu (1kg)', category: 'Tavuk', quantity: 10, expiryDate: now.add(const Duration(days: 3)), arrivalDate: now.subtract(const Duration(days: 1)), buyPrice: 12.00, salePrice: 19.99),
      Product(id: '8', name: 'Bütün Tavuk', category: 'Tavuk', quantity: 8, expiryDate: now.add(const Duration(days: 2)), arrivalDate: now.subtract(const Duration(days: 1)), buyPrice: 18.00, salePrice: 28.99),
      Product(id: '9', name: 'Kırmızı Et (500g)', category: 'Et', quantity: 9, expiryDate: now.add(const Duration(days: 2)), arrivalDate: now.subtract(const Duration(days: 1)), buyPrice: 20.00, salePrice: 34.99),
      Product(id: '10', name: 'Köfte (500g)', category: 'Et', quantity: 14, expiryDate: now.add(const Duration(days: 3)), arrivalDate: now.subtract(const Duration(days: 1)), buyPrice: 16.00, salePrice: 26.99),
      Product(id: '11', name: 'Beyaz Peynir', category: 'Peynir', quantity: 16, expiryDate: now.add(const Duration(days: 20)), arrivalDate: now.subtract(const Duration(days: 5)), buyPrice: 18.00, salePrice: 32.99),
      Product(id: '12', name: 'Cheddar Peynir', category: 'Peynir', quantity: 12, expiryDate: now.add(const Duration(days: 30)), arrivalDate: now.subtract(const Duration(days: 10)), buyPrice: 12.00, salePrice: 19.99),
      Product(id: '13', name: 'Mozzarella Peynir', category: 'Peynir', quantity: 20, expiryDate: now.add(const Duration(days: 15)), arrivalDate: now.subtract(const Duration(days: 3)), buyPrice: 10.00, salePrice: 16.99),
      Product(id: '14', name: 'Sucuk (500g)', category: 'Şarkuteri', quantity: 11, expiryDate: now.add(const Duration(days: 25)), arrivalDate: now.subtract(const Duration(days: 5)), buyPrice: 14.00, salePrice: 22.99),
      Product(id: '15', name: 'Pastırma (400g)', category: 'Şarkuteri', quantity: 9, expiryDate: now.add(const Duration(days: 20)), arrivalDate: now.subtract(const Duration(days: 5)), buyPrice: 16.00, salePrice: 26.99),
      Product(id: '16', name: 'Deterjan (2kg)', category: 'Temizlik', quantity: 8, expiryDate: now.add(const Duration(days: 730)), arrivalDate: now.subtract(const Duration(days: 30)), buyPrice: 18.00, salePrice: 28.99),
      Product(id: '17', name: 'Çamaşır Suyu', category: 'Temizlik', quantity: 12, expiryDate: now.add(const Duration(days: 365)), arrivalDate: now.subtract(const Duration(days: 20)), buyPrice: 8.00, salePrice: 13.99),
      Product(id: '18', name: 'Bulaşık Deterjanı', category: 'Temizlik', quantity: 20, expiryDate: now.add(const Duration(days: 365)), arrivalDate: now.subtract(const Duration(days: 15)), buyPrice: 4.50, salePrice: 7.99),
      Product(id: '19', name: 'Tuvalet Kağıdı', category: 'Temizlik', quantity: 35, expiryDate: now.add(const Duration(days: 365)), arrivalDate: now.subtract(const Duration(days: 10)), buyPrice: 6.00, salePrice: 9.99),
      Product(id: '20', name: 'Yer Temizleyici', category: 'Temizlik', quantity: 7, expiryDate: now.add(const Duration(days: 365)), arrivalDate: now.subtract(const Duration(days: 25)), buyPrice: 10.00, salePrice: 15.99),
      Product(id: '21', name: 'Chips Tuzlu', category: 'Atıştırma', quantity: 50, expiryDate: now.add(const Duration(days: 120)), arrivalDate: now.subtract(const Duration(days: 20)), buyPrice: 1.50, salePrice: 2.99),
      Product(id: '22', name: 'Crackers', category: 'Atıştırma', quantity: 45, expiryDate: now.add(const Duration(days: 150)), arrivalDate: now.subtract(const Duration(days: 25)), buyPrice: 2.00, salePrice: 3.99),
      Product(id: '23', name: 'Fındık', category: 'Atıştırma', quantity: 30, expiryDate: now.add(const Duration(days: 180)), arrivalDate: now.subtract(const Duration(days: 40)), buyPrice: 8.00, salePrice: 13.99),
      Product(id: '24', name: 'Çiçek Işığı', category: 'Atıştırma', quantity: 35, expiryDate: now.add(const Duration(days: 120)), arrivalDate: now.subtract(const Duration(days: 30)), buyPrice: 3.50, salePrice: 5.99),
      Product(id: '25', name: 'Kuru Meyveler', category: 'Atıştırma', quantity: 28, expiryDate: now.add(const Duration(days: 200)), arrivalDate: now.subtract(const Duration(days: 35)), buyPrice: 12.00, salePrice: 19.99),
      Product(id: '26', name: 'Sabun', category: 'Kişisel', quantity: 40, expiryDate: now.add(const Duration(days: 365)), arrivalDate: now.subtract(const Duration(days: 20)), buyPrice: 2.50, salePrice: 4.99),
      Product(id: '27', name: 'Diş Macunu', category: 'Kişisel', quantity: 25, expiryDate: now.add(const Duration(days: 365)), arrivalDate: now.subtract(const Duration(days: 15)), buyPrice: 3.00, salePrice: 5.99),
      Product(id: '28', name: 'Şampuan', category: 'Kişisel', quantity: 18, expiryDate: now.add(const Duration(days: 365)), arrivalDate: now.subtract(const Duration(days: 10)), buyPrice: 6.00, salePrice: 10.99),
      Product(id: '29', name: 'Deodorant', category: 'Kişisel', quantity: 22, expiryDate: now.add(const Duration(days: 365)), arrivalDate: now.subtract(const Duration(days: 25)), buyPrice: 5.50, salePrice: 9.99),
      Product(id: '30', name: 'Mendil', category: 'Kişisel', quantity: 50, expiryDate: now.add(const Duration(days: 365)), arrivalDate: now.subtract(const Duration(days: 5)), buyPrice: 2.00, salePrice: 3.99),
      Product(id: '31', name: 'Kahve', category: 'Yiyecek', quantity: 15, expiryDate: now.add(const Duration(days: 365)), arrivalDate: now.subtract(const Duration(days: 40)), buyPrice: 12.00, salePrice: 19.99),
      Product(id: '32', name: 'Çay', category: 'Yiyecek', quantity: 25, expiryDate: now.add(const Duration(days: 730)), arrivalDate: now.subtract(const Duration(days: 60)), buyPrice: 5.00, salePrice: 8.99),
      Product(id: '33', name: 'Portakal Suyu', category: 'Yiyecek', quantity: 20, expiryDate: now.add(const Duration(days: 30)), arrivalDate: now.subtract(const Duration(days: 5)), buyPrice: 6.00, salePrice: 10.99),
      Product(id: '34', name: 'Meyve Yoğurdu', category: 'Yiyecek', quantity: 30, expiryDate: now.add(const Duration(days: 5)), arrivalDate: now.subtract(const Duration(days: 1)), buyPrice: 1.50, salePrice: 2.99),
      Product(id: '35', name: 'Zeytinyağı', category: 'Yiyecek', quantity: 10, expiryDate: now.add(const Duration(days: 365)), arrivalDate: now.subtract(const Duration(days: 50)), buyPrice: 25.00, salePrice: 39.99),
      Product(id: '36', name: 'Süresi Geçmiş TEST', category: 'Yiyecek', quantity: 2, expiryDate: now.subtract(const Duration(days: 5)), arrivalDate: now.subtract(const Duration(days: 30)), buyPrice: 5.00, salePrice: 8.99),
      Product(id: '37', name: 'Kritik SKT TEST', category: 'Yiyecek', quantity: 3, expiryDate: now.add(const Duration(days: 2)), arrivalDate: now.subtract(const Duration(days: 20)), buyPrice: 3.00, salePrice: 5.99),
    ];
  }
}
