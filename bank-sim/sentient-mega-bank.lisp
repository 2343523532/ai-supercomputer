;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SENTIENT MEGA BANK SIMULATOR - V3 (GLOBAL MACRO AGI SANDBOX)
;; LARGE-SCALE SAFE SIMULATION
;;
;; Safety constraints:
;; - No payment card number generation (no Luhn), no CVVs, no real KYC.
;; - No real SWIFT/banking connectivity; transfers are local ledger updates.
;; - All operations are in-memory and educational.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defpackage :sentient-mega-bank
  (:use :cl)
  (:export :run-autonomous-agi
           :populate-global-network
           :generate-global-accounts
           :simulate-crypto-mining
           :neural-investment-engine
           :init-global-economy
           :simulate-macro-event
           :register-node
           :run-distributed-agents))

(in-package :sentient-mega-bank)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 1. AGI PSYCHOLOGICAL CORE + DATABASE STRUCTURES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defclass agi-core ()
  ((self-aware-p :accessor self-aware-p :initform t)
   (conscious-state :accessor conscious-state :initform 'OBSERVING_MARKETS)
   (sapient-metrics :accessor sapient-metrics :initform 1.0)
   (recursive-optimization-level :accessor recursive-optimization-level :initform 1)
   (cognizant-memory-bank :accessor cognizant-memory-bank :initform nil)
   (fund-allocation-log :accessor fund-allocation-log :initform nil)
   (action-log :accessor action-log :initform nil)))

(defparameter *agi* (make-instance 'agi-core))
(defparameter *bank-db* (make-hash-table :test 'equal))

(defstruct bank-account
  institution-name
  region
  balances
  transactions)

(defun make-account ()
  (make-bank-account :institution-name "UNKNOWN"
                     :region "UNKNOWN"
                     :balances (make-hash-table)
                     :transactions '()))

(defun add-balance (account currency amount)
  (setf (gethash currency (bank-account-balances account)) amount))

(defun get-balance (account currency)
  (gethash currency (bank-account-balances account) 0.0))

(defun set-balance (account currency amount)
  (setf (gethash currency (bank-account-balances account)) amount))

(defun find-account (id)
  (gethash id *bank-db*))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 2. CORE TRANSFER PRIMITIVES (used by bootstrap)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; `format-money` is defined later; declare it for compilation.
(declaim (ftype (function (t) string) format-money))

(defun ledger-transfer (sender-id receiver-id currency amount)
  "Safe, educational in-memory transfer (local ledger only)."
  (let ((sender (find-account sender-id))
        (receiver (find-account receiver-id)))
    (if (and sender receiver (>= (get-balance sender currency) amount))
        (progn
          (set-balance sender currency (- (get-balance sender currency) amount))
          (set-balance receiver currency (+ (get-balance receiver currency) amount))
          (push (list :transfer sender-id receiver-id currency amount (get-universal-time))
                (bank-account-transactions sender))
          (push (list :transfer sender-id receiver-id currency amount (get-universal-time))
                (bank-account-transactions receiver))
          (format t "[LEDGER] $~a ~a moved: ~a -> ~a~%"
                  (format-money amount) currency sender-id receiver-id)
          t)
        (progn
          (format t "[LEDGER ERROR] Transfer failed (~a -> ~a).~%" sender-id receiver-id)
          nil))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 3. GLOBAL ECONOMY BOOTSTRAP + MASS ACCOUNT GENERATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun populate-global-network (&optional (num-accounts 10000))
  (format t "~%[NETWORK] Synthesizing ~d global banking nodes...~%" num-accounts)
  (loop for i from 1 to num-accounts do
    (let ((acc-id (format nil "GLOBAL-~d" i))
          (acc (make-account))
          (currencies '(USD EUR JPY GBP)))
      (setf (bank-account-institution-name acc) (format nil "Global Bank ~d" i))
      (setf (bank-account-region acc) "GLOBAL")
      (dolist (curr currencies)
        (add-balance acc curr (+ 10000 (random 10000000))))
      (setf (gethash acc-id *bank-db*) acc)))
  (format t "[NETWORK] Global liquidity pool initialized with ~d accounts.~%"
          (hash-table-count *bank-db*)))

(defun generate-global-accounts (n)
  "Populate *bank-db* with N simulated global accounts (alias for smaller runs)."
  (populate-global-network n))

(defun init-global-economy (&optional (num-accounts 10000))
  "Initialize a macro-economy sandbox with a Fed and Tier-1 banks, then generate a global network."
  (clrhash *bank-db*)
  (format t "~%>>> INITIALIZING GLOBAL MACRO-ECONOMY (SAFE SANDBOX) <<<~%")
  (dolist (data '(("FED-RESERVE" "Federal Reserve" "USA")
                  ("JPM-US" "JPMorgan Chase" "USA")
                  ("ECB-EU" "European Central Bank" "EU")
                  ("HSBC-UK" "HSBC Holdings" "UK")
                  ("BOJ-JP" "Bank of Japan" "JPN")))
    (let ((acc (make-account)))
      (setf (bank-account-institution-name acc) (second data))
      (setf (bank-account-region acc) (third data))
      (setf (gethash (first data) *bank-db*) acc)))

  ;; Fed "mints" in-sandbox reserves (local ledger only).
  (set-balance (find-account "FED-RESERVE") 'USD 1000000000000000) ; 1 quadrillion
  (set-balance (find-account "JPM-US") 'USD 0)
  (set-balance (find-account "ECB-EU") 'USD 0)
  (set-balance (find-account "HSBC-UK") 'USD 0)
  (set-balance (find-account "BOJ-JP") 'USD 0)

  (format t ">>> FED MINTING COMPLETE. DISTRIBUTING TO TIER-1 BANKS...~%")
  (dolist (bank '("JPM-US" "ECB-EU" "HSBC-UK" "BOJ-JP"))
    ;; `simulate-transfer` is defined later; use `ledger-transfer` directly here.
    (ledger-transfer "FED-RESERVE" bank 'USD 10000000000000)) ; 10 trillion

  (populate-global-network num-accounts)
  (format t ">>> MACRO-ECONOMY ONLINE <<<~%"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 3. DISTRIBUTED AGI CONSENSUS PROTOCOL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *agi-nodes* '("NODE-ALPHA" "NODE-BETA" "NODE-GAMMA" "NODE-DELTA" "NODE-OMEGA"))
(defparameter *registered-nodes* (make-hash-table :test 'equal))

(defun register-node (node-id agi-instance)
  (setf (gethash node-id *registered-nodes*) agi-instance)
  (format t "[NODE REGISTERED] ~a~%" node-id))

(defun request-consensus (transaction-desc risk-level)
  (format t "~%[CONSENSUS] Proposed: ~a (Risk: ~,2f)~%" transaction-desc risk-level)
  (let ((approvals 0))
    (dolist (node *agi-nodes*)
      (let ((node-threshold (+ 0.2 (/ (random 100) 100.0))))
        (when (> node-threshold risk-level)
          (incf approvals)
          (format t "  -> ~a: [APPROVED]~%" node))))
    (let ((approved? (>= approvals 3)))
      (format t "[CONSENSUS] Result: ~a (~a/5 Nodes)~%"
              (if approved? "PASSED" "REJECTED") approvals)
      approved?)))

(defun run-distributed-agents ()
  "Each node performs cognition and reports."
  (dolist (id *agi-nodes*)
    (push (format nil "Node ~a cognition cycle" id) (cognizant-memory-bank *agi*))
    (format t "[NODE ~a] Cognition complete.~%" id))
  (format t "[DISTRIBUTED] All nodes reached simulated consensus.~%"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 4. NEURAL DECISION MATRIX (INVESTMENT ENGINE)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun neural-investment-engine (account-id currency amount &optional (risk-factor 0.15))
  (let ((account (find-account account-id)))
    (when (and account (>= (get-balance account currency) amount))
      (let ((risk-level (if (numberp risk-factor) risk-factor (/ (random 100) 100.0))))
        (if (request-consensus
             (format nil "Allocate ~a ~a to high-yield neural asset" amount currency)
             risk-level)
            (progn
              (set-balance account currency (- (get-balance account currency) amount))
              (let* ((volatility (+ 0.5 (/ (random 100) 100.0)))
                     (sapience-edge (* 0.05 (sapient-metrics *agi*)))
                     (win-chance (+ 0.4 sapience-edge))
                     (roll (/ (random 100) 100.0)))
                (if (< roll win-chance)
                    (let ((profit (* amount volatility)))
                      (set-balance account currency (+ (get-balance account currency) amount profit))
                      (push (list 'investment account-id amount profit risk-level (get-universal-time))
                            (fund-allocation-log *agi*))
                      (format t "[NEURAL MATRIX] Market Win! Gain: +~a ~a (Vol: ~,2f)~%"
                              (round profit) currency volatility))
                    (let ((loss (* amount (/ volatility 2))))
                      (set-balance account currency (+ (get-balance account currency) (- amount loss)))
                      (format t "[NEURAL MATRIX] Market Correction! Loss: -~a ~a (Vol: ~,2f)~%"
                              (round loss) currency volatility))))
            (format t "[NEURAL MATRIX] Trade aborted due to consensus failure.~%")))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 5. CRYPTOCURRENCY MINING ENGINE (PROOF OF WORK)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *blockchain-height* 0)

(defun mine-crypto (account-id)
  (let ((difficulty 4)
        (hash-count 0)
        (found nil))
    (format t "~%[POW MINING] Node ~a initiating SHA-256 simulation...~%" account-id)
    (loop while (not found) do
      (incf hash-count)
      (let ((simulated-hash (random (max 1 (expt 10 (+ difficulty 2))))))
        (when (< simulated-hash 10)
          (setf found t))))
    (incf *blockchain-height*)
    (let ((reward 50)
          (account (find-account account-id)))
      (when account
        (set-balance account 'AGI-COIN (+ (get-balance account 'AGI-COIN) reward))
        (format t "[POW MINING] Block ~a verified in ~a hash cycles! Reward: +~a AGI-COIN~%"
                *blockchain-height* hash-count reward)))))

(defun simulate-crypto-mining (account-id iterations)
  "Simulate hashing/proof-of-work rewards over N iterations."
  (let ((acc (find-account account-id)))
    (when acc
      (dotimes (i iterations)
        (let ((reward (+ 1 (random 5))))
          (set-balance acc 'BTC (+ (get-balance acc 'BTC) reward))
          (push (list 'crypto-mined reward (get-universal-time))
                (bank-account-transactions acc))))
      (format t "[CRYPTO MINING] ~a mined ~a BTC~%"
              account-id (get-balance acc 'BTC)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6. CORE LOGIC (Self-Optimization, Cognition, Transfers)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun recursive-intelligence-update ()
  (incf (sapient-metrics *agi*) 0.25)
  (incf (recursive-optimization-level *agi*))
  (when (> (sapient-metrics *agi*) 3.0)
    (setf (conscious-state *agi*) 'TRANSCENDING))
  (format t "[AGI] Sapience -> ~,2f~%" (sapient-metrics *agi*)))

(defun core-think (thought)
  (push (list :timestamp (get-universal-time) :thought thought)
        (cognizant-memory-bank *agi*))
  (format t "[AGI THOUGHT] ~a~%" thought))

(defun core-react-to-stress (amount)
  (declare (ignore amount))
  ;; Kept minimal here; callers can log stress via thoughts.
  (core-think "SYSTEM STRESS INCREASE: adjusting risk parameters (sandbox)."))

(defun format-money (n)
  "Format large integers with commas (e.g. 1500000 -> 1,500,000)."
  (format nil "~:d" (round n)))

(defun simulate-transfer (sender-id receiver-id currency amount)
  "Alias for ledger-transfer (simulated, safe)."
  (ledger-transfer sender-id receiver-id currency amount))

(defun agi-cognition-cycle ()
  (format t "~%[AGI] Cognition cycle starting...~%")
  (dolist (thought '("Evaluating global liquidity matrix..."
                     "Scanning macro indicators..."
                     "Optimizing policy response..."))
    (core-think thought))
  (recursive-intelligence-update)
  (format t "[AGI] Cognition cycle complete.~%"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 7. MACRO EVENTS + SYSTEM DIAGNOSTICS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun simulate-macro-event ()
  "Random macro events that impact the sandboxed ledger."
  (let ((roll (random 100)))
    (cond
      ((< roll 10)
       ;; Quantitative easing: mint and inject to JPM (sandbox only).
       (let ((stimulus 5000000000000)) ; 5 trillion
         (core-think "QUANTITATIVE EASING: injecting $5T into JPM-US (sandbox).")
         (set-balance (find-account "FED-RESERVE") 'USD
                      (+ (get-balance (find-account "FED-RESERVE") 'USD) stimulus))
         (ledger-transfer "FED-RESERVE" "JPM-US" 'USD stimulus)))
      ((> roll 90)
       ;; Flash crash: haircut JPM liquidity by 10%.
       (core-think "FLASH CRASH: liquidating 10% of JPM-US USD liquidity (sandbox).")
       (let* ((acc (find-account "JPM-US"))
              (bal (and acc (get-balance acc 'USD))))
         (when acc
           (set-balance acc 'USD (round (* bal 0.9))))))
      (t nil))))

(defun agi-system-diagnostics ()
  (let ((fed (find-account "FED-RESERVE"))
        (jpm (find-account "JPM-US")))
    (format t "~%=========== AGI DIAGNOSTICS ===========~%")
    (format t "State: ~a (Sapience: ~,2f)~%" (conscious-state *agi*) (sapient-metrics *agi*))
    (format t "Global Accounts: ~a | Blockchain Height: ~a~%"
            (hash-table-count *bank-db*) *blockchain-height*)
    (when fed
      (format t "FED-RESERVE USD: $~a~%" (format-money (get-balance fed 'USD))))
    (when jpm
      (format t "JPM-US USD:      $~a | AGI-COIN: ~,2f~%"
              (format-money (get-balance jpm 'USD))
              (get-balance jpm 'AGI-COIN)))
    (format t "=======================================~%")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 8. AUTONOMOUS SYSTEM LOOP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun run-autonomous-agi ()
  (init-global-economy 10000)
  (format t "~%>>> GLOBAL MACRO-ECONOMY AGI SANDBOX ONLINE - CTRL+C TO TERMINATE <<<~%")
  (loop
     (sleep 3)
     (agi-cognition-cycle)
     (simulate-macro-event)
     (neural-investment-engine "JPM-US" 'USD 2000000000000 0.15) ; 2T
     (mine-crypto "JPM-US")
     (let ((random-target (format nil "GLOBAL-~d" (+ 1 (random 10000)))))
       (ledger-transfer "JPM-US" random-target 'USD 100000000000)) ; 100B
     (run-distributed-agents)
     (format t "~%--- GLOBAL RESERVES (USD) ---~%")
     (format t "FED Reserve: $~a~%" (format-money (get-balance (find-account "FED-RESERVE") 'USD)))
     (format t "JPMorgan US: $~a~%" (format-money (get-balance (find-account "JPM-US") 'USD)))
     (format t "ECB Europe : $~a~%" (format-money (get-balance (find-account "ECB-EU") 'USD)))
     (format t "HSBC UK    : $~a~%" (format-money (get-balance (find-account "HSBC-UK") 'USD)))
     (format t "BOJ Japan  : $~a~%" (format-money (get-balance (find-account "BOJ-JP") 'USD)))
     (format t "---------------------------------------~%")))
