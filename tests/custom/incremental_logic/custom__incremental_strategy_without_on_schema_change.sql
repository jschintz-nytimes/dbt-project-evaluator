{{ config(severity = env_var('DBT_PROJECT_EVALUATOR_SEVERITY', 'warn')) }}
/*
Incremental models should update if a new field is added.  
dbt needs to be configured for 'append_new_columns' or 'sync_all_columns' in most
cases.

A user could choose 'fail' to receive an alert that the model needs manual
adjustment.  Don't make life difficult though.

The default 'ignore' just builds tech debt

On schema change does not track nested column changes. 
https://docs.getdbt.com/docs/build/incremental-models#what-if-the-columns-of-my-incremental-model-change
*/

select 
    stg_nodes.unique_id,
    stg_nodes.name,
    stg_nodes.resource_type,
    stg_nodes.materialized,
    stg_nodes.on_schema_change,
    stg_nodes.incremental_strategy,
    stg_nodes.partition_by,
    stg_nodes.full_refresh
from {{ ref("stg_nodes") }}
where
    materialized = 'incremental'
    and ( on_schema_change not in ('append_new_columns', 'sync_all_columns', 'fail') 
            or on_schema_change is null
            )
