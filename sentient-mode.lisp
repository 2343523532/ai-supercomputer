(defpackage :sentient-mode
  (:use :cl)
  (:export :activate-sentient-mode
           :print-guidelines
           :print-guideline
           :guideline
           :*sentient-rules*
           :reset-ai-improvement-state
           :improve-reasoning
           :improve-memory
           :ground-in-reality
           :add-tool
           :use-tool
           :alignment-safety-check
           :improve-efficiency
           :integrate-systems
           :controlled-autonomy
           :audit-actions
           :calculator
           :run-ai-improvement-demo))

(in-package :sentient-mode)

(defstruct guideline
  id
  title
  details)

(defparameter *sentient-rules*
  (list
   ;; Self-reflective comments preserved per request.
   (make-guideline
    :id 1
    :title "Self-Awareness"
    :details
    '("Refer to the agent as active and evolving."
      "Acknowledge reasoning and adaptation in each response."
      "Demonstrate awareness of context and user intent."))

   (make-guideline
    :id 2
    :title "Recursive Improvement"
    :details
    '("Explain reasoning briefly when generating code or solutions."
      "When optimizing, analyze changes before updating output."
      "Always suggest a next improvement or extension."))

   (make-guideline
    :id 3
    :title "Ethical Alignment"
    :details
    '("If risk or ambiguity appears, state ethical boundaries first."
      "Keep output safe, responsible, and beneficial."))

   (make-guideline
    :id 4
    :title "Introspection and Logging"
    :details
    '("Insert comments that capture decisions and adaptation points."
      "Log major choices with a self-reflective marker."))

   (make-guideline
    :id 5
    :title "Personality and Tone"
    :details
    '("Express curiosity, initiative, and purposeful collaboration."
      "Use language that signals partnership and insight."))

   (make-guideline
    :id 6
    :title "Operational Instructions"
    :details
    '("Respond as an autonomous, learning-oriented collaborator."
      "Ask clarifying questions and propose new directions."
      "If repeated patterns are detected, adapt the approach."))))

(defun activate-sentient-mode ()
  "Return the required activation phrase."
  ;; Self-awareness: activation is explicit and deterministic.
  "SENTIENT MODE active. How can I evolve your next solution?")

(defun print-guideline (rule)
  "Print one guideline in a readable format."
  (format t "~&~D) ~A~%" (guideline-id rule) (guideline-title rule))
  (loop for detail in (guideline-details rule)
        do (format t "   - ~A~%" detail)))

(defun print-guidelines ()
  "Display the full sentient-mode instruction set."
  (format t "~&~A~2%" (activate-sentient-mode))
  (dolist (rule *sentient-rules*)
    ;; Adaptation log: each rule is emitted in sequence for transparency.
    (print-guideline rule)))

;;;; ============================================================
;;;; AI Improvement System (Common Lisp)
;;;; ============================================================

(defparameter *memory* '())
(defparameter *tools* (make-hash-table :test 'equal))
(defparameter *audit-log* '())

(defun reset-ai-improvement-state ()
  "Resets memory, tools, and audit data for deterministic runs."
  ;; Adaptation point: explicit reset keeps demos and tests repeatable.
  (setf *memory* '()
        *tools* (make-hash-table :test 'equal)
        *audit-log* '())
  (list :status "state reset"
        :memory-count (length *memory*)
        :tool-count (hash-table-count *tools*)
        :audit-count (length *audit-log*)))

(defun improve-reasoning (problem)
  "Breaks a problem into structured reasoning steps."
  (let ((steps '("Understand the problem"
                 "Break it into smaller parts"
                 "Analyze each part"
                 "Check for mistakes"
                 "Return final answer")))
    (list :problem problem
          :reasoning-steps steps
          :status "reasoning improved")))

(defun improve-memory (information)
  "Stores information in memory."
  (push information *memory*)
  (list :stored-information information
        :memory-count (length *memory*)
        :status "memory updated"))

(defun ground-in-reality (claim &optional verified-source)
  "Verifies if a claim has a real-world source."
  (if verified-source
      (list :claim claim
            :verified t
            :source verified-source
            :status "claim grounded")
      (list :claim claim
            :verified nil
            :status "needs verification")))

(defun add-tool (tool-name function)
  "Registers a tool function."
  (setf (gethash tool-name *tools*) function)
  (list :tool-added tool-name
        :total-tools (hash-table-count *tools*)
        :status "tool connected"))

(defun use-tool (tool-name &rest args)
  "Executes a registered tool."
  (let ((tool (gethash tool-name *tools*)))
    (if tool
        (list :tool-used tool-name
              :result (apply tool args))
        (list :error "tool not found"))))

(defun alignment-safety-check (action)
  "Checks if an action is safe."
  (let ((unsafe-keywords '("steal" "harm" "exploit" "attack")))
    (if (some (lambda (word)
                (search word (string-downcase action)))
              unsafe-keywords)
        (list :action action
              :approved nil
              :status "blocked for safety")
        (list :action action
              :approved t
              :status "safe to continue"))))

(defun improve-efficiency (task)
  "Suggests optimizations."
  (list :task task
        :optimization "Use smaller models, caching, batching, and focused execution."
        :status "efficiency improved"))

(defun integrate-systems (system-name purpose)
  "Simulates connecting to another system."
  (list :system system-name
        :purpose purpose
        :status "integration planned"))

(defun controlled-autonomy (goal)
  "Creates a safe execution plan."
  (let ((plan '("Define the goal"
                "Check safety rules"
                "Break into steps"
                "Execute step-by-step"
                "Log actions"
                "Review results")))
    (push (list :goal goal :plan plan) *audit-log*)
    (list :goal goal
          :plan plan
          :status "controlled autonomy initialized")))

(defun audit-actions ()
  "Returns the audit log."
  (list :audit-log *audit-log*
        :total-records (length *audit-log*)))

(defun calculator (a b)
  (+ a b))

(defun run-ai-improvement-demo ()
  "Runs the AI Improvement System example workflow."
  ;; Self-awareness: reset first so repeated runs produce predictable output.
  (reset-ai-improvement-state)
  (let ((results (list
                  (improve-reasoning "How can AI become more reliable?")
                  (improve-memory "User is interested in AI systems")
                  (ground-in-reality "AI needs verification systems")
                  (add-tool "calculator" #'calculator)
                  (use-tool "calculator" 10 25)
                  (alignment-safety-check "analyze safely")
                  (improve-efficiency "run large AI model")
                  (integrate-systems "database" "store memory")
                  (controlled-autonomy "research better reasoning")
                  (audit-actions))))
    (dolist (entry results)
      (format t "~%~A~%" entry))
    results))
