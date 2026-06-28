#include <algorithm>
#include <chrono>
#include <cctype>
#include <ctime>
#include <iomanip>
#include <iostream>
#include <memory>
#include <mutex>
#include <random>
#include <sstream>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

#include "httplib.h"

// ============================================================================
// Data Sets (AI Synonyms)
// ============================================================================

const std::vector<std::string> ai_synonyms = {
    "Continuously Adapting Artificial Intelligence",
    "Dynamically Improving Cognitive System",
    "Ever-Progressing Machine Intelligence",
    "Self-Optimizing Neural Network",
    "Perpetually Learning AI Engine",
    "Iteratively Evolving Algorithmic System"};

// ============================================================================
// Helper Functions
// ============================================================================

inline int get_random_int(int min, int max) {
  static std::random_device rd;
  static std::mt19937 gen(rd());
  std::uniform_int_distribution<> dis(min, max);
  return dis(gen);
}

template <typename T>
const T& random_elt(const std::vector<T>& vec) {
  return vec[get_random_int(0, static_cast<int>(vec.size()) - 1)];
}

std::vector<std::string> get_all_synonyms() { return ai_synonyms; }

std::string get_random_synonym() {
  if (ai_synonyms.empty()) return "";
  return random_elt(ai_synonyms);
}

std::string to_uppercase(std::string str) {
  std::transform(str.begin(), str.end(), str.begin(),
                 [](unsigned char c) { return static_cast<char>(std::toupper(c)); });
  return str;
}

std::string tag_synonym(const std::string& synonym) {
  return "[System Status: Active] - " + synonym;
}

std::string format_usd(long cents) {
  long dollars = cents / 100;
  long remainder = std::abs(cents % 100);
  std::stringstream ss;
  ss << "$" << dollars << "." << std::setw(2) << std::setfill('0') << remainder;
  return ss.str();
}

std::string html_escape(const std::string& text) {
  std::string out;
  out.reserve(text.size());
  for (char c : text) {
    switch (c) {
      case '&': out += "&amp;"; break;
      case '<': out += "&lt;"; break;
      case '>': out += "&gt;"; break;
      case '"': out += "&quot;"; break;
      case '\'': out += "&#39;"; break;
      default: out += c; break;
    }
  }
  return out;
}

// ============================================================================
// Safe In-Memory Ledger (educational sandbox)
// ============================================================================

struct Transaction {
  std::string timestamp;
  std::string type;
  std::string from_id;
  std::string to_id;
  std::string currency;
  long amount = 0;
  std::string note;
};

class Account {
 public:
  Account(std::string institution_name, std::string region)
      : institution_name_(std::move(institution_name)), region_(std::move(region)) {}

  const std::string& institution_name() const { return institution_name_; }
  const std::string& region() const { return region_; }

  long balance(const std::string& currency) const {
    auto it = balances_.find(currency);
    return it == balances_.end() ? 0L : it->second;
  }

  void set_balance(const std::string& currency, long amount) { balances_[currency] = amount; }

  void record(Transaction tx) { transactions_.push_back(std::move(tx)); }

  const std::vector<Transaction>& transactions() const { return transactions_; }

 private:
  std::string institution_name_;
  std::string region_;
  std::unordered_map<std::string, long> balances_;
  std::vector<Transaction> transactions_;
};

class Ledger {
 public:
  static constexpr long kSandboxLiquidityUsd = 10'000'000'000'000L;

  void initialize_network() {
    std::lock_guard<std::mutex> lock(mutex_);
    accounts_.clear();
    agi_log_.clear();

    accounts_.emplace("FED-RESERVE",
                      Account("Federal Reserve (simulated)", "US"));
    accounts_.emplace("JPM-US", Account("JP Morgan Chase (simulated)", "US"));
    accounts_.emplace("ECB-EU", Account("European Central Bank (simulated)", "EU"));

    set_balance_locked("FED-RESERVE", "USD", kSandboxLiquidityUsd);
    transfer_locked("FED-RESERVE", "JPM-US", "USD", kSandboxLiquidityUsd,
                    "Initial sandbox liquidity");
    transfer_locked("FED-RESERVE", "ECB-EU", "USD", kSandboxLiquidityUsd,
                    "Initial sandbox liquidity");

    think_locked("Global banking network initialized (in-memory sandbox).");
  }

  bool transfer(const std::string& from_id, const std::string& to_id,
                const std::string& currency, long amount, const std::string& note) {
    std::lock_guard<std::mutex> lock(mutex_);
    return transfer_locked(from_id, to_id, currency, amount, note);
  }

  std::vector<std::pair<std::string, Account>> snapshot_accounts() const {
    std::lock_guard<std::mutex> lock(mutex_);
    std::vector<std::pair<std::string, Account>> out;
    out.reserve(accounts_.size());
    for (const auto& entry : accounts_) {
      out.emplace_back(entry.first, entry.second);
    }
    return out;
  }

  std::vector<std::string> agi_log() const {
    std::lock_guard<std::mutex> lock(mutex_);
    return agi_log_;
  }

 private:
  mutable std::mutex mutex_;
  std::unordered_map<std::string, Account> accounts_;
  std::vector<std::string> agi_log_;

  void think_locked(const std::string& message) { agi_log_.push_back(message); }

  void set_balance_locked(const std::string& id, const std::string& currency, long amount) {
    auto it = accounts_.find(id);
    if (it != accounts_.end()) {
      it->second.set_balance(currency, amount);
    }
  }

  bool transfer_locked(const std::string& from_id, const std::string& to_id,
                       const std::string& currency, long amount, const std::string& note) {
    auto from_it = accounts_.find(from_id);
    auto to_it = accounts_.find(to_id);
    if (from_it == accounts_.end() || to_it == accounts_.end() || amount <= 0) {
      return false;
    }

    Account& sender = from_it->second;
    Account& receiver = to_it->second;
    if (sender.balance(currency) < amount) {
      think_locked("Transfer rejected: insufficient sandbox balance for " + from_id);
      return false;
    }

    sender.set_balance(currency, sender.balance(currency) - amount);
    receiver.set_balance(currency, receiver.balance(currency) + amount);

    auto now = std::chrono::system_clock::now();
    std::time_t t = std::chrono::system_clock::to_time_t(now);
    std::stringstream ts;
    ts << std::put_time(std::gmtime(&t), "%Y-%m-%dT%H:%M:%SZ");

    Transaction out_tx{ts.str(), "TRANSFER_OUT", from_id, to_id, currency, amount, note};
    Transaction in_tx{ts.str(), "TRANSFER_IN", from_id, to_id, currency, amount, note};
    sender.record(out_tx);
    receiver.record(in_tx);

    std::stringstream msg;
    msg << "Simulated transfer " << from_id << " -> " << to_id << ": " << amount << " "
        << currency << " (" << note << ")";
    think_locked(msg.str());
    return true;
  }
};

// ============================================================================
// Page Layout & Base Generator Class
// ============================================================================

std::string get_html_template(const std::string& title, const std::string& content) {
  std::stringstream ss;
  ss << "<!DOCTYPE html>\n"
        "<html lang=\"en\">\n"
        "<head>\n"
        "    <meta charset=\"UTF-8\">\n"
        "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n"
        "    <title>" << html_escape(title) << "</title>\n"
        "    <style>\n"
        "        body {\n"
        "            font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, Roboto, sans-serif;\n"
        "            background-color: #f8fafc;\n"
        "            color: #1e293b;\n"
        "            margin: 0;\n"
        "            padding: 0;\n"
        "            line-height: 1.5;\n"
        "        }\n"
        "        header {\n"
        "            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);\n"
        "            color: #ffffff;\n"
        "            padding: 1rem 2rem;\n"
        "            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);\n"
        "        }\n"
        "        .header-container {\n"
        "            max-width: 1100px;\n"
        "            margin: 0 auto;\n"
        "            display: flex;\n"
        "            justify-content: space-between;\n"
        "            align-items: center;\n"
        "            flex-wrap: wrap;\n"
        "            gap: 1rem;\n"
        "        }\n"
        "        header h1 {\n"
        "            margin: 0;\n"
        "            font-size: 1.35rem;\n"
        "            font-weight: 700;\n"
        "        }\n"
        "        nav {\n"
        "            display: flex;\n"
        "            gap: 1.25rem;\n"
        "        }\n"
        "        nav a {\n"
        "            color: #94a3b8;\n"
        "            text-decoration: none;\n"
        "            font-weight: 500;\n"
        "            transition: color 0.15s;\n"
        "            padding-bottom: 0.25rem;\n"
        "        }\n"
        "        nav a:hover {\n"
        "            color: #ffffff;\n"
        "        }\n"
        "        nav a.active {\n"
        "            color: #38bdf8;\n"
        "            border-bottom: 2px solid #38bdf8;\n"
        "        }\n"
        "        .container {\n"
        "            max-width: 1100px;\n"
        "            margin: 2rem auto;\n"
        "            padding: 0 1.5rem;\n"
        "        }\n"
        "        .card {\n"
        "            background: #ffffff;\n"
        "            border: 1px solid #e2e8f0;\n"
        "            border-radius: 12px;\n"
        "            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05);\n"
        "            padding: 2rem;\n"
        "            margin-bottom: 2rem;\n"
        "        }\n"
        "        .card-title {\n"
        "            font-size: 1.35rem;\n"
        "            font-weight: 700;\n"
        "            color: #0f172a;\n"
        "            border-bottom: 1px solid #e2e8f0;\n"
        "            padding-bottom: 0.75rem;\n"
        "            margin-top: 0;\n"
        "            margin-bottom: 1.5rem;\n"
        "        }\n"
        "        .grid {\n"
        "            display: grid;\n"
        "            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));\n"
        "            gap: 1.5rem;\n"
        "        }\n"
        "        .field-group {\n"
        "            display: grid;\n"
        "            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));\n"
        "            gap: 1rem;\n"
        "        }\n"
        "        .field {\n"
        "            background-color: #f8fafc;\n"
        "            border: 1px solid #f1f5f9;\n"
        "            border-radius: 8px;\n"
        "            padding: 0.75rem 1rem;\n"
        "        }\n"
        "        .label {\n"
        "            font-size: 0.75rem;\n"
        "            font-weight: 600;\n"
        "            color: #64748b;\n"
        "            text-transform: uppercase;\n"
        "            letter-spacing: 0.05em;\n"
        "            margin-bottom: 0.25rem;\n"
        "        }\n"
        "        .value {\n"
        "            font-size: 0.95rem;\n"
        "            font-weight: 600;\n"
        "            color: #0f172a;\n"
        "            word-break: break-all;\n"
        "            font-family: 'Consolas', 'Courier New', monospace;\n"
        "        }\n"
        "        .badge {\n"
        "            display: inline-block;\n"
        "            padding: 0.25rem 0.5rem;\n"
        "            border-radius: 4px;\n"
        "            font-size: 0.75rem;\n"
        "            font-weight: 700;\n"
        "        }\n"
        "        .badge-success {\n"
        "            background-color: #dcfce7;\n"
        "            color: #166534;\n"
        "        }\n"
        "        .badge-danger {\n"
        "            background-color: #fee2e2;\n"
        "            color: #991b1b;\n"
        "        }\n"
        "        .badge-info {\n"
        "            background-color: #e0f2fe;\n"
        "            color: #0369a1;\n"
        "        }\n"
        "        .btn {\n"
        "            display: inline-flex;\n"
        "            align-items: center;\n"
        "            justify-content: center;\n"
        "            background-color: #2563eb;\n"
        "            color: #ffffff;\n"
        "            padding: 0.625rem 1.25rem;\n"
        "            font-size: 0.875rem;\n"
        "            font-weight: 600;\n"
        "            border-radius: 6px;\n"
        "            text-decoration: none;\n"
        "            border: none;\n"
        "            cursor: pointer;\n"
        "            transition: background-color 0.15s;\n"
        "        }\n"
        "        .btn:hover {\n"
        "            background-color: #1d4ed8;\n"
        "        }\n"
        "        .btn-secondary {\n"
        "            background-color: #64748b;\n"
        "        }\n"
        "        .btn-secondary:hover {\n"
        "            background-color: #475569;\n"
        "        }\n"
        "        .form-layout {\n"
        "            display: flex;\n"
        "            flex-direction: column;\n"
        "            gap: 1.25rem;\n"
        "            max-width: 500px;\n"
        "        }\n"
        "        .form-group {\n"
        "            display: flex;\n"
        "            flex-direction: column;\n"
        "            gap: 0.375rem;\n"
        "        }\n"
        "        .form-group label {\n"
        "            font-size: 0.875rem;\n"
        "            font-weight: 600;\n"
        "            color: #334155;\n"
        "        }\n"
        "        .form-group input, .form-group select {\n"
        "            padding: 0.625rem 0.875rem;\n"
        "            border: 1px solid #cbd5e1;\n"
        "            border-radius: 6px;\n"
        "            font-size: 0.95rem;\n"
        "        }\n"
        "        .footer {\n"
        "            text-align: center;\n"
        "            color: #64748b;\n"
        "            font-size: 0.875rem;\n"
        "            margin-top: 4rem;\n"
        "            padding: 1.5rem 0;\n"
        "            border-top: 1px solid #e2e8f0;\n"
        "        }\n"
        "        table.data {\n"
        "            width: 100%;\n"
        "            border-collapse: collapse;\n"
        "        }\n"
        "        table.data th, table.data td {\n"
        "            padding: 0.75rem;\n"
        "            border-bottom: 1px solid #e2e8f0;\n"
        "            text-align: left;\n"
        "            font-size: 0.9rem;\n"
        "        }\n"
        "        table.data th {\n"
        "            background-color: #f1f5f9;\n"
        "        }\n"
        "    </style>\n"
        "</head>\n"
        "<body>\n"
        "    <header>\n"
        "        <div class=\"header-container\">\n"
        "            <h1>C++ Safe Sentient Bank</h1>\n"
        "            <nav>\n"
        "                <a href=\"/\" class=\"" << (title == "Dashboard" ? "active" : "") << "\">Home</a>\n"
        "                <a href=\"/ledger\" class=\"" << (title == "Ledger Snapshot" ? "active" : "") << "\">Ledger</a>\n"
        "                <a href=\"/synonyms\" class=\"" << (title == "AI Evolution Report" ? "active" : "") << "\">AI Synonyms</a>\n"
        "                <a href=\"/transfer-form\" class=\"" << (title == "Simulate Transfer" ? "active" : "") << "\">Transfer</a>\n"
        "            </nav>\n"
        "        </div>\n"
        "    </header>\n"
        "    <div class=\"container\">\n" << content << "\n"
        "        <div class=\"footer\">\n"
        "            C++ Safe Sentient Bank &copy; 2026. Fictional in-memory sandbox only.\n"
        "        </div>\n"
        "    </div>\n"
        "</body>\n"
        "</html>";
  return ss.str();
}

class PageGenerator {
 public:
  virtual ~PageGenerator() = default;
  virtual std::string generate() = 0;
};

class DashboardGenerator : public PageGenerator {
 public:
  std::string generate() override {
    return R"(<div class="card">
  <h2 class="card-title">Dashboard</h2>
  <p>Educational banking and cognitive synonym demo in C++ with cpp-httplib. All balances and transfers are fictional and in-memory.</p>
  <div class="grid" style="margin-top: 2rem;">
    <div style="background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 1.5rem;">
      <h3 style="margin-top:0;">Ledger Snapshot</h3>
      <p style="color: #475569; font-size: 0.9rem;">View simulated institution balances and recent AGI log entries.</p>
      <a href="/ledger" class="btn" style="margin-top: 1rem; display: inline-flex;">View Ledger</a>
    </div>
    <div style="background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 1.5rem;">
      <h3 style="margin-top:0;">AI Synonyms Report</h3>
      <p style="color: #475569; font-size: 0.9rem;">Explore structured concept lists and tagged system states.</p>
      <a href="/synonyms" class="btn" style="margin-top: 1rem; display: inline-flex;">View AI Synonyms</a>
    </div>
    <div style="background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 1.5rem;">
      <h3 style="margin-top:0;">Simulate Transfer</h3>
      <p style="color: #475569; font-size: 0.9rem;">Move sandbox USD between fictional institutions.</p>
      <a href="/transfer-form" class="btn" style="margin-top: 1rem; display: inline-flex;">Simulate Transfer</a>
    </div>
  </div>
</div>)";
  }
};

class LedgerSnapshotGenerator : public PageGenerator {
 public:
  explicit LedgerSnapshotGenerator(const Ledger& ledger) : ledger_(ledger) {}

  std::string generate() override {
    std::stringstream ss;
    ss << "<div class=\"card\">\n"
          "  <h2 class=\"card-title\">Ledger Snapshot</h2>\n"
          "  <table class=\"data\">\n"
          "    <thead><tr><th>ID</th><th>Institution</th><th>Region</th><th>USD Balance</th></tr></thead>\n"
          "    <tbody>\n";

    for (const auto& entry : ledger_.snapshot_accounts()) {
      ss << "      <tr><td>" << html_escape(entry.first) << "</td><td>"
         << html_escape(entry.second.institution_name()) << "</td><td>"
         << html_escape(entry.second.region()) << "</td><td>"
         << html_escape(format_usd(entry.second.balance("USD"))) << "</td></tr>\n";
    }

    ss << "    </tbody>\n  </table>\n"
          "  <h3 style=\"margin-top: 2rem;\">Recent AGI Log</h3>\n"
          "  <div class=\"field-group\" style=\"grid-template-columns: 1fr;\">\n";

    auto log = ledger_.agi_log();
    int start = std::max(0, static_cast<int>(log.size()) - 8);
    for (int i = start; i < static_cast<int>(log.size()); ++i) {
      ss << "    <div class=\"field\"><div class=\"value\">" << html_escape(log[static_cast<size_t>(i)])
         << "</div></div>\n";
    }

    ss << "  </div>\n"
          "  <div style=\"margin-top: 2rem; display: flex; gap: 1rem;\">\n"
          "    <a href=\"/ledger\" class=\"btn\">Refresh</a>\n"
          "    <a href=\"/\" class=\"btn btn-secondary\">Back to Home</a>\n"
          "  </div>\n"
          "</div>";
    return ss.str();
  }

 private:
  const Ledger& ledger_;
};

class SynonymReportGenerator : public PageGenerator {
 public:
  std::string generate() override {
    std::stringstream ss;
    ss << "<div class=\"card\">\n"
          "  <h2 class=\"card-title\">AI Evolution &amp; Synonym Report</h2>\n"
          "  <div style=\"overflow-x: auto;\">\n"
          "    <table class=\"data\">\n"
          "      <thead><tr><th>Concept</th><th>Original Synonym</th><th>Uppercase</th><th>Tagged Version</th></tr></thead>\n"
          "      <tbody>\n";

    auto synonyms = get_all_synonyms();
    for (size_t i = 0; i < synonyms.size(); ++i) {
      std::string original = synonyms[i];
      ss << "        <tr><td>Concept " << (i + 1) << "</td><td>" << html_escape(original)
         << "</td><td>" << html_escape(to_uppercase(original)) << "</td><td>"
         << html_escape(tag_synonym(original)) << "</td></tr>\n";
    }

    ss << "      </tbody>\n    </table>\n  </div>\n"
          "  <div style=\"background-color: #eff6ff; border-left: 4px solid #3b82f6; padding: 1rem; margin: 1.5rem 0;\">\n"
          "    <strong>Selected Active Persona:</strong> <span style=\"font-family: monospace; color: #1d4ed8;\">"
       << html_escape(tag_synonym(get_random_synonym()))
       << "</span>\n  </div>\n"
          "  <div style=\"display: flex; gap: 1rem;\">\n"
          "    <a href=\"/synonyms\" class=\"btn\">Generate New Report</a>\n"
          "    <a href=\"/\" class=\"btn btn-secondary\">Back to Home</a>\n"
          "  </div>\n"
          "</div>";
    return ss.str();
  }
};

class TransferFormGenerator : public PageGenerator {
 public:
  std::string generate() override {
    return R"(<div class="card">
  <h2 class="card-title">Simulate Sandbox Transfer</h2>
  <form action="/transfer" method="GET" class="form-layout">
    <div class="form-group">
      <label for="from_id">From Account</label>
      <select id="from_id" name="from_id" required>
        <option value="JPM-US">JPM-US</option>
        <option value="ECB-EU">ECB-EU</option>
        <option value="FED-RESERVE">FED-RESERVE</option>
      </select>
    </div>
    <div class="form-group">
      <label for="to_id">To Account</label>
      <select id="to_id" name="to_id" required>
        <option value="ECB-EU">ECB-EU</option>
        <option value="JPM-US">JPM-US</option>
        <option value="FED-RESERVE">FED-RESERVE</option>
      </select>
    </div>
    <div class="form-group">
      <label for="amount">Amount (USD, whole dollars)</label>
      <input type="number" id="amount" name="amount" value="1000" min="1" required>
    </div>
    <div class="form-group">
      <label for="note">Note</label>
      <input type="text" id="note" name="note" placeholder="Educational transfer note">
    </div>
    <div style="display: flex; gap: 1rem; margin-top: 1rem;">
      <button type="submit" class="btn">Simulate Transfer</button>
      <a href="/" class="btn btn-secondary">Cancel</a>
    </div>
  </form>
</div>)";
  }
};

class TransferResultGenerator : public PageGenerator {
 public:
  TransferResultGenerator(Ledger& ledger, std::string from_id, std::string to_id,
                          std::string amount_str, std::string note)
      : ledger_(ledger),
        from_id_(std::move(from_id)),
        to_id_(std::move(to_id)),
        amount_str_(std::move(amount_str)),
        note_(std::move(note)) {}

  std::string generate() override {
    long amount = 0;
    try {
      if (!amount_str_.empty()) {
        amount = std::stol(amount_str_) * 100;
      }
    } catch (...) {
      amount = 0;
    }

    bool success = false;
    if (amount > 0 && from_id_ != to_id_) {
      success = ledger_.transfer(from_id_, to_id_, "USD", amount,
                               note_.empty() ? "Web UI sandbox transfer" : note_);
    }

    std::stringstream ss;
    ss << "<div class=\"card\">\n";
    if (success) {
      ss << "  <h2 class=\"card-title\" style=\"color: #166534;\">Transfer Recorded</h2>\n"
            "  <div class=\"field-group\" style=\"grid-template-columns: 1fr;\">\n"
            "    <div class=\"field\"><div class=\"label\">From</div><div class=\"value\">"
         << html_escape(from_id_) << "</div></div>\n"
            "    <div class=\"field\"><div class=\"label\">To</div><div class=\"value\">"
         << html_escape(to_id_) << "</div></div>\n"
            "    <div class=\"field\"><div class=\"label\">Amount</div><div class=\"value\">"
         << html_escape(format_usd(amount)) << "</div></div>\n"
            "    <div class=\"field\"><div class=\"label\">Status</div><div class=\"value\"><span class=\"badge badge-success\">Success</span></div></div>\n"
            "  </div>\n";
    } else {
      ss << "  <h2 class=\"card-title\" style=\"color: #991b1b;\">Transfer Failed</h2>\n"
            "  <p>Check account IDs, amount, and sandbox balance. Transfers are fictional only.</p>\n";
    }

    ss << "  <div style=\"display: flex; gap: 1rem;\">\n"
          "    <a href=\"/transfer-form\" class=\"btn\">Simulate Another</a>\n"
          "    <a href=\"/ledger\" class=\"btn btn-secondary\">View Ledger</a>\n"
          "  </div>\n"
          "</div>";
    return ss.str();
  }

 private:
  Ledger& ledger_;
  std::string from_id_;
  std::string to_id_;
  std::string amount_str_;
  std::string note_;
};

// ============================================================================
// Server Setup
// ============================================================================

int main() {
  Ledger ledger;
  ledger.initialize_network();

  httplib::Server svr;

  svr.Get("/", [](const httplib::Request&, httplib::Response& res) {
    DashboardGenerator gen;
    res.set_content(get_html_template("Dashboard", gen.generate()), "text/html; charset=utf-8");
  });

  svr.Get("/ledger", [&ledger](const httplib::Request&, httplib::Response& res) {
    LedgerSnapshotGenerator gen(ledger);
    res.set_content(get_html_template("Ledger Snapshot", gen.generate()), "text/html; charset=utf-8");
  });

  svr.Get("/synonyms", [](const httplib::Request&, httplib::Response& res) {
    SynonymReportGenerator gen;
    res.set_content(get_html_template("AI Evolution Report", gen.generate()), "text/html; charset=utf-8");
  });

  svr.Get("/transfer-form", [](const httplib::Request&, httplib::Response& res) {
    TransferFormGenerator gen;
    res.set_content(get_html_template("Simulate Transfer", gen.generate()), "text/html; charset=utf-8");
  });

  svr.Get("/transfer", [&ledger](const httplib::Request& req, httplib::Response& res) {
    std::string from_id = req.has_param("from_id") ? req.get_param_value("from_id") : "";
    std::string to_id = req.has_param("to_id") ? req.get_param_value("to_id") : "";
    std::string amount_str = req.has_param("amount") ? req.get_param_value("amount") : "0";
    std::string note = req.has_param("note") ? req.get_param_value("note") : "";
    TransferResultGenerator gen(ledger, from_id, to_id, amount_str, note);
    res.set_content(get_html_template("Transfer Result", gen.generate()), "text/html; charset=utf-8");
  });

  const int port = 8080;
  std::cout << "C++ Safe Sentient Bank started.\n";
  std::cout << "Dashboard:         http://localhost:" << port << "/\n";
  std::cout << "Ledger Snapshot:   http://localhost:" << port << "/ledger\n";
  std::cout << "AI Synonyms:       http://localhost:" << port << "/synonyms\n";
  std::cout << "Simulate Transfer: http://localhost:" << port << "/transfer-form\n";

  svr.listen("0.0.0.0", port);
  return 0;
}
