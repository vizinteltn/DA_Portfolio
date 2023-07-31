#TASK - join conversion rate sessions and orders by utm content tables
use mavenfuzzyfactory;
select 
website_sessions.utm_content,
count(distinct website_sessions.website_session_id) as sessions,
count(distinct orders.order_id) as orders,
count(distinct orders.order_id)/count(distinct website_sessions.website_session_id) as session_to_order_conv_rt

from website_sessions 
left join orders
on orders.website_session_id=website_sessions.website_session_id

where website_sessions.website_session_id between 1000 and 2000

group by website_sessions.utm_content
order by sessions desc
;

#TASK - break sessions by utm_source, utm_campaign, http_referer
use mavenfuzzyfactory;
select 
utm_source,
utm_campaign,
http_referer,
count(distinct website_session_id) as sessions

from website_sessions 
where created_at<'2012-04-12'
group by utm_source, utm_campaign, http_referer
order by sessions desc
;

#TASK - orders to sessions rate
use mavenfuzzyfactory;
SELECT 
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS orders_to_sessions_conv_rt
FROM
    website_sessions
        LEFT JOIN
    orders ON orders.website_session_id = website_sessions.website_session_id
WHERE
    website_sessions.created_at < '2012-04-14'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
;

#TASK - nonbrand sessions by volume, by week
use mavenfuzzyfactory;
SELECT 
    #year(created_at) as year,
    #week(created_at) as week,
    MIN(DATE(created_at)) AS week_start_date,
    COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE created_at < '2012-05-12'
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
group by year(created_at), week(created_at)
;

#TASK - join - conv rate by device type
use mavenfuzzyfactory;
select 
count(distinct website_sessions.website_session_id) as sessions,
count(distinct orders.order_id) as orders,
count(distinct orders.order_id)/count(distinct website_sessions.website_session_id) as session_to_order_conv_rt

from website_sessions 
left join orders
on orders.website_session_id=website_sessions.website_session_id

WHERE website_sessions.created_at < '2012-05-11'
	AND website_sessions.utm_source = 'gsearch'
	AND website_sessions.utm_campaign = 'nonbrand'

group by website_sessions.device_type
order by sessions desc
;

#TASK - sessions by week and pivoted (columns added) by device type
use mavenfuzzyfactory;
SELECT 
    #year(created_at) as year,
    #week(created_at) as week,
    MIN(DATE(created_at)) AS week_start_date,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN website_session_id ELSE NULL END) AS dtop_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mod_sessions
FROM website_sessions
WHERE created_at > '2012-04-15'
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
group by year(created_at), week(created_at)
;

