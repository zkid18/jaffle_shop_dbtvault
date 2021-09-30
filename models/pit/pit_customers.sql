{{
    config(
        enabled=True
    )
}}

{%- set source_model = "hub_customer" -%}
{%- set src_pk = "CUSTOMER_PK" -%}
{%- set src_ldts = "LOAD_DATE" -%}
{%- set satellites = { "sat_customer_details": {"pk":{"pk": src_pk }, "ldts":{"ldts":src_ldts}}} -%}
{%- set stage_tables = ["v_stg_customers"] -%}
{%- set as_of_dates_table = "as_of_date" -%}


with pit_temp AS (
    {{ dbtvault.pit(source_model=source_model, src_pk=src_pk,
                    as_of_dates_table=as_of_dates_table,
                    satellites=satellites,
                    stage_tables=stage_tables,
                    src_ldts=src_ldts) }}
)

select as_of_date,sat_customer_details_ldts,first_name,last_name,email
from pit_temp, {{ ref('sat_customer_details') }}
where pit_temp.customer_pk = {{ ref('sat_customer_details') }}.customer_pk
and pit_temp.sat_customer_details_ldts = {{ ref('sat_customer_details') }}.load_date