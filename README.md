# Rotation Feed: set up your own app (partner guide)

This folder lets you create **Rotation Feed**, the small Shopify app that brings Rotation's products and stock into **your** Shopify store. You create it in your own Shopify account, install it on your own store, and connect it yourself with the partner code Rotation sent you.

- There is **no program code** in this folder. It only holds the app's settings (`shopify.app.toml`). The app itself runs on Rotation's server at `bridge.rotationfootwear.com`.
- You don't need to be a developer. You copy and paste a few commands, and click through the Shopify Dev Dashboard.
- **Time:** about 30 to 45 minutes the first time, most of it installing the tools.
- Stuck at any step? Email **kristoffer@rotation.no** (see step K). Tell us the step number and copy the exact message you see.

Screens and button names in Shopify change from time to time. Where this guide says *the exact wording may differ slightly*, look for the button or link that does what is described.

---

## What's in this folder

| File | What it is |
|---|---|
| `README.md` | This guide |
| `shopify.app.toml` | The app's settings. You change **one** line (the Client ID); leave everything else as it is |
| `set-client-id.sh` | A small helper that writes your Client ID into `shopify.app.toml` (macOS and Linux) |
| `package.json` | Needed by the Shopify CLI to recognise the folder as an app. Nothing to install from it |
| `PARTNER_DETAILS_TEMPLATE.md` | Only if you have no partner code: the details to send Rotation (no secret) |
| `.gitignore` | Keeps local files out of Git |

---

## Before you start (checklist, 10 to 20 minutes)

Tick each line before you continue.

1. **A Shopify store you own** (or where you are staff with permission to install apps). Note its `.myshopify.com` address: Shopify admin > **Settings** > **Domains**. It looks like `your-store.myshopify.com`.
2. **A Shopify Dev Dashboard account with an organization.** Open <https://dev.shopify.com/dashboard> and log in with your Shopify account. If you can see **Apps** in the left menu, you're ready. If it asks you to create or choose an organization, do that first (use your company name).
3. **A terminal** (the window where you type commands):
   - macOS: press Cmd + Space, type **Terminal**, press Enter.
   - Windows: open the Start menu, type **PowerShell**, open **Windows PowerShell**.
   - Linux: your usual terminal.
4. **Node.js 22.12 or newer** (the Shopify CLI needs it). Install the **LTS** version from <https://nodejs.org/en/download>. Then check it in the terminal:
   ```sh
   node --version
   ```
   You should see `v22.12.0` or a higher number (for example `v24.x.x`). If you see "command not found", close the terminal, open a new one and try again.
5. **Git** (optional: you can download a ZIP instead, see step A). Install from <https://git-scm.com/downloads> and check:
   ```sh
   git --version
   ```
   You should see `git version 2.28` or higher.
6. **The Shopify CLI.** Install it once:
   ```sh
   npm install -g @shopify/cli@latest
   ```
   Check it:
   ```sh
   shopify version
   ```
   You should see a version number (for example `3.x.x` or higher).
   - macOS: if you get a permission error (`EACCES`), install it with Homebrew instead: `brew tap shopify/shopify` and then `brew install shopify-cli`.
7. **Your partner code from Rotation** (in Rotation's email, it looks like `RT7K-92MX-4Q`). You enter it in the app at the end (step G).

---

## A. Download this folder (2 minutes)

Choose one.

**With Git:**
```sh
git clone https://github.com/kristoffervk/rotation-feed-partner-app rotation-feed-partner-app
cd rotation-feed-partner-app
```

**Without Git:** open `https://github.com/kristoffervk/rotation-feed-partner-app` in your browser, click the green **Code** button, then **Download ZIP**. Unzip the file. The folder is usually called `rotation-feed-partner-app-main`. In the terminal, go into it, for example:
```sh
cd ~/Downloads/rotation-feed-partner-app-main
```
(On Windows: `cd $HOME\Downloads\rotation-feed-partner-app-main`.)

**You should see** the files from the table above when you type `ls` (macOS/Linux) or `dir` (Windows).

All commands below are run **inside this folder**.

---

## B. Create the app in the Dev Dashboard (3 minutes)

1. Open <https://dev.shopify.com/dashboard> and choose your organization.
2. Click **Apps** in the left menu, then **Create app** (top right).
3. If asked how to start, choose **Start from Dev Dashboard**.
4. Name the app **Rotation Feed** and click **Create**.
5. Open the app's **Settings** page. Copy the **Client ID** (32 characters, letters a to f and numbers). Keep the page open: you need the **Client secret** from the same page in step G.

**Don't** fill in URLs, permissions or webhooks here, and **don't release a version** in the Dev Dashboard. The next steps do all of that from `shopify.app.toml`.

---

## C. Put your Client ID in the file (1 minute)

Choose one way. Replace `YOUR_CLIENT_ID` with the Client ID you copied.

**macOS or Linux (the helper script):**
```sh
sh set-client-id.sh YOUR_CLIENT_ID
```
**You should see:** `Done: shopify.app.toml now uses Client ID ...` followed by the next steps. If it says the ID doesn't look right, check you copied the **Client ID**, not the Client secret.

**Windows (PowerShell, one line):**
```powershell
(Get-Content shopify.app.toml) -replace '^client_id = .*', 'client_id = "YOUR_CLIENT_ID"' | Set-Content shopify.app.toml
```

**By hand (any computer):** open `shopify.app.toml` in a plain text editor (TextEdit in plain-text mode, Notepad, or VS Code). Find this line:
```toml
client_id = "PASTE_YOUR_CLIENT_ID_HERE"
```
Replace `PASTE_YOUR_CLIENT_ID_HERE` with your Client ID. Keep the quotes. Save the file. Change nothing else.

**Check:** the line now reads `client_id = "` followed by your 32-character ID and `"`.

---

## D. Log in and deploy the app's settings (5 minutes)

1. Log in to Shopify from the terminal:
   ```sh
   shopify auth login
   ```
   A browser window opens. Log in with **the same Shopify account you used in the Dev Dashboard** and approve. The terminal then says you're logged in.

2. Send the app's settings to Shopify:
   ```sh
   shopify app deploy
   ```
   What the questions mean (the exact wording may differ slightly):
   - It may first show a summary of what changes (the app's URL, permissions and webhooks). That is the content of `shopify.app.toml`.
   - **"Release a new version of Rotation Feed?"** (or similar): answer **Yes, release this new version**. Use the arrow keys and press Enter.
   - If it asks which organization or app to use, choose your organization and the **Rotation Feed** app you created in step B.

   **You should see** a success message that a new version was released (for example "New version released to users"). In the Dev Dashboard, your app now shows a version.

   If you get an error, see the troubleshooting table (step I).

---

## E. Get the install link (3 minutes)

Open your **Rotation Feed** app in the Dev Dashboard. What you see depends on the type of your organization.

**If you see a "Distribution" card** (a Partner organization):
1. On the app's home, find **Distribution** and click **Select distribution method**.
2. Choose **Custom distribution** and confirm. **Never choose Public distribution.** The choice can't be changed later.
3. Enter your store's address, `your-store.myshopify.com`.
4. Leave **Allow multi-store installs** unticked (clear it if it is ticked), unless Rotation asked you to install on several stores of the same Shopify Plus organization.
5. Click **Generate link** and copy the **install link**. You can find it again later under **Manage custom install link** on the same card.

Good to know about custom distribution (from Shopify's documentation): an app with custom distribution installs on **one store**, or on several stores only if they all belong to **the same Shopify Plus organization**. If your store isn't accepted, check that you typed the `.myshopify.com` address of the store you own.

**If you don't see a Distribution card** (your store's own organization): that's normal. You install the app directly in step F, from the **Installs** card. There is no install link to copy, and you don't need one: you connect with your partner code in step G.

---

## F. Install the app on your store and approve the permissions (2 minutes)

1. **With an install link:** open it in your browser while you're logged in to your store's admin.
   **Without one:** in the Dev Dashboard open the app and click **Install app** on the **Installs** card, then choose your store and click **Install**.
2. Shopify shows the permissions the app asks for. The standard app file (`shopify.app.toml`) is **stock-only**: all
   Rotation does is add another warehouse. In plain language:

   | What Shopify shows (roughly) | Why Rotation needs it |
   |---|---|
   | View **products** | To find Rotation's shoes among your products. Read only: nothing is changed (Shopify's permission covers your whole product list; Rotation stores only what matching needs, see PRIVACY.md). |
   | View and edit **inventory** | To keep the stock of Rotation's products up to date in the Rotation warehouse. |
   | View and edit **locations** | To create the separate **"Rotation"** warehouse, so Rotation's stock stays apart from yours. |

   The app asks for **no order access and no customer access**, and cannot change your product titles, descriptions,
   images, SEO or prices. The full explanation for you (and your lawyer) is in [PRIVACY.md](PRIVACY.md).
   (Only if Rotation asked you to: `shopify.app.full.toml` is the full variant, which also creates Rotation's products
   as drafts and reads order lines. Deploy it with `shopify app deploy --config full` after putting your Client ID in it.)
3. Click **Install**.

**You should see** Rotation Feed in your Shopify admin's apps list. Shopify may open it right away. **Until you connect it (step G) it shows "This app is not connected to Rotation yet"**, with a form for your partner code and the app's Client secret. That's expected: continue with step G.

---

## G. Connect the app with your partner code (2 minutes)

You need the **partner code** Rotation sent you (it looks like `RT7K-92MX-4Q`) and your app's **Client secret**.

1. In your Shopify admin open **Apps** > **Rotation Feed**. It says **"This app is not connected to Rotation yet"**.
2. **Partner code:** type the code from Rotation's message. Capitals, spaces and dashes don't matter.
3. **Client secret:** in the Dev Dashboard open **Rotation Feed** > **Settings** and copy the **Client secret** (you may have to click a button to reveal or copy it). Paste it into the app.
4. Click **Connect**.

**You should see** the next setup step (where Rotation's stock should go). Your app is now registered with Rotation: **there is nothing to send Rotation**, no Client ID, no secret, no install link.

**About the Client secret.** It is a password. You only ever paste it into the Rotation Feed app itself, which checks it against your app (the app proves it is really yours) and stores it encrypted. It is never shown again, and Rotation staff never need it by chat or email. **Never** post it in a chat, an email, a screenshot, this folder or any Git repository. If you think it leaked, rotate it in the Dev Dashboard (on the app's Settings page; the exact wording may differ slightly) and email Rotation (step K): the app pauses until Rotation stores the new one.

**"That didn't work"?** Check the code (it works once, until the date in Rotation's message, and only on the store Rotation made it for, if they named one) and that you copied the **Client secret** of **this** app, not the Client ID. After 5 wrong tries the form locks for 15 minutes. A code that has expired or was used: ask Rotation for a new one.

**Fallback (only if Rotation asks for it):** no partner code? Send Rotation the **Client ID** shown on the same screen (and in Dev Dashboard > Settings). The Client ID is not secret. Use [`PARTNER_DETAILS_TEMPLATE.md`](PARTNER_DETAILS_TEMPLATE.md). Rotation then sends you a partner code, and you connect as above.

---

## H. What happens next

1. Right after **Connect** the app asks where Rotation's stock should go. Keep the suggestion **Create a new warehouse "Rotation"**: it keeps Rotation's stock apart from your own.
2. The app looks for Rotation products **you already sell**, so you don't get duplicates. Check the matches under **Your products** (sure matches can be confirmed in one click).
3. Rotation's other products appear under **Products** as **drafts without a price**. You choose prices and when to publish.

Rotation **never changes your own products**: for a product you confirm as the same shoe, only the stock in the Rotation warehouse is updated. Your titles, photos, prices and publishing stay yours.

---

## I. Troubleshooting

| What you see | What to do |
|---|---|
| `command not found: shopify` (or `shopify` is not recognized) | Close the terminal and open a new one. Still missing: run `npm install -g @shopify/cli@latest` again (macOS: or use Homebrew, see the checklist). Check with `shopify version`. |
| `command not found: node` / `npm`, or the CLI says your Node.js is too old | Install the LTS version from <https://nodejs.org/en/download>, open a new terminal, check `node --version` (22.12 or higher). |
| "Cannot find a valid organization" / "No organization found" | You're logged in with a different Shopify account than the one in the Dev Dashboard, or that account has no organization yet. Open <https://dev.shopify.com/dashboard> and check you see your organization. Then `shopify auth logout`, `shopify auth login` with the right account, and `shopify app deploy` again. |
| Logged in with the wrong account | `shopify auth logout`, then `shopify auth login` and choose the right account in the browser. |
| Deploy says the app or Client ID can't be found | Check the `client_id` line in `shopify.app.toml` (step C) is the **Client ID** of the app you created in step B, in the organization you're logged in to. |
| Deploy or install mentions **protected customer data** or the `orders/create` webhook | Shopify wants you to confirm how the app uses order data. In the Dev Dashboard open the app and look for **API access** / **Protected customer data** (the exact wording may differ slightly). Choose protected customer data for **app functionality**, and **don't** select any of the fields name, email, phone or address. Save, then run `shopify app deploy` again. If you can't find it, send us the exact message. |
| `set-client-id.sh: permission denied` | Run it as `sh set-client-id.sh YOUR_CLIENT_ID`. |
| The install link doesn't work or says the store can't install it | Check the link was generated for **your** store's `.myshopify.com` address (step E). Log in to that store's admin first, then open the link again. You can generate a new link under **Manage custom install link**. If your organization has no Distribution card, install from the **Installs** card instead. |
| The permission screen shows **more or fewer** permissions than in step F | Don't install. Your `shopify.app.toml` was probably changed, or the deploy didn't finish. Download the folder again (step A), set the Client ID (C), deploy (D) and try again. If it still differs, tell us what you see. |
| **I reset my Client secret** (or the app says "Update your app's Client secret") | Open the app in your Shopify admin. On the status page open **Update your app's Client secret** (the app shows it by itself if the old secret no longer works), paste the new secret from the Dev Dashboard (your app › Settings) and save. Then revoke the old secret in the Dev Dashboard. Never send the secret over chat. |
| The app opens blank, or shows "This app is not connected to Rotation yet", "Your session expired" or "set up for a different store" | Before step H that's expected: the first message just means we haven't registered your app yet. Afterwards, ask us (step K) and tell us the exact message. |

---

## J. Uninstall or disconnect

- **Tell Rotation first.** Rotation's pairs in your Rotation warehouse can still be sold in your store until Rotation sets that stock to 0, and Rotation can only do that while the app is connected.
- Then, in your Shopify admin: **Settings** > **Apps** (or **Apps and sales channels**) > **Rotation Feed** > **Uninstall**.
- Products already in your store stay where they are. Nothing is deleted.
- If you no longer want the app at all, you can afterwards remove it in the Dev Dashboard too (the exact wording may differ slightly). Rotation can then delete your registration.

---

## K. Support

Email **kristoffer@rotation.no**. Say which step you're on and paste the exact message you see. **Never include the Client secret in an email**: Rotation never needs it from you; you only paste it into the app itself (step G).
