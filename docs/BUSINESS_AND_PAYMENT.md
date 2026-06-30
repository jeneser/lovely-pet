# Business and Payment

## Commercial Model

Lovely Pet should start as a service-assisted product rather than a fully automated SaaS. Human QA is the differentiator: the customer pays for a recognizable, polished pet, not merely an auto-generated file.

## Recommended MVP Payment Flow

1. Landing page explains packages and examples.
2. Customer uploads photos and chooses package.
3. Checkout collects payment.
4. Webhook creates an internal order.
5. Operator performs asset workflow and QA.
6. Build pipeline creates the app.
7. Customer receives a secure download link.

## Payment Provider

For the first version, Stripe Checkout is the most pragmatic default for non-App-Store distribution. Keep the payment system separate from the desktop runtime.

## Pricing Ladder

| Package | Suggested Scope |
|---|---|
| Basic | 1 pet, 3 states, standard style |
| Plus | 1 pet, 5 states, signed build, one revision |
| Premium | more animation polish, extra variants, priority support |

## Refund and Revision Policy

- Offer one free revision for Plus and Premium.
- Define a minimum photo-quality requirement.
- Refund only before character-lock approval, unless delivery fails.
- For memorial pets, use a more careful review and approval process.

## Data Policy

- Do not use customer pet photos for marketing without explicit permission.
- Store raw photos separately from generated builds.
- Delete raw photos after a configurable retention window unless the customer opts in.
- Keep the demo cat assets isolated from customer assets.
