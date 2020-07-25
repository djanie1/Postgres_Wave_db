--Q1
SELECT COUNT(u_id) FROM public.users; --This counts the total number of values found in the user id (u_id) column of the users table. Every user has a single and distinct u_id in the users table, so there is no need to include the DISTINCT clause

--Q2
SELECT COUNT(transfer_id) FROM public.transfers 
	WHERE send_amount_currency = 'CFA'; --This counts the total number of transactions which have been sent via wave in CFA.
	
--Q3
SELECT DISTINCT COUNT(u_id) FROM public.transfers
	WHERE send_amount_currency = 'CFA'; --This counts the total number of distinct users who sent money in CFA

--Q4
SELECT TO_CHAR(TO_DATE (EXTRACT(MONTH FROM when_created)::text, 'MM'), 'Month')	AS months, --This selects the months value and converts it to month string
	COUNT(atx_id) FROM public.agent_transactions 						--This counts the agent transactions
	WHERE EXTRACT(YEAR FROM agent_transactions.when_created) = 2018 	--This selects the agent transactions created done in the year 2018
	GROUP BY EXTRACT(MONTH FROM agent_transactions.when_created);		--This groups the extracted number of agent transactions in 2018 by the month in which they were done

--Q5
WITH agent_withdrawers AS
(SELECT COUNT (agent_id)
AS net_withdrawers
FROM agent_transactions 
HAVING COUNT (amount)
IN (SELECT COUNT (amount) FROM agent_transactions WHERE amount > -1 
AND amount !=0 HAVING COUNT (amount) > (SELECT COUNT(amount)
FROM agent_transactions WHERE amount < 1 AND  AMOUNT !=0)))
SELECT net_withdrawers
FROM agent_withdrawers;

--Q6
CREATE OR REPLACE VIEW atx_volume_city_summary AS 		--This creates a new table View which can be updated with columns without creating actual tables which will contain redundant data 
SELECT COUNT(atx_id) AS volume, city					--This counts the number of agent transactions and places labels it volume, and selects the city in which those transactions took place
FROM public.agent_transactions							
INNER JOIN public.agents ON agents.agent_id = agent_transactions.agent_id	--This relates the transactions done to the agent who performed those transactions
WHERE agent_transactions.when_created > now() -INTERVAL '7 days'			--This limits the query to select transactions which occurred within the past seven days, i.e, from the current date to 7days before
GROUP BY city;																--This groups the results by the city in which they were performed

--Q7
CREATE OR REPLACE VIEW atx_volume_city_summary AS  --This updates the new table View with columns without creating another table which will contain redundant data
SELECT COUNT(atx_id) AS volume, city, country		--This counts the number of agent transactions and places labels it volume, and selects the city and country in which those transactions took place
FROM public.agent_transactions
INNER JOIN public.agents ON agents.agent_id = agent_transactions.agent_id	--This relates the transactions done to the agent who performed those transactions
WHERE agent_transactions.when_created > now() -INTERVAL '7 days'		--This limits the query to select transactions which occurred within the past seven days, i.e, from the current date to 7days before
GROUP BY city, country;													--This groups the results by the city and country in which they were performed

--Q8
CREATE OR REPLACE VIEW send_volume AS
SELECT COUNT(atx_id) AS volume,kind,country
FROM public.agent_transactions,public.transfers, public.agents
WHERE agent_transactions.when_created>current_date -interval '7 days'
GROUP BY kind,country;

--Q9
CREATE OR REPLACE VIEW send_volume AS
SELECT COUNT(DISTINCT transfers.source_wallet_id) AS Unique_Senders,
COUNT(transfer_id) AS Transaction_count,
transfers.kind AS Transfer_Kind, wallets.ledger_location AS Country,
SUM(transfers.send_amount_scalar) AS Volume
FROM transfers INNER JOIN wallets
ON transfers.source_wallet_id = wallets.wallet_id
WHERE (transfers.when_created > (NOW() - INTERVAL '7 days'))
GROUP BY wallets.ledger_location, transfers.kind;

--Q10
SELECT transfers.source_wallet_id, sum( transfers.send_amount_scalar) AS total_sent FROM transfers	--This selects the source wallet id and sums up all values in the sent amount column
WHERE send_amount_currency = 'CFA'		--This selects amounts which were sent in CFA
    AND (transfers.when_created > (now() - INTERVAL '1 month'))	--This selects the transfers from the past month
    GROUP BY transfers.source_wallet_id							--This groups the transfers by the wallet used to make the transfers
    HAVING sum( transfers.send_amount_scalar)>10000000;			--This selects sums of transfers sent within the past month which have a value over 10,000,000 CFA
	
	
	

	
