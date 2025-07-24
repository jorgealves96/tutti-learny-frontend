import 'package:flutter/material.dart';

// TODO: In the future, you'll get offerings from RevenueCat here.
// For now, we'll use a local model for the UI.
class SubscriptionTier {
  final String title;
  final String monthlyPrice;
  final String? yearlyPrice;
  final List<String> features;
  final bool isRecommended;

  SubscriptionTier({
    required this.title,
    required this.monthlyPrice,
    this.yearlyPrice,
    required this.features,
    this.isRecommended = false,
  });
}

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  // Mock data for the tiers
  final List<SubscriptionTier> _tiers = [
    SubscriptionTier(
      title: 'Pro',
      monthlyPrice: '5.99€/month',
      yearlyPrice: '50€/year',
      features: ['25 Learning Path Generations/month', '25 Learning Path Extensions/month'],
      isRecommended: true,
    ),
    SubscriptionTier(
      title: 'Unlimited',
      monthlyPrice: '10.99€/month',
      yearlyPrice: '100€/year',
      features: ['Unlimited Learning Path Generations', 'Unlimited Learning Path Extensions'],
    ),
  ];

  int _selectedTierIndex = 0;
  bool _isYearly = false;

  void _purchase() {
    // TODO: Implement purchase logic with RevenueCat
    final selectedTier = _tiers[_selectedTierIndex];
    final duration = _isYearly ? 'yearly' : 'monthly';
    print('Purchasing ${selectedTier.title} - $duration');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Starting purchase for ${selectedTier.title} ($duration)',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the height of the bottom system navigation bar (the safe area)
    final bottomSafeArea = MediaQuery.of(context).viewPadding.bottom;

    return Padding(
      // Add the system padding to your existing padding to push content up
      padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0 + bottomSafeArea),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Upgrade Your Learning',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Monthly'),
              Switch(
                value: _isYearly,
                onChanged: (value) {
                  setState(() {
                    _isYearly = value;
                  });
                },
                activeColor: Theme.of(context).colorScheme.secondary,
              ),
              const Text('Yearly (Save ~30%)'),
            ],
          ),
          const SizedBox(height: 16),
          ..._tiers.asMap().entries.map((entry) {
            int index = entry.key;
            SubscriptionTier tier = entry.value;
            bool isSelected = _selectedTierIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTierIndex = index;
                });
              },
              child: Card(
                elevation: isSelected ? 8 : 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tier.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isYearly ? tier.yearlyPrice! : tier.monthlyPrice,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      for (String feature in tier.features)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(feature),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _purchase,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Upgrade Now', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
