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
