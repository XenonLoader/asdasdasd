// ==UserScript==
// @name         kxBypass LootLabs Enhanced - Mobile Compatible
// @namespace    https://discord.gg/pqEBSTqdxV
// @version      v2.1
// @description  Ultra-Fast Enhanced Bypass for Lootlinks - Premium UI & Lightning Speed - Mobile Compatible
// @author       awaitlol.
// @match        https://lootlinks.co/*
// @match        https://loot-links.com/*
// @match        https://loot-link.com/*
// @match        https://linksloot.net/*
// @match        https://lootdest.com/*
// @match        https://lootlink.org/*
// @match        https://lootdest.info/*
// @match        https://lootdest.org/*
// @match        https://links-loot.com/*
// @icon         https://i.pinimg.com/736x/aa/2a/e5/aa2ae567da2c40ac6834a44abbb9e9ff.jpg
// @grant        none
// @run-at       document-start
// ==/UserScript==

(function () {
    "use strict";

    // Mobile detection
    const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ||
                     window.innerWidth <= 768 ||
                     'ontouchstart' in window;

    // Enhanced configuration for mobile compatibility
    const CONFIG = {
        WEBSOCKET_TIMEOUT: isMobile ? 12000 : 8000,      // Longer timeout for mobile
        HEARTBEAT_INTERVAL: isMobile ? 500 : 300,        // Slower heartbeat for mobile
        UI_DELAY: isMobile ? 800 : 500,                  // Longer delay for mobile
        MAX_RETRIES: 5,                                  // More retries for mobile
        ANIMATION_SPEED: isMobile ? 0.5 : 0.3,           // Slower animations for mobile
        FETCH_TIMEOUT: isMobile ? 10000 : 5000           // Longer fetch timeout for mobile
    };

    // Global variables that might be missing
    let INCENTIVE_SERVER_DOMAIN = 'loot-links.com';
    let INCENTIVE_SYNCER_DOMAIN = 'loot-links.com';
    let KEY = 'defaultkey';
    let TID = 'defaulttid';

    let bypassState = {
        isActive: false,
        startTime: Date.now(),
        retryCount: 0,
        progress: 0
    };

    // Enhanced mobile-friendly logging
    function mobileLog(message, type = 'info') {
        console.log(`[kxBypass Mobile] ${type.toUpperCase()}: ${message}`);

        // Show visual feedback on mobile
        if (isMobile && type === 'error') {
            showMobileNotification(message, 'error');
        }
    }

    function showMobileNotification(message, type = 'info') {
        const notification = document.createElement('div');
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            background: ${type === 'error' ? '#ef4444' : '#4ade80'};
            color: white;
            padding: 12px 20px;
            border-radius: 8px;
            z-index: 9999999;
            font-family: Arial, sans-serif;
            font-size: 14px;
            max-width: 90vw;
            text-align: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        `;
        notification.textContent = message;
        document.body.appendChild(notification);

        setTimeout(() => {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 3000);
    }

    // Enhanced progress simulation with mobile optimization
    function simulateProgress() {
        const progressInterval = setInterval(() => {
            if (bypassState.progress < 90) {
                bypassState.progress += Math.random() * (isMobile ? 10 : 15);
                updateProgressBar();
            } else {
                clearInterval(progressInterval);
            }
        }, isMobile ? 300 : 200);
    }

    function updateProgressBar() {
        const progressBar = document.querySelector('.progress-fill');
        const progressText = document.querySelector('.progress-text');
        if (progressBar && progressText) {
            progressBar.style.width = `${Math.min(bypassState.progress, 100)}%`;
            progressText.textContent = `${Math.round(bypassState.progress)}%`;
        }
    }

    // Enhanced fetch with timeout for mobile
    function fetchWithTimeout(url, options = {}, timeout = CONFIG.FETCH_TIMEOUT) {
        return Promise.race([
            fetch(url, options),
            new Promise((_, reject) =>
                setTimeout(() => reject(new Error('Fetch timeout')), timeout)
            )
        ]);
    }

    // Auto-detect required parameters from page
    function detectPageParameters() {
        try {
            // Try to extract parameters from page scripts or global variables
            const scripts = document.getElementsByTagName('script');
            for (let script of scripts) {
                const content = script.textContent || script.innerHTML;

                // Look for common patterns
                const keyMatch = content.match(/key['"]\s*:\s*['"]([^'"]+)['"]/i);
                const tidMatch = content.match(/tid['"]\s*:\s*['"]([^'"]+)['"]/i);
                const domainMatch = content.match(/domain['"]\s*:\s*['"]([^'"]+)['"]/i);

                if (keyMatch) KEY = keyMatch[1];
                if (tidMatch) TID = tidMatch[1];
                if (domainMatch) {
                    INCENTIVE_SERVER_DOMAIN = domainMatch[1];
                    INCENTIVE_SYNCER_DOMAIN = domainMatch[1];
                }
            }

            // Fallback: try to get from window object
            if (window.lootConfig) {
                KEY = window.lootConfig.key || KEY;
                TID = window.lootConfig.tid || TID;
                INCENTIVE_SERVER_DOMAIN = window.lootConfig.domain || INCENTIVE_SERVER_DOMAIN;
            }

            mobileLog(`Detected params - KEY: ${KEY.substring(0, 10)}..., TID: ${TID}, Domain: ${INCENTIVE_SERVER_DOMAIN}`);
        } catch (error) {
            mobileLog(`Parameter detection failed: ${error.message}`, 'error');
        }
    }

    function handleLootlinks() {
        if (bypassState.isActive) return;
        bypassState.isActive = true;
        bypassState.startTime = Date.now();

        mobileLog(`Starting bypass on ${isMobile ? 'mobile' : 'desktop'} device`);

        // Detect parameters first
        detectPageParameters();

        // Enhanced fetch interceptor with mobile optimizations
        const originalFetch = window.fetch;
        window.fetch = async function (...args) {
            const [resource] = args;
            const url = typeof resource === "string" ? resource : resource.url;

            mobileLog(`Intercepted fetch: ${url}`);

            if (url.includes("/tc") || url.includes("task") || url.includes("challenge")) {
                return handleTcRequest(originalFetch, args);
            }

            return originalFetch(...args);
        };

        // Enhanced popup and redirect blocking for mobile
        const originalOpen = window.open;
        window.open = function(...args) {
            mobileLog(`Blocked popup: ${args[0]}`);
            return null;
        };

        const originalReplace = window.location.replace;
        window.location.replace = function(url) {
            mobileLog(`Blocked redirect: ${url}`);
        };

        // Block mobile-specific redirects
        Object.defineProperty(window.location, 'href', {
            set: function(url) {
                if (url.includes('loot') && !url.includes(window.location.hostname)) {
                    mobileLog(`Blocked location.href redirect: ${url}`);
                    return;
                }
                originalReplace.call(this, url);
            },
            get: function() {
                return window.location.toString();
            }
        });

        // Initialize mobile-optimized UI
        setTimeout(() => {
            clearPageAndCreateUI();
            simulateProgress();
        }, CONFIG.UI_DELAY);

        // Mobile-specific: Try alternative bypass methods
        if (isMobile) {
            setTimeout(() => {
                tryAlternativeBypass();
            }, CONFIG.UI_DELAY + 2000);
        }
    }

    // Alternative bypass method for mobile
    function tryAlternativeBypass() {
        mobileLog('Trying alternative bypass method for mobile');

        // Look for bypass buttons or links
        const possibleBypassElements = [
            ...document.querySelectorAll('button'),
            ...document.querySelectorAll('a'),
            ...document.querySelectorAll('[onclick]'),
            ...document.querySelectorAll('.btn'),
            ...document.querySelectorAll('.button')
        ];

        for (let element of possibleBypassElements) {
            const text = element.textContent || element.innerText || '';
            const onclick = element.getAttribute('onclick') || '';

            if (text.toLowerCase().includes('continue') ||
                text.toLowerCase().includes('proceed') ||
                text.toLowerCase().includes('get link') ||
                onclick.includes('bypass') ||
                onclick.includes('continue')) {

                mobileLog(`Found potential bypass element: ${text}`);

                // Try to click it
                setTimeout(() => {
                    try {
                        element.click();
                        mobileLog('Clicked bypass element');
                    } catch (error) {
                        mobileLog(`Failed to click bypass element: ${error.message}`, 'error');
                    }
                }, 1000);
                break;
            }
        }
    }

    async function handleTcRequest(originalFetch, args) {
        try {
            mobileLog('Processing TC request');

            const response = await fetchWithTimeout(...args);
            const data = await response.clone().json();

            mobileLog(`TC Response: ${JSON.stringify(data).substring(0, 200)}...`);

            if (Array.isArray(data) && data.length > 0) {
                await processBypassData(data[0]);
            } else if (data && typeof data === 'object') {
                await processBypassData(data);
            } else {
                throw new Error('Invalid response data format');
            }

            return response;
        } catch (err) {
            mobileLog(`Bypass error: ${err.message}`, 'error');

            if (bypassState.retryCount < CONFIG.MAX_RETRIES) {
                bypassState.retryCount++;
                updateRetryUI();
                mobileLog(`Retrying... Attempt ${bypassState.retryCount}/${CONFIG.MAX_RETRIES}`);

                await new Promise(resolve => setTimeout(resolve, 1000 * bypassState.retryCount)); // Exponential backoff
                return originalFetch(...args);
            } else {
                showErrorUI("Multiple bypass attempts failed. This might be a mobile compatibility issue.");
                throw err;
            }
        }
    }

    async function processBypassData(data) {
        mobileLog(`Processing bypass data: ${JSON.stringify(data).substring(0, 100)}...`);

        const { urid, task_id, action_pixel_url, session_id } = data;

        if (!urid || !task_id) {
            throw new Error('Missing required parameters (urid or task_id)');
        }

        const shard = parseInt(urid.slice(-5)) % 3;
        const wsUrl = `wss://${shard}.${INCENTIVE_SERVER_DOMAIN}/c?uid=${urid}&cat=${task_id}&key=${KEY}&session_id=${session_id}&is_loot=1&tid=${TID}`;

        mobileLog(`WebSocket URL: ${wsUrl}`);

        return new Promise((resolve, reject) => {
            let ws;

            try {
                ws = new WebSocket(wsUrl);
            } catch (error) {
                mobileLog(`WebSocket creation failed: ${error.message}`, 'error');
                reject(error);
                return;
            }

            let heartbeatInterval;
            let wsTimeout = setTimeout(() => {
                mobileLog('WebSocket timeout', 'error');
                if (ws) ws.close();
                reject(new Error('WebSocket timeout'));
            }, CONFIG.WEBSOCKET_TIMEOUT);

            ws.onopen = () => {
                mobileLog('WebSocket connected');
                clearTimeout(wsTimeout);
                bypassState.progress = 60;
                updateProgressBar();

                heartbeatInterval = setInterval(() => {
                    if (ws.readyState === WebSocket.OPEN) {
                        ws.send("0");
                        mobileLog('Heartbeat sent');
                    }
                }, CONFIG.HEARTBEAT_INTERVAL);
            };

            ws.onmessage = (e) => {
                mobileLog(`WebSocket message: ${e.data.substring(0, 50)}...`);

                if (e.data.startsWith("r:")) {
                    clearInterval(heartbeatInterval);
                    bypassState.progress = 100;
                    updateProgressBar();

                    const encodedString = e.data.slice(2);
                    try {
                        const destinationUrl = decodeURI(encodedString);
                        mobileLog(`Decoded URL: ${destinationUrl}`);
                        setTimeout(() => showBypassResult(destinationUrl), 300);
                        resolve(destinationUrl);
                    } catch (err) {
                        mobileLog(`Decryption error: ${err.message}`, 'error');
                        reject(err);
                    }
                }
            };

            ws.onerror = (error) => {
                mobileLog(`WebSocket error: ${error}`, 'error');
                clearInterval(heartbeatInterval);
                clearTimeout(wsTimeout);
                reject(error);
            };

            ws.onclose = (event) => {
                mobileLog(`WebSocket closed: ${event.code} - ${event.reason}`);
                clearInterval(heartbeatInterval);
                clearTimeout(wsTimeout);
            };

            // Enhanced tracking requests with mobile-friendly error handling
            const trackingPromises = [];

            if (action_pixel_url) {
                trackingPromises.push(
                    fetchWithTimeout(`https:${action_pixel_url}`, {}, 3000).catch(err =>
                        mobileLog(`Action pixel failed: ${err.message}`, 'error')
                    )
                );
            }

            trackingPromises.push(
                fetchWithTimeout(`https://${shard}.${INCENTIVE_SERVER_DOMAIN}/st?uid=${urid}&cat=${task_id}`, {}, 3000).catch(err =>
                    mobileLog(`ST request failed: ${err.message}`, 'error')
                )
            );

            trackingPromises.push(
                fetchWithTimeout(`https://${INCENTIVE_SYNCER_DOMAIN}/td?ac=auto_complete&urid=${urid}&cat=${task_id}&tid=${TID}`, {}, 3000).catch(err =>
                    mobileLog(`TD request failed: ${err.message}`, 'error')
                )
            );

            Promise.allSettled(trackingPromises).then(results => {
                mobileLog(`Tracking requests completed: ${results.length} requests`);
            });
        });
    }

    function clearPageAndCreateUI() {
        mobileLog('Clearing page and creating UI');

        // More aggressive page clearing for mobile
        try {
            document.documentElement.innerHTML = '';
            document.head.innerHTML = '';
            document.body.innerHTML = '';
        } catch (error) {
            mobileLog(`Page clearing failed: ${error.message}`, 'error');
        }

        // Inject mobile-optimized fonts
        const font = document.createElement("link");
        font.rel = "stylesheet";
        font.href = "https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap";
        document.head.appendChild(font);

        // Add mobile viewport meta tag
        const viewport = document.createElement("meta");
        viewport.name = "viewport";
        viewport.content = "width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no";
        document.head.appendChild(viewport);

        createMobileOptimizedUI();
    }

    function createMobileOptimizedUI() {
        const overlay = document.createElement("div");
        overlay.id = "kxBypass-overlay";
        overlay.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            background-size: 400% 400%;
            animation: gradientShift 8s ease infinite;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            z-index: 2147483647;
            color: white;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            overflow: hidden;
            padding: ${isMobile ? '20px' : '0'};
            box-sizing: border-box;
        `;

        const elapsedTime = Math.round((Date.now() - bypassState.startTime) / 1000);

        overlay.innerHTML = `
            <!-- Animated background particles -->
            <div class="particles">
                ${Array.from({length: isMobile ? 25 : 50}, (_, i) => `<div class="particle" style="--delay: ${i * 0.1}s"></div>`).join('')}
            </div>

            <!-- Main content -->
            <div class="main-container">
                <div class="logo-container">
                    <div class="logo-icon">🚀</div>
                    <div class="logo-text">kxBypass</div>
                    <div class="version-badge">v2.1 Mobile</div>
                </div>

                <div class="status-text">
                    Bypassing with <span class="highlight">lightning speed</span>...
                    ${isMobile ? '<br><small>Mobile Optimized</small>' : ''}
                </div>

                <!-- Enhanced progress bar -->
                <div class="progress-container">
                    <div class="progress-bar">
                        <div class="progress-fill"></div>
                        <div class="progress-glow"></div>
                    </div>
                    <div class="progress-text">0%</div>
                </div>

                <!-- Stats container -->
                <div class="stats-container">
                    <div class="stat-item">
                        <div class="stat-label">Time</div>
                        <div class="stat-value" id="elapsed-time">${elapsedTime}s</div>
                    </div>
                    <div class="stat-divider"></div>
                    <div class="stat-item">
                        <div class="stat-label">Attempt</div>
                        <div class="stat-value">${bypassState.retryCount + 1}/${CONFIG.MAX_RETRIES + 1}</div>
                    </div>
                    <div class="stat-divider"></div>
                    <div class="stat-item">
                        <div class="stat-label">Device</div>
                        <div class="stat-value">${isMobile ? 'Mobile' : 'Desktop'}</div>
                    </div>
                </div>

                <!-- Loading animation -->
                <div class="loading-container">
                    <div class="spinner-modern"></div>
                </div>

                <div class="footer-text">
                    Enhanced for maximum performance & mobile compatibility
                </div>
            </div>
        `;

        document.body.appendChild(overlay);

        const style = document.createElement("style");
        style.textContent = `
            @keyframes gradientShift {
                0% { background-position: 0% 50%; }
                50% { background-position: 100% 50%; }
                100% { background-position: 0% 50%; }
            }

            @keyframes float {
                0%, 100% { transform: translateY(0px) rotate(0deg); }
                50% { transform: translateY(-20px) rotate(180deg); }
            }

            @keyframes pulse {
                0%, 100% { opacity: 0.3; transform: scale(1); }
                50% { opacity: 1; transform: scale(1.1); }
            }

            @keyframes spin {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }

            @keyframes progressGlow {
                0%, 100% { opacity: 0.5; }
                50% { opacity: 1; }
            }

            .particles {
                position: absolute;
                width: 100%;
                height: 100%;
                overflow: hidden;
                z-index: 1;
            }

            .particle {
                position: absolute;
                width: ${isMobile ? '3px' : '4px'};
                height: ${isMobile ? '3px' : '4px'};
                background: rgba(255, 255, 255, 0.6);
                border-radius: 50%;
                animation: float 6s ease-in-out infinite;
                animation-delay: var(--delay);
                left: ${Math.random() * 100}%;
                top: ${Math.random() * 100}%;
            }

            .main-container {
                text-align: center;
                max-width: ${isMobile ? '90vw' : '500px'};
                width: 100%;
                padding: ${isMobile ? '30px 20px' : '50px 30px'};
                background: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(20px);
                border-radius: 24px;
                border: 1px solid rgba(255, 255, 255, 0.2);
                box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
                z-index: 2;
                position: relative;
                animation: slideUp 0.6s ease-out;
                box-sizing: border-box;
            }

            @keyframes slideUp {
                from { opacity: 0; transform: translateY(30px); }
                to { opacity: 1; transform: translateY(0); }
            }

            .logo-container {
                margin-bottom: ${isMobile ? '24px' : '32px'};
                position: relative;
            }

            .logo-icon {
                font-size: ${isMobile ? '36px' : '48px'};
                margin-bottom: ${isMobile ? '12px' : '16px'};
                animation: pulse 2s ease-in-out infinite;
            }

            .logo-text {
                font-size: ${isMobile ? '24px' : '32px'};
                font-weight: 800;
                background: linear-gradient(45deg, #fff, #f0f0f0);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                margin-bottom: 8px;
            }

            .version-badge {
                display: inline-block;
                padding: 4px 12px;
                background: linear-gradient(45deg, #4ade80, #22c55e);
                border-radius: 20px;
                font-size: ${isMobile ? '10px' : '12px'};
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .status-text {
                font-size: ${isMobile ? '16px' : '18px'};
                margin-bottom: ${isMobile ? '24px' : '32px'};
                opacity: 0.9;
                font-weight: 500;
                line-height: 1.4;
            }

            .highlight {
                background: linear-gradient(45deg, #fbbf24, #f59e0b);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                font-weight: 700;
            }

            .progress-container {
                margin-bottom: ${isMobile ? '24px' : '32px'};
                position: relative;
            }

            .progress-bar {
                width: 100%;
                height: ${isMobile ? '6px' : '8px'};
                background: rgba(255, 255, 255, 0.2);
                border-radius: 10px;
                overflow: hidden;
                position: relative;
                margin-bottom: 12px;
            }

            .progress-fill {
                height: 100%;
                background: linear-gradient(90deg, #4ade80, #22c55e, #16a34a);
                border-radius: 10px;
                width: 0%;
                transition: width 0.3s ease;
                position: relative;
            }

            .progress-glow {
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
                animation: progressGlow 2s ease-in-out infinite;
            }

            .progress-text {
                font-size: ${isMobile ? '12px' : '14px'};
                font-weight: 600;
                font-family: 'JetBrains Mono', monospace;
                opacity: 0.8;
            }

            .stats-container {
                display: flex;
                justify-content: center;
                align-items: center;
                margin-bottom: ${isMobile ? '24px' : '32px'};
                padding: ${isMobile ? '12px' : '16px'};
                background: rgba(255, 255, 255, 0.1);
                border-radius: 16px;
                backdrop-filter: blur(10px);
                flex-wrap: ${isMobile ? 'wrap' : 'nowrap'};
            }

            .stat-item {
                text-align: center;
                flex: 1;
                min-width: ${isMobile ? '80px' : 'auto'};
            }

            .stat-label {
                font-size: ${isMobile ? '10px' : '12px'};
                opacity: 0.7;
                margin-bottom: 4px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .stat-value {
                font-size: ${isMobile ? '14px' : '16px'};
                font-weight: 700;
                font-family: 'JetBrains Mono', monospace;
            }

            .stat-divider {
                width: 1px;
                height: 30px;
                background: rgba(255, 255, 255, 0.3);
                margin: 0 ${isMobile ? '8px' : '16px'};
                display: ${isMobile ? 'none' : 'block'};
            }

            .loading-container {
                margin-bottom: ${isMobile ? '20px' : '24px'};
            }

            .spinner-modern {
                width: ${isMobile ? '32px' : '40px'};
                height: ${isMobile ? '32px' : '40px'};
                border: 3px solid rgba(255, 255, 255, 0.2);
                border-top: 3px solid #4ade80;
                border-radius: 50%;
                animation: spin 0.8s cubic-bezier(0.68, -0.55, 0.265, 1.55) infinite;
                margin: 0 auto;
            }

            .footer-text {
                font-size: ${isMobile ? '11px' : '13px'};
                opacity: 0.6;
                font-weight: 400;
                line-height: 1.4;
            }

            .success-container {
                animation: successPulse 0.6s ease-out;
            }

            @keyframes successPulse {
                0% { transform: scale(0.9); opacity: 0; }
                50% { transform: scale(1.05); }
                100% { transform: scale(1); opacity: 1; }
            }

            .success-icon {
                font-size: ${isMobile ? '48px' : '64px'};
                margin-bottom: ${isMobile ? '16px' : '24px'};
                animation: bounce 0.6s ease-out;
            }

            @keyframes bounce {
                0%, 20%, 53%, 80%, 100% { transform: translate3d(0,0,0); }
                40%, 43% { transform: translate3d(0,-30px,0); }
                70% { transform: translate3d(0,-15px,0); }
                90% { transform: translate3d(0,-4px,0); }
            }

            .continue-btn {
                padding: ${isMobile ? '14px 28px' : '16px 32px'};
                background: linear-gradient(45deg, #4ade80, #22c55e);
                color: white;
                border: none;
                border-radius: 12px;
                font-size: ${isMobile ? '14px' : '16px'};
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                font-family: 'Inter', sans-serif;
                box-shadow: 0 10px 25px rgba(74, 222, 128, 0.3);
                text-transform: uppercase;
                letter-spacing: 0.5px;
                width: ${isMobile ? '100%' : 'auto'};
                max-width: ${isMobile ? '300px' : 'none'};
                touch-action: manipulation;
            }

            .continue-btn:hover, .continue-btn:active {
                transform: translateY(-2px);
                box-shadow: 0 15px 35px rgba(74, 222, 128, 0.4);
            }

            .url-display {
                background: rgba(0, 0, 0, 0.3);
                padding: ${isMobile ? '12px' : '16px'};
                border-radius: 12px;
                margin: 24px 0;
                word-break: break-all;
                font-family: 'JetBrains Mono', monospace;
                font-size: ${isMobile ? '11px' : '13px'};
                border: 1px solid rgba(255, 255, 255, 0.2);
                max-height: ${isMobile ? '80px' : '100px'};
                overflow-y: auto;
                line-height: 1.4;
            }

            /* Mobile-specific optimizations */
            @media (max-width: 768px) {
                .main-container {
                    margin: 10px;
                    max-width: calc(100vw - 20px);
                }

                .stats-container {
                    flex-direction: column;
                    gap: 8px;
                }

                .stat-item {
                    margin-bottom: 8px;
                }

                .stat-divider {
                    display: none;
                }
            }

            /* Touch-friendly interactions */
            @media (hover: none) and (pointer: coarse) {
                .continue-btn:hover {
                    transform: none;
                }

                .continue-btn:active {
                    transform: scale(0.98);
                }
            }
        `;
        document.head.appendChild(style);

        // Update timer every 100ms for smoother updates
        const timer = setInterval(() => {
            if (!document.getElementById("kxBypass-overlay")) {
                clearInterval(timer);
                return;
            }
            const elapsed = Math.round((Date.now() - bypassState.startTime) / 1000);
            const timeElement = document.getElementById('elapsed-time');
            if (timeElement) {
                timeElement.textContent = `${elapsed}s`;
            }
        }, 100);
    }

    function updateRetryUI() {
        const statValue = document.querySelector('.stat-item:nth-child(3) .stat-value');
        if (statValue) {
            statValue.textContent = `${bypassState.retryCount + 1}/${CONFIG.MAX_RETRIES + 1}`;
        }
    }

    function showBypassResult(destinationUrl) {
        let overlay = document.getElementById("kxBypass-overlay");
        if (!overlay) {
            createMobileOptimizedUI();
            overlay = document.getElementById("kxBypass-overlay");
        }

        const totalTime = Math.round((Date.now() - bypassState.startTime) / 1000);

        overlay.innerHTML = `
            <div class="particles">
                ${Array.from({length: isMobile ? 15 : 30}, (_, i) => `<div class="particle" style="--delay: ${i * 0.1}s"></div>`).join('')}
            </div>

            <div class="main-container success-container">
                <div class="success-icon">✅</div>

                <div class="logo-text" style="color: #4ade80; margin-bottom: 16px;">
                    Bypass Successful!
                </div>

                <div class="status-text">
                    Completed in <span class="highlight">${totalTime} seconds</span>
                    ${isMobile ? '<br><small>Mobile Optimized</small>' : ''}
                </div>

                <div class="stats-container">
                    <div class="stat-item">
                        <div class="stat-label">Speed</div>
                        <div class="stat-value" style="color: #4ade80;">Ultra Fast</div>
                    </div>
                    <div class="stat-divider"></div>
                    <div class="stat-item">
                        <div class="stat-label">Status</div>
                        <div class="stat-value" style="color: #4ade80;">Success</div>
                    </div>
                    <div class="stat-divider"></div>
                    <div class="stat-item">
                        <div class="stat-label">Time</div>
                        <div class="stat-value">${totalTime}s</div>
                    </div>
                </div>

                <div class="url-display">
                    ${destinationUrl}
                </div>

                <button class="continue-btn" onclick="window.location.href='${destinationUrl}'" ontouchstart="">
                    Continue to Destination →
                </button>

                <div class="footer-text" style="margin-top: 20px;">
                    🚀 Enhanced bypass completed successfully on ${isMobile ? 'mobile' : 'desktop'}
                </div>
            </div>
        `;

        mobileLog(`Bypass successful! Redirecting to: ${destinationUrl}`);
        showMobileNotification('Bypass successful!', 'success');
    }

    function showErrorUI(message) {
        let overlay = document.getElementById("kxBypass-overlay");
        if (!overlay) {
            createMobileOptimizedUI();
            overlay = document.getElementById("kxBypass-overlay");
        }

        const totalTime = Math.round((Date.now() - bypassState.startTime) / 1000);

        overlay.innerHTML = `
            <div class="particles">
                ${Array.from({length: isMobile ? 10 : 20}, (_, i) => `<div class="particle" style="--delay: ${i * 0.1}s"></div>`).join('')}
            </div>

            <div class="main-container">
                <div class="success-icon" style="color: #ef4444;">❌</div>

                <div class="logo-text" style="color: #ef4444; margin-bottom: 16px;">
                    Bypass Failed
                </div>

                <div class="status-text">
                    ${message}
                    ${isMobile ? '<br><small>Try refreshing or using desktop</small>' : ''}
                </div>

                <div class="stats-container" style="background: rgba(239, 68, 68, 0.1);">
                    <div class="stat-item">
                        <div class="stat-label">Time</div>
                        <div class="stat-value">${totalTime}s</div>
                    </div>
                    <div class="stat-divider"></div>
                    <div class="stat-item">
                        <div class="stat-label">Attempts</div>
                        <div class="stat-value">${bypassState.retryCount}/${CONFIG.MAX_RETRIES}</div>
                    </div>
                    <div class="stat-divider"></div>
                    <div class="stat-item">
                        <div class="stat-label">Device</div>
                        <div class="stat-value">${isMobile ? 'Mobile' : 'Desktop'}</div>
                    </div>
                </div>

                <button class="continue-btn" onclick="window.location.reload()" ontouchstart=""
                        style="background: linear-gradient(45deg, #ef4444, #dc2626);">
                    🔄 Refresh & Retry
                </button>

                <div class="footer-text" style="margin-top: 20px;">
                    Please try refreshing the page or switching to desktop
                </div>
            </div>
        `;

        mobileLog(`Bypass failed: ${message}`, 'error');
        showMobileNotification('Bypass failed! Try refreshing.', 'error');
    }

    function decodeURI(encodedString, prefixLength = 5) {
        try {
            let decodedString = "";
            const base64Decoded = atob(encodedString);
            const prefix = base64Decoded.substring(0, prefixLength);
            const encodedPortion = base64Decoded.substring(prefixLength);

            for (let i = 0; i < encodedPortion.length; i++) {
                const encodedChar = encodedPortion.charCodeAt(i);
                const prefixChar = prefix.charCodeAt(i % prefix.length);
                const decodedChar = encodedChar ^ prefixChar;
                decodedString += String.fromCharCode(decodedChar);
            }

            mobileLog(`Successfully decoded URL: ${decodedString.substring(0, 50)}...`);
            return decodedString;
        } catch (error) {
            mobileLog(`Decoding error: ${error.message}`, 'error');
            throw new Error('Failed to decode destination URL');
        }
    }

    // Enhanced initialization with mobile detection
    function initializeBypass() {
        mobileLog(`Initializing bypass - Device: ${isMobile ? 'Mobile' : 'Desktop'}, URL: ${window.location.href}`);

        if (window.location.href.includes("loot")) {
            // Add mobile-specific delay
            const initDelay = isMobile ? 1000 : 0;

            setTimeout(() => {
                handleLootlinks();
            }, initDelay);
        } else {
            mobileLog('Not a loot link, skipping bypass');
        }
    }

    // Ultra-fast initialization with mobile compatibility
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initializeBypass);
    } else {
        initializeBypass();
    }

    // Mobile-specific: Handle page visibility changes
    if (isMobile) {
        document.addEventListener('visibilitychange', () => {
            if (document.visibilityState === 'visible' && bypassState.isActive) {
                mobileLog('Page became visible, checking bypass status');
            }
        });
    }

    mobileLog('kxBypass Mobile Enhanced loaded successfully');
})();