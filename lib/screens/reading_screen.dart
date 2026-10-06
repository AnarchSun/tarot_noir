import 'package:flutter/material.dart';

import '../app_config.dart';
import '../l10n/app_localizations.dart';
import '../models/tarot_card.dart';
import '../widgets/orion_premium_insight.dart';
import '../widgets/tarot_card_view.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({
    required this.dailyCard,
    required this.dailyOrientation,
    required this.freeCard,
    required this.freeOrientation,
    required this.onDraw,
    required this.isRestoring,
    required this.showAccessChoices,
    required this.showGuestSignIn,
    required this.isSigningIn,
    required this.isFacebookSigningIn,
    required this.onGoogleSignIn,
    required this.onFacebookSignIn,
    required this.onContinueAsGuest,
    super.key,
  });

  final TarotCard dailyCard;
  final CardOrientation dailyOrientation;
  final TarotCard? freeCard;
  final CardOrientation freeOrientation;
  final VoidCallback onDraw;
  final bool isRestoring;
  final bool showAccessChoices;
  final bool showGuestSignIn;
  final bool isSigningIn;
  final bool isFacebookSigningIn;
  final Future<void> Function() onGoogleSignIn;
  final Future<void> Function() onFacebookSignIn;
  final Future<void> Function() onContinueAsGuest;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final cardHeight = (viewportHeight * 0.32).clamp(180.0, 260.0).toDouble();
    final textTheme = Theme.of(context).textTheme;
    final drawnCard = freeCard;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 12),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.appTitle.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    letterSpacing: 3,
                    color: Color(0xFFD4AF59),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.dailyReading,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                if (isRestoring) ...[
                  Semantics(
                    label: l10n.restoringRitual,
                    child: const LinearProgressIndicator(),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: cardHeight,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF171220),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF49395D)),
                    ),
                    child: const CircularProgressIndicator(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.restoringRitual,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium,
                  ),
                ] else ...[
                  TweenAnimationBuilder<double>(
                    key: ValueKey(dailyCard.id),
                    tween: Tween(begin: 0.94, end: 1),
                    duration: const Duration(milliseconds: 480),
                    curve: Curves.easeOutCubic,
                    child: TarotCardView(
                      card: dailyCard,
                      orientation: dailyOrientation,
                      height: cardHeight,
                    ),
                    builder: (context, scale, child) => Opacity(
                      opacity: ((scale - 0.94) / 0.06).clamp(0, 1).toDouble(),
                      child: Transform.scale(scale: scale, child: child),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    dailyCard.name,
                    textAlign: TextAlign.center,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dailyCard.keyword.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      letterSpacing: 2,
                      color: Color(0xFFD4AF59),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dailyCard.message,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(height: 1.35),
                  ),
                  if (AppConfig.premiumEnabled) ...[
                    const SizedBox(height: 16),
                    OrionPremiumInsight(
                      card: dailyCard,
                      orientation: dailyOrientation,
                    ),
                  ],
                ],
                if (!isRestoring && showGuestSignIn) ...[
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    key: const Key('google-sign-in'),
                    onPressed: isSigningIn ? null : onGoogleSignIn,
                    icon: isSigningIn
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.g_mobiledata, size: 28),
                    label: Text(l10n.continueWithGoogle),
                  ),
                  if (AppConfig.facebookSignInVisible) ...[
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      key: const Key('facebook-sign-in'),
                      onPressed: isFacebookSigningIn ? null : onFacebookSignIn,
                      icon: isFacebookSigningIn
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.facebook),
                      label: Text(l10n.continueWithFacebook),
                    ),
                  ],
                  if (showAccessChoices) ...[
                    const SizedBox(height: 4),
                    TextButton(
                      key: const Key('continue-as-guest'),
                      onPressed: onContinueAsGuest,
                      child: Text(l10n.continueWithoutAccount),
                    ),
                  ],
                ],
                if (!isRestoring && !showAccessChoices) ...[
                  const SizedBox(height: 22),
                  FilledButton.icon(
                    key: const Key('basic-draw'),
                    onPressed: onDraw,
                    icon: const Icon(Icons.casino_outlined),
                    label: Text(l10n.basicDraw),
                  ),
                  if (drawnCard != null) ...[
                    const Divider(height: 28),
                    Text(
                      l10n.freeDrawType,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TweenAnimationBuilder<double>(
                      key: ValueKey('free-${drawnCard.id}'),
                      tween: Tween(begin: 0.94, end: 1),
                      duration: const Duration(milliseconds: 420),
                      curve: Curves.easeOutCubic,
                      child: TarotCardView(
                        card: drawnCard,
                        orientation: freeOrientation,
                        height: cardHeight > 280 ? 280 : cardHeight,
                      ),
                      builder: (context, scale, child) => Opacity(
                        opacity: ((scale - 0.94) / 0.06).clamp(0, 1).toDouble(),
                        child: Transform.scale(scale: scale, child: child),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      drawnCard.name,
                      textAlign: TextAlign.center,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      drawnCard.keyword.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        letterSpacing: 2,
                        color: Color(0xFFD4AF59),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      drawnCard.message,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(height: 1.45),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
