import os


os.system("flex scanner.l")
os.system("gcc lex.yy.c")

for i in os.listdir("./lexer-tests"):
    print(i)
    fullpath = "./lexer-tests/"+i
    os.system(f"./a.out {fullpath}")
    print("----------------------------------------------------------------------------------")
