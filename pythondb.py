import psycopg2

def db_connection():
    return psycopg2.connect(
        host="localhost",
        port="5432",
        database="dictdb",
        user="postgres",
        password="pac112") 

def read_dict():
    dbconn = db_connection()
    cur = dbconn.cursor()
    cur.execute("SELECT id, word, translation FROM dictionary;")
    rows = cur.fetchall()
    cur.close()
    dbconn.close()
    return rows


while True: ## REPL - Read Execute Program Loop
    cmd = input("Command: ")
    if cmd == "quit":
        exit()
    elif cmd == "list":
        pass
    elif cmd == "add":
        pass
    elif cmd == "delete":
        pass
    else:
        print("Incorrect command. [list/add/delete/quit]")
        continue

    # elif cmd == 'p':
    #     print(list(read_dict()))