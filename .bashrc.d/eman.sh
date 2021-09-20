
eman ()
{
  emacs -nw --eval "(progn (man \"$1\") (delete-window))"
}
