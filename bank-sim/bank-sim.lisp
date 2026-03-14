;;; Educational banking simulation for learning Common Lisp.
;;; No real card generation or financial network simulation.

(defpackage :bank-sim
  (:use :cl)
  (:export :create-account :deposit :withdraw :balance))

(in-package :bank-sim)

(defclass account ()
  ((name :initarg :name :accessor name)
   (balance :initarg :balance :initform 0 :accessor balance)
   (transactions :initform '() :accessor transactions)))

(defparameter *accounts* (make-hash-table :test 'equal))

(defun create-account (id name)
  (setf (gethash id *accounts*)
        (make-instance 'account :name name))
  id)

(defun deposit (id amount)
  (let ((acc (gethash id *accounts*)))
    (incf (balance acc) amount)
    (push (list :deposit amount) (transactions acc))
    (balance acc)))

(defun withdraw (id amount)
  (let ((acc (gethash id *accounts*)))
    (when (>= (balance acc) amount)
      (decf (balance acc) amount)
      (push (list :withdraw amount) (transactions acc)))
    (balance acc)))

(defun balance (id)
  (balance (gethash id *accounts*)))
