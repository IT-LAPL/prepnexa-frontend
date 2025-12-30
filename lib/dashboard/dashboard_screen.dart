import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback? onLogout;
  const DashboardScreen({super.key, this.onLogout});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService.instance;
    final name = auth.name ?? 'Student';
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PrepNexa'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: onLogout,
          ),
        ],
      ),

      // ✅ Scroll-safe layout
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 👋 Welcome Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(
                        Icons.school,
                        size: 28,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back 👋',
                            style: theme.textTheme.labelLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            name,
                            style: theme.textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// 📌 Section Title
            Text(
              'Your Tools',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            /// 🧩 Dashboard Grid (NO OVERFLOW)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final item = _items[index];
                return _DashboardCard(item: item);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// 🧠 Dashboard Items Model
class _DashboardItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;

  const _DashboardItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });
}

/// 📦 Dashboard Data
const List<_DashboardItem> _items = [
  _DashboardItem(
    icon: Icons.upload_file,
    title: 'Upload PYQs',
    subtitle: 'Add previous papers',
    route: '/upload-pyqs',
  ),
  _DashboardItem(
    icon: Icons.bar_chart,
    title: 'Analyze Papers',
    subtitle: 'Topic & trend insights',
    route: '/analyze',
  ),
  _DashboardItem(
    icon: Icons.smart_toy,
    title: 'Predict Paper',
    subtitle: 'AI-based prediction',
    route: '/predict',
  ),
  _DashboardItem(
    icon: Icons.book,
    title: 'My Subjects',
    subtitle: 'Manage syllabus',
    route: '/subjects',
  ),
];

/// 🎨 Dashboard Card Widget
class _DashboardCard extends StatelessWidget {
  final _DashboardItem item;
  const _DashboardCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      elevation: 1,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).pushNamed(item.route);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                item.icon,
                size: 36,
                color: theme.colorScheme.primary,
              ),
              const Spacer(),
              Text(
                item.title,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                item.subtitle,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
