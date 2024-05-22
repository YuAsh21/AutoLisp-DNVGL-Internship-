(defun-q C:PLINEDOT( / olducf oldcmd olderr worldu ans
                       edata 10list eset iplist add2ip point
                   )
 (setq olducf (getvar "ucsfollow") oldcmd (getvar "cmdecho") olderr *error*)
 (setvar "ucsfollow" 0)
 (setvar "cmdecho" 0)
 (setq worldu nil)
 (if (= 0 (getvar "worlducs"))
  (command "ucs" "world")
  (setq worldu T)
 )
 (if (null debugg)
  (defun-q *error*(msg)
   (if msg
    (if (null (member msg (list "Function cancelled")))
     (princ (strcat "\nERROR: " msg ". "))
    )
   )
   (if (null worldu)
    (command "ucs" "p")
   )
   (setvar "cmdecho" oldcmd)
   (setvar "ucsfollow" olducf)
   (setq *error* olderr)
   (prin1)
  )
 )
 (defun-q add2ip(point / OK epoint )
  (setq OK T)
  (foreach epoint iplist
   (if (> (* 0.01 plinedot_radius)(distance epoint point))
    (setq OK nil)
   )
  )
  (if OK
   (setq iplist (cons point iplist))
  )
 )  
 (if (numberp plinedot_radius)
  (if (<= plinedot_radius 0.0)
   (setq plinedot_radius nil)
  )
  (setq plinedot_radius nil)
 )
 (if plinedot_radius
  (progn
   (initget 6)
   (if
    (setq ans
     (getreal
      (strcat "\nEnter circle radius <" (rtos plinedot_radius 2 4) ">: ")
     )
    )
    (setq plinedot_radius ans)
   )
  )
  (progn
   (initget 7)
   (setq plinedot_radius (getreal "\nEnter circle radius: "))
  )
 )
 (setq iplist nil) ; list of insertion points of circles
 (princ "\nSelect LINES, ARCS, POLYLINES and LWPOLYLINES: ")
 (if
  (setq eset
   (ssget
    (list
     (cons -4 "<or")
      (cons 0 "LINE")
      (cons 0 "POLYLINE")
      (cons 0 "LWPOLYLINE")
      (cons 0 "ARC")
     (cons -4 "or>")
    )
   )
  )
  (progn
   (princ (strcat "\n" (itoa (sslength eset)) " entities selected..."))
   ; compile IPLIST, list of unique points
   (foreach edata (ss2edl eset)
    (cond
     ((= (cdr (assoc 0 edata)) "POLYLINE")
      (setq loop T vname (cdr (assoc -1 edata)))
      (while loop
       (if (setq vname (entnext vname))
        (if (= "SEQEND" (cdr (assoc 0 (setq vdata (entget vname)))))
         (setq loop nil)
         (add2ip (cdr (assoc 10 vdata)))
        )
        (setq loop nil)
       )
      )
     )
     ((= (cdr (assoc 0 edata)) "LWPOLYLINE")
      (while (setq 10list (assoc 10 edata))
       (add2ip (cdr 10list))
       (setq edata (cdr (member 10list edata)))
      )
     )
     ((= (cdr (assoc 0 edata)) "LINE")
      (add2ip (cdr (assoc 10 edata)))
      (add2ip (cdr (assoc 11 edata)))
     )
     ((= (cdr (assoc 0 edata)) "ARC")
      (add2ip (polar (cdr (assoc 10 edata))(cdr (assoc 50 edata))(cdr (assoc 40 edata))))
      (add2ip (polar (cdr (assoc 10 edata))(cdr (assoc 51 edata))(cdr (assoc 40 edata))))
     )
     (T (princ "I thought we filtered out everything but LINES, ARCS, POLYLINES and LWPOLYLINES!  What gives? "))
    )
   ) ; end foreach
   ; now draw circles at each point in IPLIST
   (foreach point iplist
    (command "circle" point plinedot_radius)
   )
   (if dos_beep
    (dos_beep 550 125)
   )
   (princ (strcat "Done! " (itoa (length iplist)) " circles drawn. "))
   (setq eset nil)
  ) ; end progn
  (princ "\nNo ARCS, LINES or POLYLINES selected. ")
 )
 (*error* nil)
 (princ "\nOperation finished. Thank you very much. Terrible Software inc.\n")
 (prin1)
)