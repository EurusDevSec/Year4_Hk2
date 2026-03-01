def evaluate_f1_components(tp=2, fp=3, fn=4):
    if (type(tp) != "int" and type(fp) != "int" and type(fn) != "int"):

        print("fn must be int")
        exit()
    try:
        if tp >=0 and fp >=0 and fn >=0:
            

            prec = tp/(tp + fp)
            Recall = tp/(tp + fn)
            f1_score = 2 * (prec * Recall)/(prec + Recall)
        else:
            print("tp and fp and fn must be greater than or equal zero")
            exit()
    except ZeroDivisionError:
        print("khong duoc nhap so 0 ")
    pass

evaluate_f1_components()
