#!/bin/bash
# PLT EMAIL AUTOMATION - Automated email sequences
# PROFIT: Convert leads to buyers | LOVE: Build relationships | TAX: Minimal manual effort

EMAIL_LOG="email-automation.log"
LEADS_DB="plt-leads.json"
CUSTOMERS_DB="plt-customers.json"
EMAIL_SEQUENCES_DIR="plt-content/email"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] EMAIL: $1" | tee -a "$EMAIL_LOG"
}

# Create email sequences directory structure
setup_email_sequences() {
    mkdir -p "$EMAIL_SEQUENCES_DIR"/{welcome,nurturing,book-buyers,calculator-users,abandoned-cart,win-back}
    log "📧 Email sequence directories created"
}

# Generate welcome sequence for new subscribers
create_welcome_sequence() {
    cat > "$EMAIL_SEQUENCES_DIR/welcome/day-1-welcome.md" << 'EOF'
# Welcome to the PLT Revolution

Subject: Your PLT journey starts now (+ exclusive calculator inside)

Hi {{first_name}},

Welcome to the PROFIT · LOVE · TAX community!

You're about to discover the framework that turns every decision into measurable value:
- **PROFIT** → What you gain
- **LOVE** → Relationships you build  
- **TAX** → Cost you pay

🎯 **Your Welcome Gift**: PLT Calculator
Calculate the true value of any opportunity: [PLT Calculator Link]

**What happens next:**
- Tomorrow: The #1 mistake people make with profit calculations
- Day 3: How to identify hidden "love" value in business decisions
- Day 5: Tax optimization strategies (legal & ethical)

Ready to see reality through the PLT lens?

Craig Jones
Author, PLT Framework

P.S. Hit reply - I read every email personally.
EOF

    cat > "$EMAIL_SEQUENCES_DIR/welcome/day-3-profit-mistakes.md" << 'EOF'
# The $10,000 Profit Calculation Mistake

Subject: This profit mistake cost me $10,000 (don't repeat it)

{{first_name}},

Three years ago, I made a decision that cost me $10,000.

I looked at the immediate profit: $5,000 revenue - $3,000 costs = $2,000 profit.

Seemed good. I said yes.

**What I missed:** The hidden TAX.

That $2,000 profit required:
- 40 hours of my time ($2,000 ÷ 40 = $50/hour)
- Stress that damaged relationships (LOVE cost)
- Opportunity cost: couldn't pursue $15,000 project

**Real PLT equation:**
PROFIT: $2,000
LOVE: -$1,000 (relationship strain)
TAX: $11,000 (time + opportunity cost)
**SOUL PROFIT: -$10,000**

The framework would have shown this immediately.

🔥 **Calculate your last decision:**
[Use PLT Calculator] - What was YOUR real profit?

Tomorrow: How to find hidden LOVE value in any deal.

Craig
EOF

    log "✅ Welcome sequence created (2 emails)"
}

# Generate book buyer sequence
create_book_buyer_sequence() {
    cat > "$EMAIL_SEQUENCES_DIR/book-buyers/immediate-delivery.md" << 'EOF'
# Your PLT Book is Ready!

Subject: 📚 Your book download + next steps

{{first_name}},

Your PLT book is ready for download!

**Download Link:** {{download_link}}

**What to do RIGHT NOW:**
1. Download and save to your device
2. Read Chapter 3 first (the "aha moment" chapter)
3. Try the framework on one decision this week

**Bonus Resources:**
- PLT Calculator (if you don't have it): [Link]
- Private Facebook group: [PLT Implementers]
- Next book in series (25% off): [Link]

**Questions?** Hit reply - I personally answer every customer email.

Ready to measure reality?

Craig Jones
Author, PLT Framework

P.S. Chapter 7 contains the "million-dollar insight" that changed everything for me.
EOF

    cat > "$EMAIL_SEQUENCES_DIR/book-buyers/day-7-implementation.md" << 'EOF'
# How's Your PLT Implementation Going?

Subject: Week 1 check-in: Any PLT "aha moments" yet?

Hey {{first_name}},

It's been a week since you got your PLT book.

**Quick question:** Have you had your first "PLT moment" yet?

That moment when you look at a decision and suddenly see:
- The hidden PROFIT you missed
- The LOVE cost you didn't calculate  
- The real TAX (time, energy, opportunity)

**If you haven't started yet** (totally normal):
→ Just read pages 23-31 today
→ Apply it to ONE recent decision
→ See what you discover

**If you're already implementing:**
→ I'd love to hear your results
→ Hit reply and share your story
→ Might feature it (with permission)

**Struggling with something specific?**
Common questions I get:
- "How do you calculate LOVE value?"
- "What if TAX seems higher than profit?"
- "Can this work for personal decisions?"

Reply with your question - I answer personally.

Keep measuring,
Craig

P.S. The advanced PLT course launches next month. Book buyers get first access (and 50% off).
EOF

    log "✅ Book buyer sequence created (2+ emails)"
}

# Generate calculator user nurturing sequence
create_calculator_sequence() {
    cat > "$EMAIL_SEQUENCES_DIR/calculator-users/first-calculation-followup.md" << 'EOF'
# How Did Your First PLT Calculation Go?

Subject: Your PLT calculation results + what they mean

{{first_name}},

You just used the PLT calculator on: "{{calculation_topic}}"

**Your results:**
- PROFIT: {{profit_score}}
- LOVE: {{love_score}}  
- TAX: {{tax_score}}
- **SOUL PROFIT: {{soul_profit}}**

**What this means:**
{{if soul_profit > 0}}
✅ This decision creates value - the math supports moving forward.
{{else}}
⚠️ This decision destroys value - consider alternatives.
{{endif}}

**Next steps:**
1. Trust the math (it's showing you reality)
2. If negative: What could change to improve the equation?
3. If positive: What could amplify the PROFIT or LOVE components?

**Want to see more examples?**
Check out "PLT in Action" - real calculations from real decisions:
[PLT Case Studies - Free Download]

**Questions about your results?** Hit reply - I review every calculation personally.

Craig Jones
Creator, PLT Framework

P.S. The calculator is just the beginning. The full framework goes much deeper.
EOF

    log "✅ Calculator user sequence created"
}

# Generate abandoned cart recovery
create_abandoned_cart_sequence() {
    cat > "$EMAIL_SEQUENCES_DIR/abandoned-cart/cart-reminder.md" << 'EOF'
# You Left Something Behind...

Subject: Your PLT book is waiting (cart saved for 24 hours)

Hi {{first_name}},

You were about to get "{{book_title}}" but didn't complete your order.

**No worries** - I saved your cart for 24 hours.

**Complete your order here:** {{cart_recovery_link}}

**Why this book matters:**
The PLT framework isn't just theory. It's a decision-making system that shows you the real value of every choice.

Every day you don't have it = decisions made without the math.

**Quick question:** What made you hesitate?
- Price concern? (There's a payment plan)
- Not sure it's right for you? (30-day guarantee)
- Technical issue? (I can help)

Hit reply and let me know. I read every email personally.

Craig Jones
Author, PLT Framework

P.S. This book has helped thousands calculate better decisions. Your turn.
EOF

    log "✅ Abandoned cart sequence created"
}

# Process email automation queue
process_email_queue() {
    log "🔄 Processing email automation queue..."
    
    # Check for new subscribers (welcome sequence)
    # Check for book purchases (buyer sequence) 
    # Check for calculator usage (nurturing sequence)
    # Check for abandoned carts (recovery sequence)
    
    # This would integrate with actual email service
    log "📊 Email queue processed"
}

# Main execution
main() {
    log "🚀 PLT Email Automation Starting"
    
    setup_email_sequences
    create_welcome_sequence
    create_book_buyer_sequence
    create_calculator_sequence  
    create_abandoned_cart_sequence
    process_email_queue
    
    log "✅ Email automation cycle complete"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi