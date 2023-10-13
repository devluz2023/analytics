import pyodbc

conn_str = (
    r'DRIVER={ODBC Driver 17 for SQL Server};'
    r'SERVER=172.172.176.175;'  # Your SQL Server IP Address
    r'DATABASE=master;'  # Replace with your database name
    r'UID=sa;'  # Replace with your username
    r'PWD=vale@123;'  # Replace with your password
)

connection = pyodbc.connect(conn_str)
cursor = connection.cursor()
cursor.execute("SELECT @@version;")
row = cursor.fetchone()
if row:
    print(row)
