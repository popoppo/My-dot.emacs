(defun declare-class ()
  (interactive)
  (setq class (read-from-minibuffer "Class name : " nil ))
  (setq super (read-from-minibuffer "Super class : " nil ))
  (insert (format "
class %s : public %s
{
  public:
	%s();
	virtual ~%s();
};
" class super class class)))

(defun define-method ()
  (interactive)
  
)

class test : public super
{
public:
	test();
	virtual ~test();

	int methodA(char *c, int i, double *d);
}




  
