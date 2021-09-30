select 
    date_trunc('week', load_date) AS first_dow_ts,
    status AS status,
    count(*) AS orders_cnt
from 
    {{ ref('sat_order_details') }}
group by
    date_trunc('week', load_date),
    status