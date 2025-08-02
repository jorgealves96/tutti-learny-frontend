import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

import 'l10n/app_localizations.dart';
import 'models/subscription_status_model.dart';
import 'services/api_service.dart';
import 'utils/snackbar_helper.dart';

class SubscriptionScreen extends StatefulWidget {
  final SubscriptionStatus? currentStatus;
  const SubscriptionScreen({super.key, this.currentStatus});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  late Future<Offering?> _offeringsFuture;
  bool _isYearly = false;
  bool _isPurchasing = false;
  Package? _selectedPackage;

  @override
  void initState() {
    super.initState();
    _offeringsFuture = _fetchOfferings();
  }

  Future<Offering?> _fetchOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current != null &&
          offerings.current!.availablePackages.isNotEmpty) {
        return offerings.current;
      } else {
        return null;
      }
    } on PlatformException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching plans: ${e.message}")),
        );
      }
      return null;
    }
  }

  Future<void> _purchase(Package package) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isPurchasing = true);
    print(
      "--- Attempting to purchase package: ${package.storeProduct.identifier} ---",
    );
    try {
      final purchaseResult = await Purchases.purchaseStoreProduct(
        package.storeProduct,
      );

      final isPro =
          purchaseResult.customerInfo.entitlements.active['pro']?.isActive ??
          false;
      final isUnlimited =
          purchaseResult
              .customerInfo
              .entitlements
              .active['unlimited']
              ?.isActive ??
          false;

      print(
        "--- Purchase successful. Pro: $isPro, Unlimited: $isUnlimited ---",
      );

      if (isPro || isUnlimited) {
        // --- 3. If successful, now call YOUR backend to update the user's tier ---
        int tierId = isUnlimited ? 2 : 1; // 2 for Unlimited, 1 for Pro
        bool isYearly = package.packageType == PackageType.annual;
        await ApiService().updateSubscription(tierId, isYearly);

        // 4. Show the success message and pop the screen to trigger a refresh
        if (mounted) {
          showSuccessSnackBar(context, l10n.subscriptionScreen_upgradeSuccess);
          await Future.delayed(
            const Duration(milliseconds: 500),
          ); // Give snackbar time to show
          Navigator.of(context).pop(true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.subscriptionScreen_purchaseVerificationError),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } on PlatformException catch (e) {
      print("--- ERROR during purchase: ${e.message} ---");
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        if (mounted)
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
      } else {
        if (mounted)
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Purchase cancelled.')));
      }
    } finally {
      if (mounted) setState(() => _isPurchasing = false);
    }
  }

  Future<void> _manageSubscription() async {
    final String url;
    if (Platform.isIOS) {
      url = 'https://apps.apple.com/account/subscriptions';
    } else if (Platform.isAndroid) {
      url = 'https://play.google.com/store/account/subscriptions';
    } else {
      return;
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
    final l10n = AppLocalizations.of(context)!;
    final bottomSafeArea = MediaQuery.of(context).viewPadding.bottom;

    return FutureBuilder<Offering?>(
      future: _offeringsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: Text(l10n.subscriptionScreen_noPlansAvailable),
            ),
          );
        }

        final offering = snapshot.data!;

        var visiblePackages = offering.availablePackages
            .where(
              (pkg) => _isYearly
                  ? pkg.storeProduct.identifier.contains('yearly')
                  : pkg.storeProduct.identifier.contains('monthly'),
            )
            .toList();

        final currentUserTier =
            widget.currentStatus?.tier.toLowerCase() ?? 'free';
            
        if (currentUserTier == 'pro') {
          visiblePackages = visiblePackages
              .where((p) => p.storeProduct.identifier.contains('unlimited'))
              .toList();
        } else if (currentUserTier == 'unlimited') {
          visiblePackages = visiblePackages
              .where((p) => p.storeProduct.identifier.contains('unlimited'))
              .toList();
        }

        visiblePackages.sort(
          (a, b) => a.storeProduct.price.compareTo(b.storeProduct.price),
        );

        if (_selectedPackage == null ||
            !visiblePackages.contains(_selectedPackage)) {
          _selectedPackage = visiblePackages.isNotEmpty
              ? visiblePackages.first
              : null;
        }

        return Padding(
          padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0 + bottomSafeArea),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.subscriptionScreen_title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
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
                        // When the toggle changes, reset the selected package
                        _selectedPackage = null;
                      });
                    },
                    activeColor: Theme.of(context).colorScheme.secondary,
                  ),
                  Text(l10n.subscriptionScreen_yearly),
                ],
              ),
              const SizedBox(height: 16),

              if (visiblePackages.isEmpty && currentUserTier != 'free')
                const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    "You are on the highest tier!",
                    textAlign: TextAlign.center,
                  ),
                )
              else
                ...visiblePackages.map((package) {
                  final isSelected = _selectedPackage == package;
                  final List<String> features;
                  if (package.storeProduct.identifier.contains('pro')) {
                    features = [
                      l10n.subscriptionScreen_tierPro_feature1(15),
                      l10n.subscriptionScreen_tierPro_feature2(15),
                    ];
                  } else if (package.storeProduct.identifier.contains(
                    'unlimited',
                  )) {
                    features = [
                      l10n.subscriptionScreen_tierUnlimited_feature1,
                      l10n.subscriptionScreen_tierUnlimited_feature2,
                    ];
                  } else {
                    features = [];
                  }
                  return GestureDetector(
                    onTap: () => setState(() => _selectedPackage = package),
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
                              package.storeProduct.title
                                  .replaceFirst("(Tutti Learni)", "")
                                  .trim(),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              package.storeProduct.priceString,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            for (String feature in features)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(feature)),
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
              if (visiblePackages.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_isPurchasing || _selectedPackage == null)
                        ? null
                        : () {
                            if (_selectedPackage!.storeProduct.identifier
                                .contains(currentUserTier)) {
                              _manageSubscription();
                            } else {
                              _purchase(_selectedPackage!);
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
                            (_selectedPackage != null &&
                                    _selectedPackage!.storeProduct.identifier
                                        .contains(currentUserTier))
                                ? l10n.profileScreen_manageSubscription
                                : l10n.subscriptionScreen_upgradeNow,
                            style: const TextStyle(fontSize: 18),
                          ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
