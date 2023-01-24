#This python file converts a csv of integers to a list of fxp seperated by lines.
#Length of each fxp is decided by n_word variable and fraction portion is decided by n_frac


from fxpmath import Fxp

#x = Fxp(5.625, signed=False, n_word=8, n_frac=4)
#print(x)         # float value
#print(x.bin())   # binary representation
#print(x.hex())   # hex repr
#print(x.val)     # raw val (decimal of binary stored)



with open(r".\noisy_sine_wave.txt",'r') as file:
    lines = file.readlines()

newLines = [""]
index = 0;
a = ""
for i in lines[0]:
    if i !="," and i != "\n":
        a += i
    else:
        temp = float(a)
        temp2 = Fxp(temp, signed=True, n_word = 16, n_frac = 4)
        newLines[index] += str(temp2.bin())
        newLines[index] += "\n"
        newLines.append("");
        index = index + 1
        a = ""

with open(r".\noisy_sine_wave.txt",'w') as file:
    file.writelines(newLines);
    

