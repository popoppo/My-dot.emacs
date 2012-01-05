#!/usr/bin/env python
#
# py_imenu.py: "better" (more precise, but potentially slower) Imenu support
#              for python, using the compiler package
#
# author: Alberto Griggio
#

from Pymacs import lisp
import compiler


class ImenuVisitor:
    def __init__(self):
        self.classes = {}
        self.functions = self.classes['*Functions*'] = []
        self.globals = []
        self.global_vars = set()
        self.imports = []

    def to_point(self, line):
        lisp.goto_char(lisp.point_min())
        return lisp.point_at_bol(line)

    def imenu_info(self, name, lineno):
        return (name, self.to_point(lineno))

    def visitImport(self, node, cur_class=None):
        if cur_class is None:
            for name, alias in node.names:
                if alias: name += ' as ' + alias
                self.imports.append(self.imenu_info(name, node.lineno))

    def visitFrom(self, node, cur_class=None):
        if cur_class is None:
            symbols = []
            for name, alias in node.names:
                if alias: name += ' as ' + alias
                symbols.append(name)
            name = ', '.join(symbols) + ' from ' + node.modname
            self.imports.append(self.imenu_info(name, node.lineno))

    def visitClass(self, node, cur_class=None):
        if cur_class is None:
            info = self.imenu_info("class " + node.name, node.lineno)
            self.classes[node.name] = [info]
            for c in node.getChildNodes():
                self.visit(c, node.name)

    def visitFunction(self, node, cur_class=None):
        if cur_class is None:
            cur_class = '*Functions*'
        infos = self.classes.setdefault(cur_class, [])
        infos.append(self.imenu_info("def " + node.name, node.lineno))

    def visitAssign(self, node, cur_class=None):
        def do_add(n):
            cn = n.__class__.__name__
            if cn not in ('AssName', 'AssTuple'):
                return
            try:
                if n.name not in self.global_vars:
                    self.globals.append(self.imenu_info(n.name, n.lineno))
                    self.global_vars.add(n.name)
            except AttributeError:
                for c in n.nodes:
                    do_add(c)
        if cur_class is None:
            for n in node.nodes:
                do_add(n)                    

    def to_imenu(self):
        # everything done in reverse order (because lisp.cons adds in front of
        # the list, not at the end)
        menu = lisp.nil
        # functions
        for n, p in sorted(self.functions, reverse=True):
            menu = lisp.cons(lisp.cons(n, p), menu)
        del self.classes['*Functions*']
        # classes
        for name in sorted(self.classes, reverse=True):
            entries = lisp.nil
            for n, p in sorted(self.classes[name], reverse=True):
                entries = lisp.cons(lisp.cons(n, p), entries)
            menu = lisp.cons(lisp.cons("class " + name, entries), menu)
        # global variables
        g = lisp.nil
        for n, p in sorted(self.globals, reverse=True):
            g = lisp.cons(lisp.cons(n, p), g)
        if g is not lisp.nil:
            menu = lisp.cons(lisp.cons("*Globals*", g), menu)        
        # import statements
        imp = lisp.nil
        for n, p in sorted(self.imports, reverse=True):
            imp = lisp.cons(lisp.cons(n, p), imp)
        if imp is not lisp.nil:
            menu = lisp.cons(lisp.cons("*Imports*", imp), menu)
        return menu

##     def to_imenu(self):
##         menu = []
##         for name in sorted(self.classes):
##             if name == '*Functions*':
##                 continue # handled later
##             entries = [lisp.cons(n, p) for n, p in
##                        sorted(self.classes[name])] 
##             menu.append(lisp.cons("class " + name, entries))
            
##         functions = [lisp.cons(n, p) for n, p in
##                      sorted(self.classes['*Functions*'])]
##         menu.extend(functions)
##         return menu


# end of class ImenuVisitor


def make_imenu():
##     import time
##     start = time.time()
    ast = compiler.parse(lisp.buffer_string() + '\n')
    visitor = ImenuVisitor()
    compiler.walk(ast, visitor)
    ret = visitor.to_imenu()
##     end = time.time()
##     lisp.message("Total time: %f" % (end - start))
    return ret
