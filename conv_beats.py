data = """"""

for line in data.strip().splitlines():
    t, b, *_ = line.split(",")
    bpm = round(60 / (float(b) / 1000))
    print([int(t), bpm], end=",\n")
