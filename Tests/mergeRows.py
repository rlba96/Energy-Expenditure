input_files = ['1tstamp.csv', 'Data_HR_RRI.csv']
output_file = 'dataset.csv'

output = None
for infile in input_files:
    with open(infile, 'r') as fh:
        if output:
            for i, l in enumerate(fh.readlines()):
                output[i] = "{},{}".format(output[i].rstrip('\n'), l)
        else:
            output = fh.readlines()

with open(output_file, 'w') as fh:
    for line in output:
        fh.write(line) 
