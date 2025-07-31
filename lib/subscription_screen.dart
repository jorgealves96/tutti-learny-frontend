import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'services/api_service.dart';
import 'models/subscription_status_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import 'utils/snackbar_helper.dart';

// Model for displaying tier data in the UI
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
  final SubscriptionStatus? currentStatus;
  const SubscriptionScreen({super.key, this.currentStatus});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedTierIndex = 0;
  bool _isYearly = false;
  bool _isPurchasing = false;

  Future<void> _purchase(
    SubscriptionTier selectedTier,
    AppLocalizations l10n,
  ) async {
    setState(() {
      _isPurchasing = true;
    });

    // 1. Determine the integer tier ID to send to the backend
    int tierId;
    if (selectedTier.title == l10n.subscriptionScreen_tierPro_title) {
      tierId = 1; // Pro
    } else if (selectedTier.title ==
        l10n.subscriptionScreen_tierUnlimited_title) {
      tierId = 2; // Unlimited
    } else {
      // Fallback for an unknown tier
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unknown subscription tier selected.')),
        );
      }
      setState(() => _isPurchasing = false);
      return;
    }

    // 2. Call your backend API
    try {
      await ApiService().updateSubscription(tierId, _isYearly);
      if (mounted) {
      showSuccessSnackBar(context, l10n.subscriptionScreen_upgradeSuccess);
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst("Exception: ", ""))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPurchasing = false;
        });
      }
    }
  }

  Future<void> _manageSubscription() async {
    final String url;
    if (Platform.isIOS) {
      url = 'https://apps.apple.com/account/subscriptions';
    } else if (Platform.isAndroid) {
      url = 'https://play.google.com/store/account/subscriptions';
    } else {
      return; // Platform not supported
    }

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open subscription page.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // --- Define all possible tiers using translations ---
    final List<SubscriptionTier> allTiers = [
      SubscriptionTier(
        title: l10n.subscriptionScreen_tierPro_title,
        monthlyPrice: l10n.subscriptionScreen_tierPro_priceMonthly('5.99\$'),
        yearlyPrice: l10n.subscriptionScreen_tierPro_priceYearly('49.99\$'),
        features: [
          l10n.subscriptionScreen_tierPro_feature1(15),
          l10n.subscriptionScreen_tierPro_feature2(15),
        ],
        isRecommended: true,
      ),
      SubscriptionTier(
        title: l10n.subscriptionScreen_tierUnlimited_title,
        monthlyPrice: l10n.subscriptionScreen_tierUnlimited_priceMonthly(
          '10.99\$',
        ),
        yearlyPrice: l10n.subscriptionScreen_tierUnlimited_priceYearly(
          '99.99\$',
        ),
        features: [
          l10n.subscriptionScreen_tierUnlimited_feature1,
          l10n.subscriptionScreen_tierUnlimited_feature2,
        ],
      ),
    ];

    // --- Filter the list of tiers to show only relevant upgrades ---
    final List<SubscriptionTier> visibleTiers;
    final currentUserTier = widget.currentStatus?.tier;

    if (currentUserTier == l10n.subscriptionScreen_tierPro_title) {
      visibleTiers = allTiers
          .where((t) => t.title == l10n.subscriptionScreen_tierUnlimited_title)
          .toList();
    } else if (currentUserTier == l10n.subscriptionScreen_tierUnlimited_title) {
      visibleTiers = allTiers
          .where((t) => t.title == l10n.subscriptionScreen_tierUnlimited_title)
          .toList();
    } else {
      visibleTiers = allTiers;
    }

    // Ensure the selected index is valid for the visible tiers
    if (_selectedTierIndex >= visibleTiers.length) {
      _selectedTierIndex = 0;
    }

    final bottomSafeArea = MediaQuery.of(context).viewPadding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0 + bottomSafeArea),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.subscriptionScreen_title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
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
          ...visibleTiers.asMap().entries.map((entry) {
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
              onPressed: _isPurchasing
                  ? null
                  : () {
                      final selectedTier = visibleTiers[_selectedTierIndex];
                      if (selectedTier.title == currentUserTier) {
                        _manageSubscription();
                      } else {
                        _purchase(selectedTier, l10n);
                      }
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
              ),
              child: _isPurchasing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      (visibleTiers.isNotEmpty &&
                              visibleTiers[_selectedTierIndex].title ==
                                  currentUserTier)
                          ? l10n.profileScreen_manageSubscription
                          : l10n.subscriptionScreen_upgradeNow,
                      style: const TextStyle(fontSize: 18),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
