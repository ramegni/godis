# need_par state if parentheses needed around the left resp. right side of the operator op
# in the printout of the expression "(e1 op-left e2) op (e3 op-right e4)"
# need_par_left[
need_par_left  = {('*','+'): 1,
                  ('*','-'): 1,
                  ('/','+'): 1,
                  ('/','-'): 1,
                 }
need_par_right = {('-','+'): 1,
                  ('-','-'): 1,
                  ('*','+'): 1,
                  ('*','-'): 1,
                  ('/','+'): 1,
                  ('/','-'): 1,
                 }

class Exp():

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

    def __sub__(self, other):
        e = Exp(0)
        e.left = self
        e.right= other
        e.op = '-'
        e.typ = "binop"
        return(e)

    def __mul__(self, other):
        e = Exp(0)
        e.left = self
        e.right= other
        e.op = '*'
        e.typ = "binop"
        return(e)

    def __div__(self, other):
        e = Exp(0)
        e.left = self
        e.right= other
        e.op = '/'
        e.typ = "binop"
        return(e)

    def __str__(self):
        if self.typ == "leaf":
            return self.value.__str__()
        if self.typ == "binop":
            l = self.left.__str__()
            if self.left.typ == "binop":
                if (self.op, self.left.op) in need_par_left:
                    l = '(' + l + ')'
            r = self.right.__str__()
            if self.right.typ == "binop":
                if (self.op, self.right.op) in need_par_right:
                    r = '(' + r + ')'
            return "%s%s%s" % (l, self.op, r)

if __name__ == '__main__':
    e1 = Exp('x')
    e2 = Exp(5)
    e3 = e1 + e2
    e4 = e1 * e3
    e5 = e3 - e4
    print("e1 = %s" % e1)
    print("e2 = %s" % e2)
    print("e3 = %s" % e3)
    print("e4 = %s" % e4)
    print("e5 = %s" % e5)
