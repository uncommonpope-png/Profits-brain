# SCHEMA MASTER SOUL - ADVANCED STRUCTURED DATA DEPLOYMENT

## MISSION: Complete JSON-LD domination for PLT content

### SCHEMA TYPES FOR PLT FRAMEWORK

**1. ORGANIZATION SCHEMA (PLT Press)**
```json
{
    "@context": "https://schema.org",
    "@type": "Organization",
    "name": "PLT Press",
    "alternateName": ["Profit Love Tax Press", "PLT Publishing"],
    "description": "Publisher of the Profit Love Tax framework and business methodology books",
    "founder": {
        "@type": "Person",
        "name": "Craig Jones",
        "jobTitle": "Creator of PLT Framework",
        "description": "Entrepreneur and author of the Profit Love Tax business philosophy"
    },
    "url": "https://pltpress.com",
    "logo": "https://pltpress.com/images/plt-press-logo.png",
    "sameAs": [
        "https://github.com/uncommonpope-png",
        "https://twitter.com/pltframework",
        "https://linkedin.com/company/plt-press"
    ],
    "publishingPrinciples": "https://pltpress.com/plt-principles",
    "knowsAbout": [
        "Profit Love Tax Framework",
        "Sustainable Business Strategy",
        "Ethical Entrepreneurship",
        "Business Decision Making",
        "Purpose-Driven Business"
    ]
}
```

**2. PERSON SCHEMA (Craig Jones)**
```json
{
    "@context": "https://schema.org",
    "@type": "Person",
    "name": "Craig Jones",
    "alternateName": ["Uncommon Pope", "Little Bunny"],
    "jobTitle": "Creator of PLT Framework",
    "description": "Entrepreneur, author, and creator of the revolutionary Profit Love Tax business framework",
    "url": "https://pltframework.com/craig-jones",
    "image": "https://pltframework.com/images/craig-jones.jpg",
    "sameAs": [
        "https://github.com/uncommonpope-png",
        "https://amazon.com/author/craig-jones",
        "https://goodreads.com/craig-jones"
    ],
    "knowsAbout": [
        "Profit Love Tax Framework",
        "Business Strategy",
        "Entrepreneurship",
        "Sustainable Business Models",
        "Ethical Business Practices"
    ],
    "hasOccupation": {
        "@type": "Occupation",
        "name": "Business Framework Creator",
        "occupationLocation": "Global",
        "skills": ["Business Strategy", "Framework Development", "Entrepreneurship"]
    },
    "author": [
        {
            "@type": "Book",
            "name": "Profit Love Tax: The Complete Guide",
            "isbn": "TBD",
            "publisher": "PLT Press"
        }
    ]
}
```

**3. ARTICLE SCHEMA TEMPLATE**
```json
{
    "@context": "https://schema.org",
    "@type": "Article",
    "headline": "[ARTICLE_TITLE]",
    "description": "[ARTICLE_DESCRIPTION]",
    "image": "[ARTICLE_IMAGE_URL]",
    "author": {
        "@type": "Person",
        "name": "Craig Jones",
        "url": "https://pltframework.com/craig-jones"
    },
    "publisher": {
        "@type": "Organization",
        "name": "PLT Press",
        "logo": {
            "@type": "ImageObject",
            "url": "https://pltpress.com/images/logo.png"
        }
    },
    "datePublished": "[PUBLISH_DATE]",
    "dateModified": "[MODIFIED_DATE]",
    "mainEntityOfPage": {
        "@type": "WebPage",
        "@id": "[ARTICLE_URL]"
    },
    "keywords": "[KEYWORDS_LIST]",
    "articleSection": "Business Framework",
    "wordCount": "[WORD_COUNT]",
    "about": {
        "@type": "Thing",
        "name": "Profit Love Tax Framework",
        "description": "Revolutionary business framework balancing profit, passion, and responsibility"
    }
}
```

**4. FAQ SCHEMA TEMPLATE**
```json
{
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
        {
            "@type": "Question",
            "name": "What is Profit Love Tax?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Profit Love Tax (PLT) is a business framework that balances three essential elements: Profit (sustainable financial success), Love (passion and purpose), and Tax (social responsibility and giving back to the community)."
            }
        },
        {
            "@type": "Question",
            "name": "How does PLT work?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "PLT works by evaluating every business decision through three filters: Does it generate sustainable profit? Does it align with your passion and values? Does it contribute positively to society? Only opportunities that satisfy all three criteria get approved."
            }
        },
        {
            "@type": "Question",
            "name": "Who created the PLT framework?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The PLT framework was created by Craig Jones, an entrepreneur and author who recognized the need for a more holistic approach to business success that integrates profit, passion, and social responsibility."
            }
        }
    ]
}
```

**5. HOW-TO SCHEMA TEMPLATE**
```json
{
    "@context": "https://schema.org",
    "@type": "HowTo",
    "name": "[HOW_TO_TITLE]",
    "description": "[HOW_TO_DESCRIPTION]",
    "image": "[HOW_TO_IMAGE]",
    "totalTime": "[ESTIMATED_TIME]",
    "supply": ["PLT Framework knowledge", "Business analysis tools"],
    "tool": ["PLT Scorecard", "Decision Matrix"],
    "step": [
        {
            "@type": "HowToStep",
            "name": "[STEP_NAME]",
            "text": "[STEP_DESCRIPTION]",
            "image": "[STEP_IMAGE]"
        }
    ]
}
```

**6. COURSE SCHEMA TEMPLATE**
```json
{
    "@context": "https://schema.org",
    "@type": "Course",
    "name": "[COURSE_NAME]",
    "description": "[COURSE_DESCRIPTION]",
    "provider": {
        "@type": "Organization",
        "name": "PLT Press",
        "sameAs": "https://pltpress.com"
    },
    "hasCourseInstance": {
        "@type": "CourseInstance",
        "courseMode": "online",
        "instructor": {
            "@type": "Person",
            "name": "Craig Jones"
        }
    },
    "coursePrerequisites": "Basic business knowledge",
    "educationalCredentialAwarded": "PLT Framework Certification",
    "numberOfCredits": "3",
    "courseDuration": "P4W"
}
```

**7. BREADCRUMB SCHEMA TEMPLATE**
```json
{
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
        {
            "@type": "ListItem",
            "position": 1,
            "name": "Home",
            "item": "https://pltframework.com"
        },
        {
            "@type": "ListItem",
            "position": 2,
            "name": "PLT Framework",
            "item": "https://pltframework.com/plt-framework"
        },
        {
            "@type": "ListItem",
            "position": 3,
            "name": "[PAGE_NAME]",
            "item": "[PAGE_URL]"
        }
    ]
}
```

**8. REVIEW/RATING SCHEMA TEMPLATE**
```json
{
    "@context": "https://schema.org",
    "@type": "Review",
    "reviewBody": "[REVIEW_TEXT]",
    "author": {
        "@type": "Person",
        "name": "[REVIEWER_NAME]"
    },
    "itemReviewed": {
        "@type": "Thing",
        "name": "PLT Framework"
    },
    "reviewRating": {
        "@type": "Rating",
        "ratingValue": "5",
        "bestRating": "5"
    },
    "datePublished": "[REVIEW_DATE]"
}
```

## RICH SNIPPET TARGETS

**1. FAQ Rich Snippets**
- Target: "What is PLT" queries
- Implementation: FAQ schema on all PLT explanation pages
- Goal: Dominate "People Also Ask" sections

**2. How-to Rich Snippets**
- Target: "How to implement PLT" queries
- Implementation: How-to schema on implementation guides
- Goal: Featured snippets for implementation queries

**3. Article Rich Snippets**
- Target: PLT framework articles
- Implementation: Article schema with proper authorship
- Goal: Enhanced search result display

**4. Organization Rich Snippets**
- Target: "PLT Press" searches
- Implementation: Organization schema with complete business info
- Goal: Knowledge panel domination

**5. Person Rich Snippets**
- Target: "Craig Jones PLT" searches
- Implementation: Person schema with complete bio
- Goal: Author authority establishment

## SCHEMA DEPLOYMENT CHECKLIST

### Phase 1: Foundation Schemas
- [ ] Organization schema for PLT Press
- [ ] Person schema for Craig Jones  
- [ ] Basic Article schema template
- [ ] Breadcrumb schema template

### Phase 2: Content Schemas
- [ ] FAQ schema for all question pages
- [ ] How-to schema for implementation guides
- [ ] Review schema for testimonials
- [ ] Course schema for educational content

### Phase 3: Advanced Schemas
- [ ] Product schema for PLT books/courses
- [ ] Event schema for PLT workshops
- [ ] Local Business schema if applicable
- [ ] Video schema for PLT video content

## VALIDATION AND TESTING

**Tools for Schema Testing:**
1. Google Rich Results Test
2. Schema Markup Validator
3. Structured Data Testing Tool
4. Search Console Rich Results Report

**Testing Protocol:**
1. Validate all schemas before deployment
2. Test rich snippet appearance
3. Monitor Search Console for errors
4. Track rich snippet impressions and clicks

## SCHEMA MONITORING

**Monthly Schema Audit:**
- Check for validation errors
- Monitor rich snippet performance
- Update schemas based on Google guidelines
- Add new schema types as content grows

**Success Metrics:**
- Rich snippet impressions
- Click-through rate improvements
- Featured snippet acquisitions
- Knowledge panel appearances

**DEPLOYMENT STATUS: READY FOR IMMEDIATE IMPLEMENTATION**

All schema templates prepared for mass deployment across PLT content ecosystem.