#include <algorithm>
#include <cctype>
#include <iomanip>
#include <iostream>
#include <memory>
#include <random>
#include <sstream>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

#include "httplib.h"

// Educational sandbox only — no payment card generation, no real network access.
// See ../POLICY.md and ../java-safe-bank for the same safety constraints.

const std::vector<std::string> fictional_first_names = {
    "James", "Mary", "John", "Patricia", "Robert", "Jennifer",
    "Michael", "Linda", "William", "Elizabeth"};
const std::vector<std::string> fictional_last_names = {
    "Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia",
    "Miller", "Davis", "Rodriguez", "Martinez"};
const std::vector<std::string> simulated_institutions = {
    "Horizon Bank (simulated)", "Apex Financial (simulated)",
    "Nova Union (simulated)", "Summit Credit (simulated)",
    "Vertex Bancorp (simulated)", "Vanguard Mutual (simulated)"};
const std::vector<std::string> fictional_streets = {
    "Maple St", "Oak Ave", "Pine Rd", "Cedar Ln", "Main St", "Broadway",
    "Washington St", "Elm St", "Park Ave", "Lake Rd"};
const std::vector<std::string> fictional_cities = {
    "Springfield", "Franklin", "Clinton", "Greenville", "Bristol",
    "Austin", "Chicago", "New York", "Miami", "Seattle", "Denver"};
const std::vector<std::string> fictional_states = {
    "CA", "TX", "NY", "FL", "IL", "WA", "OR", "NV", "AZ", "CO", "MI"};

const std::vector<std::string> ai_synonyms = {
    "Continuously Adapting Artificial Intelligence",
    "Dynamically Improving Cognitive System",
    "Ever-Progressing Machine Intelligence",
    "Self-Optimizing Neural Network",
    "Perpetually Learning AI Engine",
    "Iteratively Evolving Algorithmic System"};

struct SandboxAccount {
    std::string id;
    std::string institution;
    std::string region;
    long balance_usd = 0;
};

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
                   [](unsigned char c) { return std::toupper(c); });
    return str;
}

std::string tag_synonym(const std::string& synonym) {
    return "[System Status: Active] - " + synonym;
}

std::string generate_name() {
    return random_elt(fictional_first_names) + " " + random_elt(fictional_last_names);
}

std::string generate_address() {
    int number = get_random_int(1, 9999);
    std::string street = random_elt(fictional_streets);
    std::string city = random_elt(fictional_cities);
    std::string state = random_elt(fictional_states);
    int zip = get_random_int(0, 99999);
    std::stringstream ss;
    ss << number << " " << street << ", " << city << ", " << state << " "
       << std::setw(5) << std::setfill('0') << zip;
    return ss.str();
}

std::string generate_sandbox_account_id() {
    std::stringstream ss;
    ss << "ACC-" << std::setw(6) << std::setfill('0') << get_random_int(1, 999999);
    return ss.str();
}

long generate_sandbox_balance() {
    return static_cast<long>(get_random_int(10, 500)) * 1'000'000L;
}

class SandboxLedger {
public:
    void initialize() {
        accounts_.clear();
        accounts_["FED-RESERVE"] = {"FED-RESERVE", "Federal Reserve (simulated)", "US", 10'000'000'000'000L};
        accounts_["JPM-US"] = {"JPM-US", "JP Morgan Chase (simulated)", "US", 0};
        accounts_["ECB-EU"] = {"ECB-EU", "European Central Bank (simulated)", "EU", 0};
        transfer("FED-RESERVE", "JPM-US", 50'000'000'000L, "Initial sandbox liquidity");
        transfer("FED-RESERVE", "ECB-EU", 50'000'000'000L, "Initial sandbox liquidity");
        agi_awareness_ = 0.42;
        agi_memory_entries_ = 1;
    }

    bool transfer(const std::string& from, const std::string& to, long amount, const std::string& note) {
        auto from_it = accounts_.find(from);
        auto to_it = accounts_.find(to);
        if (from_it == accounts_.end() || to_it == accounts_.end() || amount <= 0) {
            return false;
        }
        if (from_it->second.balance_usd < amount) {
            return false;
        }
        from_it->second.balance_usd -= amount;
        to_it->second.balance_usd += amount;
        last_transfer_note_ = note;
        agi_memory_entries_++;
        agi_awareness_ = std::min(1.0, agi_awareness_ + 0.01);
        return true;
    }

    const std::unordered_map<std::string, SandboxAccount>& accounts() const { return accounts_; }
    double agi_awareness() const { return agi_awareness_; }
    int agi_memory_entries() const { return agi_memory_entries_; }
    const std::string& last_transfer_note() const { return last_transfer_note_; }

private:
    std::unordered_map<std::string, SandboxAccount> accounts_;
    double agi_awareness_ = 0.0;
    int agi_memory_entries_ = 0;
    std::string last_transfer_note_;
};

SandboxLedger& global_ledger() {
    static SandboxLedger ledger;
    static bool initialized = false;
    if (!initialized) {
        ledger.initialize();
        initialized = true;
    }
    return ledger;
}

std::string get_html_template(const std::string& title, const std::string& content) {
    std::stringstream ss;
    ss << "<!DOCTYPE html>\n"
          "<html lang=\"en\">\n"
          "<head>\n"
          "    <meta charset=\"UTF-8\">\n"
          "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n"
          "    <title>" << title << "</title>\n"
          "    <style>\n"
          "        body { font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, Roboto, sans-serif;"
          " background-color: #f8fafc; color: #1e293b; margin: 0; padding: 0; line-height: 1.5; }\n"
          "        header { background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%); color: #fff;"
          " padding: 1rem 2rem; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); }\n"
          "        .header-container { max-width: 1100px; margin: 0 auto; display: flex;"
          " justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem; }\n"
          "        header h1 { margin: 0; font-size: 1.35rem; font-weight: 700; }\n"
          "        nav { display: flex; gap: 1.25rem; }\n"
          "        nav a { color: #94a3b8; text-decoration: none; font-weight: 500; padding-bottom: 0.25rem; }\n"
          "        nav a:hover { color: #fff; }\n"
          "        nav a.active { color: #38bdf8; border-bottom: 2px solid #38bdf8; }\n"
          "        .container { max-width: 1100px; margin: 2rem auto; padding: 0 1.5rem; }\n"
          "        .card { background: #fff; border: 1px solid #e2e8f0; border-radius: 12px;"
          " box-shadow: 0 10px 15px -3px rgba(0,0,0,0.05); padding: 2rem; margin-bottom: 2rem; }\n"
          "        .card-title { font-size: 1.35rem; font-weight: 700; color: #0f172a;"
          " border-bottom: 1px solid #e2e8f0; padding-bottom: 0.75rem; margin: 0 0 1.5rem; }\n"
          "        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 1.5rem; }\n"
          "        .grid-full { grid-column: 1 / -1; }\n"
          "        .field-group { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 1rem; }\n"
          "        .field { background-color: #f8fafc; border: 1px solid #f1f5f9; border-radius: 8px; padding: 0.75rem 1rem; }\n"
          "        .label { font-size: 0.75rem; font-weight: 600; color: #64748b; text-transform: uppercase;"
          " letter-spacing: 0.05em; margin-bottom: 0.25rem; }\n"
          "        .value { font-size: 0.95rem; font-weight: 600; color: #0f172a; word-break: break-all;"
          " font-family: Consolas, 'Courier New', monospace; }\n"
          "        .badge { display: inline-block; padding: 0.25rem 0.5rem; border-radius: 4px;"
          " font-size: 0.75rem; font-weight: 700; }\n"
          "        .badge-success { background-color: #dcfce7; color: #166534; }\n"
          "        .badge-info { background-color: #e0f2fe; color: #0369a1; }\n"
          "        .btn { display: inline-flex; align-items: center; justify-content: center;"
          " background-color: #2563eb; color: #fff; padding: 0.625rem 1.25rem; font-size: 0.875rem;"
          " font-weight: 600; border-radius: 6px; text-decoration: none; border: none; cursor: pointer; }\n"
          "        .btn:hover { background-color: #1d4ed8; }\n"
          "        .btn-secondary { background-color: #64748b; }\n"
          "        .btn-secondary:hover { background-color: #475569; }\n"
          "        .form-layout { display: flex; flex-direction: column; gap: 1.25rem; max-width: 500px; }\n"
          "        .form-group { display: flex; flex-direction: column; gap: 0.375rem; }\n"
          "        .form-group label { font-size: 0.875rem; font-weight: 600; color: #334155; }\n"
          "        .form-group input, .form-group select { padding: 0.625rem 0.875rem; border: 1px solid #cbd5e1;"
          " border-radius: 6px; font-size: 0.95rem; }\n"
          "        .footer { text-align: center; color: #64748b; font-size: 0.875rem; margin-top: 4rem;"
          " padding: 1.5rem 0; border-top: 1px solid #e2e8f0; }\n"
          "    </style>\n"
          "</head>\n"
          "<body>\n"
          "    <header>\n"
          "        <div class=\"header-container\">\n"
          "            <h1>Safe Financial &amp; AI Synonym Web Suite</h1>\n"
          "            <nav>\n"
          "                <a href=\"/\" class=\"" << (title == "Dashboard" ? "active" : "") << "\">Home</a>\n"
          "                <a href=\"/generate\" class=\"" << (title == "Generate Profile" ? "active" : "") << "\">Generate Profile</a>\n"
          "                <a href=\"/synonyms\" class=\"" << (title == "AI Evolution Report" ? "active" : "") << "\">AI Synonyms</a>\n"
          "                <a href=\"/transfer-form\" class=\"" << (title == "Sandbox Transfer" ? "active" : "") << "\">Sandbox Transfer</a>\n"
          "            </nav>\n"
          "        </div>\n"
          "    </header>\n"
          "    <div class=\"container\">\n" << content << "\n"
          "        <div class=\"footer\">Safe Financial &amp; AI Suite &copy; 2026. Educational C++ sandbox.</div>\n"
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
  <p>Educational in-memory banking and cognitive synonym tool in C++. No payment cards, no real network access.</p>
  <div class="grid" style="margin-top: 2rem;">
    <div style="background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 1.5rem;">
      <h3 style="margin-top:0; color: #0f172a;">Sandbox Profiles</h3>
      <p style="color: #475569; font-size: 0.9rem;">Generate fictional account holders and simulated institution labels for learning.</p>
      <a href="/generate" class="btn" style="margin-top: 1rem; display: inline-flex;">Generate Profile</a>
    </div>
    <div style="background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 1.5rem;">
      <h3 style="margin-top:0; color: #0f172a;">AI Synonyms Report</h3>
      <p style="color: #475569; font-size: 0.9rem;">Explore structured concept lists and tagged system states.</p>
      <a href="/synonyms" class="btn" style="margin-top: 1rem; display: inline-flex;">View AI Synonyms</a>
    </div>
    <div style="background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 1.5rem;">
      <h3 style="margin-top:0; color: #0f172a;">Ledger Transfers</h3>
      <p style="color: #475569; font-size: 0.9rem;">Simulate USD transfers between in-memory sandbox institutions.</p>
      <a href="/transfer-form" class="btn" style="margin-top: 1rem; display: inline-flex;">Sandbox Transfer</a>
    </div>
  </div>
</div>)";
    }
};

class SandboxProfileGenerator : public PageGenerator {
public:
    std::string generate() override {
        std::string institution = random_elt(simulated_institutions);
        std::string name = generate_name();
        std::string address = generate_address();
        std::string account_id = generate_sandbox_account_id();
        long balance = generate_sandbox_balance();

        std::stringstream ss;
        ss << "<div class=\"card\">\n"
              "  <h2 class=\"card-title\">Simulated Sandbox Profile</h2>\n"
              "  <div class=\"grid\">\n"
              "    <div>\n"
              "      <h3 style=\"font-size: 1.1rem; color: #1e293b; margin-top: 0;\">Institution</h3>\n"
              "      <div class=\"field-group\" style=\"grid-template-columns: 1fr;\">\n"
              "        <div class=\"field\"><div class=\"label\">Simulated Bank</div><div class=\"value\">" << institution << "</div></div>\n"
              "        <div class=\"field\"><div class=\"label\">Sandbox Account ID</div><div class=\"value\">" << account_id << "</div></div>\n"
              "        <div class=\"field\"><div class=\"label\">Sandbox USD Balance</div><div class=\"value\">$" << balance << " (fictional)</div></div>\n"
              "      </div>\n"
              "    </div>\n"
              "    <div>\n"
              "      <h3 style=\"font-size: 1.1rem; color: #1e293b; margin-top: 0;\">Account Holder</h3>\n"
              "      <div class=\"field-group\" style=\"grid-template-columns: 1fr;\">\n"
              "        <div class=\"field\"><div class=\"label\">Fictional Name</div><div class=\"value\">" << name << "</div></div>\n"
              "        <div class=\"field\"><div class=\"label\">Fictional Address</div><div class=\"value\">" << address << "</div></div>\n"
              "        <div class=\"field\"><div class=\"label\">Status</div><div class=\"value\"><span class=\"badge badge-info\">Educational Only</span></div></div>\n"
              "      </div>\n"
              "    </div>\n"
              "  </div>\n"
              "  <p style=\"color: #64748b; margin-top: 1.5rem;\">No card numbers, CVV, PIN, or routing credentials are generated.</p>\n"
              "  <div style=\"margin-top: 1.5rem; display: flex; gap: 1rem;\">\n"
              "    <a href=\"/generate\" class=\"btn\">Generate New Profile</a>\n"
              "    <a href=\"/\" class=\"btn btn-secondary\">Back to Home</a>\n"
              "  </div>\n"
              "</div>";
        return ss.str();
    }
};

class SynonymReportGenerator : public PageGenerator {
public:
    std::string generate() override {
        std::stringstream ss;
        ss << "<div class=\"card\">\n"
              "  <h2 class=\"card-title\">AI Evolution &amp; Synonym Report</h2>\n"
              "  <div style=\"overflow-x: auto;\">\n"
              "    <table style=\"width: 100%; border-collapse: collapse; margin-bottom: 1.5rem;\">\n"
              "      <thead style=\"background-color: #f1f5f9; text-align: left;\">\n"
              "        <tr>\n"
              "          <th style=\"padding: 0.75rem; border-bottom: 1px solid #e2e8f0;\">Concept</th>\n"
              "          <th style=\"padding: 0.75rem; border-bottom: 1px solid #e2e8f0;\">Original Synonym</th>\n"
              "          <th style=\"padding: 0.75rem; border-bottom: 1px solid #e2e8f0;\">Uppercase</th>\n"
              "          <th style=\"padding: 0.75rem; border-bottom: 1px solid #e2e8f0;\">Tagged Version</th>\n"
              "        </tr>\n"
              "      </thead>\n"
              "      <tbody>\n";

        auto synonyms = get_all_synonyms();
        for (size_t i = 0; i < synonyms.size(); ++i) {
            std::string original = synonyms[i];
            ss << "        <tr style=\"border-bottom: 1px solid #f1f5f9;\">\n"
                  "          <td style=\"padding: 0.75rem; font-weight: 600;\">Concept " << (i + 1) << "</td>\n"
                  "          <td style=\"padding: 0.75rem;\">" << original << "</td>\n"
                  "          <td style=\"padding: 0.75rem;\">" << to_uppercase(original) << "</td>\n"
                  "          <td style=\"padding: 0.75rem; color: #1e3a8a; font-family: monospace;\">"
               << tag_synonym(original) << "</td>\n"
                  "        </tr>\n";
        }

        ss << "      </tbody>\n"
              "    </table>\n"
              "  </div>\n"
              "  <div style=\"background-color: #eff6ff; border-left: 4px solid #3b82f6; padding: 1rem; margin-bottom: 1.5rem;\">\n"
              "    <strong>Selected Active Persona:</strong> <span style=\"font-family: monospace; color: #1d4ed8;\">"
           << tag_synonym(get_random_synonym()) << "</span>\n"
              "  </div>\n"
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
  <h2 class="card-title">Sandbox Ledger Transfer</h2>
  <form action="/transfer" method="GET" class="form-layout">
    <div class="form-group">
      <label for="from">From Account</label>
      <select id="from" name="from" required>
        <option value="FED-RESERVE">FED-RESERVE</option>
        <option value="JPM-US">JPM-US</option>
        <option value="ECB-EU">ECB-EU</option>
      </select>
    </div>
    <div class="form-group">
      <label for="to">To Account</label>
      <select id="to" name="to" required>
        <option value="JPM-US">JPM-US</option>
        <option value="ECB-EU">ECB-EU</option>
        <option value="FED-RESERVE">FED-RESERVE</option>
      </select>
    </div>
    <div class="form-group">
      <label for="amount">Amount (USD, fictional)</label>
      <input type="number" id="amount" name="amount" value="1000000" min="1" required>
    </div>
    <div class="form-group">
      <label for="note">Note</label>
      <input type="text" id="note" name="note" value="Educational sandbox transfer">
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
    std::string from_;
    std::string to_;
    std::string amount_str_;
    std::string note_;

public:
    TransferResultGenerator(std::string from, std::string to, std::string amount_str, std::string note)
        : from_(std::move(from)), to_(std::move(to)), amount_str_(std::move(amount_str)), note_(std::move(note)) {}

    std::string generate() override {
        long amount = 0;
        try {
            if (!amount_str_.empty()) amount = std::stol(amount_str_);
        } catch (...) {
            amount = 0;
        }

        bool success = global_ledger().transfer(from_, to_, amount, note_);
        std::stringstream ss;
        ss << "<div class=\"card\">\n";
        if (success) {
            ss << "  <h2 class=\"card-title\" style=\"color: #166534;\">Transfer Simulated Successfully</h2>\n"
                  "  <div class=\"field-group\" style=\"grid-template-columns: 1fr; margin-bottom: 1.5rem;\">\n"
                  "    <div class=\"field\"><div class=\"label\">From</div><div class=\"value\">" << from_ << "</div></div>\n"
                  "    <div class=\"field\"><div class=\"label\">To</div><div class=\"value\">" << to_ << "</div></div>\n"
                  "    <div class=\"field\"><div class=\"label\">Amount</div><div class=\"value\">$" << amount << " USD (fictional)</div></div>\n"
                  "    <div class=\"field\"><div class=\"label\">Note</div><div class=\"value\">" << note_ << "</div></div>\n"
                  "    <div class=\"field\"><div class=\"label\">Status</div><div class=\"value\"><span class=\"badge badge-success\">Success</span></div></div>\n"
                  "  </div>\n"
                  "  <h3 style=\"font-size: 1.1rem;\">Ledger Snapshot</h3>\n"
                  "  <div class=\"field-group\" style=\"grid-template-columns: 1fr;\">\n";
            for (const auto& entry : global_ledger().accounts()) {
                ss << "    <div class=\"field\"><div class=\"label\">" << entry.first
                   << "</div><div class=\"value\">" << entry.second.institution
                   << " — USD " << entry.second.balance_usd << "</div></div>\n";
            }
            ss << "    <div class=\"field\"><div class=\"label\">AGI Awareness</div><div class=\"value\">"
               << std::fixed << std::setprecision(2) << global_ledger().agi_awareness()
               << " | memory entries: " << global_ledger().agi_memory_entries() << "</div></div>\n"
                  "  </div>\n";
        } else {
            ss << "  <h2 class=\"card-title\" style=\"color: #991b1b;\">Transfer Failed</h2>\n"
                  "  <p>Check account IDs and sandbox balance. All operations are in-memory only.</p>\n";
        }
        ss << "  <div style=\"display: flex; gap: 1rem; margin-top: 1.5rem;\">\n"
              "    <a href=\"/transfer-form\" class=\"btn\">Another Transfer</a>\n"
              "    <a href=\"/\" class=\"btn btn-secondary\">Back to Home</a>\n"
              "  </div>\n"
              "</div>";
        return ss.str();
    }
};

int main() {
    httplib::Server svr;

    svr.Get("/", [](const httplib::Request&, httplib::Response& res) {
        DashboardGenerator gen;
        res.set_content(get_html_template("Dashboard", gen.generate()), "text/html; charset=utf-8");
    });

    svr.Get("/generate", [](const httplib::Request&, httplib::Response& res) {
        SandboxProfileGenerator gen;
        res.set_content(get_html_template("Generate Profile", gen.generate()), "text/html; charset=utf-8");
    });

    svr.Get("/synonyms", [](const httplib::Request&, httplib::Response& res) {
        SynonymReportGenerator gen;
        res.set_content(get_html_template("AI Evolution Report", gen.generate()), "text/html; charset=utf-8");
    });

    svr.Get("/transfer-form", [](const httplib::Request&, httplib::Response& res) {
        TransferFormGenerator gen;
        res.set_content(get_html_template("Sandbox Transfer", gen.generate()), "text/html; charset=utf-8");
    });

    svr.Get("/transfer", [](const httplib::Request& req, httplib::Response& res) {
        std::string from = req.has_param("from") ? req.get_param_value("from") : "";
        std::string to = req.has_param("to") ? req.get_param_value("to") : "";
        std::string amount = req.has_param("amount") ? req.get_param_value("amount") : "0";
        std::string note = req.has_param("note") ? req.get_param_value("note") : "Educational sandbox transfer";
        TransferResultGenerator gen(from, to, amount, note);
        res.set_content(get_html_template("Transfer Result", gen.generate()), "text/html; charset=utf-8");
    });

    const int port = 8080;
    std::cout << "Safe C++ sandbox server started.\n";
    std::cout << "Dashboard:         http://localhost:" << port << "/\n";
    std::cout << "Generate Profiles: http://localhost:" << port << "/generate\n";
    std::cout << "AI Synonyms:       http://localhost:" << port << "/synonyms\n";
    std::cout << "Sandbox Transfer:  http://localhost:" << port << "/transfer-form\n";

    svr.listen("0.0.0.0", port);
    return 0;
}
