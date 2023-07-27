import pandas as pd

# Load the CSV file into a DataFrame
df = pd.read_csv('raw_data/Coupons.csv')

# Add 'coupon_id' column
df['coupon_id'] = range(1, len(df) + 1)

# Specify the column order
columns = ['coupon_id'] + [col for col in df.columns if col != 'coupon_id']


df_orders = pd.read_csv('processed_data/Orders.csv')

# Create a boolean Series that is True where 'id' in df_orders exists in df
valid_order_ids = df['order_id'].isin(df_orders['id'])

# Keep only the rows in df_orders where 'unique_customer_id' exists in df_customers
df = df[valid_order_ids]

# Write the DataFrame back to the CSV file with the specified column order
df.to_csv('processed_data/Coupons.csv', columns=columns, index=False)
