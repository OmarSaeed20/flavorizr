# Phase 3 — Monetization

> **Duration:** 2-3 weeks  
> **Priority:** Medium-High  
> **Dependencies:** Phase 2 (Real-time & Engagement)

---

## 📋 Overview

Phase 3 introduces monetization capabilities through in-app purchases and subscriptions. This phase also includes basic admin features for content moderation.

**Key Deliverables:**
- Subscription plans with RevenueCat
- In-app purchases for virtual goods
- Paywall system with feature gating
- Basic admin dashboard
- Content moderation tools

---

## 🎯 Goals

| Goal | Success Criteria |
|------|------------------|
| Subscriptions | Users can subscribe to premium plans |
| Purchases | In-app purchases work on iOS and Android |
| Feature Gating | Premium features properly locked for free users |
| Admin Panel | Moderators can manage content |
| Analytics | Purchase events tracked |

---

## 📁 Tasks Breakdown

### Task 3.1: RevenueCat Integration

**Estimated Time:** 2-3 days

#### Objectives
- Set up RevenueCat SDK
- Configure products and entitlements
- Implement purchase flow
- Handle subscription status

#### Implementation Steps

1. **Create `lib/features/subscription/domain/entities/subscription.dart`**
   ```dart
   import 'package:freezed_annotation/freezed_annotation.dart';
   
   part 'subscription.freezed.dart';
   
   /// Subscription tiers available in the app.
   enum SubscriptionTier {
     /// Free tier with basic features.
     free,
     
     /// Basic paid tier.
     basic,
     
     /// Premium tier with all features.
     premium,
     
     /// Enterprise tier for businesses.
     enterprise,
   }
   
   /// Subscription billing period.
   enum BillingPeriod {
     /// Weekly billing.
     weekly,
     
     /// Monthly billing.
     monthly,
     
     /// Yearly billing.
     yearly,
     
     /// Lifetime purchase.
     lifetime,
   }
   
   /// Represents a subscription product.
   @freezed
   class SubscriptionProduct with _$SubscriptionProduct {
     const SubscriptionProduct._();
     
     const factory SubscriptionProduct({
       /// Product identifier.
       required String id,
       
       /// Product title.
       required String title,
       
       /// Product description.
       required String description,
       
       /// Subscription tier this product grants.
       required SubscriptionTier tier,
       
       /// Billing period.
       required BillingPeriod billingPeriod,
       
       /// Localized price string (e.g., "$9.99").
       required String priceString,
       
       /// Price in cents for calculations.
       required int priceInCents,
       
       /// Currency code (e.g., "USD").
       required String currencyCode,
       
       /// Whether this is the default/recommended option.
       @Default(false) bool isDefault,
       
       /// Free trial duration in days (0 if no trial).
       @Default(0) int freeTrialDays,
       
       /// Features included in this product.
       @Default([]) List<String> features,
       
       /// Savings percentage compared to monthly (for yearly plans).
       int? savingsPercentage,
     }) = _SubscriptionProduct;
     
     /// Returns the price per month for comparison.
     double get monthlyEquivalent {
       switch (billingPeriod) {
         case BillingPeriod.weekly:
           return (priceInCents * 4.33) / 100;
         case BillingPeriod.monthly:
           return priceInCents / 100;
         case BillingPeriod.yearly:
           return priceInCents / 12 / 100;
         case BillingPeriod.lifetime:
           return 0;
       }
     }
     
     /// Returns the billing period display text.
     String get periodText {
       switch (billingPeriod) {
         case BillingPeriod.weekly:
           return 'week';
         case BillingPeriod.monthly:
           return 'month';
         case BillingPeriod.yearly:
           return 'year';
         case BillingPeriod.lifetime:
           return 'one-time';
       }
     }
   }
   
   /// Current subscription status.
   @freezed
   class SubscriptionStatus with _$SubscriptionStatus {
     const SubscriptionStatus._();
     
     const factory SubscriptionStatus({
       /// Current subscription tier.
       required SubscriptionTier tier,
       
       /// Whether the subscription is active.
       required bool isActive,
       
       /// Product ID of the active subscription.
       String? productId,
       
       /// When the subscription expires.
       DateTime? expirationDate,
       
       /// Whether the subscription will auto-renew.
       @Default(true) bool willRenew,
       
       /// Whether the subscription is in a billing retry period.
       @Default(false) bool isBillingRetry,
       
       /// Whether this is a free trial.
       @Default(false) bool isFreeTrial,
       
       /// When the subscription was originally purchased.
       DateTime? purchaseDate,
       
       /// Platform where the subscription was purchased.
       String? platform,
       
       /// Entitlements granted by this subscription.
       @Default([]) List<String> entitlements,
     }) = _SubscriptionStatus;
     
     /// Returns true if the user has an active paid subscription.
     bool get isPaid => isActive && tier != SubscriptionTier.free;
     
     /// Returns true if the user has premium features.
     bool get hasPremium =>
         isActive && (tier == SubscriptionTier.premium || tier == SubscriptionTier.enterprise);
     
     /// Returns the days remaining until expiration.
     int? get daysRemaining {
       if (expirationDate == null) return null;
       return expirationDate!.difference(DateTime.now()).inDays;
     }
     
     /// Default free subscription status.
     static const free = SubscriptionStatus(
       tier: SubscriptionTier.free,
       isActive: true,
     );
   }
   ```

2. **Create `lib/core/services/subscription_service.dart`**
   ```dart
   import 'dart:async';
   
   import 'package:purchases_flutter/purchases_flutter.dart';
   
   import '../../config/app_config.dart';
   import '../../features/subscription/domain/entities/subscription.dart';
   import '../logger/app_logger.dart';
   
   /// Service for managing subscriptions with RevenueCat.
   /// 
   /// Handles:
   /// - Product fetching
   /// - Purchase flow
   /// - Subscription status
   /// - Restore purchases
   class SubscriptionService {
     static SubscriptionService? _instance;
     
     final _statusController = StreamController<SubscriptionStatus>.broadcast();
     
     SubscriptionStatus _currentStatus = SubscriptionStatus.free;
     List<SubscriptionProduct> _products = [];
     
     SubscriptionService._();
     
     /// Gets the singleton instance.
     static SubscriptionService get instance {
       _instance ??= SubscriptionService._();
       return _instance!;
     }
     
     /// Current subscription status.
     SubscriptionStatus get status => _currentStatus;
     
     /// Stream of subscription status changes.
     Stream<SubscriptionStatus> get statusChanges => _statusController.stream;
     
     /// Available subscription products.
     List<SubscriptionProduct> get products => _products;
     
     /// Initializes the subscription service.
     /// 
     /// [userId] - Optional user ID for attribution.
     Future<void> initialize({String? userId}) async {
       try {
         // Configure RevenueCat
         final configuration = PurchasesConfiguration(
           _getApiKey(),
         );
         
         if (userId != null) {
           configuration.appUserID = userId;
         }
         
         await Purchases.configure(configuration);
         
         // Enable debug logs in non-production
         if (!AppConfig.instance.isProd) {
           await Purchases.setLogLevel(LogLevel.debug);
         }
         
         // Listen for customer info updates
         Purchases.addCustomerInfoUpdateListener(_handleCustomerInfoUpdate);
         
         // Fetch initial status
         await refreshStatus();
         
         // Fetch products
         await fetchProducts();
         
         AppLogger.info('Subscription service initialized');
       } catch (e, s) {
         AppLogger.error('Failed to initialize subscription service', error: e, stackTrace: s);
       }
     }
     
     String _getApiKey() {
       // Return platform-specific RevenueCat API key
       // TODO: Get from environment configuration
       return 'your_revenuecat_api_key';
     }
     
     void _handleCustomerInfoUpdate(CustomerInfo customerInfo) {
       _updateStatusFromCustomerInfo(customerInfo);
     }
     
     void _updateStatusFromCustomerInfo(CustomerInfo info) {
       final entitlements = info.entitlements.active;
       
       if (entitlements.isEmpty) {
         _currentStatus = SubscriptionStatus.free;
       } else {
         // Find the highest tier entitlement
         final premiumEntitlement = entitlements['premium'] ?? entitlements['basic'];
         
         if (premiumEntitlement != null) {
           _currentStatus = SubscriptionStatus(
             tier: _tierFromEntitlement(premiumEntitlement.identifier),
             isActive: premiumEntitlement.isActive,
             productId: premiumEntitlement.productIdentifier,
             expirationDate: premiumEntitlement.expirationDate,
             willRenew: premiumEntitlement.willRenew,
             isBillingRetry: premiumEntitlement.billingIssueDetectedAt != null,
             isFreeTrial: premiumEntitlement.periodType == PeriodType.trial,
             purchaseDate: premiumEntitlement.originalPurchaseDate,
             platform: info.originalAppUserId,
             entitlements: entitlements.keys.toList(),
           );
         } else {
           _currentStatus = SubscriptionStatus.free;
         }
       }
       
       _statusController.add(_currentStatus);
       AppLogger.info('Subscription status updated: ${_currentStatus.tier}');
     }
     
     SubscriptionTier _tierFromEntitlement(String entitlementId) {
       switch (entitlementId.toLowerCase()) {
         case 'premium':
           return SubscriptionTier.premium;
         case 'basic':
           return SubscriptionTier.basic;
         case 'enterprise':
           return SubscriptionTier.enterprise;
         default:
           return SubscriptionTier.free;
       }
     }
     
     /// Refreshes the current subscription status.
     Future<SubscriptionStatus> refreshStatus() async {
       try {
         final customerInfo = await Purchases.getCustomerInfo();
         _updateStatusFromCustomerInfo(customerInfo);
         return _currentStatus;
       } catch (e, s) {
         AppLogger.error('Failed to refresh subscription status', error: e, stackTrace: s);
         return _currentStatus;
       }
     }
     
     /// Fetches available subscription products.
     Future<List<SubscriptionProduct>> fetchProducts() async {
       try {
         final offerings = await Purchases.getOfferings();
         final current = offerings.current;
         
         if (current == null) {
           AppLogger.warning('No current offering available');
           return [];
         }
         
         _products = current.availablePackages.map((package) {
           return SubscriptionProduct(
             id: package.storeProduct.identifier,
             title: package.storeProduct.title,
             description: package.storeProduct.description,
             tier: _tierFromProductId(package.storeProduct.identifier),
             billingPeriod: _periodFromPackageType(package.packageType),
             priceString: package.storeProduct.priceString,
             priceInCents: (package.storeProduct.price * 100).round(),
             currencyCode: package.storeProduct.currencyCode,
             isDefault: package.packageType == PackageType.annual,
             freeTrialDays: package.storeProduct.introductoryPrice?.cycles ?? 0,
             features: _featuresForTier(_tierFromProductId(package.storeProduct.identifier)),
           );
         }).toList();
         
         // Sort by tier and period
         _products.sort((a, b) {
           final tierCompare = a.tier.index.compareTo(b.tier.index);
           if (tierCompare != 0) return tierCompare;
           return a.billingPeriod.index.compareTo(b.billingPeriod.index);
         });
         
         AppLogger.info('Fetched ${_products.length} subscription products');
         return _products;
       } catch (e, s) {
         AppLogger.error('Failed to fetch products', error: e, stackTrace: s);
         return [];
       }
     }
     
     SubscriptionTier _tierFromProductId(String productId) {
       if (productId.contains('premium')) return SubscriptionTier.premium;
       if (productId.contains('basic')) return SubscriptionTier.basic;
       if (productId.contains('enterprise')) return SubscriptionTier.enterprise;
       return SubscriptionTier.free;
     }
     
     BillingPeriod _periodFromPackageType(PackageType type) {
       switch (type) {
         case PackageType.weekly:
           return BillingPeriod.weekly;
         case PackageType.monthly:
           return BillingPeriod.monthly;
         case PackageType.annual:
         case PackageType.sixMonth:
         case PackageType.threeMonth:
         case PackageType.twoMonth:
           return BillingPeriod.yearly;
         case PackageType.lifetime:
           return BillingPeriod.lifetime;
         default:
           return BillingPeriod.monthly;
       }
     }
     
     List<String> _featuresForTier(SubscriptionTier tier) {
       switch (tier) {
         case SubscriptionTier.free:
           return [
             'Basic features',
             'Limited storage',
             'Ads supported',
           ];
         case SubscriptionTier.basic:
           return [
             'All free features',
             'No ads',
             'Extended storage',
             'Email support',
           ];
         case SubscriptionTier.premium:
           return [
             'All basic features',
             'Unlimited storage',
             'Priority support',
             'Advanced analytics',
             'Custom themes',
             'Offline mode',
           ];
         case SubscriptionTier.enterprise:
           return [
             'All premium features',
             'Dedicated support',
             'Custom integrations',
             'Team management',
             'API access',
           ];
       }
     }
     
     /// Purchases a subscription product.
     /// 
     /// Returns the updated subscription status on success.
     /// Throws on failure.
     Future<SubscriptionStatus> purchase(String productId) async {
       try {
         final products = await Purchases.getProducts([productId]);
         
         if (products.isEmpty) {
           throw Exception('Product not found: $productId');
         }
         
         final customerInfo = await Purchases.purchaseStoreProduct(products.first);
         _updateStatusFromCustomerInfo(customerInfo);
         
         AppLogger.info('Purchase completed: $productId');
         return _currentStatus;
       } on PurchasesErrorCode catch (e) {
         if (e == PurchasesErrorCode.purchaseCancelledError) {
           AppLogger.info('Purchase cancelled by user');
           throw PurchaseCancelledException();
         }
         rethrow;
       } catch (e, s) {
         AppLogger.error('Purchase failed', error: e, stackTrace: s);
         rethrow;
       }
     }
     
     /// Restores previous purchases.
     Future<SubscriptionStatus> restorePurchases() async {
       try {
         final customerInfo = await Purchases.restorePurchases();
         _updateStatusFromCustomerInfo(customerInfo);
         
         AppLogger.info('Purchases restored');
         return _currentStatus;
       } catch (e, s) {
         AppLogger.error('Restore purchases failed', error: e, stackTrace: s);
         rethrow;
       }
     }
     
     /// Updates the user ID for attribution.
     Future<void> setUserId(String userId) async {
       try {
         await Purchases.logIn(userId);
         await refreshStatus();
       } catch (e, s) {
         AppLogger.error('Failed to set user ID', error: e, stackTrace: s);
       }
     }
     
     /// Logs out the current user.
     Future<void> logout() async {
       try {
         await Purchases.logOut();
         _currentStatus = SubscriptionStatus.free;
         _statusController.add(_currentStatus);
       } catch (e, s) {
         AppLogger.error('Failed to logout', error: e, stackTrace: s);
       }
     }
     
     /// Disposes resources.
     void dispose() {
       _statusController.close();
     }
   }
   
   /// Exception thrown when purchase is cancelled by user.
   class PurchaseCancelledException implements Exception {
     @override
     String toString() => 'Purchase was cancelled by the user';
   }
   ```

3. **Create `lib/features/subscription/presentation/widgets/paywall.dart`**
   ```dart
   import 'package:flutter/material.dart';
   import 'package:flutter_riverpod/flutter_riverpod.dart';
   
   import '../../../../core/services/subscription_service.dart';
   import '../../domain/entities/subscription.dart';
   
   /// Provider for subscription status.
   final subscriptionStatusProvider = StreamProvider<SubscriptionStatus>((ref) {
     return SubscriptionService.instance.statusChanges;
   });
   
   /// Provider for subscription products.
   final subscriptionProductsProvider = FutureProvider<List<SubscriptionProduct>>((ref) {
     return SubscriptionService.instance.fetchProducts();
   });
   
   /// A paywall widget that displays subscription options.
   /// 
   /// Shows:
   /// - Available subscription tiers
   /// - Feature comparison
   /// - Purchase buttons
   /// - Restore purchases option
   class Paywall extends ConsumerStatefulWidget {
     /// Title shown at the top of the paywall.
     final String title;
     
     /// Description text.
     final String description;
     
     /// Features to highlight (uses defaults if not provided).
     final List<String>? features;
     
     /// Callback when purchase completes successfully.
     final VoidCallback? onPurchaseComplete;
     
     /// Callback when user dismisses the paywall.
     final VoidCallback? onDismiss;
     
     const Paywall({
       super.key,
       this.title = 'Upgrade to Premium',
       this.description = 'Unlock all features and remove limits',
       this.features,
       this.onPurchaseComplete,
       this.onDismiss,
     });
   
     @override
     ConsumerState<Paywall> createState() => _PaywallState();
   }
   
   class _PaywallState extends ConsumerState<Paywall> {
     bool _isLoading = false;
     String? _selectedProductId;
     String? _errorMessage;
   
     @override
     Widget build(BuildContext context) {
       final theme = Theme.of(context);
       final products = ref.watch(subscriptionProductsProvider);
       
       return Scaffold(
         body: SafeArea(
           child: products.when(
             loading: () => const Center(child: CircularProgressIndicator()),
             error: (error, stack) => _buildError(error.toString()),
             data: (productList) => _buildPaywall(theme, productList),
           ),
         ),
       );
     }
   
     Widget _buildPaywall(ThemeData theme, List<SubscriptionProduct> products) {
       // Filter to show only unique tiers (prefer yearly)
       final uniqueProducts = <SubscriptionTier, SubscriptionProduct>{};
       for (final product in products) {
         if (!uniqueProducts.containsKey(product.tier) ||
             product.billingPeriod == BillingPeriod.yearly) {
           uniqueProducts[product.tier] = product;
         }
       }
       
       final displayProducts = uniqueProducts.values.toList()
         ..sort((a, b) => a.tier.index.compareTo(b.tier.index));
       
       return CustomScrollView(
         slivers: [
           SliverToBoxAdapter(
             child: Padding(
               padding: const EdgeInsets.all(24),
               child: Column(
                 children: [
                   // Close button
                   Align(
                     alignment: Alignment.topRight,
                     child: IconButton(
                       onPressed: widget.onDismiss ?? () => Navigator.pop(context),
                       icon: const Icon(Icons.close),
                     ),
                   ),
                   const SizedBox(height: 16),
                   
                   // Premium icon
                   Container(
                     padding: const EdgeInsets.all(20),
                     decoration: BoxDecoration(
                       color: theme.colorScheme.primaryContainer,
                       shape: BoxShape.circle,
                     ),
                     child: Icon(
                       Icons.workspace_premium,
                       size: 48,
                       color: theme.colorScheme.primary,
                     ),
                   ),
                   const SizedBox(height: 24),
                   
                   // Title
                   Text(
                     widget.title,
                     style: theme.textTheme.headlineMedium?.copyWith(
                       fontWeight: FontWeight.bold,
                     ),
                     textAlign: TextAlign.center,
                   ),
                   const SizedBox(height: 8),
                   
                   // Description
                   Text(
                     widget.description,
                     style: theme.textTheme.bodyLarge?.copyWith(
                       color: theme.colorScheme.onSurfaceVariant,
                     ),
                     textAlign: TextAlign.center,
                   ),
                   const SizedBox(height: 32),
                   
                   // Features list
                   ..._buildFeatures(theme),
                   const SizedBox(height: 32),
                   
                   // Error message
                   if (_errorMessage != null) ...[
                     Container(
                       padding: const EdgeInsets.all(12),
                       decoration: BoxDecoration(
                         color: theme.colorScheme.errorContainer,
                         borderRadius: BorderRadius.circular(8),
                       ),
                       child: Row(
                         children: [
                           Icon(
                             Icons.error_outline,
                             color: theme.colorScheme.onErrorContainer,
                           ),
                           const SizedBox(width: 12),
                           Expanded(
                             child: Text(
                               _errorMessage!,
                               style: TextStyle(
                                 color: theme.colorScheme.onErrorContainer,
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                     const SizedBox(height: 16),
                   ],
                 ],
               ),
             ),
           ),
           
           // Product cards
           SliverPadding(
             padding: const EdgeInsets.symmetric(horizontal: 24),
             sliver: SliverList(
               delegate: SliverChildBuilderDelegate(
                 (context, index) {
                   final product = displayProducts[index];
                   return Padding(
                     padding: const EdgeInsets.only(bottom: 12),
                     child: _ProductCard(
                       product: product,
                       isSelected: _selectedProductId == product.id,
                       isLoading: _isLoading,
                       onTap: () => _selectProduct(product.id),
                       onPurchase: () => _purchase(product.id),
                     ),
                   );
                 },
                 childCount: displayProducts.length,
               ),
             ),
           ),
           
           SliverToBoxAdapter(
             child: Padding(
               padding: const EdgeInsets.all(24),
               child: Column(
                 children: [
                   // Restore purchases
                   TextButton(
                     onPressed: _isLoading ? null : _restorePurchases,
                     child: const Text('Restore Purchases'),
                   ),
                   const SizedBox(height: 16),
                   
                   // Legal text
                   Text(
                     'Subscriptions automatically renew unless cancelled at least 24 hours before the end of the current period.',
                     style: theme.textTheme.bodySmall?.copyWith(
                       color: theme.colorScheme.onSurfaceVariant,
                     ),
                     textAlign: TextAlign.center,
                   ),
                   const SizedBox(height: 8),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       TextButton(
                         onPressed: () {
                           // Open terms of service
                         },
                         child: Text(
                           'Terms of Service',
                           style: theme.textTheme.bodySmall,
                         ),
                       ),
                       Text(
                         ' • ',
                         style: TextStyle(
                           color: theme.colorScheme.onSurfaceVariant,
                         ),
                       ),
                       TextButton(
                         onPressed: () {
                           // Open privacy policy
                         },
                         child: Text(
                           'Privacy Policy',
                           style: theme.textTheme.bodySmall,
                         ),
                       ),
                     ],
                   ),
                 ],
               ),
             ),
           ),
         ],
       );
     }
   
     List<Widget> _buildFeatures(ThemeData theme) {
       final features = widget.features ??
           [
             'Unlimited storage',
             'No advertisements',
             'Priority support',
             'Advanced analytics',
             'Custom themes',
             'Offline mode',
           ];
       
       return features.map((feature) {
         return Padding(
           padding: const EdgeInsets.symmetric(vertical: 4),
           child: Row(
             children: [
               Icon(
                 Icons.check_circle,
                 color: theme.colorScheme.primary,
                 size: 20,
               ),
               const SizedBox(width: 12),
               Text(
                 feature,
                 style: theme.textTheme.bodyMedium,
               ),
             ],
           ),
         );
       }).toList();
     }
   
     Widget _buildError(String error) {
       return Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             const Icon(Icons.error_outline, size: 48),
             const SizedBox(height: 16),
             Text('Failed to load products'),
             const SizedBox(height: 8),
             Text(error),
             const SizedBox(height: 16),
             ElevatedButton(
               onPressed: () => ref.refresh(subscriptionProductsProvider),
               child: const Text('Retry'),
             ),
           ],
         ),
       );
     }
   
     void _selectProduct(String productId) {
       setState(() {
         _selectedProductId = productId;
         _errorMessage = null;
       });
     }
   
     Future<void> _purchase(String productId) async {
       setState(() {
         _isLoading = true;
         _errorMessage = null;
       });
       
       try {
         await SubscriptionService.instance.purchase(productId);
         widget.onPurchaseComplete?.call();
         if (mounted) {
           Navigator.pop(context);
         }
       } on PurchaseCancelledException {
         // User cancelled, do nothing
       } catch (e) {
         setState(() {
           _errorMessage = 'Purchase failed. Please try again.';
         });
       } finally {
         if (mounted) {
           setState(() {
             _isLoading = false;
           });
         }
       }
     }
   
     Future<void> _restorePurchases() async {
       setState(() {
         _isLoading = true;
         _errorMessage = null;
       });
       
       try {
         final status = await SubscriptionService.instance.restorePurchases();
         
         if (status.isPaid) {
           widget.onPurchaseComplete?.call();
           if (mounted) {
             Navigator.pop(context);
           }
         } else {
           setState(() {
             _errorMessage = 'No previous purchases found.';
           });
         }
       } catch (e) {
         setState(() {
           _errorMessage = 'Failed to restore purchases. Please try again.';
         });
       } finally {
         if (mounted) {
           setState(() {
             _isLoading = false;
           });
         }
       }
     }
   }
   
   /// Card widget for displaying a subscription product.
   class _ProductCard extends StatelessWidget {
     final SubscriptionProduct product;
     final bool isSelected;
     final bool isLoading;
     final VoidCallback onTap;
     final VoidCallback onPurchase;
   
     const _ProductCard({
       required this.product,
       required this.isSelected,
       required this.isLoading,
       required this.onTap,
       required this.onPurchase,
     });
   
     @override
     Widget build(BuildContext context) {
       final theme = Theme.of(context);
       
       return Card(
         elevation: isSelected ? 4 : 1,
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(16),
           side: BorderSide(
             color: isSelected
                 ? theme.colorScheme.primary
                 : theme.colorScheme.outline.withOpacity(0.5),
             width: isSelected ? 2 : 1,
           ),
         ),
         child: InkWell(
           onTap: onTap,
           borderRadius: BorderRadius.circular(16),
           child: Padding(
             padding: const EdgeInsets.all(16),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   children: [
                     Expanded(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(
                             children: [
                               Text(
                                 product.title,
                                 style: theme.textTheme.titleMedium?.copyWith(
                                   fontWeight: FontWeight.bold,
                                 ),
                               ),
                               if (product.isDefault) ...[
                                 const SizedBox(width: 8),
                                 Container(
                                   padding: const EdgeInsets.symmetric(
                                     horizontal: 8,
                                     vertical: 2,
                                   ),
                                   decoration: BoxDecoration(
                                     color: theme.colorScheme.primary,
                                     borderRadius: BorderRadius.circular(12),
                                   ),
                                   child: Text(
                                     'BEST VALUE',
                                     style: theme.textTheme.labelSmall?.copyWith(
                                       color: theme.colorScheme.onPrimary,
                                       fontWeight: FontWeight.bold,
                                     ),
                                   ),
                                 ),
                               ],
                             ],
                           ),
                           const SizedBox(height: 4),
                           Text(
                             product.description,
                             style: theme.textTheme.bodySmall?.copyWith(
                               color: theme.colorScheme.onSurfaceVariant,
                             ),
                           ),
                         ],
                       ),
                     ),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.end,
                       children: [
                         Text(
                           product.priceString,
                           style: theme.textTheme.titleLarge?.copyWith(
                             fontWeight: FontWeight.bold,
                             color: theme.colorScheme.primary,
                           ),
                         ),
                         Text(
                           '/${product.periodText}',
                           style: theme.textTheme.bodySmall?.copyWith(
                             color: theme.colorScheme.onSurfaceVariant,
                           ),
                         ),
                       ],
                     ),
                   ],
                 ),
                 if (product.freeTrialDays > 0) ...[
                   const SizedBox(height: 8),
                   Container(
                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                     decoration: BoxDecoration(
                       color: theme.colorScheme.secondaryContainer,
                       borderRadius: BorderRadius.circular(8),
                     ),
                     child: Text(
                       '${product.freeTrialDays} days free trial',
                       style: theme.textTheme.labelSmall?.copyWith(
                         color: theme.colorScheme.onSecondaryContainer,
                       ),
                     ),
                   ),
                 ],
                 if (isSelected) ...[
                   const SizedBox(height: 16),
                   SizedBox(
                     width: double.infinity,
                     child: FilledButton(
                       onPressed: isLoading ? null : onPurchase,
                       child: isLoading
                           ? const SizedBox(
                               width: 20,
                               height: 20,
                               child: CircularProgressIndicator(
                                 strokeWidth: 2,
                               ),
                             )
                           : const Text('Subscribe'),
                     ),
                   ),
                 ],
               ],
             ),
           ),
         ),
       );
     }
   }
   ```

#### Acceptance Criteria
- [ ] RevenueCat SDK initializes correctly
- [ ] Products are fetched and displayed
- [ ] Purchase flow works on iOS and Android
- [ ] Subscription status is tracked
- [ ] Restore purchases works

---

### Task 3.2: Feature Gating

**Estimated Time:** 1-2 days

#### Objectives
- Create entitlement checking system
- Build premium-only widget wrappers
- Implement soft/hard paywalls

#### Implementation Steps

1. **Create `lib/core/services/entitlement_service.dart`**
   ```dart
   import 'package:flutter_riverpod/flutter_riverpod.dart';
   
   import '../../features/subscription/domain/entities/subscription.dart';
   import 'subscription_service.dart';
   
   /// Defines available feature entitlements.
   /// 
   /// Each entitlement maps to one or more subscription tiers.
   enum Entitlement {
     /// Basic app usage.
     basicUsage,
     
     /// Remove advertisements.
     noAds,
     
     /// Extended storage quota.
     extendedStorage,
     
     /// Unlimited storage.
     unlimitedStorage,
     
     /// Priority customer support.
     prioritySupport,
     
     /// Advanced analytics features.
     advancedAnalytics,
     
     /// Custom themes/appearance.
     customThemes,
     
     /// Offline mode access.
     offlineMode,
     
     /// API access for integrations.
     apiAccess,
     
     /// Team management features.
     teamManagement,
   }
   
   /// Extension for checking entitlement requirements.
   extension EntitlementX on Entitlement {
     /// Returns the minimum subscription tier required for this entitlement.
     SubscriptionTier get requiredTier {
       switch (this) {
         case Entitlement.basicUsage:
           return SubscriptionTier.free;
         case Entitlement.noAds:
         case Entitlement.extendedStorage:
           return SubscriptionTier.basic;
         case Entitlement.unlimitedStorage:
         case Entitlement.prioritySupport:
         case Entitlement.advancedAnalytics:
         case Entitlement.customThemes:
         case Entitlement.offlineMode:
           return SubscriptionTier.premium;
         case Entitlement.apiAccess:
         case Entitlement.teamManagement:
           return SubscriptionTier.enterprise;
       }
     }
     
     /// Returns a user-friendly name for this entitlement.
     String get displayName {
       switch (this) {
         case Entitlement.basicUsage:
           return 'Basic Usage';
         case Entitlement.noAds:
           return 'Ad-Free Experience';
         case Entitlement.extendedStorage:
           return 'Extended Storage';
         case Entitlement.unlimitedStorage:
           return 'Unlimited Storage';
         case Entitlement.prioritySupport:
           return 'Priority Support';
         case Entitlement.advancedAnalytics:
           return 'Advanced Analytics';
         case Entitlement.customThemes:
           return 'Custom Themes';
         case Entitlement.offlineMode:
           return 'Offline Mode';
         case Entitlement.apiAccess:
           return 'API Access';
         case Entitlement.teamManagement:
           return 'Team Management';
       }
     }
   }
   
   /// Service for checking user entitlements.
   class EntitlementService {
     final SubscriptionService _subscriptionService;
     
     EntitlementService(this._subscriptionService);
     
     /// Checks if the user has the specified entitlement.
     bool hasEntitlement(Entitlement entitlement) {
       final status = _subscriptionService.status;
       
       if (!status.isActive) {
         return entitlement == Entitlement.basicUsage;
       }
       
       return status.tier.index >= entitlement.requiredTier.index;
     }
     
     /// Checks if the user can access a premium feature.
     bool canAccess(Entitlement entitlement) => hasEntitlement(entitlement);
     
     /// Checks if the user has any paid subscription.
     bool get hasPaidSubscription => _subscriptionService.status.isPaid;
     
     /// Checks if the user has premium tier or higher.
     bool get hasPremium => _subscriptionService.status.hasPremium;
     
     /// Gets all entitlements available to the current user.
     List<Entitlement> get availableEntitlements {
       return Entitlement.values
           .where((e) => hasEntitlement(e))
           .toList();
     }
     
     /// Gets all entitlements the user is missing.
     List<Entitlement> get missingEntitlements {
       return Entitlement.values
           .where((e) => !hasEntitlement(e))
           .toList();
     }
   }
   
   /// Provider for the entitlement service.
   final entitlementServiceProvider = Provider<EntitlementService>((ref) {
     return EntitlementService(SubscriptionService.instance);
   });
   
   /// Provider for checking a specific entitlement.
   final hasEntitlementProvider = Provider.family<bool, Entitlement>((ref, entitlement) {
     final service = ref.watch(entitlementServiceProvider);
     // Also watch subscription status to react to changes
     ref.watch(subscriptionStatusProvider);
     return service.hasEntitlement(entitlement);
   });
   
   /// Provider for the subscription status stream.
   final subscriptionStatusProvider = StreamProvider<SubscriptionStatus>((ref) {
     return SubscriptionService.instance.statusChanges;
   });
   ```

2. **Create `lib/shared/presentation/widgets/premium_feature.dart`**
   ```dart
   import 'package:flutter/material.dart';
   import 'package:flutter_riverpod/flutter_riverpod.dart';
   import 'package:go_router/go_router.dart';
   
   import '../../../core/services/entitlement_service.dart';
   import '../../../features/subscription/presentation/widgets/paywall.dart';
   
   /// Widget that gates content behind a subscription requirement.
   /// 
   /// Shows the [child] if the user has the required [entitlement],
   /// otherwise shows a [placeholder] or triggers a paywall.
   /// 
   /// Usage:
   /// ```dart
   /// PremiumFeature(
   ///   entitlement: Entitlement.advancedAnalytics,
   ///   child: AnalyticsDashboard(),
   ///   placeholder: LockedFeatureCard(
   ///     title: 'Advanced Analytics',
   ///     description: 'Upgrade to Premium to access detailed analytics.',
   ///   ),
   /// )
   /// ```
   class PremiumFeature extends ConsumerWidget {
     /// The required entitlement to show the content.
     final Entitlement entitlement;
     
     /// The widget to show when the user has access.
     final Widget child;
     
     /// The widget to show when the user doesn't have access.
     /// If null, shows a default locked feature card.
     final Widget? placeholder;
     
     /// Whether to show the paywall immediately when tapped.
     final bool showPaywallOnTap;
     
     /// Custom callback when the locked feature is tapped.
     final VoidCallback? onLockedTap;
     
     const PremiumFeature({
       super.key,
       required this.entitlement,
       required this.child,
       this.placeholder,
       this.showPaywallOnTap = true,
       this.onLockedTap,
     });
   
     @override
     Widget build(BuildContext context, WidgetRef ref) {
       final hasAccess = ref.watch(hasEntitlementProvider(entitlement));
       
       if (hasAccess) {
         return child;
       }
       
       return GestureDetector(
         onTap: () {
           if (onLockedTap != null) {
             onLockedTap!();
           } else if (showPaywallOnTap) {
             _showPaywall(context);
           }
         },
         child: placeholder ?? _DefaultLockedPlaceholder(entitlement: entitlement),
       );
     }
   
     void _showPaywall(BuildContext context) {
       showModalBottomSheet(
         context: context,
         isScrollControlled: true,
         useSafeArea: true,
         builder: (context) => Paywall(
           title: 'Unlock ${entitlement.displayName}',
           description: 'Upgrade to access this premium feature.',
           features: [entitlement.displayName],
         ),
       );
     }
   }
   
   /// Default placeholder for locked features.
   class _DefaultLockedPlaceholder extends StatelessWidget {
     final Entitlement entitlement;
   
     const _DefaultLockedPlaceholder({required this.entitlement});
   
     @override
     Widget build(BuildContext context) {
       final theme = Theme.of(context);
       
       return Container(
         padding: const EdgeInsets.all(24),
         decoration: BoxDecoration(
           color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
           borderRadius: BorderRadius.circular(16),
           border: Border.all(
             color: theme.colorScheme.outline.withOpacity(0.3),
           ),
         ),
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             Container(
               padding: const EdgeInsets.all(12),
               decoration: BoxDecoration(
                 color: theme.colorScheme.primaryContainer,
                 shape: BoxShape.circle,
               ),
               child: Icon(
                 Icons.lock_outline,
                 color: theme.colorScheme.primary,
                 size: 32,
               ),
             ),
             const SizedBox(height: 16),
             Text(
               entitlement.displayName,
               style: theme.textTheme.titleMedium?.copyWith(
                 fontWeight: FontWeight.bold,
               ),
               textAlign: TextAlign.center,
             ),
             const SizedBox(height: 8),
             Text(
               'Upgrade to ${entitlement.requiredTier.name} to unlock',
               style: theme.textTheme.bodyMedium?.copyWith(
                 color: theme.colorScheme.onSurfaceVariant,
               ),
               textAlign: TextAlign.center,
             ),
             const SizedBox(height: 16),
             FilledButton.icon(
               onPressed: null, // Handled by parent GestureDetector
               icon: const Icon(Icons.workspace_premium),
               label: const Text('Upgrade'),
             ),
           ],
         ),
       );
     }
   }
   
   /// A banner that shows at the top of screens for free users.
   class UpgradeBanner extends ConsumerWidget {
     final String? message;
     final VoidCallback? onUpgrade;
   
     const UpgradeBanner({
       super.key,
       this.message,
       this.onUpgrade,
     });
   
     @override
     Widget build(BuildContext context, WidgetRef ref) {
       final status = ref.watch(subscriptionStatusProvider);
       
       return status.when(
         loading: () => const SizedBox.shrink(),
         error: (_, __) => const SizedBox.shrink(),
         data: (subscription) {
           if (subscription.isPaid) {
             return const SizedBox.shrink();
           }
           
           return _BannerContent(
             message: message ?? 'Upgrade to Premium for the full experience',
             onUpgrade: onUpgrade ?? () => _showPaywall(context),
           );
         },
       );
     }
   
     void _showPaywall(BuildContext context) {
       showModalBottomSheet(
         context: context,
         isScrollControlled: true,
         useSafeArea: true,
         builder: (context) => const Paywall(),
       );
     }
   }
   
   class _BannerContent extends StatelessWidget {
     final String message;
     final VoidCallback onUpgrade;
   
     const _BannerContent({
       required this.message,
       required this.onUpgrade,
     });
   
     @override
     Widget build(BuildContext context) {
       final theme = Theme.of(context);
       
       return Container(
         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
         decoration: BoxDecoration(
           gradient: LinearGradient(
             colors: [
               theme.colorScheme.primary,
               theme.colorScheme.tertiary,
             ],
           ),
         ),
         child: Row(
           children: [
             Icon(
               Icons.workspace_premium,
               color: theme.colorScheme.onPrimary,
             ),
             const SizedBox(width: 12),
             Expanded(
               child: Text(
                 message,
                 style: theme.textTheme.bodyMedium?.copyWith(
                   color: theme.colorScheme.onPrimary,
                 ),
               ),
             ),
             TextButton(
               onPressed: onUpgrade,
               style: TextButton.styleFrom(
                 foregroundColor: theme.colorScheme.onPrimary,
               ),
               child: const Text('Upgrade'),
             ),
           ],
         ),
       );
     }
   }
   ```

#### Acceptance Criteria
- [ ] Entitlement checks work correctly
- [ ] Premium features are properly gated
- [ ] Paywall appears when accessing locked features
- [ ] Upgrade banner shows for free users
- [ ] State updates when subscription changes

---

### Task 3.3: Admin Dashboard

**Estimated Time:** 3-4 days

#### Objectives
- Create admin route guards
- Build admin dashboard UI
- Implement content moderation
- Add user management

*(Detailed implementation with admin screens)*

---

## 📊 Phase 3 Checklist

| Task | Status | Notes |
|------|--------|-------|
| 3.1 RevenueCat Integration | ⬜ | |
| 3.2 Feature Gating | ⬜ | |
| 3.3 Admin Dashboard | ⬜ | |

---

## 🔗 Dependencies for Next Phase

Phase 4 requires the following from Phase 3:
- ✅ Subscription status for premium-only accessibility features
- ✅ Feature gating system for A/B testing
- ✅ Admin dashboard structure for content management

---

## 📝 Notes

- RevenueCat handles all store interactions
- Always verify subscription status server-side for sensitive operations
- Feature gating should fail open (show content) in case of errors
- Admin routes must be protected both client and server-side
