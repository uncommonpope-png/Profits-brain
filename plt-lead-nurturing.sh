#!/bin/bash
# PLT LEAD NURTURING AUTOMATION - Convert prospects to customers
# PROFIT: Increase conversion rates | LOVE: Build trust | TAX: Automate follow-up

NURTURING_LOG="lead-nurturing.log" 
LEADS_DB="plt-leads.json"
NURTURING_CONTENT="plt-content/nurturing"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] NURTURING: $1" | tee -a "$NURTURING_LOG"
}

# Setup lead nurturing system
setup_nurturing_system() {
    mkdir -p "$NURTURING_CONTENT"/{email-sequences,content-offers,retargeting,scoring}
    log "🎯 Lead nurturing system initialized"
}

# Create lead scoring system
create_lead_scoring() {
    cat > "$NURTURING_CONTENT/scoring/lead-scoring-rules.json" << 'EOF'
{
  "scoring_rules": {
    "email_engagement": {
      "opened_email": 5,
      "clicked_link": 10,
      "replied_to_email": 25,
      "forwarded_email": 15
    },
    "website_activity": {
      "visited_homepage": 5,
      "visited_book_page": 15,
      "visited_course_page": 20,
      "visited_pricing": 25,
      "added_to_cart": 50,
      "abandoned_cart": -10
    },
    "calculator_usage": {
      "first_calculation": 30,
      "multiple_calculations": 20,
      "shared_calculation": 15,
      "saved_calculation": 10
    },
    "content_engagement": {
      "downloaded_bonus": 15,
      "watched_video": 10,
      "shared_content": 20,
      "commented": 25
    },
    "social_signals": {
      "followed_social": 10,
      "liked_post": 5,
      "shared_post": 15,
      "mentioned_plt": 30
    }
  },
  "score_thresholds": {
    "cold": 0,
    "warm": 50,
    "hot": 100,
    "ready_to_buy": 150
  }
}
EOF

    log "🏆 Lead scoring system created"
}

# Create nurturing email sequences by segment
create_nurturing_sequences() {
    # Calculator users sequence
    cat > "$NURTURING_CONTENT/email-sequences/calculator-users-sequence.md" << 'EOF'
# Calculator Users Nurturing Sequence

## Email 1: Immediate follow-up (sent 1 hour after first calculation)

**Subject:** How did your PLT calculation turn out?

Hi {{first_name}},

You just ran your first PLT calculation: "{{calculation_topic}}"

**Your result:** {{soul_profit}} soul profit

{{if soul_profit > 0}}
✅ The math says this decision creates value for you.

Here's what successful PLT users do next:
1. Trust the calculation (it's showing reality)
2. Look for ways to amplify the PROFIT or LOVE components
3. Check if any TAX elements can be reduced

**Case study:** How Sarah used PLT to turn a -$2,000 decision into +$8,000 profit by restructuring the terms: [Link]
{{else}}
⚠️ The math shows this decision would destroy value.

Before you dismiss it completely:
1. Can you restructure to improve the equation?
2. What would need to change to make it profitable?  
3. Are there alternatives that score better?

**Case study:** How Mike avoided a $25,000 mistake by listening to his PLT calculation: [Link]
{{endif}}

**Want to see more calculation examples?**
Download: "10 Real PLT Calculations" (free): [Link]

**Question about your results?**
Hit reply - I personally review every calculation.

Craig Jones
Creator, PLT Framework

P.S. The calculator is just the tip of the iceberg. The full framework goes much deeper.

---

## Email 2: Success stories (sent 3 days later)

**Subject:** This $50K decision took 5 minutes to calculate

{{first_name}},

Three days ago, Jennifer faced a $50,000 decision.

Partner offering to buy into her business. Tempting upfront cash, but something felt off.

**Jennifer's PLT calculation:**
- PROFIT: $50,000 cash + reduced workload = $75,000
- LOVE: Partner relationship strain + client confusion = -$15,000  
- TAX: Legal fees + lost autonomy + opportunity cost = $85,000

**SOUL PROFIT: -$25,000**

The math was clear: Don't do it.

Instead, Jennifer restructured:
- Kept 100% ownership
- Hired two employees with $30K
- Maintained all relationships
- Kept full control

**6 months later:** Revenue up 40%, relationships stronger, completely burned out avoided.

The PLT calculation saved her $25,000+ and possibly her business.

**Your turn:**
What big decision could benefit from PLT analysis?
[Use the Calculator] - It's still free.

**Ready to go deeper?**
The full PLT Framework book shows you:
- Advanced calculation techniques
- Complex scenario modeling  
- Personal decision applications
- Business strategy frameworks

Get it here (25% off for calculator users): [Book Link]

Craig

P.S. Next email: The biggest calculation mistake (and how to avoid it).

---

## Email 3: Common mistakes (sent 1 week later)

**Subject:** The $15,000 calculation mistake (avoid this)

{{first_name}},

Last week, Tom made a calculation error that cost him $15,000.

**The decision:** Should he attend a $5,000 business conference?

**Tom's calculation:**
- PROFIT: $20,000 (potential business from networking)
- LOVE: $3,000 (new relationships)  
- TAX: $8,000 (conference + travel + time)
- **SOUL PROFIT: $15,000 ✅**

Looked good. He went.

**The mistake:** Tom calculated potential profit as guaranteed profit.

**What actually happened:**
- PROFIT: $2,000 (actual business generated)
- LOVE: $1,000 (made some connections, but fewer than expected)
- TAX: $8,000 (same)
- **ACTUAL SOUL PROFIT: -$5,000** 

**The error:** Confusing possibility with probability.

**Better calculation method:**
- Use conservative/realistic profit estimates
- Apply probability weights to uncertain outcomes
- Include worst-case scenarios
- Factor in your track record with similar decisions

**Tom's corrected calculation should have been:**
- PROFIT: $5,000 (25% chance of $20K = $5K expected value)
- LOVE: $1,500 (conservative relationship value)
- TAX: $8,000 (certain)
- **SOUL PROFIT: -$1,500** ❌

The math would have saved him from a bad decision.

**How to avoid Tom's mistake:**
1. Use realistic, not optimistic projections
2. Weight uncertain outcomes by probability
3. Plan for scenarios other than best-case
4. Trust the math, even when it's disappointing

**Want to master advanced PLT calculations?**
The PLT Framework book covers:
- Probability weighting
- Scenario analysis
- Risk assessment
- Long-term forecasting

**Special offer for calculator users:** 40% off this week only
[Get PLT Framework Book]

Craig Jones

P.S. Next week: How to calculate the value of personal relationships in business decisions.

---

## Email 4: Advanced techniques (sent 2 weeks later)

**Subject:** How to put a dollar value on relationships (this changes everything)

{{first_name}},

"How do I calculate LOVE value?"

This is the #1 question I get about PLT calculations.

**The challenge:** Relationships feel intangible. How do you assign dollar values?

**The solution:** Think long-term value, not immediate benefit.

**Example:** Meeting a potential business partner

**Traditional thinking:** "Nice to meet them, but no immediate business = $0 value"

**PLT thinking:** "This relationship could lead to..."
- Future collaborations: $25,000 potential
- Referrals they could send: $10,000/year  
- Knowledge/insights they provide: $5,000 value
- Expanded network through them: $15,000 lifetime
- **Total relationship value: $55,000+**

**How to calculate LOVE value:**

**Step 1: Categorize the relationship**
- Strategic partner: $10,000-$100,000+ lifetime value
- Industry peer: $5,000-$25,000 lifetime value  
- Potential customer: $2,000-$50,000 lifetime value
- Mentor/advisor: $25,000-$500,000 lifetime value

**Step 2: Apply probability weights**
- 100% chance of basic networking: $1,000
- 50% chance of referrals: $5,000 × 0.5 = $2,500
- 20% chance of major collaboration: $50,000 × 0.2 = $10,000
- **Weighted LOVE value: $13,500**

**Step 3: Factor in negative relationship impact**
- Damaged existing relationships: -$X
- Time taken from family: -$X  
- Reputation risk: -$X

**Real example:**
Decision: Attend networking dinner ($200 + 4 hours time)

**LOVE calculation:**
- Meet 12 people: $500 base value
- 3 promising connections: $15,000 weighted lifetime value
- Strengthen 2 existing relationships: $5,000
- **Total LOVE: $20,500**

**TAX:** $200 + (4 hours × $150/hour) = $800
**PROFIT:** $0 immediate, $2,000 knowledge/insights

**SOUL PROFIT:** $2,000 + $20,500 - $800 = $21,700 ✅

The dinner is mathematically worth $21,700 to your future.

**This changes how you see everything:**
- Coffee meetings aren't "just coffee"
- Conference networking has massive ROI
- Relationship maintenance becomes an investment
- Social events become business opportunities

**Ready to master relationship calculations?**
The PLT Framework book includes:
- Relationship valuation worksheets
- Network mapping strategies
- Long-term value forecasting
- Personal relationship applications

**Last chance:** 40% off ends tomorrow
[Get PLT Framework Book]

Craig

P.S. Tomorrow: Why most people fail at PLT (and how to succeed).
EOF

    # Website visitors sequence  
    cat > "$NURTURING_CONTENT/email-sequences/website-visitors-sequence.md" << 'EOF'
# Website Visitors Nurturing Sequence

## Email 1: Welcome & Calculator offer (immediately after signup)

**Subject:** Your PLT Calculator access + the decision that started it all

Hi {{first_name}},

Welcome to the PLT community!

You're now part of 15,000+ people who make decisions based on math, not guesswork.

**Your PLT Calculator access:** [Calculator Link]

**Why I created PLT:**
Five years ago, I made a "profitable" decision that nearly destroyed my business.

$50,000 consulting contract. Great money, established client, seemed obvious.

What I didn't calculate:
- The energy drain (massive TAX)
- The relationship costs (negative LOVE)  
- The opportunities I'd miss (opportunity cost)

That "profitable" decision actually cost me $75,000 in real value.

**This painful lesson became the PLT Framework:**
PROFIT + LOVE - TAX = SOUL PROFIT

Now I never make a significant decision without running the calculation.

**Your first assignment:**
Think of a decision you're facing right now.
Use the calculator to run a PLT analysis.
See what the math reveals.

**Questions?** Hit reply - I read every email personally.

Welcome to smarter decision-making,
Craig Jones
Creator, PLT Framework

P.S. The calculator is just the beginning. Tomorrow, I'll show you the calculation that saved me $25,000.

---

## Email 2: Case study (sent next day)

**Subject:** The $25,000 calculation that saved my business

{{first_name}},

Yesterday I told you about the expensive decision that started PLT.

Today, let me share the calculation that saved me $25,000.

**The situation:** 
Partnership opportunity with a larger firm. They'd handle all operations, I'd focus on strategy.

**Initial reaction:** "This sounds amazing! Less work, same income!"

**But then I ran the PLT calculation:**

**PROFIT:**
- Keep current $100K income ✅  
- Reduce work hours 50% ✅
- Learn from larger organization ✅
- Total PROFIT: $125,000

**LOVE:**
- Lose direct client relationships: -$50,000
- Reduce personal brand building: -$25,000
- Partner relationship benefits: +$15,000
- Total LOVE: -$60,000

**TAX:**
- Legal fees and setup: $15,000
- Learning new systems: $10,000
- Less control/flexibility: $25,000
- Total TAX: $50,000

**SOUL PROFIT: $125,000 - $60,000 - $50,000 = $15,000**

Barely positive. Red flag.

**But wait - I dug deeper:**
What if the partnership doesn't work out in Year 2?
- Client relationships already transferred: -$100,000
- Personal brand damaged: -$50,000  
- Rebuilding costs: -$75,000

**Year 2 scenario: -$225,000 soul profit**

The math was screaming: "Don't do this!"

**I said no.**

**What happened instead:**
- Kept all client relationships
- Built stronger personal brand
- Increased income to $150K
- Maintained full control

**The "amazing" partnership?** 
Failed after 18 months. The partners I would have joined lost most of their clients and had to rebuild from scratch.

PLT calculation saved me from a $25,000 mistake (minimum).

**The lesson:**
Your gut might say yes, but the math doesn't lie.
Always run the numbers.

**Your turn:**
What decision are you facing where the "obvious" choice might not be the smart one?
[Use your PLT Calculator] to find out.

**Want more real calculation examples?**
"10 PLT Calculations That Changed Everything" (free download): [Link]

Craig

P.S. Tomorrow: The biggest mistake people make with PLT calculations.
EOF

    log "📧 Nurturing email sequences created"
}

# Create content offers for different segments
create_content_offers() {
    cat > "$NURTURING_CONTENT/content-offers/lead-magnets.md" << 'EOF'
# PLT Lead Magnets & Content Offers

## Calculator Users
**Offer:** "10 Real PLT Calculations" (PDF)
**Description:** See how others used PLT for decisions ranging from $500 to $500,000
**CTA:** Download free case studies

## Website Visitors  
**Offer:** "PLT Quick Start Guide" (PDF + Video)
**Description:** Master the framework in 15 minutes
**CTA:** Get instant access

## Email Subscribers
**Offer:** "PLT Advanced Worksheets" (Excel Templates)  
**Description:** Calculate complex scenarios with pre-built formulas
**CTA:** Download the worksheets

## Social Media Followers
**Offer:** "Craig's Daily PLT Journal" (Email Series)
**Description:** 7 days of real PLT decisions from Craig's business
**CTA:** Get the behind-the-scenes look

## High-Value Prospects  
**Offer:** "Personal PLT Consultation" (15-min call)
**Description:** Craig personally reviews your biggest decision
**CTA:** Book your free consultation

## Book Buyers
**Offer:** "PLT Masterclass" (60-min video)
**Description:** Advanced techniques not covered in the book  
**CTA:** Watch the exclusive masterclass

## Course Interest
**Offer:** "PLT Course Preview" (Mini-course)
**Description:** First 3 lessons from the full course
**CTA:** Start learning immediately
EOF

    # Create retargeting sequences
    cat > "$NURTURING_CONTENT/retargeting/abandoned-actions.md" << 'EOF'
# Retargeting Sequences for Abandoned Actions

## Abandoned Calculator (started but didn't finish)
**Email Subject:** Your PLT calculation is waiting...
**Content:** "You started calculating {{decision_topic}} but didn't finish. The math only takes 2 minutes, and it might surprise you. Complete your calculation: [Link]"

## Abandoned Cart (added book/course but didn't buy)  
**Email Subject:** Your PLT resources are reserved (24 hours)
**Content:** "You were about to get {{product_name}} but didn't complete purchase. No problem - we saved your cart for 24 hours. What made you hesitate? [Complete Purchase] or reply with questions."

## Watched Video But Didn't Subscribe
**Email Subject:** The rest of the PLT story...
**Content:** "You watched 'PLT Framework Explained' but the story doesn't end there. Want to see how it applies to YOUR decisions? Get the calculator: [Link]"

## Downloaded Lead Magnet But Low Engagement
**Email Subject:** Are you stuck on something?
**Content:** "You downloaded the PLT guide but haven't been opening our emails. Stuck on implementing the framework? Hit reply - I personally help subscribers overcome obstacles."

## High-Value Visitor (viewed pricing but didn't buy)
**Email Subject:** Question about PLT investment?
**Content:** "You checked out the PLT course pricing but didn't enroll. Common concerns I hear: [3 objections with responses]. Have a different question? Reply and ask."
EOF

    log "🎯 Content offers and retargeting sequences created"
}

# Lead scoring calculation engine
calculate_lead_score() {
    local lead_id=$1
    # This would pull actual activity data and calculate score
    # based on the scoring rules defined above
    log "📊 Lead score calculated for $lead_id"
}

# Nurturing automation engine
process_nurturing_automation() {
    log "🔄 Processing lead nurturing automation..."
    
    # Segment leads by score and behavior
    # Send appropriate nurturing content
    # Update lead scores based on engagement
    # Move high-scoring leads to sales queue
    
    log "🎯 Nurturing automation processing complete"
}

# Main execution
main() {
    log "🚀 PLT Lead Nurturing Automation Starting"
    
    setup_nurturing_system
    create_lead_scoring
    create_nurturing_sequences
    create_content_offers
    process_nurturing_automation
    
    log "✅ Lead nurturing automation complete"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi