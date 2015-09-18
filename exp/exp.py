class Exp():

    value = ()
    def __init__(self, e):
        self.typ = "leaf"
        self.value = e

    def __add__(self, other):
        e = Exp(0)
        e.left = self
        e.right= other
        e.op = '+'
        e.typ = "binop"
        return(e)

    def __str__(self):
        if self.typ == "leaf":
            return self.value.__str__()
        if self.typ == "binop":
            return "(%s)%s(%s)" % (self.left.__str__(), self.op, self.right.__str__())

e1 = Exp('x')
e2 = Exp(5)

e3 = e1 + e2;

print("e1 = %s" % e1)
print("e2 = %s" % e2)
print("e3 = %s" % e3)

e4 = e1 + 7
print("e4 = %s" % e4)
