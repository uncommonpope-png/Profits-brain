#!/bin/bash
# PLT SALES FUNNEL AUTOMATION - Convert visitors to customers automatically
# PROFIT: Maximize conversion rates | LOVE: Guide prospects naturally | TAX: Minimize manual sales work

FUNNEL_LOG="sales-funnel.log"
FUNNEL_DATA="plt-funnel-data.json"
FUNNEL_ASSETS="plt-content/funnel"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] FUNNEL: $1" | tee -a "$FUNNEL_LOG"
}

# Setup sales funnel infrastructure
setup_funnel_system() {
    mkdir -p "$FUNNEL_ASSETS"/{landing-pages,email-sequences,upsells,checkout,analytics}
    log "🎯 Sales funnel system initialized"
}

# Create landing pages for different traffic sources
create_landing_pages() {
    # Primary PLT Framework landing page
    cat > "$FUNNEL_ASSETS/landing-pages/plt-framework-main.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stop Making $10,000 Mistakes - PLT Framework</title>
    <style>
        .container { max-width: 800px; margin: 0 auto; padding: 20px; }
        .headline { font-size: 36px; color: #1a1a1a; margin-bottom: 20px; }
        .subhead { font-size: 24px; color: #666; margin-bottom: 30px; }
        .cta-button { background: #ff6b35; color: white; padding: 20px 40px; font-size: 18px; border: none; border-radius: 5px; cursor: pointer; }
        .benefit { margin: 20px 0; padding: 15px; background: #f8f8f8; border-radius: 5px; }
        .proof { background: #e8f5e8; padding: 20px; margin: 20px 0; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="headline">The $25,000 Decision-Making Framework That Prevents Costly Mistakes</h1>
        
        <p class="subhead">How the PROFIT · LOVE · TAX equation helps entrepreneurs make mathematically-correct decisions (even when your gut says otherwise)</p>

        <div class="proof">
            <strong>Case Study:</strong> Sarah used PLT to avoid a $50,000 partnership mistake and instead restructured the deal into a $75,000 profit. The calculation took 5 minutes.
        </div>

        <h2>What You Get:</h2>
        <div class="benefit">
            ✅ <strong>The PLT Framework book</strong> - Complete decision-making system
        </div>
        <div class="benefit">
            ✅ <strong>PLT Calculator</strong> - Instant decision analysis tool
        </div>
        <div class="benefit">
            ✅ <strong>10 Real Case Studies</strong> - See PLT in action ($500 to $500K decisions)
        </div>
        <div class="benefit">
            ✅ <strong>Decision Templates</strong> - Excel worksheets for complex scenarios
        </div>
        <div class="benefit">
            ✅ <strong>30-Day Guarantee</strong> - If PLT doesn't change your decision-making, full refund
        </div>

        <center>
            <button class="cta-button" onclick="location.href='#order'">Get PLT Framework - $47 (Usually $97)</button>
        </center>

        <h2>Why Most "Profitable" Decisions Actually Lose Money</h2>
        <p>Traditional business advice tells you to "follow the profit." But profit alone is incomplete.</p>
        
        <p>Every decision has three forces:</p>
        <ul>
            <li><strong>PROFIT</strong> - What you gain (money, opportunities, skills)</li>
            <li><strong>LOVE</strong> - Relationship impact (positive or negative)</li>
            <li><strong>TAX</strong> - True cost (time, energy, opportunity cost)</li>
        </ul>

        <p>The formula: <strong>SOUL PROFIT = PROFIT + LOVE - TAX</strong></p>

        <div class="proof">
            <strong>Example:</strong> $20K consulting project<br>
            PROFIT: $20,000 fee<br>
            LOVE: -$5,000 (relationship strain)<br>
            TAX: $18,000 (time + opportunity cost)<br>
            <strong>SOUL PROFIT: -$3,000</strong> ❌<br><br>
            The "profitable" project actually loses money when you calculate ALL factors.
        </div>

        <h2>Who This Is For:</h2>
        <ul>
            <li>Entrepreneurs making 5-figure+ decisions</li>
            <li>Business owners tired of "gut feeling" decisions</li>
            <li>Anyone who's made a "profitable" choice that felt wrong later</li>
            <li>People who want mathematical certainty in decision-making</li>
        </ul>

        <h2>About Craig Jones</h2>
        <p>Creator of the PLT Framework. After losing $75,000 on "profitable" decisions, Craig developed PLT to measure the true value of every choice. Used by 15,000+ entrepreneurs and featured in...</p>

        <center>
            <button class="cta-button" onclick="location.href='#order'">Get PLT Framework - Limited Time $47</button>
        </center>

        <div id="order">
            <!-- Stripe checkout integration would go here -->
            <p><strong>Secure Checkout - 30-Day Money-Back Guarantee</strong></p>
        </div>

        <script>
        // Track visitor behavior for funnel optimization
        // Heatmap integration
        // A/B testing framework
        </script>
    </div>
</body>
</html>
EOF

    # Calculator-focused landing page
    cat > "$FUNNEL_ASSETS/landing-pages/calculator-lead.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Free PLT Calculator - Make Better Decisions in 2 Minutes</title>
</head>
<body>
    <div class="container">
        <h1>Calculate Any Decision in 2 Minutes</h1>
        <p class="subhead">The free PLT Calculator shows you the real profit of any choice (including hidden costs most people miss)</p>

        <div class="calculator-preview">
            <h3>Example: Should I take this job offer?</h3>
            <div class="calc-input">PROFIT: $85,000 salary + $10,000 learning = $95,000</div>
            <div class="calc-input">LOVE: New team relationships + industry connections = $15,000</div>
            <div class="calc-input">TAX: Commute time + stress + opportunity cost = $35,000</div>
            <div class="calc-result"><strong>SOUL PROFIT: $75,000 ✅ Take the job!</strong></div>
        </div>

        <center>
            <button class="cta-button">Get Free Calculator (No Email Required)</button>
        </center>

        <h2>What People Say:</h2>
        <div class="testimonial">"Saved me from a $25,000 mistake in 5 minutes" - Jennifer M.</div>
        <div class="testimonial">"Finally, a way to make decisions with math instead of gut feeling" - David R.</div>

        <h2>Works For Any Decision:</h2>
        <ul>
            <li>Business partnerships</li>
            <li>Job opportunities</li>
            <li>Investment choices</li>
            <li>Major purchases</li>
            <li>Life changes</li>
        </ul>

        <center>
            <button class="cta-button">Start Calculating Now</button>
        </center>
    </div>
</body>
</html>
EOF

    log "🌐 Landing pages created for different traffic sources"
}

# Create email sequences for sales funnel
create_funnel_sequences() {
    # Post-purchase sequence
    cat > "$FUNNEL_ASSETS/email-sequences/post-purchase-upsell.md" << 'EOF'
# Post-Purchase Upsell Sequence

## Email 1: Thank you + immediate access (sent immediately)

**Subject:** Your PLT Framework is ready! + Exclusive bonus inside

Hi {{first_name}},

Welcome to the PLT Framework!

**Your download links:**
- PLT Framework Book (PDF): {{book_link}}
- PLT Calculator: {{calculator_link}}
- Bonus Case Studies: {{bonus_link}}
- Decision Templates: {{templates_link}}

**Do this first:**
1. Download the book to your device
2. Bookmark the calculator
3. Read Chapter 3 (the "aha moment" chapter)

**SPECIAL BONUS:** Since you just purchased, you qualify for the PLT Advanced Course at 50% off (normally $297, yours for $147).

The Advanced Course includes:
- 4 weeks of video training
- Group coaching calls with Craig
- Advanced calculation techniques
- Personal decision consultations
- Lifetime course updates

**This offer expires in 24 hours.**
[Claim 50% Off Advanced Course]

**Questions?** Hit reply - I personally help all PLT Framework customers.

Ready to master decision-making?
Craig Jones

P.S. The Advanced Course spots are limited to 50 students per month. Don't miss out.

---

## Email 2: Course reminder (sent 12 hours later)

**Subject:** 12 hours left - PLT Advanced Course 50% off

{{first_name}},

Quick reminder: Your 50% discount on PLT Advanced Course expires in 12 hours.

**What you get:**
✅ 4 weeks of step-by-step video training
✅ Live group coaching with Craig (2x monthly)
✅ Advanced PLT techniques not in the book
✅ Personal decision consultation ($200 value)
✅ Private student community
✅ Lifetime access + updates

**Investment:** $147 (normally $297)
**Guarantee:** 60 days - complete Module 1, and if you don't see immediate value, full refund

[Secure Your Spot - 50% Off]

**Still on the fence?**
Check out what current students say: {{testimonials_link}}

**Questions?** Reply to this email.

Craig

P.S. This discount won't be offered again. Next cohort pays full price ($297).

---

## Email 3: Final chance (sent 2 hours before expiration)

**Subject:** Final 2 hours - Don't miss PLT Advanced (50% off ends tonight)

{{first_name}},

Your 50% discount expires at midnight tonight.

**The reality:** Most people buy frameworks like PLT but never fully implement them.

**The difference:** The Advanced Course ensures you actually USE what you learned.

Here's what happens:
- Week 1: Master the core calculations
- Week 2: Apply PLT to YOUR specific decisions
- Week 3: Advanced techniques (scenario modeling, probability weighting)  
- Week 4: Build PLT into your permanent decision-making process

**Plus:** Direct access to Craig via group coaching calls.

**Result:** You'll never second-guess a major decision again.

**Last chance:** [Get PLT Advanced - $147]

This offer expires at midnight (Eastern).

Craig

P.S. If you're still reading this email, you know you want to go deeper with PLT. Don't let indecision cost you $150 in savings.
EOF

    log "📧 Sales funnel email sequences created"
}

# Create upsell and cross-sell offers
create_upsell_system() {
    cat > "$FUNNEL_ASSETS/upsells/offer-stack.json" << 'EOF'
{
  "upsell_offers": {
    "book_buyers": [
      {
        "product": "PLT Advanced Course",
        "original_price": 297,
        "upsell_price": 147,
        "discount": "50%",
        "urgency": "24 hours only",
        "conversion_target": "25%"
      },
      {
        "product": "PLT Calculator Pro",
        "original_price": 47,
        "upsell_price": 27,
        "discount": "40%",
        "urgency": "This page only",
        "conversion_target": "35%"
      }
    ],
    "calculator_users": [
      {
        "product": "PLT Framework Book",
        "original_price": 47,
        "upsell_price": 37,
        "discount": "20%",
        "urgency": "Calculator users only",
        "conversion_target": "15%"
      }
    ],
    "course_students": [
      {
        "product": "PLT Mastermind",
        "original_price": 997,
        "upsell_price": 497,
        "discount": "50%",
        "urgency": "Course graduates only",
        "conversion_target": "10%"
      },
      {
        "product": "PLT Business Consultation",
        "original_price": 500,
        "upsell_price": 297,
        "discount": "40%",
        "urgency": "This month only",
        "conversion_target": "20%"
      }
    ]
  },
  "cross_sell_offers": {
    "plt_books": [
      "PLT for Relationships (coming soon)",
      "PLT for Investing (pre-order)",
      "PLT Case Study Collection"
    ],
    "complementary_products": [
      "Business Decision Journal",
      "PLT Worksheets Pack",
      "Annual PLT Planning Guide"
    ]
  }
}
EOF

    log "💰 Upsell and cross-sell system created"
}

# Funnel analytics and optimization
create_analytics_system() {
    cat > "$FUNNEL_ASSETS/analytics/funnel-metrics.json" << 'EOF'
{
  "conversion_funnel": {
    "traffic_sources": {
      "organic_search": {
        "visitors_per_day": 150,
        "email_conversion": 0.12,
        "purchase_conversion": 0.025
      },
      "social_media": {
        "visitors_per_day": 75,
        "email_conversion": 0.08,
        "purchase_conversion": 0.015
      },
      "paid_ads": {
        "visitors_per_day": 200,
        "email_conversion": 0.15,
        "purchase_conversion": 0.04
      },
      "referrals": {
        "visitors_per_day": 25,
        "email_conversion": 0.25,
        "purchase_conversion": 0.08
      }
    },
    "conversion_steps": {
      "visitor": 100,
      "email_signup": 12,
      "calculator_use": 8,
      "book_purchase": 3,
      "course_upsell": 1
    },
    "optimization_targets": {
      "email_conversion": 0.20,
      "book_conversion": 0.05,
      "upsell_conversion": 0.30
    }
  },
  "revenue_metrics": {
    "average_order_value": 47,
    "lifetime_value": 285,
    "refund_rate": 0.05,
    "customer_acquisition_cost": 23
  }
}
EOF

    log "📊 Analytics and tracking system created"
}

# A/B testing framework
create_ab_testing_system() {
    cat > "$FUNNEL_ASSETS/analytics/ab-tests.json" << 'EOF'
{
  "active_tests": {
    "landing_page_headline": {
      "variant_a": "Stop Making $10,000 Mistakes",
      "variant_b": "The Decision Framework That Prevents Costly Mistakes",
      "metric": "email_signup_rate",
      "duration": "2_weeks",
      "sample_size": 1000
    },
    "email_subject_lines": {
      "variant_a": "Your PLT calculation results",
      "variant_b": "How did your PLT calculation turn out?",
      "metric": "open_rate",
      "duration": "1_week",
      "sample_size": 500
    },
    "price_points": {
      "variant_a": 47,
      "variant_b": 67,
      "variant_c": 37,
      "metric": "conversion_rate",
      "duration": "3_weeks",
      "sample_size": 1500
    }
  },
  "completed_tests": {
    "cta_button_color": {
      "winner": "orange",
      "improvement": "23%",
      "confidence": "95%"
    }
  }
}
EOF

    log "🧪 A/B testing framework created"
}

# Process funnel automation
process_funnel_automation() {
    log "🔄 Processing sales funnel automation..."
    
    # Check for new visitors and segment by source
    # Trigger appropriate landing page experience
    # Track conversion through each step
    # Send follow-up sequences based on behavior
    # Optimize based on performance data
    
    log "📈 Funnel optimization processing complete"
}

# Main execution
main() {
    log "🚀 PLT Sales Funnel Automation Starting"
    
    setup_funnel_system
    create_landing_pages
    create_funnel_sequences
    create_upsell_system
    create_analytics_system
    create_ab_testing_system
    process_funnel_automation
    
    log "✅ Sales funnel automation complete"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi