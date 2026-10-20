# Rotation Feed: what the app can and cannot do in your store

*Plain-language privacy letter for store owners and their advisers. It describes the standard app file
`shopify.app.toml` ("stock-only"). If Rotation agreed with you in writing to use `shopify.app.full.toml` instead,
see the last section.*

## In one sentence

The app adds **one extra warehouse called "Rotation"** to your store and keeps the stock of Rotation's shoes in that
warehouse up to date. That is all it does.

## The permissions the app asks for

Shopify only lets an app do what its permissions (Shopify calls them "access scopes") allow. The app asks for
exactly these five:

| Permission (scope) | What Shopify shows (roughly) | What it lets Rotation do |
|---|---|---|
| `read_products` | View products | **Read** your products to find which of them are the same shoes as Rotation's. Read only: nothing is changed. Note: Shopify does not offer a narrower permission, so technically this lets the app read your **whole product list** (including prices and descriptions) through Shopify's API. Rotation reads it only to match and stores only the matching facts listed under "What Rotation stores". |
| `read_inventory` | View inventory | See the stock quantity of those products in the **Rotation** warehouse. |
| `write_inventory` | Edit inventory | Set the stock quantity of Rotation's shoes **in the Rotation warehouse**. |
| `read_locations` | View locations | See your list of warehouses (to find the Rotation one). |
| `write_locations` | Edit locations | Create the separate **Rotation** warehouse once. |

## What the app can NOT do

Because those are the only permissions, Shopify itself blocks the app from:

- reading your **orders** or anything about your **customers** (names, emails, phone numbers, addresses);
- changing product **titles, descriptions, images, SEO** (page titles, meta descriptions, URLs), **prices**,
  **tags**, **collections**, product types, vendors, or whether a product is **published** on a sales channel;
- creating or deleting products.

Rotation's server also has its own guard: for a stock-only store it never sends a product change at all.

The app only writes stock at the Rotation warehouse it created. It does **not** change the stock in your other
warehouses: your own stock stays yours.

## How you can check this yourself

- Shopify shows the permissions on the install screen before you click **Install**.
- Any time later: Shopify admin > **Settings** > **Apps and sales channels** > **Rotation Feed** > the permissions
  section (sometimes behind "View details"). It lists exactly the permissions above.
- If the list ever shows more (for example "orders" or "edit products"), contact us: that would be the full variant.

## How Rotation sees that a pair was sold

Rotation does not see your orders. Rotation sees only that **the quantity in the Rotation warehouse went down**
(for example from 3 to 2). Shopify lowers that number when you sell a pair that was in stock only there, so Rotation
lowers its own stock by the same amount and does not sell the same pair twice. Because of this, please treat the
Rotation warehouse as **managed by Rotation**: do not edit its quantities by hand (a manual drop is counted as a sale,
a manual increase is put back to Rotation's number). Shipping the pair is arranged with Rotation as agreed.

## What Rotation stores

- For the products that are matched (and the candidates shown to you during matching): Shopify ids, titles, vendor,
  product type, sizes, SKUs, barcodes and an image link, and the stock quantities in the Rotation warehouse. Your
  prices and descriptions are not stored.
- For each sale detected: which product and size, how many pairs, and when.
- No customer data, no orders, no prices, no payment data.

Records of sales are kept for 18 months; technical logs for a shorter time.

## Disconnecting and deleting

- **Before you uninstall**, ask Rotation to **zero the Rotation warehouse** (kristoffer@rotation.no), so no Rotation
  pairs stay on sale in your store. After an uninstall Shopify stops our access, and we can no longer do it for you.
- Uninstall: Shopify admin > Settings > Apps and sales channels > Rotation Feed > Uninstall. Shopify revokes the
  app's access at once.
- 48 hours after an uninstall Shopify asks us to delete your store's data ("shop/redact"); we then delete it (sales
  records are kept anonymised for Rotation's bookkeeping).
- Questions or a deletion request: kristoffer@rotation.no.

## The full variant (only if agreed)

`shopify.app.full.toml` additionally asks for `write_products` (create Rotation's products in your store as drafts
without a price) and `read_orders` (order lines of Rotation's products only; customer details are never stored).
Use it only if Rotation asked you to and you agreed.
