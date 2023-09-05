import psycopg2

def db_connection():
    return psycopg2.connect(
        host="localhost",
        port="5432",
        database="dictdb",
        user="postgres",
        password="pac112") 

def read_dict():
    # borde kanske finnas hantering av exceptions här men har inte hunnit
    dbconn = db_connection()
    cur = dbconn.cursor()
    cur.execute("SELECT id, word, translation FROM dictionary;")
    rows = cur.fetchall()
    cur.close()
    dbconn.close()
    return rows


def add_to_dict(eng_word, swe_translation):
    # borde kanske finnas hantering av exceptions här men har inte hunnit
    dbconn = db_connection()
    cur = dbconn.cursor()
    cur.execute("INSERT INTO dictionary (word, translation) VALUES (%s, %s);",
        (eng_word, swe_translation))
    cur.execute("COMMIT;")
    cur.close()
    dbconn.close()
    print(f"An entry was made - {eng_word} : {swe_translation}")

def delete_from_dict(eng_word):
    # borde kanske finnas hantering av exceptions här men har inte hunnit
    dbconn = db_connection()
    cur = dbconn.cursor()
    cur.execute("DELETE FROM dictionary WHERE word = '{}';".format(eng_word))
    cur.execute("COMMIT;")
    cur.close()
    dbconn.close()
    print(f"A deletion was made - {eng_word}")


while True: ## REPL - Read Execute Program Loop
    cmd = input("Command: ")
    if cmd == "quit":
        exit()
    elif cmd == "list":
        information = list(read_dict())
        print("")
        for word in information:
            print(f"{word[1]} : {word[2]}")
        print("")
    elif cmd == "add":
        english_word = input("Input English word: ")
        swe_translation = input("Input Swedish translation: ")
        add_to_dict(english_word, swe_translation)
    elif cmd == "delete":
        english_word = input("Enter the english word you want to remove from the dictionary: ")
        delete_from_dict(english_word)
    else:
        print("Incorrect command. [list/add/delete/quit]")
        continue
