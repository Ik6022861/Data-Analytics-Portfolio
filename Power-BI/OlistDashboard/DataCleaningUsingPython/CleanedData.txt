import pandas as pd
import pyodbc
import re

# ==========================================
# SQL Server Connection
# ==========================================

server = "localhost"
database = "campusx_project2"

conn = pyodbc.connect(
    f"DRIVER={{ODBC Driver 17 for SQL Server}};"
    f"SERVER={server};"
    f"DATABASE={database};"
    "Trusted_Connection=yes;"
)

# ==========================================
# Load Customers Table
# ==========================================

query = """
SELECT *
FROM olist_customers_dataset
"""

customers = pd.read_sql(query, conn)

# ==========================================
# Data Cleaning
# ==========================================

# Convert city names to Title Case
customers["customer_city"] = customers["customer_city"].str.title()

# Remove unwanted special symbols while keeping
# letters, accented letters, numbers, spaces,
# apostrophes and hyphens.
customers["customer_city"] = (
    customers["customer_city"]
    .astype(str)
    .str.replace(r"[^A-Za-zÀ-ÿ0-9\s'\-]", "", regex=True)
    .str.strip()
)

# Remove unnecessary column
customers.drop(columns=["customer_unique_id"], inplace=True)

# ==========================================
# Final Table for Power BI
# ==========================================

customers



--------------------------------------------------------------------------


import pandas as pd
import pyodbc
import re
import html
from unidecode import unidecode

# ==========================================
# SQL Server Connection
# ==========================================

server = "localhost"
database = "campusx_project2"

conn = pyodbc.connect(
    f"DRIVER={{ODBC Driver 17 for SQL Server}};"
    f"SERVER={server};"
    f"DATABASE={database};"
    "Trusted_Connection=yes;"
)

# ==========================================
# Load Geolocation Table
# ==========================================

query = """
SELECT *
FROM olist_geolocation_dataset
"""

geo = pd.read_sql(query, conn)

# ==========================================
# Data Cleaning
# ==========================================

# Title Case
geo["geolocation_city"] = geo["geolocation_city"].str.title()

# Remove duplicate rows
geo.drop_duplicates(inplace=True)

# Remove unnecessary columns
geo.drop(
    columns=[
        "geolocation_lat",
        "geolocation_lng"
    ],
    inplace=True
)

# Remove accents
geo["geolocation_city"] = geo["geolocation_city"].apply(unidecode)

# Remove numbers from city names
geo["geolocation_city"] = geo["geolocation_city"].str.replace(
    r"\d+",
    "",
    regex=True
)

# Remove apostrophes
geo["geolocation_city"] = geo["geolocation_city"].str.replace(
    "'",
    "",
    regex=False
)

# Remove asterisks
geo["geolocation_city"] = geo["geolocation_city"].str.replace(
    "*",
    "",
    regex=False
)

# Remove ellipsis
geo["geolocation_city"] = geo["geolocation_city"].str.replace(
    "...",
    "",
    regex=False
)

# General city cleaning
def clean_city(text):

    if isinstance(text, str):

        text = html.unescape(text)

        text = re.sub(
            r"[^A-Za-zÀ-ÿ0-9\s()-]",
            "",
            text
        )

        text = re.sub(
            r"\s+",
            " ",
            text
        ).strip()

    return text


geo["geolocation_city"] = geo["geolocation_city"].apply(clean_city)

# Manual corrections
geo["geolocation_city"] = geo["geolocation_city"].replace(
    {
        "Sao Joao Do Pau D Alho": "Sao Joao Do Pau DAlho",
        "Sao Joao Do Pau DAposBalho": "Sao Joao Do Pau DAlho",
    }
)

# Remove duplicates after cleaning
geo.drop_duplicates(inplace=True)

# ==========================================
# Final Table for Power BI
# ==========================================

geo


-------------------------------------------------------------------------------

import pandas as pd
import pyodbc

# ==========================================
# SQL Server Connection
# ==========================================

server = "localhost"
database = "campusx_project2"

conn = pyodbc.connect(
    f"DRIVER={{ODBC Driver 17 for SQL Server}};"
    f"SERVER={server};"
    f"DATABASE={database};"
    "Trusted_Connection=yes;"
)

# ==========================================
# Load Products Table
# ==========================================

products = pd.read_sql(
    "SELECT * FROM olist_products_dataset",
    conn
)

# ==========================================
# Remove Unnecessary Columns
# ==========================================

products.drop(
    columns=[
        "product_name_lenght",
        "product_description_lenght",
        "product_weight_g",
        "product_length_cm",
        "product_height_cm",
        "product_width_cm"
    ],
    inplace=True
)

# ==========================================
# Load Translation Table
# ==========================================

product_translation = pd.read_sql(
    "SELECT * FROM product_category_name_translation",
    conn
)

# Remove unwanted first row
product_translation = (
    product_translation
    .drop(index=0)
    .reset_index(drop=True)
)

# ==========================================
# Merge English Category Names
# ==========================================

products = products.merge(
    product_translation,
    left_on="product_category_name",
    right_on="Product Category",
    how="left"
)

# ==========================================
# Fix Missing Translations
# ==========================================

translation_fix = {
    "beleza_saude": "health_beauty",
    "pc_gamer": "gaming_pc",
    "portateis_cozinha_e_preparadores_de_alimentos": "kitchen_appliances"
}

products["product category in english"] = (
    products["product category in english"]
    .fillna(
        products["product_category_name"].map(translation_fix)
    )
)

# Replace Portuguese category with English
products["product_category_name"] = (
    products["product category in english"]
)

# Remove helper columns
products.drop(
    columns=[
        "Product Category",
        "product category in english"
    ],
    inplace=True
)

# ==========================================
# Final Table for Power BI
# ==========================================

products


----------------------------------------------------------------------------------


import pandas as pd
import pyodbc

# ==========================================
# SQL Server Connection
# ==========================================

server = "localhost"
database = "campusx_project2"

conn = pyodbc.connect(
    f"DRIVER={{ODBC Driver 17 for SQL Server}};"
    f"SERVER={server};"
    f"DATABASE={database};"
    "Trusted_Connection=yes;"
)

# ==========================================
# Load Sellers Table
# ==========================================

seller = pd.read_sql(
    "SELECT * FROM olist_sellers_dataset",
    conn
)

# ==========================================
# Data Cleaning
# ==========================================

# Convert city names to Title Case
seller["seller_city"] = seller["seller_city"].str.title()

# Remove duplicate rows
seller.drop_duplicates(inplace=True)

# ==========================================
# Final Table for Power BI
# ==========================================

seller


------------------------------------------------------------------------------------

import pandas as pd
import pyodbc

# ==========================================
# SQL Server Connection
# ==========================================

server = "localhost"
database = "campusx_project2"

conn = pyodbc.connect(
    f"DRIVER={{ODBC Driver 17 for SQL Server}};"
    f"SERVER={server};"
    f"DATABASE={database};"
    "Trusted_Connection=yes;"
)

# ==========================================
# Load Orders
# ==========================================

orders = pd.read_sql(
    "SELECT * FROM olist_orders_dataset",
    conn
)

# ==========================================
# Clean Orders
# ==========================================

# Remove invalid date sequences
orders = orders[
    ((orders["order_approved_at"] - orders["order_purchase_timestamp"]).dt.total_seconds() / 86400 >= 0)
    &
    ((orders["order_delivered_carrier_date"] - orders["order_approved_at"]).dt.days >= 0)
]

# Remove canceled orders that were delivered
orders = orders.drop(
    orders[
        (orders["order_status"] == "canceled")
        &
        (orders["order_delivered_customer_date"].notna())
    ].index
)

# ==========================================
# Load Payments
# ==========================================

payments = pd.read_sql(
    "SELECT * FROM olist_order_payments_dataset",
    conn
)

payments.drop(
    columns=[
        "payment_sequential",
        "payment_installments"
    ],
    inplace=True
)

payments = (
    payments
    .groupby(
        ["order_id", "payment_type"],
        as_index=False
    )
    .sum()
)

# Merge Payments
orders = orders.merge(
    payments,
    on="order_id",
    how="inner"
)

# ==========================================
# Load Order Items
# ==========================================

order_items = pd.read_sql(
    "SELECT * FROM olist_order_items_dataset",
    conn
)

orders = orders.merge(
    order_items,
    on="order_id",
    how="inner"
)

# ==========================================
# Remove Invalid Shipping Dates
# ==========================================

orders = orders[
    (orders["shipping_limit_date"] > orders["order_purchase_timestamp"])
    &
    (orders["shipping_limit_date"] > orders["order_approved_at"])
    &
    (orders["shipping_limit_date"] < orders["order_delivered_customer_date"])
]

# Remove unnecessary column
orders.drop(
    columns="order_item_id",
    inplace=True
)

# ==========================================
# Aggregate Multiple Order Items
# ==========================================
orders = orders.groupby(
    ['order_id', 'customer_id', 'order_status', 'order_purchase_timestamp',
     'order_approved_at', 'order_delivered_carrier_date',
     'order_delivered_customer_date', 'order_estimated_delivery_date',
     'payment_type', 'payment_value', 'product_id', 'seller_id',
     'shipping_limit_date']
).agg(
    price=("price", "sum"),
    freight_value=("freight_value", "sum"),
    Quantity=("product_id", "count")
).reset_index()

# ==========================================
# Final Table for Power BI
# ==========================================

orders


-----------------------------------------------------------------------------------


import pandas as pd
import pyodbc

# ==========================================
# SQL Server Connection
# ==========================================

server = "localhost"
database = "campusx_project2"

conn = pyodbc.connect(
    f"DRIVER={{ODBC Driver 17 for SQL Server}};"
    f"SERVER={server};"
    f"DATABASE={database};"
    "Trusted_Connection=yes;"
)

query = "SELECT * FROM olist_order_reviews_dataset"
reviews = pd.read_sql(query, conn)

# Final Reviews Table
reviews = reviews[[
    "review_id",
    "order_id",
    "review_score",
    "review_creation_date",
    "review_answer_timestamp"
]]

reviews.head()


--------------------------------------------------------------