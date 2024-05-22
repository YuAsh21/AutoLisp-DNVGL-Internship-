(DEFUN c:CPU ( / CNT DIAM INCH)

  (setq CNT (getpoint "\nselect circle center"));click the center of the circle
  
  	(initget 1 "2 2.5 3 3.5 4 6 8 10 12 14 16 18 20")
  	(setq INCH (getkword "\nSelect Diameter: [2 / 2.5 / 3 / 3.5 / 4 / 6 / 8 / 10 / 12 / 14 / 16 / 18 / 20]"))
  	;To do not write the real diameter number

  	(setq DIAM (cond ((= INCH "2") 0.060325)
			 ((= INCH "2.5") 0.073025)
			 ((= INCH "3") 0.0889)
			 ((= INCH "3.5") 0.1016)
			 ((= INCH "4") 0.1143)			 
			 ((= INCH "6") 0.1683)
			 ((= INCH "8") 0.2191)
			 ((= INCH "10") 0.2730)
			 ((= INCH "12") 0.3238)
			 ((= INCH "14") 0.3556)
			 ((= INCH "16") 0.4064)
			 ((= INCH "18") 0.4572)
			 ((= INCH "20") 0.5080)			 
		    );End conditional
  	) ;End setq

   		(command "circle" "_non" CNT "D" DIAM);draw the circle
		
  (PRIN1)
  )