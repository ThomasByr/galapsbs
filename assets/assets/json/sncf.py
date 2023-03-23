import pandas as pd
import json

# Read the Excel file into a pandas DataFrame
df = pd.read_excel("sncf.xlsx", sheet_name="Feuil1", header=None)

# Rename the columns
df.columns = ['Table', 'Name1', 'Name2', 'Starter', 'Main', 'Dessert']

# Group the data by Table
grouped = df.groupby('Table')

# Initialize the list that will store the JSON data
tables = []

# Loop through each group (i.e. each Table)
for name, group in grouped:
  table = {
      'id':
          int(name),
      'seats': [{
          'name': f"{row['Name1']} {row['Name2']}",
          'menu': {
              'starter': row['Starter'],
              'main': row['Main'],
              'dessert': row['Dessert']
          }
      } for _, row in group.iterrows()]
  }
  tables.append(table)

# Convert the list of tables to a JSON object
json_data = {'sncf': tables}

# Write the JSON data to a file
with open('sncf.json', 'w') as f:
  f.write(json.dumps(json_data, indent=4))
