import pandas as pd

import chardet

# Detect the encoding
with open('raw_data/Stores.csv', 'rb') as f:
    result = chardet.detect(f.read())
    
encoding = result['encoding']

# Load the CSV file into a DataFrame
df = pd.read_csv('raw_data/Stores.csv',encoding=encoding)

# Write the DataFrame to a new CSV file with UTF-8 encoding
df.to_csv('processed_data/Stores.csv', index=False, encoding='utf-8')