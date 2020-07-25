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