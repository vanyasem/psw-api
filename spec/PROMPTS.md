# Claude Code prompts

1) Read @PLAN.md and follow the instructions for Stage 1
2)

```text
1) Put the dart package in `bin`, and the rest of the code in `lib`
2) Output folder should be at the current working directory, in `data/orders`
3) Output filename should be `<orderID>.json`
4) Skip already downloaded orders
5) No concurrency needed
6) Skip and continue on error
7) Create an `.env.example` with empty values
8)  Dart SDK constraint is `sdk: '>=3.11.0 <4.0.0'`
```

3) Read @PLAN.md and follow the instructions for Stage 2
4) Read @PLAN.md and follow the instructions for Stage 3
5)

```text
1) Run menu fetch as a separate subcommand. Make refresh menu & get orders two different subcommands. By default (if no command specified) print the usage guide.
2) Output the file as `data/menu.json`
3) Always re-fetch and overwrite
4) Not applicable due to menu fetch being a separate subcommand
```

6) Read @PLAN.md and follow the instructions for Stage 4
