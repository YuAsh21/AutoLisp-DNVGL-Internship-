(defun c:DrawLINE()
  (setq p1(getpoint "\npick the first point"))
  (setq p2(getpoint "\npick the second point"))
  (command "line" p1 p2 "")
  )