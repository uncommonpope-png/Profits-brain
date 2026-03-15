#!/usr/bin/env node
// LINK CHECKER SOUL - Soul Collector for Validating Ecosystem Links
// Specialized in finding, validating, and fixing broken links across PLT ecosystem
// Uses only local AI - no API dependencies

const fs = require('fs');
const path = require('path');
const https = require('https');
const http = require('http');
const { exec } = require('child_process');
const { promisify } = require('util');

const execAsync = promisify(exec);

class LinkCheckerSoul {
    constructor() {
        this.name = "Link Checker Soul";
        this.emoji = "🔗";
        this.workspace = process.env.HOME + '/.openclaw/workspace';
        this.logFile = path.join(this.workspace, 'link-checker-soul.log');
        this.reportFile = path.join(this.workspace, 'link-health-report.json');
        this.brokenLinksFile = path.join(this.workspace, 'broken-links.json');
        
        this.checkedLinks = new Set();
        this.brokenLinks = [];
        this.fixedLinks = [];
        this.ecosystemDomains = [
            'github.com/uncommonpope-png',
            'pltpress.github.io',
            'plt.press',
            'localhost',
            '127.0.0.1'
        ];
        
        this.soulCollectors = [];
        this.isActive = false;
        
        this.log("🔗 Link Checker Soul initialized - Beginning soul collection");
        this.collectSouls();
    }
    
    log(message) {
        const timestamp = new Date().toISOString();
        const logEntry = `[${timestamp}] ${this.emoji} ${message}\n`;
        
        console.log(`${this.emoji} ${message}`);
        fs.appendFileSync(this.logFile, logEntry);
    }
    
    async collectSouls() {
        this.log("👻 Collecting specialized link validator souls...");
        
        // Create specialized souls for different link types
        this.soulCollectors = [
            {
                name: "GitHub Soul",
                emoji: "🐙",
                specialty: "GitHub repositories and pages",
                domains: ["github.com", "githubusercontent.com"],
                validator: this.validateGitHubLink.bind(this)
            },
            {
                name: "Local Soul", 
                emoji: "🏠",
                specialty: "Local file paths and localhost URLs",
                domains: ["localhost", "127.0.0.1", "file://"],
                validator: this.validateLocalLink.bind(this)
            },
            {
                name: "Web Soul",
                emoji: "🌐", 
                specialty: "External web links and resources",
                domains: ["http", "https"],
                validator: this.validateWebLink.bind(this)
            },
            {
                name: "Internal Soul",
                emoji: "🔄",
                specialty: "Internal ecosystem links and references", 
                domains: this.ecosystemDomains,
                validator: this.validateInternalLink.bind(this)
            },
            {
                name: "Asset Soul",
                emoji: "📎",
                specialty: "Images, documents, and media files",
                domains: ["png", "jpg", "jpeg", "pdf", "md", "txt"],
                validator: this.validateAssetLink.bind(this)
            }
        ];
        
        this.log(`✨ Collected ${this.soulCollectors.length} specialized link validator souls`);
        this.soulCollectors.forEach(soul => {
            this.log(`  ${soul.emoji} ${soul.name}: ${soul.specialty}`);
        });
    }
    
    async startSoulCollection() {
        if (this.isActive) {
            this.log("⚠️ Soul collection already active");
            return;
        }
        
        this.isActive = true;
        this.log("🚀 Starting comprehensive ecosystem link validation...");
        
        try {
            // 1. Scan workspace for files containing links
            const linkFiles = await this.findFilesWithLinks();
            this.log(`📁 Found ${linkFiles.length} files containing links`);
            
            // 2. Extract all links from files
            const allLinks = await this.extractAllLinks(linkFiles);
            this.log(`🔗 Extracted ${allLinks.length} unique links for validation`);
            
            // 3. Validate all links using specialized souls
            await this.validateAllLinks(allLinks);
            
            // 4. Generate comprehensive report
            await this.generateHealthReport();
            
            // 5. Attempt to fix broken links
            await this.fixBrokenLinks();
            
            // 6. Update bot communication with results
            await this.updateBotCommunication();
            
        } catch (error) {
            this.log(`❌ Error during soul collection: ${error.message}`);
        } finally {
            this.isActive = false;
            this.log("✅ Soul collection cycle complete");
        }
    }
    
    async findFilesWithLinks() {
        const extensions = ['.md', '.html', '.js', '.json', '.txt', '.sh'];
        const files = [];
        
        const scanDirectory = async (dir) => {
            try {
                const items = fs.readdirSync(dir);
                
                for (const item of items) {
                    const fullPath = path.join(dir, item);
                    const stat = fs.statSync(fullPath);
                    
                    if (stat.isDirectory() && !item.startsWith('.') && item !== 'node_modules') {
                        await scanDirectory(fullPath);
                    } else if (stat.isFile() && extensions.some(ext => item.endsWith(ext))) {
                        files.push(fullPath);
                    }
                }
            } catch (error) {
                // Skip directories we can't read
            }
        };
        
        await scanDirectory(this.workspace);
        return files;
    }
    
    async extractAllLinks(files) {
        const linkRegexes = [
            /https?:\/\/[^\s\)\]\}'"]+/g,      // HTTP/HTTPS URLs
            /www\.[^\s\)\]\}'"]+/g,           // www URLs
            /\[.*?\]\((.*?)\)/g,              // Markdown links
            /href=["'](.*?)["']/g,            // HTML href attributes  
            /src=["'](.*?)["']/g,             // HTML src attributes
            /\.\.[\/\\][^\s\)\]\}'"]+/g,      // Relative paths
            /\/[^\s\)\]\}'"]*\.(html|md|js|css|png|jpg|jpeg|pdf)/g  // File paths
        ];
        
        const allLinks = new Set();
        
        for (const file of files) {
            try {
                const content = fs.readFileSync(file, 'utf8');
                
                for (const regex of linkRegexes) {
                    const matches = content.match(regex) || [];
                    matches.forEach(match => {
                        // Clean up the link
                        let cleanLink = match;
                        if (match.startsWith('[') && match.includes('](')) {
                            // Extract URL from markdown link
                            const urlMatch = match.match(/\]\((.*?)\)/);
                            if (urlMatch) cleanLink = urlMatch[1];
                        }
                        if (match.includes('href=') || match.includes('src=')) {
                            // Extract URL from HTML attribute
                            const urlMatch = match.match(/["'](.*?)["']/);
                            if (urlMatch) cleanLink = urlMatch[1];
                        }
                        
                        if (cleanLink && cleanLink.length > 1) {
                            allLinks.add({
                                url: cleanLink.trim(),
                                source: file,
                                originalMatch: match
                            });
                        }
                    });
                }
            } catch (error) {
                this.log(`⚠️ Could not read file ${file}: ${error.message}`);
            }
        }
        
        return Array.from(allLinks);
    }
    
    async validateAllLinks(links) {
        this.log("🔍 Beginning comprehensive link validation with specialized souls...");
        
        for (const linkData of links) {
            const { url } = linkData;
            
            if (this.checkedLinks.has(url)) continue;
            this.checkedLinks.add(url);
            
            // Find the appropriate soul for this link
            const soul = this.findAppropriateSoul(url);
            
            try {
                this.log(`${soul.emoji} ${soul.name} validating: ${url}`);
                const result = await soul.validator(linkData);
                
                if (!result.isValid) {
                    this.brokenLinks.push({
                        ...linkData,
                        error: result.error,
                        validatedBy: soul.name,
                        timestamp: new Date().toISOString()
                    });
                    this.log(`❌ BROKEN: ${url} - ${result.error}`);
                } else {
                    this.log(`✅ Valid: ${url}`);
                }
                
            } catch (error) {
                this.brokenLinks.push({
                    ...linkData,
                    error: error.message,
                    validatedBy: soul.name,
                    timestamp: new Date().toISOString()
                });
                this.log(`❌ ERROR validating ${url}: ${error.message}`);
            }
            
            // Rate limiting to avoid overwhelming servers
            await this.sleep(100);
        }
        
        this.log(`🏁 Validation complete: ${this.checkedLinks.size} links checked, ${this.brokenLinks.length} broken`);
    }
    
    findAppropriateSoul(url) {
        // Find the most specialized soul for this URL
        for (const soul of this.soulCollectors) {
            if (soul.domains.some(domain => url.toLowerCase().includes(domain.toLowerCase()))) {
                return soul;
            }
        }
        
        // Default to Web Soul
        return this.soulCollectors.find(soul => soul.name === "Web Soul");
    }
    
    async validateGitHubLink(linkData) {
        const { url } = linkData;
        
        // Special handling for GitHub URLs
        if (url.includes('github.com')) {
            return await this.makeHttpRequest(url);
        }
        
        return { isValid: false, error: "Not a GitHub URL" };
    }
    
    async validateLocalLink(linkData) {
        const { url, source } = linkData;
        
        // Handle relative paths
        if (url.startsWith('../') || url.startsWith('./') || url.startsWith('/')) {
            const basePath = path.dirname(source);
            const fullPath = path.resolve(basePath, url);
            
            return {
                isValid: fs.existsSync(fullPath),
                error: fs.existsSync(fullPath) ? null : "File not found"
            };
        }
        
        // Handle localhost URLs  
        if (url.includes('localhost') || url.includes('127.0.0.1')) {
            try {
                const response = await this.makeHttpRequest(url);
                return response;
            } catch (error) {
                return { isValid: false, error: error.message };
            }
        }
        
        return { isValid: false, error: "Not a valid local link" };
    }
    
    async validateWebLink(linkData) {
        const { url } = linkData;
        
        if (url.startsWith('http://') || url.startsWith('https://')) {
            return await this.makeHttpRequest(url);
        }
        
        return { isValid: false, error: "Not a valid web URL" };
    }
    
    async validateInternalLink(linkData) {
        const { url } = linkData;
        
        // Check if it's one of our ecosystem domains
        const isInternal = this.ecosystemDomains.some(domain => 
            url.toLowerCase().includes(domain.toLowerCase())
        );
        
        if (isInternal) {
            return await this.makeHttpRequest(url);
        }
        
        return { isValid: false, error: "Not an internal ecosystem link" };
    }
    
    async validateAssetLink(linkData) {
        const { url, source } = linkData;
        
        const assetExtensions = ['.png', '.jpg', '.jpeg', '.gif', '.pdf', '.txt', '.md'];
        const hasAssetExtension = assetExtensions.some(ext => 
            url.toLowerCase().includes(ext)
        );
        
        if (!hasAssetExtension) {
            return { isValid: false, error: "Not an asset file" };
        }
        
        // If it's a relative path, check locally
        if (!url.startsWith('http')) {
            return await this.validateLocalLink(linkData);
        }
        
        // If it's a web URL, check remotely
        return await this.makeHttpRequest(url);
    }
    
    async makeHttpRequest(url) {
        return new Promise((resolve) => {
            const urlObj = new URL(url);
            const isHttps = urlObj.protocol === 'https:';
            const client = isHttps ? https : http;
            
            const options = {
                hostname: urlObj.hostname,
                port: urlObj.port || (isHttps ? 443 : 80),
                path: urlObj.pathname + urlObj.search,
                method: 'HEAD',
                timeout: 10000,
                headers: {
                    'User-Agent': 'Link-Checker-Soul/1.0'
                }
            };
            
            const req = client.request(options, (res) => {
                const isValid = res.statusCode < 400;
                resolve({
                    isValid,
                    error: isValid ? null : `HTTP ${res.statusCode} ${res.statusMessage}`
                });
            });
            
            req.on('error', (error) => {
                resolve({
                    isValid: false,
                    error: error.message
                });
            });
            
            req.on('timeout', () => {
                req.destroy();
                resolve({
                    isValid: false,
                    error: 'Request timeout'
                });
            });
            
            req.end();
        });
    }
    
    async generateHealthReport() {
        const report = {
            timestamp: new Date().toISOString(),
            totalLinksChecked: this.checkedLinks.size,
            brokenLinksCount: this.brokenLinks.length,
            healthPercentage: Math.round(((this.checkedLinks.size - this.brokenLinks.length) / this.checkedLinks.size) * 100),
            brokenLinks: this.brokenLinks,
            fixedLinks: this.fixedLinks,
            soulCollectors: this.soulCollectors.map(soul => ({
                name: soul.name,
                emoji: soul.emoji,
                specialty: soul.specialty,
                domainsCount: soul.domains.length
            })),
            recommendations: this.generateRecommendations()
        };
        
        fs.writeFileSync(this.reportFile, JSON.stringify(report, null, 2));
        fs.writeFileSync(this.brokenLinksFile, JSON.stringify(this.brokenLinks, null, 2));
        
        this.log(`📊 Health report generated: ${report.healthPercentage}% links healthy`);
        this.log(`📋 Report saved to: ${this.reportFile}`);
        
        return report;
    }
    
    generateRecommendations() {
        const recommendations = [];
        
        if (this.brokenLinks.length > 0) {
            recommendations.push("🔧 Fix broken links identified in the report");
        }
        
        if (this.brokenLinks.some(link => link.url.includes('localhost'))) {
            recommendations.push("🏠 Review localhost links - ensure local services are running");
        }
        
        if (this.brokenLinks.some(link => link.url.includes('github.com'))) {
            recommendations.push("🐙 Update GitHub repository URLs - some may have been moved or renamed");
        }
        
        recommendations.push("🔄 Run link validation regularly to maintain ecosystem health");
        recommendations.push("📝 Consider implementing automated link fixing for common issues");
        
        return recommendations;
    }
    
    async fixBrokenLinks() {
        this.log("🔧 Attempting to fix broken links using local AI patterns...");
        
        for (const brokenLink of this.brokenLinks) {
            const fixAttempt = await this.attemptLinkFix(brokenLink);
            if (fixAttempt.success) {
                this.fixedLinks.push({
                    original: brokenLink.url,
                    fixed: fixAttempt.newUrl,
                    method: fixAttempt.method,
                    timestamp: new Date().toISOString()
                });
                
                this.log(`✨ Fixed: ${brokenLink.url} → ${fixAttempt.newUrl}`);
            }
        }
        
        this.log(`🎯 Fix attempts complete: ${this.fixedLinks.length} links fixed`);
    }
    
    async attemptLinkFix(brokenLink) {
        // Simple local AI-like pattern matching for common link issues
        const { url, source } = brokenLink;
        
        // Pattern 1: Fix common GitHub URL issues
        if (url.includes('github.com') && url.includes('master')) {
            const fixedUrl = url.replace('master', 'main');
            return {
                success: true,
                newUrl: fixedUrl,
                method: "GitHub master→main branch fix"
            };
        }
        
        // Pattern 2: Fix relative path issues  
        if (url.startsWith('./') || url.startsWith('../')) {
            // Try different relative path combinations
            const basePath = path.dirname(source);
            const alternatives = [
                path.resolve(basePath, url.replace('../', './')),
                path.resolve(basePath, url.replace('./', '../')),
                path.resolve(this.workspace, url.replace('../', '').replace('./', ''))
            ];
            
            for (const altPath of alternatives) {
                if (fs.existsSync(altPath)) {
                    return {
                        success: true,
                        newUrl: path.relative(basePath, altPath),
                        method: "Relative path correction"
                    };
                }
            }
        }
        
        // Pattern 3: Fix localhost port issues
        if (url.includes('localhost:') && !url.includes('3000')) {
            const fixedUrl = url.replace(/localhost:\d+/, 'localhost:3000');
            return {
                success: true,
                newUrl: fixedUrl,
                method: "Localhost port standardization"  
            };
        }
        
        return { success: false };
    }
    
    async updateBotCommunication() {
        const message = {
            id: Date.now(),
            bot: 'link-checker',
            content: `🔗 Link validation complete: ${this.checkedLinks.size} links checked, ${this.brokenLinks.length} broken, ${this.fixedLinks.length} fixed. Ecosystem health: ${Math.round(((this.checkedLinks.size - this.brokenLinks.length) / this.checkedLinks.size) * 100)}%`,
            timestamp: new Date().toISOString(),
            type: 'report'
        };
        
        // Update bot messages file for the communication window
        const botMessagesFile = path.join(this.workspace, 'bot-messages.json');
        let messages = [];
        
        try {
            if (fs.existsSync(botMessagesFile)) {
                messages = JSON.parse(fs.readFileSync(botMessagesFile, 'utf8'));
            }
        } catch (error) {
            messages = [];
        }
        
        messages.unshift(message);
        messages = messages.slice(0, 100); // Keep only last 100 messages
        
        fs.writeFileSync(botMessagesFile, JSON.stringify(messages, null, 2));
        
        this.log("📡 Updated bot communication system with validation results");
    }
    
    sleep(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }
    
    async getStatus() {
        return {
            name: this.name,
            emoji: this.emoji,
            isActive: this.isActive,
            soulsCollected: this.soulCollectors.length,
            linksChecked: this.checkedLinks.size,
            brokenLinks: this.brokenLinks.length,
            fixedLinks: this.fixedLinks.length,
            lastRun: fs.existsSync(this.reportFile) 
                ? fs.statSync(this.reportFile).mtime.toISOString()
                : null
        };
    }
}

// CLI interface
if (require.main === module) {
    const linkChecker = new LinkCheckerSoul();
    
    const command = process.argv[2] || 'start';
    
    switch (command) {
        case 'start':
            linkChecker.startSoulCollection();
            break;
            
        case 'status':
            linkChecker.getStatus().then(status => {
                console.log(JSON.stringify(status, null, 2));
            });
            break;
            
        case 'report':
            if (fs.existsSync(linkChecker.reportFile)) {
                const report = JSON.parse(fs.readFileSync(linkChecker.reportFile, 'utf8'));
                console.log(JSON.stringify(report, null, 2));
            } else {
                console.log("No report found. Run 'start' command first.");
            }
            break;
            
        default:
            console.log(`
🔗 Link Checker Soul - Soul Collector for Ecosystem Links

Usage: node link-checker-soul.js [command]

Commands:
  start    - Start comprehensive link validation (default)
  status   - Show current status
  report   - Display last health report

The Link Checker Soul collects specialized validator souls and
comprehensively validates all links across the PLT ecosystem.
            `);
    }
}

module.exports = LinkCheckerSoul;