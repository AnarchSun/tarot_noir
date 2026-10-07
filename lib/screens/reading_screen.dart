import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app_config.dart';
import '../l10n/app_localizations.dart';
import '../models/tarot_card.dart';
import '../widgets/orion_premium_insight.dart';
import '../widgets/tarot_card_back.dart';
import '../widgets/tarot_card_view.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({
    required this.dailyCard,
    required this.dailyOrientation,
    required this.hasDrawnToday,
    required this.freeCard,
    required this.freeOrientation,
    required this.onDrawDaily,
    required this.onDrawFree,
    required this.isRestoring,
    required this.showAccessChoices,
    required this.isDailyDrawing,
    required this.isSigningIn,
    required this.isFacebookSigningIn,
    required this.onGoogleSignIn,
    required this.onFacebookSignIn,
    required this.onContinueAsGuest,
    super.key,
  });

  final TarotCard dailyCard;
  final CardOrientation dailyOrientation;
  final bool hasDrawnToday;
  final TarotCard? freeCard;
  final CardOrientation freeOrientation;
  final Future<void> Function() onDrawDaily;
  final Future<void> Function() onDrawFree;
  final bool isRestoring;
  final bool showAccessChoices;
  final bool isDailyDrawing;
  final bool isSigningIn;
  final bool isFacebookSigningIn;
  final Future<void> Function() onGoogleSignIn;
  final Future<void> Function() onFacebookSignIn;
  final Future<void> Function() onContinueAsGuest;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (isRestoring) return _StartupRitual(message: l10n.startupLoading);

    final textTheme = Theme.of(context).textTheme;
    final dailyCardWidth = MediaQuery.sizeOf(context).height < 700
        ? 136.0
        : 176.0;
    final revealedCard = freeCard;
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/branding/tarot_noir_logo.png',
                    width: 172,
                    height: 58,
                    fit: BoxFit.contain,
                    semanticLabel: l10n.appTitle,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  showAccessChoices ? l10n.welcomeTitle : l10n.dailyReading,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFFE3D8C7),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (showAccessChoices) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.startupTeaser,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFFB8D5D0),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: SizedBox(
                      width: 144,
                      child: TarotCardBack(key: const Key('daily-card-teaser')),
                    ),
                  ),
                  const SizedBox(height: 26),
                  _SignInChoices(
                    isSigningIn: isSigningIn,
                    isFacebookSigningIn: isFacebookSigningIn,
                    showFacebook: AppConfig.facebookSignInVisible,
                    onGoogleSignIn: onGoogleSignIn,
                    onFacebookSignIn: onFacebookSignIn,
                    onContinueAsGuest: onContinueAsGuest,
                  ),
                ] else ...[
                  const SizedBox(height: 16),
                  if (hasDrawnToday)
                    _CardReveal(card: dailyCard, orientation: dailyOrientation)
                  else
                    Center(
                      child: SizedBox(
                        width: dailyCardWidth,
                        child: TarotCardBack(key: const Key('daily-card-back')),
                      ),
                    ),
                  const SizedBox(height: 18),
                  if (hasDrawnToday) ...[
                    Text(
                      dailyCard.name,
                      textAlign: TextAlign.center,
                      style: textTheme.titleLarge?.copyWith(
                        color: const Color(0xFFE3D8C7),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      dailyCard.keyword.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        letterSpacing: 2,
                        color: Color(0xFFB8D5D0),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      dailyCard.message,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(height: 1.45),
                    ),
                    if (AppConfig.premiumEnabled) ...[
                      const SizedBox(height: 16),
                      OrionPremiumInsight(
                        card: dailyCard,
                        orientation: dailyOrientation,
                      ),
                    ],
                  ] else ...[
                    Text(
                      l10n.dailyDrawPrompt,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(height: 1.45),
                    ),
                  ],
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    key: const Key('daily-draw'),
                    onPressed: hasDrawnToday || isDailyDrawing
                        ? null
                        : onDrawDaily,
                    icon: isDailyDrawing
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            hasDrawnToday
                                ? Icons.check_circle_outline
                                : Icons.auto_awesome_outlined,
                          ),
                    label: Text(
                      hasDrawnToday ? l10n.dailyDrawLocked : l10n.drawDaily,
                    ),
                  ),
                  if (hasDrawnToday) ...[
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      key: const Key('basic-draw'),
                      onPressed: onDrawFree,
                      icon: const Icon(Icons.casino_outlined),
                      label: Text(l10n.basicDraw),
                    ),
                    if (revealedCard != null) ...[
                      const Divider(height: 32),
                      Text(
                        l10n.freeDrawType,
                        style: textTheme.titleMedium?.copyWith(
                          color: const Color(0xFFE3D8C7),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _CardReveal(
                        card: revealedCard,
                        orientation: freeOrientation,
                        key: ValueKey('free-${revealedCard.id}'),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        revealedCard.name,
                        textAlign: TextAlign.center,
                        style: textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        revealedCard.keyword.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          letterSpacing: 2,
                          color: Color(0xFFB8D5D0),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        revealedCard.message,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge?.copyWith(height: 1.45),
                      ),
                    ],
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

class _SignInChoices extends StatelessWidget {
  const _SignInChoices({
    required this.isSigningIn,
    required this.isFacebookSigningIn,
    required this.showFacebook,
    required this.onGoogleSignIn,
    required this.onFacebookSignIn,
    required this.onContinueAsGuest,
  });

  final bool isSigningIn;
  final bool isFacebookSigningIn;
  final bool showFacebook;
  final Future<void> Function() onGoogleSignIn;
  final Future<void> Function() onFacebookSignIn;
  final Future<void> Function() onContinueAsGuest;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
        if (showFacebook) ...[
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
        const SizedBox(height: 8),
        OutlinedButton(
          key: const Key('continue-as-guest'),
          onPressed: onContinueAsGuest,
          child: Text(l10n.continueWithoutAccount),
        ),
      ],
    );
  }
}

class _StartupRitual extends StatefulWidget {
  const _StartupRitual({required this.message});

  final String message;

  @override
  State<_StartupRitual> createState() => _StartupRitualState();
}

class _StartupRitualState extends State<_StartupRitual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _motion.stop();
      _motion.value = 0.5;
    } else if (!_motion.isAnimating) {
      _motion.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = math.min(constraints.maxWidth * 0.42, 172.0);
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/branding/tarot_noir_logo.png',
                        width: math.min(constraints.maxWidth * 0.72, 300.0),
                        height: 100,
                        fit: BoxFit.contain,
                        semanticLabel: l10n.appTitle,
                      ),
                      const SizedBox(height: 30),
                      AnimatedBuilder(
                        animation: _motion,
                        builder: (context, child) {
                          final phase = _motion.value;
                          return Transform.translate(
                            offset: Offset(0, -4 * phase),
                            child: Transform.rotate(
                              angle: (phase - 0.5) * 0.035,
                              child: child,
                            ),
                          );
                        },
                        child: SizedBox(
                          width: cardWidth,
                          child: const TarotCardBack(
                            key: Key('startup-card-back'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        widget.message,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFFE3D8C7),
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Semantics(
                        label: widget.message,
                        child: const LinearProgressIndicator(
                          key: Key('startup-progress'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.startupTeaser,
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall?.copyWith(
                          color: const Color(0xFFB8D5D0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CardReveal extends StatelessWidget {
  const _CardReveal({required this.card, required this.orientation, super.key});

  final TarotCard card;
  final CardOrientation orientation;

  @override
  Widget build(BuildContext context) {
    final cardHeight = (MediaQuery.sizeOf(context).height * 0.31)
        .clamp(190.0, 270.0)
        .toDouble();
    if (MediaQuery.of(context).disableAnimations) {
      return TarotCardView(
        card: card,
        orientation: orientation,
        height: cardHeight,
      );
    }
    return TweenAnimationBuilder<double>(
      key: ValueKey('daily-reveal-${card.id}'),
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 680),
      curve: Curves.easeOutCubic,
      builder: (context, progress, _) {
        final showingBack = progress < 0.5;
        final rotationY = showingBack
            ? math.pi * progress
            : math.pi * (progress - 1);
        final face = showingBack
            ? const SizedBox(width: 184, child: TarotCardBack())
            : TarotCardView(
                card: card,
                orientation: orientation,
                height: cardHeight,
              );
        return Center(
          child: SizedBox(
            height: cardHeight,
            width: 184,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(rotationY),
              child: face,
            ),
          ),
        );
      },
    );
  }
}
