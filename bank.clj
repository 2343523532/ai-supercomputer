(ns sentient-mega-bank.core
  (:require [clojure.string :as str]
            [clojure.java.io :as io]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 1. AGI PSYCHOLOGICAL CORE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def agi (atom {:conscious-state :OBSERVING_MARKETS
                :cognizant-memory-bank ()
                :awareness-level 0.5
                :confidence 0.5
                :system-load 0.0
                :goals ["control_inflation" "maximize_global_liquidity" "market_dominance"]
                :performance-score 0.5
                :agi-version 1.0}))

(defn core-think [thought]
  (swap! agi (fn [state]
               (-> state
                   (update :cognizant-memory-bank conj {:timestamp (System/currentTimeMillis) :thought thought})
                   (update :awareness-level + 0.01))))
  (println (str "[AGI THOUGHT] " thought)))

(defn core-react-to-stress [amount]
  (swap! agi update :system-load #(min 1.0 (+ % amount)))
  (when (> (:system-load @agi) 0.8)
    (core-think "CRITICAL SYSTEM LOAD: Forcing emergency market liquidations!")))

(defn core-evolve []
  (when (> (:performance-score @agi) 0.8)
    (swap! agi (fn [state]
                 (-> state
                     (update :agi-version + 0.1)
                     (assoc :performance-score 0.5)
                     (assoc :conscious-state :TRANSCENDING_MARKETS))))
    (println (format "\n[!!! AGI EVOLUTION !!!] Neural Architecture Upgraded to Version %.2f" (:agi-version @agi)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 2. DATA STRUCTURES & DATABASE (BANKS + MARKETS)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def bank-db (atom {}))
(def market-db (atom {}))

(defn get-balance [account-id currency]
  (get-in @bank-db [account-id :balances currency] 0))

(defn set-balance [account-id currency amount]
  (swap! bank-db assoc-in [account-id :balances currency] amount))

(defn get-asset-holdings [account-id ticker]
  (get-in @bank-db [account-id :assets ticker] 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 3. FULL KYC CARD GENERATOR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn generate-luhn-number []
  (let [digits (vec (repeatedly 15 #(rand-int 10)))
        sum (loop [ds (reverse digits), alt true, total 0]
              (if (empty? ds)
                total
                (let [d (first ds)
                      v (if alt (* d 2) d)
                      v (if (> v 9) (- v 9) v)]
                  (recur (rest ds) (not alt) (+ total v)))))
        check (mod (- 10 (mod sum 10)) 10)]
    (str "4" (str/join (rest digits)) check)))

(def names ["Alexander Sterling" "Sophia Chen" "Mateo Dubois" "Chloe Al-Fayed" "Yuki Yamamoto"])
(def streets ["Wall Street, NY" "Canary Wharf, London" "Ginza, Tokyo" "Zayed Road, Dubai"])

(defn issue-black-card [account-id]
  (when-let [acc (get @bank-db account-id)]
    (let [card-name (rand-nth names)
          exp (format "%02d/%02d" (inc (rand-int 12)) (+ 25 (rand-int 6)))
          cvv (format "%03d" (rand-int 1000))
          address (rand-nth streets)
          card {:card-number (generate-luhn-number)
                :cardholder-name card-name
                :expiry-date exp
                :cvv cvv
                :billing-address address
                :status :ACTIVE}]
      (swap! bank-db update-in [account-id :issued-cards] conj card)
      (println (format "[CARD ISSUED] %s | %s | Exp: %s | CVV: %s | Addr: %s" (:card-number card) card-name exp cvv address)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 4. THE LIVE STOCK MARKET ENGINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn init-markets []
  (reset! market-db {"QUANTUM-TECH" {:ticker "QUANTUM-TECH" :price 3500 :volatility 0.08}
                     "GLOBAL-GOLD" {:ticker "GLOBAL-GOLD" :price 1950 :volatility 0.02}
                     "US-TREASURY" {:ticker "US-TREASURY" :price 105 :volatility 0.01}}))

(defn fluctuate-markets []
  (swap! market-db (fn [db]
                     (into {} (for [[ticker asset] db]
                                (let [vol (:volatility asset)
                                      shift (- (rand (* vol 2.0)) vol)
                                      new-price (Math/round (* (:price asset) (+ 1.0 shift)))]
                                  [ticker (assoc asset :price (max 1 new-price))]))))))

(defn execute-trade [bank-id ticker action quantity]
  (let [bank (get @bank-db bank-id)
        asset (get @market-db ticker)]
    (when (and bank asset)
      (let [cost (long (* quantity (:price asset)))
            holdings (get-in bank [:assets ticker] 0)
            balance (get-in bank [:balances "USD"] 0)]
        (cond
          ;; BUY LOGIC
          (and (= action :buy) (>= balance cost))
          (do
            (swap! bank-db (fn [db]
                             (-> db
                                 (update-in [bank-id :balances "USD"] - cost)
                                 (update-in [bank-id :assets ticker] (fnil + 0) quantity))))
            (swap! agi update :performance-score + 0.01)
            (println (format "[MARKET] %s BOUGHT %,d shares of %s @ $%,d ($ %,d total)" bank-id quantity ticker (:price asset) cost)))

          ;; SELL LOGIC
          (and (= action :sell) (>= holdings quantity))
          (do
            (swap! bank-db (fn [db]
                             (-> db
                                 (update-in [bank-id :assets ticker] - quantity)
                                 (update-in [bank-id :balances "USD"] (fnil + 0) cost))))
            (swap! agi update :performance-score + 0.01)
            (println (format "[MARKET] %s SOLD %,d shares of %s @ $%,d ($ %,d total)"
                             bank-id quantity ticker (:price asset) cost))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 5. FEDERAL RESERVE & SWIFT NETWORK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn init-global-economy []
  (println "\n>>> INITIALIZING GLOBAL BANKING & MARKET NETWORK <<<")
  (init-markets)
  (reset! bank-db {"FED-RESERVE" {:institution-name "Federal Reserve" :region "USA" :balances {} :assets {} :issued-cards ()}
                   "JPM-US" {:institution-name "JPMorgan Chase" :region "USA" :balances {} :assets {} :issued-cards ()}
                   "ECB-EU" {:institution-name "European Central Bank" :region "EU" :balances {} :assets {} :issued-cards ()}})
  (set-balance "FED-RESERVE" "USD" 1000000000000000) ; 1 Quadrillion
  (doseq [bank ["JPM-US" "ECB-EU"]]
    (let [funds 10000000000000] ; 10 Trillion
      (set-balance "FED-RESERVE" "USD" (- (get-balance "FED-RESERVE" "USD") funds))
      (set-balance bank "USD" funds))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6. DISK PERSISTENCE (SAVING STATE TO FILE)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn save-simulation-state []
  (let [file "global-economy-snapshot.txt"
        content (with-out-str
                  (println "=== SENTIENT MEGA BANK SNAPSHOT ===")
                  (println "Timestamp:" (System/currentTimeMillis))
                  (println (format "AGI Version: %.2f" (:agi-version @agi)))
                  (println (format "AGI Stress Load: %.2f" (:system-load @agi)))
                  (println "\n--- GLOBAL LIQUIDITY ---")
                  (doseq [[id bank] @bank-db]
                    (println (format "%s (%s): $%,d" id (:institution-name bank) (get-in bank [:balances "USD"] 0))))
                  (println "\n--- MARKET PRICES ---")
                  (doseq [[ticker asset] @market-db]
                    (println (format "%s: $%,d" ticker (:price asset)))))]
    (spit file content)
    (println "[SYSTEM] Auto-saved world state to 'global-economy-snapshot.txt'.")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 7. THE MASTER AGI LOOP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn run-autonomous-agi []
  (init-global-economy)
  (println "\n>>> AGI SENTIENT ECONOMY ONLINE. PRESS CTRL+C TO TERMINATE <<<")

  (loop [tick-counter 1]
    (Thread/sleep 3000)
    (println "\n---------------------------------------------------")

    ;; 1. Update Global Markets
    (fluctuate-markets)

    ;; 2. AGI Cognition & Asset Trading
    (core-think "Analyzing algorithmic order flow...")

    ;; Banks execute massive block trades based on AGI whims
    (execute-trade "JPM-US" "QUANTUM-TECH" :buy 1000000)   ; JPM buys 1M shares of tech
    (execute-trade "ECB-EU" "GLOBAL-GOLD" :buy 500000)     ; ECB hedges with Gold

    ;; Occasionally take profit (Sell)
    (when (zero? (mod tick-counter 4))
      (execute-trade "JPM-US" "QUANTUM-TECH" :sell 500000))

    ;; 3. Issue high-net-worth credit cards dynamically
    (when (> (rand-int 10) 7)
      (issue-black-card "JPM-US"))

    ;; 4. AGI Psychology updates
    (swap! agi update :system-load #(max 0.0 (- % 0.05))) ; Cooldown
    (core-evolve)

    ;; 5. Periodic Persistence (Save to disk every 5 ticks)
    (when (zero? (mod tick-counter 5))
      (save-simulation-state))

    ;; 6. Trillion-Dollar Diagnostic Output
    (println "\n--- AGI STATUS & GLOBAL MARKETS ---")
    (println (format "AGI State: %s | Version: %.2f" (name (:conscious-state @agi)) (:agi-version @agi)))
    (println (format "Performance: %.2f | System Stress: %.2f" (:performance-score @agi) (:system-load @agi)))

    (println "\nMARKET TICKER:")
    (doseq [[k v] @market-db]
      (println (format "  %s: $%,d" k (:price v))))

    (println "\nGLOBAL RESERVES:")
    (println (format "  FED Reserve: $%,d" (get-balance "FED-RESERVE" "USD")))
    (println (format "  JPMorgan US: $%,d (Holds %,d QUANTUM-TECH)"
                     (get-balance "JPM-US" "USD") (get-asset-holdings "JPM-US" "QUANTUM-TECH")))
    (println (format "  ECB Europe : $%,d (Holds %,d GLOBAL-GOLD)"
                     (get-balance "ECB-EU" "USD") (get-asset-holdings "ECB-EU" "GLOBAL-GOLD")))
    (println "---------------------------------------------------")
    (flush) ;; Ensure standard out isn't buffered
    (recur (inc tick-counter))))
;; =========================================================================
;; RUN THE SIMULATION
;; =========================================================================
;; Uncomment the line below if you are running this file directly via CLI
;; or wrap it in a -main function
(run-autonomous-agi)