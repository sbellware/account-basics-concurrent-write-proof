SELECT type, COUNT(type) FROM messages WHERE TYPE IN ('Deposit', 'Deposited') GROUP BY type;
