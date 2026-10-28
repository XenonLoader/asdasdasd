// ==UserScript==
// @name         MovieBox.xyz VIP Unlocked Pro
// @namespace    http://tampermonkey.net/
// @version      5.0.0
// @description  MovieBox VIP Pro v5.0.0 — Premium Auto-Detect, Full Feature Bypass, Modern Glass UI
// @author       Amped & Antigravity
// @match        https://movieboxhd.net/*
// @match        https://*.themoviebox.xyz/*
// @match        https://newfilm122.xyz/*
// @match        https://*.newfilm122.xyz/*
// @match        https://netfilm.world/*
// @match        https://*.netfilm.world/*
// @match        https://123movienow.cc/*
// @match        https://*.mzfi.me/*
// @run-at       document-start
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    /* ══════════════════════════════════════════
       STATE
    ══════════════════════════════════════════ */
    var S = {
        on: true,
        title: '',
        detected: false,
        bypassed: 0,
        apiHit: 0,
        domHit: 0,
        premiumList: [],
        feat: { premium: true, hd: true, adFree: true, download: true },
        logs: [],
        mini: false
    };

    function addLog(msg, type) {
        var t = new Date().toTimeString().slice(0, 8);
        S.logs.unshift({ t: t, m: msg, c: type || 'info' });
        if (S.logs.length > 50) S.logs.length = 50;
        try { renderLogs(); } catch(e) {}
    }

    function addPremium(title) {
        if (!title || title.length < 2) return;
        for (var i = 0; i < S.premiumList.length; i++) {
            if (S.premiumList[i] === title) return;
        }
        S.premiumList.unshift(title);
        if (S.premiumList.length > 20) S.premiumList.length = 20;
        addLog('🔓 Premium unlocked: ' + title, 'unlock');
        S.bypassed++;
        try { renderPremiumList(); renderStats(); } catch(e) {}
    }

    /* ══════════════════════════════════════════
       VIP DEEP PATCHER
    ══════════════════════════════════════════ */
    function patchVip(o, d) {
        if (!o || typeof o !== 'object' || d > 12) return o;
        if (Array.isArray(o)) { for (var i = 0; i < o.length; i++) o[i] = patchVip(o[i], d + 1); return o; }
        var keys = Object.keys(o);
        for (var k = 0; k < keys.length; k++) {
            var key = keys[k], lk = key.toLowerCase();
            if (lk === 'isvip' || lk === 'is_vip' || lk === 'isactive' || lk === 'adfree' || lk === 'ad_free' || lk === 'issvip' || lk === 'is_svip') o[key] = true;
            else if (lk === 'viplevel' || lk === 'vip_level' || lk === 'membertype' || lk === 'member_type') o[key] = 2;
            else if (lk === 'maxresolution' || lk === 'max_resolution') o[key] = 2160;
            else if (lk === 'isrestrict' || lk === 'is_restrict' || lk === 'viprestrict' || lk === 'vip_restrict') o[key] = false;
            else if (lk === 'expireat' || lk === 'expirydate' || lk === 'expiry_date' || lk === 'svipexpirydate') o[key] = '2099-12-31T23:59:59Z';
            // MovieBox specific: unlock all episodes & watch limits
            else if (lk === 'freeepisodecount' || lk === 'freenum') o[key] = 999;
            else if (lk === 'requiredviplevel') o[key] = 0;
            else if (lk === 'ruletype') o[key] = 0;
            else if (lk === 'limited') o[key] = false;
            else if (lk === 'limitedcode') o[key] = '';
            else if (lk === 'watchtimelimit') o[key] = 0;
            else if (lk === 'previewseconds') o[key] = 0;
            else if (lk === 'isforbid') o[key] = false;
            else if (typeof o[key] === 'object' && o[key] !== null) o[key] = patchVip(o[key], d + 1);
        }
        return o;
    }

    /* ══════════════════════════════════════════
       NUXT SSR PATCH (safe polling)
    ══════════════════════════════════════════ */
    var nuxtDone = false;
    function tryPatchNuxt() {
        if (nuxtDone) return;
        try {
            if (window.__NUXT__ && typeof window.__NUXT__ === 'object') {
                patchVip(window.__NUXT__, 0);
                nuxtDone = true;
                addLog('Nuxt SSR data patched', 'bypass');
            }
        } catch(e) {}
    }

    /* ══════════════════════════════════════════
       PINIA STORE DIRECT PATCH — unlock episodes
    ══════════════════════════════════════════ */
    function patchPiniaData() {
        try {
            var appEl = document.getElementById('__nuxt') || document.getElementById('app');
            if (appEl && appEl.__vue_app__) {
                var gp = appEl.__vue_app__.config.globalProperties;
                if (gp && gp.$pinia && gp.$pinia.state && gp.$pinia.state.value) {
                    var stores = gp.$pinia.state.value;
                    for (var sk in stores) {
                        var st = stores[sk];
                        if (st && typeof st === 'object') {
                            if ('freeNum' in st) st.freeNum = 999;
                            if ('limited' in st) st.limited = false;
                            if ('limitedCode' in st) st.limitedCode = '';
                            if (st.accessStrategy) {
                                st.accessStrategy.freeEpisodeCount = 999;
                                st.accessStrategy.requiredVipLevel = 0;
                                st.accessStrategy.ruleType = 0;
                            }
                        }
                    }
                }
            }
        } catch(e) {}
    }

    /* ══════════════════════════════════════════
       LOCALSTORAGE
    ══════════════════════════════════════════ */
    try { localStorage.setItem('analyticsVipStatus', JSON.stringify({ isVip: 1, isSvip: 1, vipLevel: 2 })); } catch(e) {}

    /* ══════════════════════════════════════════
       FETCH INTERCEPTOR
    ══════════════════════════════════════════ */
    try {
        var _fetch = window.fetch;
        window.fetch = function() {
            if (!S.on) return _fetch.apply(this, arguments);
            var args = [].slice.call(arguments);
            var resource = args[0], config = args[1];
            try {
                if (config && config.headers) {
                    if (config.headers instanceof Headers) config.headers.delete('X-Vip-Restrict');
                    else if (typeof config.headers === 'object') { delete config.headers['X-Vip-Restrict']; delete config.headers['x-vip-restrict']; }
                }
            } catch(e) {}
            return _fetch.apply(this, args).then(function(resp) {
                try {
                    var url = typeof resource === 'string' ? resource : '';
                    if (url.indexOf('aoneroom.com') !== -1 || url.indexOf('/wefeed-h5') !== -1 || url.indexOf('/api/') !== -1) {
                        var clone = resp.clone();
                        return clone.text().then(function(text) {
                            if (text && text.length > 2 && (text[0] === '{' || text[0] === '[')) {
                                try {
                                    var json = JSON.parse(text);
                                    json = patchVip(json, 0);
                                    S.apiHit++;
                                    addLog('API patched: ' + url.split('/').pop().split('?')[0], 'api');
                                    return new Response(JSON.stringify(json), { status: resp.status, statusText: resp.statusText, headers: resp.headers });
                                } catch(e) { return resp; }
                            }
                            return resp;
                        }).catch(function() { return resp; });
                    }
                } catch(e) {}
                return resp;
            });
        };
        addLog('Fetch interceptor installed', 'bypass');
    } catch(e) {}

    /* ══════════════════════════════════════════
       DETECT TITLE + PREMIUM CONTENT
    ══════════════════════════════════════════ */
    function detectTitle() {
        try {
            var m = location.pathname.match(/\/(detail|movies|moviePlayPage\/movies)\/([^/?]+)/);
            if (m) {
                var parts = m[2].split('-'); parts.pop();
                var name = parts.join(' ').replace(/\b\w/g, function(c) { return c.toUpperCase(); });
                if (name && name.length > 1 && name !== S.title) {
                    S.title = name;
                    addLog('🎬 Now watching: ' + name, 'movie');
                }
            }
            if (!S.title || S.title.length < 2) {
                var h1 = document.querySelector('h1');
                if (h1) {
                    var t = h1.textContent.trim();
                    if (t.length > 1 && t.indexOf('MovieBox') === -1 && t.indexOf('Premium') === -1 && t !== S.title) {
                        S.title = t;
                        addLog('🎬 Now watching: ' + t, 'movie');
                    }
                }
            }
        } catch(e) {}
    }

    /* scan page for premium badges on movie cards */
    function scanPremiumCards() {
        try {
            var badges = document.querySelectorAll('[class*="vip" i], [class*="premium" i], [class*="crown" i], [class*="lock" i]');
            for (var i = 0; i < badges.length; i++) {
                var card = badges[i];
                if (card.closest('#mb-vip-panel')) continue;
                for (var j = 0; j < 5; j++) {
                    if (!card || card === document.body) break;
                    var link = card.querySelector('a[href*="/detail/"], a[href*="/movies/"]');
                    if (!link) link = card.closest ? card.closest('a[href*="/detail/"], a[href*="/movies/"]') : null;
                    if (link) {
                        var href = link.getAttribute('href') || '';
                        var match = href.match(/\/(detail|movies)\/([^/?]+)/);
                        if (match) {
                            var parts = match[2].split('-'); parts.pop();
                            var title = parts.join(' ').replace(/\b\w/g, function(c) { return c.toUpperCase(); });
                            if (title && title.length > 1) addPremium(title);
                        }
                        break;
                    }
                    card = card.parentElement;
                }
            }

            if (S.title && S.title.length > 1) {
                var walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT, null, false);
                while (walker.nextNode()) {
                    var node = walker.currentNode;
                    if (node.parentElement && node.parentElement.closest('#mb-vip-panel')) continue;
                    var txt = node.textContent;
                    if (txt && (
                        txt.indexOf('Premium Content') !== -1 ||
                        txt.indexOf('available for Premium members only') !== -1 ||
                        txt.indexOf('Please support us') !== -1 ||
                        txt.indexOf('Share your referral link') !== -1 ||
                        txt.indexOf('Go Premium') !== -1
                    )) {
                        S.detected = true;
                        addPremium(S.title);
                        break;
                    }
                }
            }
        } catch(e) {}
    }

    /* ══════════════════════════════════════════
       NUKE PAYWALL DOM — SURGICAL OVERLAY HIDE (Detail Pages Only)
    ══════════════════════════════════════════ */
    var lastNuke = 0;
    function nukePaywall() {
        if (!S.on || !document.body) return;
        // Only run nukePaywall on movie detail pages to avoid breaking homepage/catalog
        var isDetailPage = location.pathname.indexOf('/detail') !== -1 || location.pathname.indexOf('/movies/') !== -1 || location.pathname.indexOf('moviePlayPage') !== -1;
        if (!isDetailPage) return;

        var now = Date.now();
        if (now - lastNuke < 2000) return;
        lastNuke = now;
        try {
            var payWallTexts = ['Premium Content', 'available for Premium members only',
                'Upgrade to MovieBox Premium', 'Please support us',
                'Share your referral link', 'Go Premium',
                'enjoy 24-hour unlimited streaming'];

            // Hide overlay text elements inside player area only
            var walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT, null, false);
            while (walker.nextNode()) {
                var txt = walker.currentNode.textContent || '';
                var isPaywall = false;
                for (var p = 0; p < payWallTexts.length; p++) {
                    if (txt.indexOf(payWallTexts[p]) !== -1) { isPaywall = true; break; }
                }
                if (!isPaywall) continue;

                var el = walker.currentNode.parentElement;
                if (!el || el.closest('#mb-vip-panel')) continue;

                var target = el;
                for (var u = 0; u < 3; u++) {
                    if (!target.parentElement || target.parentElement === document.body) break;
                    var pr = target.parentElement.getBoundingClientRect();
                    if (pr.width > 800 || pr.height > 500) break;
                    target = target.parentElement;
                }

                if (target && !target.closest('#mb-vip-panel') && target.id !== '__nuxt' && target.id !== 'app') {
                    // Do not hide player elements or movie links/cards
                    if (!target.querySelector('video') && !target.querySelector('iframe') && !target.querySelector('a[href*="/movies/"], a[href*="/detail/"]')) {
                        target.style.cssText = 'display:none!important;';
                        S.domHit++;
                        if (!S.detected) { S.detected = true; addLog('⚠️ Paywall detected: ' + (S.title || 'this page'), 'detect'); }
                    }
                }
            }

            // Hide Go Premium / Unlock / Refresh buttons inside player area overlay
            var allBtns = document.querySelectorAll('a, button, div[role="button"]');
            for (var b = 0; b < allBtns.length; b++) {
                if (allBtns[b].closest('#mb-vip-panel')) continue;
                var btnTxt = (allBtns[b].textContent || '').trim();
                if (btnTxt.indexOf('Refresh') !== -1 || btnTxt.indexOf('Unlock') !== -1 || btnTxt.indexOf('Go Premium') !== -1) {
                    var bRect = allBtns[b].getBoundingClientRect();
                    if (bRect.top > 30 && bRect.top < 500 && bRect.width < 300) {
                        allBtns[b].style.cssText = 'display:none!important;';
                    }
                }
            }

            if (S.domHit > 0 && !S.logged_nuke) {
                S.logged_nuke = true;
                addLog('🛡️ Paywall overlays removed', 'bypass');
            }
        } catch(e) {}
    }

    /* ══════════════════════════════════════════
       PATCH VUE STORES
    ══════════════════════════════════════════ */
    function patchStores() {
        if (!S.on) return;
        try {
            var appEl = document.getElementById('__nuxt') || document.getElementById('app');
            if (appEl && appEl.__vue_app__) {
                var gp = appEl.__vue_app__.config.globalProperties;
                if (gp && gp.$pinia && gp.$pinia.state && gp.$pinia.state.value) {
                    var stores = gp.$pinia.state.value;
                    var ks = Object.keys(stores);
                    for (var i = 0; i < ks.length; i++) patchVip(stores[ks[i]], 0);
                }
            }
        } catch(e) {}
    }

    /* ══════════════════════════════════════════
       GUI — MODERN GLASS UI
    ══════════════════════════════════════════ */
    function buildPanel() {
        if (document.getElementById('mb-vip-panel')) return;
        if (!document.body) return;

        var css = document.createElement('style');
        css.id = 'mb-vip-css';
        css.textContent = '\
@import url("https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap");\
#mb-vip-panel{position:fixed;bottom:16px;right:16px;width:300px;font-family:"Inter",system-ui,-apple-system,sans-serif;\
background:linear-gradient(170deg,rgba(20,17,28,.96) 0%,rgba(12,10,18,.98) 100%);\
backdrop-filter:blur(24px) saturate(1.4);border:1px solid rgba(212,175,55,.25);\
border-radius:20px;color:#fff;z-index:9999999;\
box-shadow:0 20px 60px rgba(0,0,0,.6),0 0 40px rgba(212,175,55,.08),inset 0 1px 0 rgba(255,255,255,.05);\
overflow:hidden;transition:all .35s cubic-bezier(.4,0,.2,1);user-select:none}\
#mb-vip-panel.mini{width:170px;border-radius:14px}\
#mb-vip-panel.mini .mb-bd{display:none}\
\
.mb-hd{display:flex;align-items:center;justify-content:space-between;padding:14px 16px;\
background:linear-gradient(135deg,rgba(212,175,55,.1) 0%,rgba(212,175,55,.03) 100%);\
border-bottom:1px solid rgba(212,175,55,.1);cursor:pointer;transition:background .2s}\
.mb-hd:hover{background:linear-gradient(135deg,rgba(212,175,55,.15) 0%,rgba(212,175,55,.05) 100%)}\
.mb-hd-l{display:flex;align-items:center;gap:10px}\
.mb-hd-icon{width:32px;height:32px;border-radius:10px;\
background:linear-gradient(135deg,#D4AF37 0%,#B8860B 100%);\
display:flex;align-items:center;justify-content:center;font-size:16px;\
box-shadow:0 4px 12px rgba(212,175,55,.3);animation:mbg 3s ease-in-out infinite}\
@keyframes mbg{0%,100%{box-shadow:0 4px 12px rgba(212,175,55,.3)}50%{box-shadow:0 4px 20px rgba(212,175,55,.5)}}\
.mb-hd-t{font-size:13px;font-weight:700;letter-spacing:.2px}\
.mb-hd-v{font-size:9px;color:rgba(212,175,55,.8);font-weight:600;margin-top:1px}\
.mb-pill{padding:3px 10px;border-radius:20px;font-size:9px;font-weight:700;letter-spacing:.5px}\
.mb-pill-on{background:linear-gradient(135deg,rgba(34,197,94,.2),rgba(34,197,94,.1));\
color:#4ADE80;border:1px solid rgba(34,197,94,.25)}\
.mb-pill-off{background:rgba(239,68,68,.12);color:#F87171;border:1px solid rgba(239,68,68,.2)}\
\
.mb-bd{padding:12px 14px}\
\
.mb-card{background:rgba(255,255,255,.03);border:1px solid rgba(255,255,255,.06);\
border-radius:12px;padding:10px 12px;margin-bottom:10px;transition:border-color .2s}\
.mb-card:hover{border-color:rgba(212,175,55,.2)}\
.mb-card-label{font-size:9px;color:#64748B;text-transform:uppercase;letter-spacing:.8px;font-weight:600}\
.mb-card-title{font-size:13px;font-weight:700;color:#D4AF37;margin-top:3px;\
white-space:nowrap;overflow:hidden;text-overflow:ellipsis}\
.mb-card-sub{font-size:10px;margin-top:3px;font-weight:500}\
\
.mb-grid{display:grid;grid-template-columns:1fr 1fr;gap:6px;margin-bottom:10px}\
.mb-feat{display:flex;align-items:center;gap:7px;padding:7px 10px;\
background:rgba(255,255,255,.025);border:1px solid rgba(255,255,255,.05);\
border-radius:10px;cursor:pointer;transition:all .2s}\
.mb-feat:hover{background:rgba(255,255,255,.06);border-color:rgba(212,175,55,.15)}\
.mb-feat-dot{width:7px;height:7px;border-radius:50%;flex-shrink:0;transition:all .2s}\
.mb-feat-dot.on{background:#4ADE80;box-shadow:0 0 6px rgba(74,222,128,.5)}\
.mb-feat-dot.off{background:#475569}\
.mb-feat-name{font-size:10px;color:#94A3B8;font-weight:500}\
\
.mb-stats{display:flex;gap:6px;margin-bottom:10px}\
.mb-stat{flex:1;background:rgba(0,0,0,.25);border-radius:10px;padding:8px 6px;text-align:center;\
border:1px solid rgba(255,255,255,.03)}\
.mb-stat-v{font-size:16px;font-weight:800;background:linear-gradient(135deg,#D4AF37,#F5D76E);\
-webkit-background-clip:text;-webkit-text-fill-color:transparent;font-family:"Inter",monospace}\
.mb-stat-l{font-size:8px;color:#475569;text-transform:uppercase;font-weight:600;letter-spacing:.5px;margin-top:2px}\
\
.mb-section-label{font-size:9px;color:#64748B;text-transform:uppercase;letter-spacing:.8px;\
font-weight:600;margin-bottom:6px;display:flex;align-items:center;gap:5px}\
.mb-section-label::after{content:"";flex:1;height:1px;background:rgba(255,255,255,.06)}\
\
.mb-premium-list{max-height:70px;overflow-y:auto;margin-bottom:10px}\
.mb-premium-list::-webkit-scrollbar{width:2px}\
.mb-premium-list::-webkit-scrollbar-thumb{background:rgba(212,175,55,.3);border-radius:2px}\
.mb-pl-item{display:flex;align-items:center;gap:6px;padding:4px 0;\
border-bottom:1px solid rgba(255,255,255,.03);font-size:10px}\
.mb-pl-icon{font-size:10px;flex-shrink:0}\
.mb-pl-name{color:#D4AF37;font-weight:500;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}\
.mb-pl-empty{font-size:10px;color:#334155;font-style:italic;padding:6px 0}\
\
.mb-logbox{background:rgba(0,0,0,.3);border-radius:10px;padding:6px 8px;\
max-height:90px;overflow-y:auto;margin-bottom:10px;\
border:1px solid rgba(255,255,255,.03)}\
.mb-logbox::-webkit-scrollbar{width:2px}\
.mb-logbox::-webkit-scrollbar-thumb{background:rgba(212,175,55,.25);border-radius:2px}\
.mb-log{font-size:9.5px;padding:3px 0;border-bottom:1px solid rgba(255,255,255,.025);\
display:flex;gap:6px;line-height:1.4}\
.mb-log-t{color:#334155;font-family:monospace;flex-shrink:0;font-size:8.5px}\
.mb-log-m{word-break:break-word}\
.mb-log-m.bypass{color:#4ADE80}.mb-log-m.detect{color:#FBBF24}\
.mb-log-m.movie{color:#D4AF37}.mb-log-m.api{color:#38BDF8}\
.mb-log-m.error{color:#F87171}.mb-log-m.unlock{color:#A78BFA}\
.mb-log-m.info{color:#64748B}\
\
.mb-toggle-row{display:flex;align-items:center;justify-content:space-between;\
padding:8px 0;border-top:1px solid rgba(255,255,255,.05)}\
.mb-toggle-label{font-size:10px;color:#94A3B8;font-weight:500}\
.mb-tg{position:relative;width:38px;height:20px;border-radius:10px;cursor:pointer;\
transition:all .25s;background:#1E293B;border:1px solid rgba(255,255,255,.08)}\
.mb-tg.on{background:linear-gradient(135deg,#22C55E,#16A34A);border-color:rgba(34,197,94,.3);\
box-shadow:0 0 10px rgba(34,197,94,.25)}\
.mb-tg-k{position:absolute;top:2px;left:2px;width:14px;height:14px;\
background:#fff;border-radius:50%;transition:all .25s cubic-bezier(.4,0,.2,1);\
box-shadow:0 1px 3px rgba(0,0,0,.3)}\
.mb-tg.on .mb-tg-k{left:20px}\
\
.mb-ft{text-align:center;font-size:8px;color:#334155;padding-top:6px;font-weight:500}';
        document.head.appendChild(css);

        var div = document.createElement('div');
        div.id = 'mb-vip-panel';
        div.innerHTML = '\
<div class="mb-hd" id="mb-hd-click">\
  <div class="mb-hd-l">\
    <div class="mb-hd-icon">👑</div>\
    <div><div class="mb-hd-t">MovieBox VIP Pro</div><div class="mb-hd-v">v5.0.0 • Premium Bypass</div></div>\
  </div>\
  <span id="mb-pill" class="mb-pill mb-pill-on">ACTIVE</span>\
</div>\
<div class="mb-bd">\
  <div class="mb-card">\
    <div class="mb-card-label">🎬 Now Playing</div>\
    <div class="mb-card-title" id="mb-npt">Detecting...</div>\
    <div class="mb-card-sub" id="mb-nps" style="color:#64748B">Scanning page...</div>\
  </div>\
\
  <div class="mb-grid">\
    <div class="mb-feat" data-f="premium"><span class="mb-feat-dot on" id="mb-d-premium"></span><span class="mb-feat-name">Premium Unlock</span></div>\
    <div class="mb-feat" data-f="hd"><span class="mb-feat-dot on" id="mb-d-hd"></span><span class="mb-feat-name">HD / 4K Unlock</span></div>\
    <div class="mb-feat" data-f="adFree"><span class="mb-feat-dot on" id="mb-d-adFree"></span><span class="mb-feat-name">Ad-Free Mode</span></div>\
    <div class="mb-feat" data-f="download"><span class="mb-feat-dot on" id="mb-d-download"></span><span class="mb-feat-name">Download Unlock</span></div>\
  </div>\
\
  <div class="mb-stats">\
    <div class="mb-stat"><div class="mb-stat-v" id="mb-s1">0</div><div class="mb-stat-l">Bypassed</div></div>\
    <div class="mb-stat"><div class="mb-stat-v" id="mb-s2">0</div><div class="mb-stat-l">API Patched</div></div>\
    <div class="mb-stat"><div class="mb-stat-v" id="mb-s3">0</div><div class="mb-stat-l">DOM Nuked</div></div>\
  </div>\
\
  <div class="mb-section-label">🔓 Unlocked Premium</div>\
  <div class="mb-premium-list" id="mb-plist"><div class="mb-pl-empty">No premium content detected yet</div></div>\
\
  <div class="mb-section-label">📋 Activity Log</div>\
  <div class="mb-logbox" id="mb-logbox"></div>\
\
  <div class="mb-toggle-row">\
    <span class="mb-toggle-label">VIP Bypass Engine</span>\
    <div class="mb-tg on" id="mb-toggle"><div class="mb-tg-k"></div></div>\
  </div>\
  <div class="mb-ft">MovieBox.xyz VIP Unlocked Pro v5.0.0</div>\
</div>';

        document.body.appendChild(div);

        // Events
        document.getElementById('mb-hd-click').addEventListener('click', function() {
            S.mini = !S.mini;
            div.classList.toggle('mini', S.mini);
        });

        document.getElementById('mb-toggle').addEventListener('click', function() {
            S.on = !S.on;
            this.classList.toggle('on', S.on);
            var pill = document.getElementById('mb-pill');
            pill.textContent = S.on ? 'ACTIVE' : 'OFF';
            pill.className = 'mb-pill ' + (S.on ? 'mb-pill-on' : 'mb-pill-off');
            addLog(S.on ? '✅ Bypass enabled' : '❌ Bypass disabled', S.on ? 'bypass' : 'error');
        });

        var feats = document.querySelectorAll('.mb-feat');
        for (var i = 0; i < feats.length; i++) {
            feats[i].addEventListener('click', function() {
                var f = this.getAttribute('data-f');
                if (f && S.feat.hasOwnProperty(f)) {
                    S.feat[f] = !S.feat[f];
                    var dot = document.getElementById('mb-d-' + f);
                    if (dot) { dot.className = 'mb-feat-dot ' + (S.feat[f] ? 'on' : 'off'); }
                    addLog((S.feat[f] ? '✅ ' : '❌ ') + f + ' ' + (S.feat[f] ? 'ON' : 'OFF'), 'info');
                }
            });
        }

        addLog('🚀 Panel loaded, bypass active', 'bypass');
    }

    /* ══════════════════════════════════════════
       RENDER
    ══════════════════════════════════════════ */
    function renderLogs() {
        var box = document.getElementById('mb-logbox');
        if (!box) return;
        var h = '';
        for (var i = 0; i < Math.min(S.logs.length, 20); i++) {
            var l = S.logs[i];
            h += '<div class="mb-log"><span class="mb-log-t">' + l.t + '</span><span class="mb-log-m ' + l.c + '">' + l.m + '</span></div>';
        }
        box.innerHTML = h;
    }

    function renderPremiumList() {
        var box = document.getElementById('mb-plist');
        if (!box) return;
        if (S.premiumList.length === 0) {
            box.innerHTML = '<div class="mb-pl-empty">No premium content detected yet</div>';
            return;
        }
        var h = '';
        for (var i = 0; i < S.premiumList.length; i++) {
            h += '<div class="mb-pl-item"><span class="mb-pl-icon">🎬</span><span class="mb-pl-name">' + S.premiumList[i] + '</span></div>';
        }
        box.innerHTML = h;
    }

    function renderStats() {
        try {
            var s1 = document.getElementById('mb-s1');
            var s2 = document.getElementById('mb-s2');
            var s3 = document.getElementById('mb-s3');
            if (s1) s1.textContent = S.bypassed;
            if (s2) s2.textContent = S.apiHit;
            if (s3) s3.textContent = S.domHit;
            var npt = document.getElementById('mb-npt');
            var nps = document.getElementById('mb-nps');
            if (npt) npt.textContent = S.title || 'Browse a movie to detect';
            if (nps) {
                if (S.detected) { nps.textContent = '🛡️ Premium Detected → Bypassed!'; nps.style.color = '#4ADE80'; }
                else if (S.title) { nps.textContent = '🎥 Streaming...'; nps.style.color = '#38BDF8'; }
                else { nps.textContent = 'Waiting for content...'; nps.style.color = '#475569'; }
            }
        } catch(e) {}
    }

    /* ══════════════════════════════════════════
       AUTO DISMISS WELCOME MODALS & POPUPS
    ══════════════════════════════════════════ */
    function dismissWelcomeModals() {
        try {
            // Auto click "Don't show again" / "Cancel" buttons on modals
            var allBtns = document.querySelectorAll('button, a, div[role="button"], span');
            for (var i = 0; i < allBtns.length; i++) {
                var btn = allBtns[i];
                if (btn.closest('#mb-vip-panel')) continue;
                var txt = (btn.textContent || '').trim();
                if (txt === "Don't show again" || txt === "Cancel") {
                    btn.click();
                }
            }

            // Hide popups containing "Dear User", "Welcome home", "Your premium account is activated"
            var walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT, null, false);
            while (walker.nextNode()) {
                var node = walker.currentNode;
                if (node.parentElement && node.parentElement.closest('#mb-vip-panel')) continue;
                var text = node.textContent || '';
                if (text.indexOf('Welcome home') !== -1 ||
                    text.indexOf('Your premium account is activated') !== -1 ||
                    text.indexOf('Dear User') !== -1) {
                    var el = node.parentElement;
                    for (var k = 0; k < 6; k++) {
                        if (!el || el === document.body) break;
                        var pos = window.getComputedStyle(el).position;
                        if (pos === 'fixed' || pos === 'absolute' || el.className.indexOf('modal') !== -1 || el.className.indexOf('popup') !== -1) {
                            el.style.cssText = 'display:none!important;';
                            break;
                        }
                        el = el.parentElement;
                    }
                }
            }
        } catch(e) {}
    }

    /* ══════════════════════════════════════════
       MAIN TICK
    ══════════════════════════════════════════ */
    function tick() {
        if (!document.body) return;
        tryPatchNuxt();
        patchPiniaData();
        detectTitle();
        scanPremiumCards();
        dismissWelcomeModals();
        nukePaywall();
        patchStores();
        renderStats();
    }

    /* ══════════════════════════════════════════
       BOOT
    ══════════════════════════════════════════ */
    function boot() {
        if (!document.body) { setTimeout(boot, 200); return; }
        buildPanel();
        tick();
        addLog('Engine running: ' + location.pathname, 'info');
    }

    // Gentle startup: 10 ticks over 15s
    var n = 0;
    var iv = setInterval(function() { tick(); n++; if (n > 10) clearInterval(iv); }, 1500);

    // Keep-alive
    setInterval(function() {
        if (!document.getElementById('mb-vip-panel') && document.body) buildPanel();
        renderStats();
    }, 5000);

    // Debounced MutationObserver
    var dbt = null;
    function startObs() {
        if (!document.body) { setTimeout(startObs, 200); return; }
        try {
            new MutationObserver(function() {
                if (dbt) clearTimeout(dbt);
                dbt = setTimeout(tick, 1200);
            }).observe(document.body, { childList: true, subtree: true });
        } catch(e) {}
    }

    // URL change detection (SPA navigation)
    var lastUrl = location.href;
    setInterval(function() {
        if (location.href !== lastUrl) {
            lastUrl = location.href;
            S.detected = false;
            S.title = '';
            nuxtDone = false;
            addLog('📍 Navigated to: ' + location.pathname, 'info');
            setTimeout(tick, 500);
        }
    }, 1000);

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() { boot(); startObs(); });
    } else {
        boot(); startObs();
    }

})();
