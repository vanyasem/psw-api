# psw

A small Dart CLI for downloading order and menu data from the PSW
(`dataexchange.psweb.pro`) API and turning it into a readable per-order
report.

## Setup

1. Install the Dart SDK (`>=3.11.0 <4.0.0`).
2. Install dependencies:

   ```sh
   dart pub get
   ```

3. Copy `.env.example` to `.env` and fill in your credentials:

   ```
   access_token=YOUR_TOKEN
   userID=YOUR_USER_ID
   ```

## Subcommands

All commands resolve paths relative to the current working directory and
read/write a `data/` folder there. Run them from whichever directory you want
that folder to live in.

| Command | What it does |
| --- | --- |
| `psw orders` | Fetches your order history, saves it to `data/history.json`, then downloads each order's detail JSON to `data/orders/<orderID>.json`. Existing files are skipped. Reads `access_token` and `userID` from `.env`. |
| `psw menu` | Downloads the public menu (`api_v5/mobile/1-menu.pswjson`) and saves it as `data/menu.json`. Requires no credentials. |
| `psw report` | Reads `data/menu.json` and every `data/orders/*.json`, joins them on `positionID`, and prints each item's name, price, and amount grouped by order. Items missing from the current menu fall back to a `<unknown {id}>` placeholder unless they're in the retired-items table in [lib/src/menu_index.dart](lib/src/menu_index.dart). |

## Running

From the repo root:

```sh
dart run bin/psw.dart menu
dart run bin/psw.dart orders
dart run bin/psw.dart report
```

`psw report` produces output like:

```
Order 1234567 (16:33:37 28.08.2022):
  Крылышки "Буффало" 400г | 559 | 1
  Терияки | 89 | 1
  Удон со свининой | 399 | 1
```

## Layout

```
bin/psw.dart                       CLI entry point
lib/psw.dart                       pipeline functions (orders, menu, report)
lib/src/api_client.dart            HTTP client for the PSW endpoints
lib/src/env.dart                   .env loader
lib/src/orders_source.dart         parses orderIDs out of order history
lib/src/menu_index.dart            positionID → name lookup, retired-items table
lib/src/commands/                  args_command_runner Command subclasses
spec/                              implementation plan and prompt history
```
