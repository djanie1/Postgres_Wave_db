--Q1
SELECT COUNT(u_id) FROM public.users;

--Q2
SELECT COUNT(transfer_id) FROM public.transfers 
	WHERE send_amount_currency = 'CFA';
	
--Q3
SELECT DISTINCT COUNT(u_id) FROM public.transfers
	WHERE send_amount_currency = 'CFA';

--Q4
SELECT TO_CHAR(TO_DATE (EXTRACT(MONTH FROM when_created)::text, 'MM'), 'Month')	AS months, 
	COUNT(atx_id) FROM public.agent_transactions 
	WHERE EXTRACT(YEAR FROM agent_transactions.when_created) = 2018 
	GROUP BY EXTRACT(MONTH FROM agent_transactions.when_created);

--Q6
CREATE OR REPLACE VIEW atx_volume_city_summary AS
SELECT COUNT(atx_id) AS volume, city
FROM public.agent_transactions
INNER JOIN public.agents ON agents.agent_id = agent_transactions.agent_id
WHERE agent_transactions.when_created > now() -INTERVAL '7 days'
GROUP BY city;

--Q7
CREATE OR REPLACE VIEW atx_volume_city_summary AS
SELECT COUNT(atx_id) AS volume, city, country
FROM public.agent_transactions
INNER JOIN public.agents ON agents.agent_id = agent_transactions.agent_id
WHERE agent_transactions.when_created > now() -INTERVAL '7 days'
GROUP BY city, country;

--Q10
SELECT transfers.source_wallet_id, sum( transfers.send_amount_scalar) AS total_sent FROM transfers
WHERE send_amount_currency = 'CFA'
    AND (transfers.when_created > (now() - INTERVAL '10 month'))
    GROUP BY transfers.source_wallet_id
    HAVING sum( transfers.send_amount_scalar)>10000000