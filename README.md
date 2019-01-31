# Reproduction steps

1. Perform database setup and get dependencies:

```
./script/setup.sh
```

2. Start message consumer process:

```
./start-service.sh
```

3. Start one of message producers:

```
./script/produce-messages_1_long_transactions.sh
./script/produce-messages_2_batches_in_contention.sh
./script/produce-messages_3_message_in_contention.sh
```

4. Verify if number of Deposit messages equals number of Deposited. If not, you've experienced race condition in [get\_category\_messages](https://github.com/eventide-project/message-store-postgres-database/blob/1aa76c8b78b438ba439ff0f7db9cb2bc3e6ce1d9/database/functions/get-category-messages.sql#L26)

```
psql message_store < check_messages.sql
```

# Reproduction on video

The example illustrating long transactions (highest chance of race condition):
- https://v.usetapes.com/fFFLdpUS2t

The example illustraing uneven but short transactions (batches of 1-2 messages):
- https://v.usetapes.com/mipFBvNo8F
- https://v.usetapes.com/bAzuKpJQYr

The example illustrating most typical usage under high load:
- https://v.usetapes.com/gYxbsabA3D


# The problem exposed by the experiments:

![transactions_and_ids](https://user-images.githubusercontent.com/65587/30241715-2f09723e-9589-11e7-9f41-9868f6e794e1.png)

In such case we can get IDs of events 0 and 2, but skip reading uncommitted event nr 1.
