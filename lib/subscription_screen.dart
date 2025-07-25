import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

// Note: This local model is now just for structuring the data.
// The actual text comes from the l10n object.
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
  int _selectedTierIndex = 0;
  bool _isYearly = false;

  void _purchase(SubscriptionTier selectedTier, AppLocalizations l10n) {
    // TODO: Implement purchase logic with RevenueCat
    final duration = _isYearly ? 'yearly' : 'monthly';
    print('Purchasing ${selectedTier.title} - $duration');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.subscriptionScreen_startingPurchase(selectedTier.title, duration),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      // Return a loading state if localizations are not yet available
      return const Center(child: CircularProgressIndicator());
    }

    // Build the list of tiers dynamically using the translated strings
    final List<SubscriptionTier> tiers = [
      SubscriptionTier(
        title: l10n.subscriptionScreen_tierPro_title,
        monthlyPrice: l10n.subscriptionScreen_tierPro_priceMonthly('5.99€'),
        yearlyPrice: l10n.subscriptionScreen_tierPro_priceYearly('50€'),
        features: [
          l10n.subscriptionScreen_tierPro_feature1(25),
          l10n.subscriptionScreen_tierPro_feature2(25),
        ],
        isRecommended: true,
      ),
      SubscriptionTier(
        title: l10n.subscriptionScreen_tierUnlimited_title,
        monthlyPrice: l10n.subscriptionScreen_tierUnlimited_priceMonthly('10.99€'),
        yearlyPrice: l10n.subscriptionScreen_tierUnlimited_priceYearly('100€'),
        features: [
          l10n.subscriptionScreen_tierUnlimited_feature1,
          l10n.subscriptionScreen_tierUnlimited_feature2,
        ],
      ),
    ];

    final bottomSafeArea = MediaQuery.of(context).viewPadding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0 + bottomSafeArea),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.subscriptionScreen_title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.subscriptionScreen_monthly),
              Switch(
                value: _isYearly,
                onChanged: (value) {
                  setState(() {
                    _isYearly = value;
                  });
                },
                activeColor: Theme.of(context).colorScheme.secondary,
              ),
              Text(l10n.subscriptionScreen_yearly),
            ],
          ),
          const SizedBox(height: 16),
          ...tiers.asMap().entries.map((entry) {
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
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
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
              onPressed: () => _purchase(tiers[_selectedTierIndex], l10n),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
              ),
              child: Text(
                l10n.subscriptionScreen_upgradeNow,
                style: const TextStyle(fontSize: 18)
              ),
            ),
          ),
        ],
      ),
    );
  }
}