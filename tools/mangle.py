import subprocess
import re
import sys

def main(name, rettype=None):
    # Разбиваем строку по '::'
    array = name.split("::")
    indexes = list(range(len(array)))

    if not rettype:
        rettype = "void"

    prefix = ""
    middle = ""
    suffix = ""

    for index in indexes:
        if index == indexes[-1]:
            middle = f"{rettype} {array[index]};"
        elif array[index]:
            prefix += f"struct {array[index]}" + "{"
            suffix = "};" + suffix


    code = f"{prefix}{middle}{suffix} {rettype} {name}{{}}"
    print(code)

    try:
        proc = subprocess.run(
            ["clang++", "-x", "c++", "-S", "-", "-o", "-"],
            input=code.encode(),
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=True,
        )
    except subprocess.CalledProcessError as e:
        print("Ошибка компиляции:")
        print(e.stderr.decode())
        sys.exit(1)

    asm_output = proc.stdout.decode()
    #print(asm_output)

    # grep "^_.*:$" | sed 's/:$//'
    pattern = re.compile(r"(?=(_[^\s~]+:))", re.MULTILINE)
    matches = pattern.findall(asm_output)

    for label in matches:
        print(label.rstrip(":"))

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Использование: python script.py <name> [rettype]")
        sys.exit(1)

    name = sys.argv[1]
    rettype = sys.argv[2] if len(sys.argv) > 2 else None

    main(name, rettype)
