import pandas as pd

# Load the CSV file into a DataFrame
df = pd.read_csv('raw_data/Customers.csv', dtype={'contact_no': str, 'email':str})

# Drop rows where 'unique_customer_id' is NaN
df = df.dropna(subset=['unique_customer_id'])

# Convert unique_customer_id to integer
df['unique_customer_id'] = df['unique_customer_id'].astype(int)

# Convert 'first_order' to datetime and format as YYYY-MM-DD HH:MI:SS
df['first_order'] = pd.to_datetime(df['first_order'], format='%d/%m/%Y %H:%M:%S').dt.strftime('%Y-%m-%d %H:%M:%S')

# Create separate DataFrames for each table
df_customers = df[['unique_customer_id', 'first_order']].drop_duplicates().dropna()
df_emails = df[['unique_customer_id', 'email']].drop_duplicates().dropna()
df_contact_numbers = df[['unique_customer_id', 'contact_no']].drop_duplicates().dropna()

# Add an 'email_id' column
df_emails['email_id'] = range(1, len(df_emails) + 1)
df_contact_numbers['contact_id'] = range(1, len(df_contact_numbers) + 1)

# Write each DataFrame to a separate CSV file with the columns in the correct order
df_customers.to_csv('processed_data/Customers.csv', columns=['unique_customer_id', 'first_order'], index=False)
df_emails.to_csv('processed_data/Emails.csv', columns=['email_id','email', 'unique_customer_id'], index=False)
df_contact_numbers.to_csv('processed_data/ContactNumbers.csv', columns=['contact_id','contact_no', 'unique_customer_id'], index=False)
