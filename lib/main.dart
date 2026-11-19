import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ISP Kormi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class Job {
  final String title, company, category, location, phone;
  const Job(this.title, this.company, this.category, this.location, this.phone);
}

const jobs = [
  Job('Fiber Technician', 'Rahim Net', 'Technician', 'Mirpur, Dhaka', '8801700000000'),
  Job('Lineman', 'Star Broadband', 'Lineman', 'Uttara, Dhaka', '8801800000000'),
  Job('Support Executive', 'Link3 Partner', 'Support', 'Chattogram', '8801900000000'),
  Job('Billing Officer', 'Speed Net', 'Billing', 'Sylhet', '8801600000000'),
];

const categories = ['All', 'Technician', 'Lineman', 'Support', 'Billing'];

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selected = 'All';

  Future<void> open(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final list =
        selected == 'All' ? jobs : jobs.where((j) => j.category == selected).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('ISP Kormi'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(24),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text('Net er kaaj, kachhei khuje nin'),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              children: categories
                  .map((c) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(c),
                          selected: selected == c,
                          onSelected: (_) => setState(() => selected = c),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                final j = list[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(j.title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(j.company),
                        Text('📍 ${j.location}'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => open('tel:+${j.phone}'),
                              icon: const Icon(Icons.call),
                              label: const Text('Call'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () => open('https://wa.me/${j.phone}'),
                              icon: const Icon(Icons.chat),
                              label: const Text('WhatsApp'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
