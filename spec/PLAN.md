# Implementation plan

## Stage 1

Use Dart MCP. Use context7 MCP.

When the plan is ready, wait for my explicit approval before executing the task.
Ask me clarifying questions about the task.

I need a simple dart CLI client that would save the JSON output of all of my orders.

API's endpoint is GET `https://dataexchange.psweb.pro/api/order.getInformation?access_token=TOKEN&orderID=ORDERID&userID=USERID`

Read `access_token` and `userID` from @.env.

`orderID` should be read from @orders.json.

At this stage, only save the raw JSON output to a folder.

## Stage 2

Use Dart MCP. Use context7 MCP.

When the plan is ready, wait for my explicit approval before executing the task.
Ask me clarifying questions about the task.

I now need to get the orders list automatically. The endpoint is GET `https://dataexchange.psweb.pro/api/order.getHistory?access_token=TOKEN&userID=USERID`

Read `access_token` and `userID` from @.env.

At this stage, only save the raw JSON output to a folder.

## Stage 3

Use Dart MCP. Use context7 MCP.

When the plan is ready, wait for my explicit approval before executing the task.
Ask me clarifying questions about the task.

I now need to get the menu. The endpoint is GET `https://dataexchange.psweb.pro/api_v5/mobile/1-menu.pswjson`

This endpoint does not need `access_token` or `userID`

This endpoint is a bit weird. It outputs a raw binary file with a `pswjson` extension, but is in fact just a regular JSON file.

At this stage, only save the raw JSON output to a folder.

## Stage 4

Use Dart MCP. Use context7 MCP.

When the plan is ready, wait for my explicit approval before executing the task.
Ask me clarifying questions about the task.

I now need you iterate over all available orders and match each item within the order with the menu. Make a separate subcommand for it. For example, `"positionID":"615"` from the order should be matched to `"615":{"price":0,"weight":0,"id_menu":"615"` from the menu.

Look for the `menu.json` and `orders/` history in @bin/data

When successfully matched, print the name of the item (from menu's field `name`), price (from the order's field `price`), and amount (from the order's field `amount`) in a single line.

Pay attention that the name is in encoded UTF-8 (i.e. `\u041f\u0438\u0446\u0446\u0430 \u0411\u0435\u043b\u043e\u0440\u0443\u0441\u0441\u043a\u0430\u044f`). Make sure to convert it to regular text before printing to console.
