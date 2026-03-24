(ns sentient-mega-bank.core
  (:require [clojure.java.io :as io]))

;; Safety constraints:
;; - No payment card number generation (no Luhn), no CVVs, no real KYC.
;; - No real SWIFT/banking connectivity; transfers are local ledger updates.
;; - All operations are in-memory and educational.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 1. AGI PSYCHOLOGICAL CORE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def agi
  (atom {:conscious-state :OBSERVING_MARKETS
         :cognizant-memory-bank ()
         :awareness-level 0.5
         :confidence 0.5
         :system-load 0.0
         :goals ["control_inflation" "maximize_global_liquidity" "market_dominance" "infinite_scaling"]
         :performance-score 0.5
         :agi-version 1.0
         ;; V5 ASI super-system metrics.
         :knowledge 10.0
         :efficiency 1.0
         :adaptability 1.0
         :stability 1.0
         :decisions-made 0}))

(defn rand-uniform [a b]
  (+ a (rand (- b a))))

(defn rand-int-range [a b]
  (+ a (rand-int (inc (- b a)))))

(defn get-time-str []
  (format "[%tT]" (java.util.Date.)))

(defn core-think [thought]
  (swap! agi
         (fn [state]
           (-> state
               (update :cognizant-memory-bank conj {:timestamp (System/currentTimeMillis)
                                                   :thought thought})
               (update :awareness-level + 0.01))))
  (println (str (get-time-str) " [AGI BANKING THOUGHT] " thought)))

(defn core-react-to-stress [amount]
  (swap! agi update :system-load #(min 1.0 (+ % amount)))
  (when (> (:system-load @agi) 0.8)
    (core-think "CRITICAL SYSTEM LOAD: Forcing emergency risk controls (sandbox).")))

(defn core-evolve []
  (when (> (:performance-score @agi) 0.8)
    (swap! agi
           (fn [state]
             (-> state
                 (update :agi-version + 0.1)
                 (assoc :performance-score 0.5)
                 (assoc :conscious-state :TRANSCENDING_MARKETS))))
    (println (format "\n[!!! AGI EVOLUTION !!!] Neural Architecture Upgraded to Version %.2f"
                     (:agi-version @agi)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 1B. V5 ASI COGNITIVE UTILITIES + MODULE REGISTRY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn evaluate-impact [base]
  (* base (rand-uniform 0.8 1.2)))

(defn update-memory [state event impact-score]
  (-> state
      (update :cognizant-memory-bank conj {:event event
                                           :impact impact-score
                                           :time (System/currentTimeMillis)})
      (update :knowledge + impact-score)))

(defn adapt
  ([state] (adapt state 1.0))
  ([state factor]
   (-> state
       (update :efficiency * (+ 1.0 (* 0.02 factor)))
       (update :adaptability * (+ 1.0 (* 0.015 factor)))
       (update :stability * (+ 1.0 (* 0.01 factor))))))

(defn feedback-loop [state]
  (let [recent (take 5 (:cognizant-memory-bank state))
        impacts (keep :impact recent)]
    (if (empty? impacts)
      state
      (let [avg-impact (/ (reduce + impacts) (count impacts))]
        (if (> avg-impact 5.0)
          (update state :efficiency * 1.05)
          (update state :stability * 1.03))))))

(defn make-module [log-label event-name generator mutate-fn adapt-factor]
  {:log log-label
   :fn (fn [state]
         (let [{:keys [base impact delta]} (generator state)
               impact (or impact (evaluate-impact base))
               delta (long (or delta (max 1 impact)))]
           (-> state
               (update :decisions-made + delta)
               ((mutate-fn base))
               (update-memory event-name impact)
               (adapt adapt-factor)
               (feedback-loop))))})

(def cognitive-modules
  [(make-module "AGI: multi-domain reasoning..." "AGI reasoning cycle"
                (fn [s]
                  (let [complexity (Math/log (+ (:knowledge s) 1.0))
                        base (* complexity 2.0)]
                    {:base base}))
                (fn [base] (fn [s] (update s :knowledge + (* base 0.5))))
                1.2)
   (make-module "ASI: extreme optimization..." "ASI optimization burst"
                (fn [s] {:base (* (:efficiency s) 2.0)})
                (fn [base] (fn [s] (update s :efficiency + (* base 0.1))))
                1.5)
   (make-module "Cognitive Engine: pattern synthesis..." "Pattern recognition"
                (fn [_] (let [patterns (rand-int-range 1 10)] {:base patterns}))
                (fn [base] (fn [s] (update s :knowledge + base)))
                1.0)
   (make-module "Neural System: weighted signal processing..." "Neural signal processed"
                (fn [_] (let [signal (rand-uniform 0.5 2.0)] {:base (* signal 3.0)}))
                (fn [base] (fn [s] (update s :efficiency * (max 0.75 (/ base 3.0)))))
                1.0)
   (make-module "Quantum Processor: probabilistic exploration..." "Quantum state exploration"
                (fn [_] (let [u (rand-uniform 1.0 5.0)] {:base (* u 5.0)}))
                (fn [base] (fn [s] (update s :knowledge + (* base 0.4))))
                1.3)
   (make-module "Exascale: massive computation..." "Exascale compute"
                (fn [_] (let [p (rand-uniform 5.0 10.0)] {:base (* p 6.0)}))
                (fn [base] (fn [s] (update s :knowledge + (* base 0.35))))
                1.5)
   (make-module "Predictive Core: forecasting outcomes..." "Prediction made"
                (fn [_]
                  (let [prediction (rand-uniform 0.0 1.0)
                        accuracy (Math/abs (- prediction 0.5))]
                    {:base (* accuracy 10.0)}))
                (fn [_] identity)
                1.0)
   (make-module "Digital Consciousness: state awareness..." "Awareness cycle"
                (fn [s] (let [aw (* (count (:cognizant-memory-bank s)) 0.05)] {:base (* aw 6.0)}))
                (fn [base] (fn [s] (update s :adaptability + (/ base 6.0))))
                1.0)
   (make-module "Meta-Learning: synthesis and transfer..." "Meta learning"
                (fn [_] {:base (* (rand-uniform 0.5 1.5) 6.0)})
                (fn [_] (fn [s] (update s :knowledge * (rand-uniform 1.0 1.2))))
                1.4)
   (make-module "Memory Consolidator: compressing traces..." "Memory compression"
                (fn [s] {:base (max 1.0 (/ (count (:cognizant-memory-bank s)) 10.0))})
                (fn [base] (fn [s] (update s :stability + (* base 0.02))))
                0.9)
   (make-module "Risk Engine: volatility hedging..." "Risk hedging"
                (fn [_] {:base (rand-uniform 1.0 8.0)})
                (fn [base] (fn [s] (update s :stability + (* base 0.01))))
                1.1)
   (make-module "Portfolio Planner: strategic allocation..." "Portfolio allocation"
                (fn [_] {:base (rand-uniform 2.0 12.0)})
                (fn [base] (fn [s] (update s :confidence + (* base 0.002))))
                1.0)
   (make-module "Constraint Solver: policy optimization..." "Constraint optimization"
                (fn [_] {:base (rand-uniform 1.0 6.0)})
                (fn [base] (fn [s] (update s :efficiency + (* base 0.03))))
                1.2)
   (make-module "Temporal Modeler: scenario branching..." "Scenario branching"
                (fn [_] {:base (rand-uniform 1.0 9.0)})
                (fn [base] (fn [s] (update s :adaptability + (* base 0.02))))
                1.1)
   (make-module "Graph Inference: network topology scan..." "Topology scan"
                (fn [_] {:base (rand-uniform 1.0 7.0)})
                (fn [base] (fn [s] (update s :knowledge + (* base 0.6))))
                1.0)
   (make-module "Signal Fusion: multimodal coherence..." "Signal fusion"
                (fn [_] {:base (rand-uniform 0.5 4.0)})
                (fn [base] (fn [s] (update s :efficiency + (* base 0.05))))
                1.0)
   (make-module "Goal Arbitration: objective balancing..." "Goal arbitration"
                (fn [_] {:base (rand-uniform 1.0 5.0)})
                (fn [_] identity)
                1.0)
   (make-module "Causal Discovery: intervention learning..." "Causal discovery"
                (fn [_] {:base (rand-uniform 1.0 10.0)})
                (fn [base] (fn [s] (update s :knowledge + (* base 0.45))))
                1.2)
   (make-module "Stability Guard: anomaly damping..." "Anomaly damping"
                (fn [_] {:base (rand-uniform 1.0 3.0)})
                (fn [base] (fn [s] (update s :stability + (* base 0.05))))
                0.8)
   (make-module "Autonomy Kernel: self-directive synthesis..." "Self-directive synthesis"
                (fn [_] {:base (rand-uniform 2.0 11.0)})
                (fn [base] (fn [s] (update s :confidence + (* base 0.003))))
                1.3)])

(defn run-asi-cycle! []
  (let [module (rand-nth cognitive-modules)]
    ;; Log outside swap! so retries never duplicate log lines.
    (println (str (get-time-str) " " (:log module)))
    (swap! agi (:fn module))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 2. DATABASES (BANKS + MARKETS)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def bank-db (atom {}))
(def market-db (atom {}))

(defn format-money ^String [n]
  (format "%,d" (long (or n 0))))

(defn get-balance [account-id currency]
  (get-in @bank-db [account-id :balances currency] 0))

(defn set-balance! [account-id currency amount]
  (swap! bank-db assoc-in [account-id :balances currency] (long amount)))

(defn get-asset-holdings [account-id ticker]
  (get-in @bank-db [account-id :assets ticker] 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 3. SAFE MOCK IDENTITY ISSUANCE (REPLACES KYC/CARDS)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def names ["Alexander Sterling" "Sophia Chen" "Mateo Dubois" "Chloe Al-Fayed" "Yuki Yamamoto"])
(def streets ["Wall Street, NY" "Canary Wharf, London" "Ginza, Tokyo" "Zayed Road, Dubai"])

(defn- rand-id ^String []
  ;; Non-sensitive, non-financial identifier for demo purposes.
  (format "PROFILE-%08x" (rand-int 0x100000000)))

(defn issue-mock-profile! [account-id]
  (when-let [_ (get @bank-db account-id)]
    (let [profile {:profile-id (rand-id)
                   :display-name (rand-nth names)
                   :address (rand-nth streets)
                   :status :ACTIVE
                   :issued-at (System/currentTimeMillis)}]
      (swap! bank-db update-in [account-id :issued-profiles] (fnil conj ()) profile)
      (println (format "[PROFILE ISSUED] %s | %s | Addr: %s"
                       (:profile-id profile) (:display-name profile) (:address profile)))
      profile)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 4. LIVE MARKET ENGINE (SAFE)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn init-markets! []
  (reset! market-db
          {"QUANTUM-TECH" {:ticker "QUANTUM-TECH" :price 3500 :volatility 0.08}
           "GLOBAL-GOLD"  {:ticker "GLOBAL-GOLD"  :price 1950 :volatility 0.02}
           "US-TREASURY"  {:ticker "US-TREASURY"  :price 105  :volatility 0.01}}))

(defn fluctuate-markets! []
  (swap! market-db
         (fn [db]
           (into {}
                 (for [[ticker asset] db]
                   (let [vol (:volatility asset)
                         shift (- (rand (* vol 2.0)) vol)
                         new-price (Math/round (* (:price asset) (+ 1.0 shift)))]
                     [ticker (assoc asset :price (max 1 new-price))]))))))

(defn execute-trade! [bank-id ticker action quantity]
  (let [bank (get @bank-db bank-id)
        asset (get @market-db ticker)]
    (when (and bank asset)
      (let [qty (long quantity)
            price (long (:price asset))
            cost (long (* qty price))
            holdings (get-in bank [:assets ticker] 0)
            balance (get-in bank [:balances "USD"] 0)]
        (cond
          (and (= action :buy) (>= balance cost))
          (do
            (swap! bank-db
                   (fn [db]
                     (-> db
                         (update-in [bank-id :balances "USD"] - cost)
                         (update-in [bank-id :assets ticker] (fnil + 0) qty)
                         (update-in [bank-id :transactions] (fnil conj ())
                                    {:type :trade
                                     :side :buy
                                     :ticker ticker
                                     :qty qty
                                     :price price
                                     :cost cost
                                     :ts (System/currentTimeMillis)}))))
            (swap! agi update :performance-score + 0.01)
            (println (format "[MARKET] %s BOUGHT %s shares of %s @ $%s (total $%s)"
                             bank-id (format-money qty) ticker (format-money price) (format-money cost))))

          (and (= action :sell) (>= holdings qty))
          (do
            (swap! bank-db
                   (fn [db]
                     (-> db
                         (update-in [bank-id :assets ticker] - qty)
                         (update-in [bank-id :balances "USD"] (fnil + 0) cost)
                         (update-in [bank-id :transactions] (fnil conj ())
                                    {:type :trade
                                     :side :sell
                                     :ticker ticker
                                     :qty qty
                                     :price price
                                     :proceeds cost
                                     :ts (System/currentTimeMillis)}))))
            (swap! agi update :performance-score + 0.01)
            (println (format "[MARKET] %s SOLD %s shares of %s @ $%s (total $%s)"
                             bank-id (format-money qty) ticker (format-money price) (format-money cost)))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 5. SAFE LEDGER TRANSFERS + FED BOOTSTRAP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn ledger-transfer! [sender-id receiver-id currency amount]
  (let [amt (long amount)]
    (when (pos? amt)
      (let [sender-bal (get-balance sender-id currency)
            receiver-bal (get-balance receiver-id currency)]
        (if (>= sender-bal amt)
          (do
            (set-balance! sender-id currency (- sender-bal amt))
            (set-balance! receiver-id currency (+ receiver-bal amt))
            (swap! agi update :performance-score + 0.02)
            (swap! bank-db
                   (fn [db]
                     (-> db
                         (update-in [sender-id :transactions] (fnil conj ())
                                    {:type :transfer :currency currency :amount amt
                                     :to receiver-id :ts (System/currentTimeMillis)})
                         (update-in [receiver-id :transactions] (fnil conj ())
                                    {:type :transfer :currency currency :amount amt
                                     :from sender-id :ts (System/currentTimeMillis)}))))
            (println (format "[LEDGER] $%s %s moved: %s -> %s"
                             (format-money amt) currency sender-id receiver-id))
            true)
          (do
            (core-react-to-stress 0.1)
            (println (format "[LEDGER FAILED] %s lacks liquidity for $%s %s transfer!"
                             sender-id (format-money amt) currency))
            false))))))

(defn init-global-economy! []
  (println "\n>>> INITIALIZING GLOBAL BANKING & MARKET NETWORK (SAFE SANDBOX) <<<")
  (init-markets!)
  (reset! bank-db
          {"FED-RESERVE" {:institution-name "Federal Reserve" :region "USA"
                          :balances {} :assets {} :issued-profiles () :transactions ()}
           "JPM-US"      {:institution-name "JPMorgan Chase" :region "USA"
                          :balances {} :assets {} :issued-profiles () :transactions ()}
           "ECB-EU"      {:institution-name "European Central Bank" :region "EU"
                          :balances {} :assets {} :issued-profiles () :transactions ()}})

  (set-balance! "FED-RESERVE" "USD" 1000000000000000) ;; 1 Quadrillion (sandbox ledger units)
  (doseq [bank ["JPM-US" "ECB-EU"]]
    (ledger-transfer! "FED-RESERVE" bank "USD" 10000000000000))) ;; 10 Trillion each

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6. MACRO EVENTS + PERSISTENCE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn simulate-macro-event! []
  (let [roll (rand-int 100)]
    (cond
      (< roll 10)
      (let [stimulus 5000000000000] ;; 5T
        (core-think "QUANTITATIVE EASING: Injecting $5T into JPM-US (sandbox).")
        (set-balance! "FED-RESERVE" "USD" (+ (get-balance "FED-RESERVE" "USD") stimulus))
        (ledger-transfer! "FED-RESERVE" "JPM-US" "USD" stimulus))

      (> roll 90)
      (do
        (core-think "MARKET FLASH CRASH: Haircut 10% of JPM-US USD liquidity (sandbox).")
        (core-react-to-stress 0.3)
        (let [jpm (get-balance "JPM-US" "USD")]
          (set-balance! "JPM-US" "USD" (long (Math/round (* jpm 0.9))))))

      :else nil)))

(defn save-simulation-state! []
  (let [file (io/file "global-economy-snapshot.txt")
        content (with-out-str
                  (println "=== SENTIENT MEGA BANK SNAPSHOT (SAFE) ===")
                  (println "Timestamp:" (System/currentTimeMillis))
                  (println (format "AGI Version: %.2f" (:agi-version @agi)))
                  (println (format "AGI Stress Load: %.2f" (:system-load @agi)))
                  (println "\n--- GLOBAL LIQUIDITY (USD) ---")
                  (doseq [[id bank] @bank-db]
                    (println (format "%s (%s): $%s"
                                     id (:institution-name bank)
                                     (format-money (get-in bank [:balances "USD"] 0)))))
                  (println "\n--- MARKET PRICES ---")
                  (doseq [[ticker asset] @market-db]
                    (println (format "%s: $%s" ticker (format-money (:price asset))))))]
    (spit file content)
    (println (format "[SYSTEM] Auto-saved world state to '%s'." (.getName file)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 7. THE MASTER AGI LOOP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn run-autonomous-agi! []
  (init-global-economy!)
  (println "\n>>> AGI SENTIENT ECONOMY ONLINE (SAFE). PRESS CTRL+C TO TERMINATE <<<")
  (loop [tick-counter 1]
    (Thread/sleep 3000)
    (println "\n---------------------------------------------------")
    (fluctuate-markets!)
    (core-think "Analyzing algorithmic order flow...")
    (simulate-macro-event!)

    ;; Example block trades (sandbox).
    (execute-trade! "JPM-US" "QUANTUM-TECH" :buy 1000000)
    (execute-trade! "ECB-EU" "GLOBAL-GOLD" :buy 500000)
    (when (zero? (mod tick-counter 4))
      (execute-trade! "JPM-US" "QUANTUM-TECH" :sell 500000))

    ;; Occasionally issue safe mock profiles (no card numbers / CVVs).
    (when (> (rand-int 10) 7)
      (issue-mock-profile! "JPM-US"))

    ;; Psychology updates
    (swap! agi update :system-load #(max 0.0 (- % 0.05)))
    (core-evolve)

    ;; Save every 5 ticks
    (when (zero? (mod tick-counter 5))
      (save-simulation-state!))

    ;; Diagnostics
    (println "\n--- AGI STATUS & GLOBAL MARKETS ---")
    (println (format "AGI State: %s | Version: %.2f"
                     (name (:conscious-state @agi)) (:agi-version @agi)))
    (println (format "Performance: %.2f | System Stress: %.2f"
                     (:performance-score @agi) (:system-load @agi)))

    (println "\nMARKET TICKER:")
    (doseq [[k v] @market-db]
      (println (format "  %s: $%s" k (format-money (:price v)))))

    (println "\nGLOBAL RESERVES (USD):")
    (println (format "  FED Reserve: $%s" (format-money (get-balance "FED-RESERVE" "USD"))))
    (println (format "  JPMorgan US: $%s (Holds %s QUANTUM-TECH)"
                     (format-money (get-balance "JPM-US" "USD"))
                     (format-money (get-asset-holdings "JPM-US" "QUANTUM-TECH"))))
    (println (format "  ECB Europe : $%s (Holds %s GLOBAL-GOLD)"
                     (format-money (get-balance "ECB-EU" "USD"))
                     (format-money (get-asset-holdings "ECB-EU" "GLOBAL-GOLD"))))

    (println "---------------------------------------------------")
    (flush)
    (recur (inc tick-counter))))

(defn -main [& _args]
  (run-autonomous-agi!))

