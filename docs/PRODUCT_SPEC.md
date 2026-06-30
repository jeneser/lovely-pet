# Lovely Pet Product Spec

## 1. Product Goal

Lovely Pet is a repeatable customization system for paid macOS desktop pets. The repository should support many future pets rather than a single one-off cat app.

The product has three surfaces:

1. Customer-facing customization and payment flow.
2. Internal asset-production and QA workflow.
3. macOS desktop pet app template that can be instantiated per order.

## 2. Target Customers

- Pet owners who want a personalized desktop companion.
- Gift buyers who want a custom digital pet for birthdays, anniversaries, or memorial use.
- Streamers, creators, and communities who want a mascot-like desktop character.

## 3. Commercial Packages

### Basic

- One pet.
- One visual style.
- Idle, hover, and tap animation.
- Unsigned or lightly signed build for manual download.

### Plus

- More interaction states: sleep, wake, follow-cursor, drag reaction.
- Custom name and behavior settings.
- Signed and notarized build.

### Premium

- More polished animation pass.
- Multiple skins or seasonal variants.
- Priority revision window.
- Future upgrade discount.

## 4. Order State Machine

```text
created -> paid -> assets_received -> character_locked -> animation_ready -> app_built -> qa_passed -> delivered -> revision_requested -> completed
```

Failure states:

```text
payment_failed
assets_insufficient
qa_failed
refund_requested
cancelled
```

## 5. MVP Scope

The MVP should prove the full revenue loop:

1. Customer submits pet name, photos, style preference, and email.
2. Customer pays.
3. Internal operator creates standardized transparent PNG animation frames.
4. Pipeline validates `pet.json` and frame directories.
5. Pipeline creates a customer-specific macOS app.
6. Operator signs, zips, uploads, and delivers the build.

## 6. Out of Scope for MVP

- Fully automated AI image generation without human QA.
- Native in-app payment.
- Live2D runtime integration.
- Cross-platform Windows/Linux versions.
- App Store distribution.

## 7. Success Metrics

- Time from paid order to first build.
- Percentage of orders needing manual asset repair.
- Refund rate.
- Repeat purchase rate.
- Average revenue per pet.
- Number of reusable animation states produced per pet.
