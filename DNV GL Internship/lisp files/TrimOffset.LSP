;;;=====================================================
(defun Trim_Offset
       (/		  active_document
				     centr	  ep1
				     ep2	  delta_x
				     delta_y	  active_selectionset
				     list_of_x_pt1
				     list_of_y_pt1
				     list_of_x_pt2
				     list_of_y_pt2
				     pt_1	  pt_2
				     pt_3	  pt_4
				     pt_txt_x	  pt_txt_y
				     space	  sset
				     vertices_list
				     x_min	  x_max
				     y_min	  y_max
				     ss		  y_dist
				     ds1 obj2 obj3 osm
				    )

  (setq	active_document
	 (vla-get-activedocument
	   (vlax-get-acad-object)
	 )
  )

  (setq sset (ssget))

  (setq	active_selectionset
	 (vla-get-activeselectionset active_document)
  )

  (vlax-for item active_selectionset

    (vla-GetBoundingBox
      item
      'pt1
      'pt2
    )

    (setq list_of_x_pt1
	   (cons
	     (car (vlax-safearray->list pt1))
	     list_of_x_pt1
	   )
    )
    (setq list_of_y_pt1
	   (cons
	     (cadr (vlax-safearray->list pt1))
	     list_of_y_pt1
	   )
    )
    (setq list_of_x_pt2
	   (cons
	     (car (vlax-safearray->list pt2))
	     list_of_x_pt2
	   )
    )
    (setq list_of_y_pt2
	   (cons
	     (cadr (vlax-safearray->list pt2))
	     list_of_y_pt2
	   )
    )
    )
    
  (setq x_min (apply 'min list_of_x_pt1))
  (setq y_min (apply 'min list_of_y_pt1))

  (setq x_max (apply 'max list_of_x_pt2))
  (setq y_max (apply 'max list_of_y_pt2))


  (setq pt_1 (list x_min y_min 0.0))
  (setq pt_2 (list x_max y_max 0.0))

  (setq pt_3 (list (car pt_2) (cadr pt_1) 0.0))
  (setq pt_4 (list (car pt_1) (cadr pt_2) 0.0))

    (setq centr
		(polar pt_1 (angle pt_1 pt_2) (/ (distance pt_1 pt_2) 2))
	 )
	 (setq
	   ep1
	    (polar pt_1 (angle pt_1 pt_3) (/ (distance pt_1 pt_3) 2))
	 )
	 (setq
	   ep2
	    (polar pt_1 (angle pt_1 pt_4) (/ (distance pt_1 pt_4) 2))
	 )
	 (setq delta_x (distance pt_1 pt_3))
	 (setq delta_y (distance pt_1 pt_4))
  (setq osm (getvar "osmode"))
  (setvar "cmdecho" 0)
  (setvar "osmode" 0)
   (setq of1 (getreal "\n Enter Trim Offset: "))
   (command "_pline" pt_1 pt_3 pt_2 pt_4 "C")
  (setq obj2 (entlast))
  (command "offset" of1 obj2 "0,0" "")
  (setq obj3 (entlast))
  (entdel obj2)
  (command "trim" obj3 "" "F" pt_1 pt_3 pt_2 pt_4 "" "")
  (entdel obj3)
  (setvar "osmode" osm)
  (setvar "cmdecho" 1)
 (princ)
)

;;;=====================================================
(defun c:TOFF () (Trim_Offset) (princ))
;;;=====================================================
(prompt "\n*** Type TOFF to run the program ***")
;;;=====================================================
;;;=====================================================
