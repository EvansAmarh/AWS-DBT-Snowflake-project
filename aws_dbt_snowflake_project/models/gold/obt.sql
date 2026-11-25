{% set configs = [
    {
        "table": ref('silver_bookings'),
        "alias": "silver_bookings",
        "columns": ["BOOKING_ID", "LISTING_ID", "BOOKING_DATE", "TOTAL_BOOKING_AMOUNT",
                    "CLEANING_FEE", "SERVICE_FEE", "TOTAL_AMOUNT", "BOOKING_STATUS",
                    "CREATED_AT AS BOOKING_CREATED_AT"]
    },
    {
        "table": ref('silver_listings'),
        "alias": "silver_listings",
        "columns": ["HOST_ID", "PROPERTY_TYPE", "ROOM_TYPE", "CITY", "COUNTRY", "ACCOMMODATES",
                    "BEDROOMS", "BATHROOMS", "PRICE_PER_NIGHT", "PRICE_PER_NIGHT_TAG",
                    "CREATED_AT AS LISTING_CREATED_AT"],
        "join_condition": "silver_bookings.listing_id = silver_listings.listing_id"
    },
    {
        "table": ref('silver_hosts'),
        "alias": "silver_hosts",
        "columns": ["HOST_NAME", "HOST_SINCE", "IS_SUPERHOST", "RESPONSE_RATE",
                    "RESPONSE_RATE_QUALITY", "CREATED_AT AS HOST_CREATED_AT"],
        "join_condition": "silver_listings.host_id = silver_hosts.host_id"
    }
] %}

SELECT
{%- for config in configs %}
  {%- set outer_last = loop.last %}
  {%- for col in config['columns'] %}
    {{ config['alias'] }}.{{ col }}{% if not (outer_last and loop.last) %},{% endif %}
  {%- endfor %}
{%- endfor %}
FROM
{%- for config in configs %}
  {%- if loop.first %}
  {{ config['table'] }} AS {{ config['alias'] }}
  {%- else %}
  LEFT JOIN {{ config['table'] }} AS {{ config['alias'] }}
    ON {{ config['join_condition'] }}
  {%- endif %}
{%- endfor %}
