import sys

def clearBlankLine(filename):
    file1 = open(filename, 'r', encoding='utf-8')
    afterLines = []
    try:
        pre = None
        finally_line = None
        for line in file1.readlines():
            finally_line = line
            if pre == None:
                pre = line
                continue
            lineStrip = line.strip()
            if pre.strip() == "" and lineStrip in ["", "[", "]", "{", "}", "(", ")"]:
                pre = line
                continue
            afterLines.append(pre)
            pre = line
        if finally_line != None and (not (pre.strip()=="" and finally_line.strip()=="")):
            afterLines.append(finally_line)
        with open(filename, "w", encoding='utf-8') as file2:
            file2.writelines(afterLines)
    finally:
        file1.close()


if __name__ == '__main__':
    if len(sys.argv) > 1:
        print("cleaning ", sys.argv[1])
        clearBlankLine(sys.argv[1])