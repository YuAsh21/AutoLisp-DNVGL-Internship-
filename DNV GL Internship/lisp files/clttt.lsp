(defun c:CLTTT (/ pnt txt ent ss pt ls no edges)
  (while (setq pnt (getpoint "\nSpecify center point for circle <exit>: "))
    (command-s "_.CIRCLE" "_none" pnt)
    (command ".dtext" "j" "mc" pause "" "")
  	(princ)
    (if (setq pnt (getpoint "\nSpecify first point for line <no line>: "))
      (command "_.LINE" "_none" pnt PAUSE ""))
  (princ)
(prompt "\nSelect cutting edges..")
	(setq edges (ssget))
	(prompt "\nSelect object(s) to trim: ")
	(setq	ss (ssget)
		pt (getpoint "\nSide to trim: ")
		ls (sslength ss)
		no -1)
	(command "trim" edges "")
	(repeat ls
		(setq no (1+ no))
		(command (list (ssname ss no) pt))
	)
	(command "")
	(princ)
)
)