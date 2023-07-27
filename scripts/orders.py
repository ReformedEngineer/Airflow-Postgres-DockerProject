import pandas as pd

# Load the CSV files into DataFrames
df_orders = pd.read_csv('raw_data/Orders.csv')
df_customers = pd.read_csv('processed_data/Customers.csv')

# Create a boolean Series that is True where 'unique_customer_id' in df_orders exists in df_customers
valid_customer_ids = df_orders['unique_customer_id'].isin(df_customers['unique_customer_id'])

# Keep only the rows in df_orders where 'unique_customer_id' exists in df_customers
df_orders = df_orders[valid_customer_ids]

# Write the DataFrame back to the CSV file
df_orders.to_csv('processed_data/Orders.csv', index=False)
