import { r as resolveComponent, o as openBlock, c as createElementBlock, b as createBaseVNode, d as createTextVNode, e as createVNode, a as createStaticVNode, _ as _export_sfc } from "./app.BfCqIV5P.js";
const __pageData = JSON.parse('{"title":"Request","description":"API documentation for Request class from ribs_http","frontmatter":{"title":"Request","description":"API documentation for Request class from ribs_http","category":"Classes","library":"ribs_http","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_http_ribs_http/Request.md","filePath":"api/package-ribs_http_ribs_http/Request.md"}');
const _sfc_main = { name: "api/package-ribs_http_ribs_http/Request.md" };
const _hoisted_1 = {
  id: "request",
  tabindex: "-1"
};
const _hoisted_2 = {
  id: "ctor-request",
  tabindex: "-1"
};
const _hoisted_3 = {
  id: "delete",
  tabindex: "-1"
};
const _hoisted_4 = {
  id: "get",
  tabindex: "-1"
};
const _hoisted_5 = {
  id: "post",
  tabindex: "-1"
};
const _hoisted_6 = {
  id: "put",
  tabindex: "-1"
};
const _hoisted_7 = {
  id: "prop-body",
  tabindex: "-1"
};
const _hoisted_8 = {
  id: "prop-bodytext",
  tabindex: "-1"
};
const _hoisted_9 = {
  id: "prop-contenttype",
  tabindex: "-1"
};
const _hoisted_10 = {
  id: "prop-hashcode",
  tabindex: "-1"
};
const _hoisted_11 = {
  id: "prop-headers",
  tabindex: "-1"
};
const _hoisted_12 = {
  id: "prop-method",
  tabindex: "-1"
};
const _hoisted_13 = {
  id: "prop-runtimetype",
  tabindex: "-1"
};
const _hoisted_14 = {
  id: "prop-uri",
  tabindex: "-1"
};
const _hoisted_15 = {
  id: "prop-version",
  tabindex: "-1"
};
const _hoisted_16 = {
  id: "attemptas",
  tabindex: "-1"
};
const _hoisted_17 = {
  id: "nosuchmethod",
  tabindex: "-1"
};
const _hoisted_18 = {
  id: "tostring",
  tabindex: "-1"
};
const _hoisted_19 = {
  id: "operator-equals",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    createBaseVNode("h1", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("Request ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "final"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#request",
        "aria-label": 'Permalink to "Request <Badge type="info" text="final" />"'
      }, "​", -1))
    ]),
    _cache[64] || (_cache[64] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="kw">class</span> <span class="fn">Request</span> <span class="kw">extends</span> <a href="./Message" class="type-link">Message</a></code></pre></div><div class="info custom-block"><p class="custom-block-title">Inheritance</p><p>Object → <a href="/ribs/api/package-ribs_http_ribs_http/Media.html">Media</a> → <a href="/ribs/api/package-ribs_http_ribs_http/Message.html">Message</a> → <strong>Request</strong></p></div><h2 id="section-constructors" tabindex="-1">Constructors <a class="header-anchor" href="#section-constructors" aria-label="Permalink to &quot;Constructors {#section-constructors}&quot;">​</a></h2>', 3)),
    createBaseVNode("h3", _hoisted_2, [
      _cache[3] || (_cache[3] = createTextVNode("Request() ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "const"
      }),
      _cache[4] || (_cache[4] = createTextVNode()),
      _cache[5] || (_cache[5] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#ctor-request",
        "aria-label": 'Permalink to "Request() <Badge type="tip" text="const" /> {#ctor-request}"'
      }, "​", -1))
    ]),
    _cache[65] || (_cache[65] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">const</span> <span class="fn">Request</span>({\n  <a href="./Method" class="type-link">Method</a> <span class="param">method</span> = Method.GET,\n  <span class="kw">required</span> <span class="type">Uri</span> <span class="param">uri</span>,\n  <a href="./Headers" class="type-link">Headers</a> <span class="param">headers</span> = Headers.empty,\n  <a href="./HttpVersion" class="type-link">HttpVersion</a> <span class="param">version</span> = HttpVersion.Http1_1,\n  <a href="./EntityBody" class="type-link">EntityBody</a> <span class="param">body</span> = EntityBody.Empty,\n})</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Request</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">({</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.method </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Method</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">GET</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  required</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.uri,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  super</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.headers,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  super</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.version,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  super</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.body,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">});</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_3, [
      _cache[6] || (_cache[6] = createTextVNode("Request.delete() ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "factory"
      }),
      _cache[7] || (_cache[7] = createTextVNode()),
      _cache[8] || (_cache[8] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#delete",
        "aria-label": 'Permalink to "Request.delete() <Badge type="tip" text="factory" /> {#delete}"'
      }, "​", -1))
    ]),
    _cache[66] || (_cache[66] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">factory</span> <span class="fn">Request.delete</span>(<span class="type">Uri</span> <span class="param">uri</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">factory</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Request</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">delete</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Uri</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> uri) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Request</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(method</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Method</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">DELETE</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, uri</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> uri);</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_4, [
      _cache[9] || (_cache[9] = createTextVNode("Request.get() ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "factory"
      }),
      _cache[10] || (_cache[10] = createTextVNode()),
      _cache[11] || (_cache[11] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#get",
        "aria-label": 'Permalink to "Request.get() <Badge type="tip" text="factory" /> {#get}"'
      }, "​", -1))
    ]),
    _cache[67] || (_cache[67] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">factory</span> <span class="fn">Request.get</span>(<span class="type">Uri</span> <span class="param">uri</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">factory</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Request</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Uri</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> uri) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Request</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(uri</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> uri);</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_5, [
      _cache[12] || (_cache[12] = createTextVNode("Request.post() ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "factory"
      }),
      _cache[13] || (_cache[13] = createTextVNode()),
      _cache[14] || (_cache[14] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#post",
        "aria-label": 'Permalink to "Request.post() <Badge type="tip" text="factory" /> {#post}"'
      }, "​", -1))
    ]),
    _cache[68] || (_cache[68] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">factory</span> <span class="fn">Request.post</span>(<span class="type">Uri</span> <span class="param">uri</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">factory</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Request</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">post</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Uri</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> uri) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Request</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(method</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Method</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">POST</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, uri</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> uri);</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_6, [
      _cache[15] || (_cache[15] = createTextVNode("Request.put() ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "factory"
      }),
      _cache[16] || (_cache[16] = createTextVNode()),
      _cache[17] || (_cache[17] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#put",
        "aria-label": 'Permalink to "Request.put() <Badge type="tip" text="factory" /> {#put}"'
      }, "​", -1))
    ]),
    _cache[69] || (_cache[69] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">factory</span> <span class="fn">Request.put</span>(<span class="type">Uri</span> <span class="param">uri</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">factory</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Request</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">put</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Uri</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> uri) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Request</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(method</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Method</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">PUT</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, uri</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> uri);</span></span></code></pre></div></details><h2 id="section-properties" tabindex="-1">Properties <a class="header-anchor" href="#section-properties" aria-label="Permalink to &quot;Properties {#section-properties}&quot;">​</a></h2>', 3)),
    createBaseVNode("h3", _hoisted_7, [
      _cache[18] || (_cache[18] = createTextVNode("body ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[19] || (_cache[19] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[20] || (_cache[20] = createTextVNode()),
      _cache[21] || (_cache[21] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-body",
        "aria-label": 'Permalink to "body <Badge type="tip" text="final" /> <Badge type="info" text="inherited" /> {#prop-body}"'
      }, "​", -1))
    ]),
    _cache[70] || (_cache[70] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <a href="./EntityBody" class="type-link">EntityBody</a> <span class="fn">body</span></code></pre></div><p><em>Inherited from Media.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> EntityBody</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> body;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_8, [
      _cache[22] || (_cache[22] = createTextVNode("bodyText ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[23] || (_cache[23] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[24] || (_cache[24] = createTextVNode()),
      _cache[25] || (_cache[25] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-bodytext",
        "aria-label": 'Permalink to "bodyText <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-bodytext}"'
      }, "​", -1))
    ]),
    _cache[71] || (_cache[71] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">Stream</span>&lt;<span class="type">String</span>&gt; <span class="kw">get</span> <span class="fn">bodyText</span></code></pre></div><p><em>Inherited from Media.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Stream</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> bodyText </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> body.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">map</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(utf8.decode);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_9, [
      _cache[26] || (_cache[26] = createTextVNode("contentType ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[27] || (_cache[27] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[28] || (_cache[28] = createTextVNode()),
      _cache[29] || (_cache[29] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-contenttype",
        "aria-label": 'Permalink to "contentType <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-contenttype}"'
      }, "​", -1))
    ]),
    _cache[72] || (_cache[72] = createStaticVNode('<div class="member-signature"><pre><code><a href="../package-ribs_core_ribs_core/Option" class="type-link">Option</a>&lt;<a href="./ContentType" class="type-link">ContentType</a>&gt; <span class="kw">get</span> <span class="fn">contentType</span></code></pre></div><p><em>Inherited from Media.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">ContentType</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> contentType </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    headers.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;Content-Type&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">flatMap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((nel) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> ContentType</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">parse</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(nel.head.value));</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_10, [
      _cache[30] || (_cache[30] = createTextVNode("hashCode ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[31] || (_cache[31] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[32] || (_cache[32] = createTextVNode()),
      _cache[33] || (_cache[33] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-hashcode",
        "aria-label": 'Permalink to "hashCode <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-hashcode}"'
      }, "​", -1))
    ]),
    _cache[73] || (_cache[73] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></code></pre></div><p>The hash code for this object.</p><p>A hash code is a single integer which represents the state of the object that affects <a href="/ribs/api/package-ribs_http_ribs_http/Request.html#operator-equals">operator ==</a> comparisons.</p><p>All objects have hash codes. The default hash code implemented by <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object-class.html" target="_blank" rel="noreferrer">Object</a> represents only the identity of the object, the same way as the default <a href="/ribs/api/package-ribs_http_ribs_http/Request.html#operator-equals">operator ==</a> implementation only considers objects equal if they are identical (see <a href="https://api.dart.dev/stable/3.11.4/dart-core/identityHashCode.html" target="_blank" rel="noreferrer">identityHashCode</a>).</p><p>If <a href="/ribs/api/package-ribs_http_ribs_http/Request.html#operator-equals">operator ==</a> is overridden to use the object state instead, the hash code must also be changed to represent that state, otherwise the object cannot be used in hash based data structures like the default <a href="https://api.dart.dev/stable/3.11.4/dart-core/Set-class.html" target="_blank" rel="noreferrer">Set</a> and <a href="https://api.dart.dev/stable/3.11.4/dart-core/Map-class.html" target="_blank" rel="noreferrer">Map</a> implementations.</p><p>Hash codes must be the same for objects that are equal to each other according to <a href="/ribs/api/package-ribs_http_ribs_http/Request.html#operator-equals">operator ==</a>. The hash code of an object should only change if the object changes in a way that affects equality. There are no further requirements for the hash codes. They need not be consistent between executions of the same program and there are no distribution guarantees.</p><p>Objects that are not equal are allowed to have the same hash code. It is even technically allowed that all instances have the same hash code, but if clashes happen too often, it may reduce the efficiency of hash-based data structures like <a href="https://api.dart.dev/stable/3.11.4/dart-collection/HashSet-class.html" target="_blank" rel="noreferrer">HashSet</a> or <a href="https://api.dart.dev/stable/3.11.4/dart-collection/HashMap-class.html" target="_blank" rel="noreferrer">HashMap</a>.</p><p>If a subclass overrides <a href="/ribs/api/package-ribs_http_ribs_http/Request.html#prop-hashcode">hashCode</a>, it should override the <a href="/ribs/api/package-ribs_http_ribs_http/Request.html#operator-equals">operator ==</a> operator as well to maintain consistency.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> hashCode;</span></span></code></pre></div></details>', 10)),
    createBaseVNode("h3", _hoisted_11, [
      _cache[34] || (_cache[34] = createTextVNode("headers ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[35] || (_cache[35] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[36] || (_cache[36] = createTextVNode()),
      _cache[37] || (_cache[37] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-headers",
        "aria-label": 'Permalink to "headers <Badge type="tip" text="final" /> <Badge type="info" text="inherited" /> {#prop-headers}"'
      }, "​", -1))
    ]),
    _cache[74] || (_cache[74] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <a href="./Headers" class="type-link">Headers</a> <span class="fn">headers</span></code></pre></div><p><em>Inherited from Media.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Headers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> headers;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_12, [
      _cache[38] || (_cache[38] = createTextVNode("method ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[39] || (_cache[39] = createTextVNode()),
      _cache[40] || (_cache[40] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-method",
        "aria-label": 'Permalink to "method <Badge type="tip" text="final" /> {#prop-method}"'
      }, "​", -1))
    ]),
    _cache[75] || (_cache[75] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <a href="./Method" class="type-link">Method</a> <span class="fn">method</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Method</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> method;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_13, [
      _cache[41] || (_cache[41] = createTextVNode("runtimeType ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[42] || (_cache[42] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[43] || (_cache[43] = createTextVNode()),
      _cache[44] || (_cache[44] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-runtimetype",
        "aria-label": 'Permalink to "runtimeType <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-runtimetype}"'
      }, "​", -1))
    ]),
    _cache[76] || (_cache[76] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">Type</span> <span class="kw">get</span> <span class="fn">runtimeType</span></code></pre></div><p>A representation of the runtime type of the object.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Type</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> runtimeType;</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_14, [
      _cache[45] || (_cache[45] = createTextVNode("uri ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[46] || (_cache[46] = createTextVNode()),
      _cache[47] || (_cache[47] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-uri",
        "aria-label": 'Permalink to "uri <Badge type="tip" text="final" /> {#prop-uri}"'
      }, "​", -1))
    ]),
    _cache[77] || (_cache[77] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="type">Uri</span> <span class="fn">uri</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Uri</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> uri;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_15, [
      _cache[48] || (_cache[48] = createTextVNode("version ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[49] || (_cache[49] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[50] || (_cache[50] = createTextVNode()),
      _cache[51] || (_cache[51] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-version",
        "aria-label": 'Permalink to "version <Badge type="tip" text="final" /> <Badge type="info" text="inherited" /> {#prop-version}"'
      }, "​", -1))
    ]),
    _cache[78] || (_cache[78] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <a href="./HttpVersion" class="type-link">HttpVersion</a> <span class="fn">version</span></code></pre></div><p><em>Inherited from Message.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> HttpVersion</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> version;</span></span></code></pre></div></details><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2><h3 id="addheader" tabindex="-1">addHeader() <a class="header-anchor" href="#addheader" aria-label="Permalink to &quot;addHeader() {#addheader}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Request" class="type-link">Request</a> <span class="fn">addHeader</span>(<a href="./Header" class="type-link">Header</a> <span class="param">header</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Request</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> addHeader</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Header</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> header) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> transformHeaders</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((h) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> h.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">add</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(header));</span></span></code></pre></div></details>', 7)),
    createBaseVNode("h3", _hoisted_16, [
      _cache[52] || (_cache[52] = createTextVNode("attemptAs() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[53] || (_cache[53] = createTextVNode()),
      _cache[54] || (_cache[54] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#attemptas",
        "aria-label": 'Permalink to "attemptAs() <Badge type="info" text="inherited" /> {#attemptas}"'
      }, "​", -1))
    ]),
    _cache[79] || (_cache[79] = createStaticVNode('<div class="member-signature"><pre><code><a href="../package-ribs_effect_ribs_effect/IO" class="type-link">IO</a>&lt;<a href="../package-ribs_core_ribs_core/Either" class="type-link">DecodeResult</a>&lt;<a href="./DecodeFailure" class="type-link">DecodeFailure</a>, <span class="type">A</span>&gt;&gt; <span class="fn">attemptAs&lt;A&gt;</span>(<a href="./EntityDecoder" class="type-link">EntityDecoder</a>&lt;<span class="type">A</span>&gt; <span class="param">decoder</span>)</code></pre></div><p><em>Inherited from Media.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">DecodeResult</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">attemptAs</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">EntityDecoder</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; decoder) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> decoder.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">decode</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">false</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details><h3 id="copy" tabindex="-1">copy() <a class="header-anchor" href="#copy" aria-label="Permalink to &quot;copy() {#copy}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Request" class="type-link">Request</a> <span class="fn">copy</span>({\n  <a href="./Method" class="type-link">Method</a>? <span class="param">method</span>,\n  <span class="type">Uri</span>? <span class="param">uri</span>,\n  <a href="./Headers" class="type-link">Headers</a>? <span class="param">headers</span>,\n  <a href="./HttpVersion" class="type-link">HttpVersion</a>? <span class="param">version</span>,\n  <a href="./EntityBody" class="type-link">EntityBody</a>? <span class="param">body</span>,\n})</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Request</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> copy</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">({</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  Method</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> method,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  Uri</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> uri,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  Headers</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> headers,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  HttpVersion</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> version,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  EntityBody</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> body,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Request</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  method</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> method </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.method,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  uri</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> uri </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.uri,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  headers</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> headers </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.headers,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  version</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> version </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.version,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  body</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> body </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.body,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details><h3 id="filterheaders" tabindex="-1">filterHeaders() <a class="header-anchor" href="#filterheaders" aria-label="Permalink to &quot;filterHeaders() {#filterheaders}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Request" class="type-link">Request</a> <span class="fn">filterHeaders</span>(<span class="type">bool</span> <span class="type">Function</span>(<a href="./Header" class="type-link">Header</a>) <span class="param">p</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Request</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> filterHeaders</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Header</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; p) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    transformHeaders</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((h) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> h.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">transform</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> a.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">filter</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(p)));</span></span></code></pre></div></details>', 9)),
    createBaseVNode("h3", _hoisted_17, [
      _cache[55] || (_cache[55] = createTextVNode("noSuchMethod() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[56] || (_cache[56] = createTextVNode()),
      _cache[57] || (_cache[57] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#nosuchmethod",
        "aria-label": 'Permalink to "noSuchMethod() <Badge type="info" text="inherited" /> {#nosuchmethod}"'
      }, "​", -1))
    ]),
    _cache[80] || (_cache[80] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">dynamic</span> <span class="fn">noSuchMethod</span>(<span class="type">Invocation</span> <span class="param">invocation</span>)</code></pre></div><p>Invoked when a nonexistent method or property is accessed.</p><p>A dynamic member invocation can attempt to call a member which doesn&#39;t exist on the receiving object. Example:</p><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">dynamic</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> object </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">object.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">add</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">42</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">); </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">// Statically allowed, run-time error</span></span></code></pre></div><p>This invalid code will invoke the <code>noSuchMethod</code> method of the integer <code>1</code> with an <a href="https://api.dart.dev/stable/3.11.4/dart-core/Invocation-class.html" target="_blank" rel="noreferrer">Invocation</a> representing the <code>.add(42)</code> call and arguments (which then throws).</p><p>Classes can override <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object/noSuchMethod.html" target="_blank" rel="noreferrer">noSuchMethod</a> to provide custom behavior for such invalid dynamic invocations.</p><p>A class with a non-default <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object/noSuchMethod.html" target="_blank" rel="noreferrer">noSuchMethod</a> invocation can also omit implementations for members of its interface. Example:</p><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">class</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MockList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">implements</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> List</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; {</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">  noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Invocation</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> invocation) {</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    log</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(invocation);</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    super</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(invocation); </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">// Will throw.</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  }</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">void</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> main</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() {</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  MockList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">().</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">add</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">42</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div><p>This code has no compile-time warnings or errors even though the <code>MockList</code> class has no concrete implementation of any of the <code>List</code> interface methods. Calls to <code>List</code> methods are forwarded to <code>noSuchMethod</code>, so this code will <code>log</code> an invocation similar to <code>Invocation.method(#add, [42])</code> and then throw.</p><p>If a value is returned from <code>noSuchMethod</code>, it becomes the result of the original invocation. If the value is not of a type that can be returned by the original invocation, a type error occurs at the invocation.</p><p>The default behavior is to throw a <a href="https://api.dart.dev/stable/3.11.4/dart-core/NoSuchMethodError-class.html" target="_blank" rel="noreferrer">NoSuchMethodError</a>.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@pragma</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;vm:entry-point&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@pragma</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;wasm:entry-point&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> dynamic</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Invocation</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> invocation);</span></span></code></pre></div></details><h3 id="putheader" tabindex="-1">putHeader() <a class="header-anchor" href="#putheader" aria-label="Permalink to &quot;putHeader() {#putheader}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Request" class="type-link">Request</a> <span class="fn">putHeader</span>(<a href="./Header" class="type-link">Header</a> <span class="param">header</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Request</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> putHeader</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Header</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> header) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> transformHeaders</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((h) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> h.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">put</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(header));</span></span></code></pre></div></details><h3 id="removeheader" tabindex="-1">removeHeader() <a class="header-anchor" href="#removeheader" aria-label="Permalink to &quot;removeHeader() {#removeheader}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Request" class="type-link">Request</a> <span class="fn">removeHeader</span>(<a href="./CIString" class="type-link">CIString</a> <span class="param">key</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Request</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> removeHeader</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">CIString</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> key) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    transformHeaders</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((h) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> h.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">transform</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((l) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> l.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">filterNot</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((hdrs) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> hdrs.name </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> key)));</span></span></code></pre></div></details>', 19)),
    createBaseVNode("h3", _hoisted_18, [
      _cache[58] || (_cache[58] = createTextVNode("toString() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "override"
      }),
      _cache[59] || (_cache[59] = createTextVNode()),
      _cache[60] || (_cache[60] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#tostring",
        "aria-label": 'Permalink to "toString() <Badge type="info" text="override" /> {#tostring}"'
      }, "​", -1))
    ]),
    _cache[81] || (_cache[81] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">String</span> <span class="fn">toString</span>()</code></pre></div><p>A string representation of this object.</p><p>Some classes have a default textual representation, often paired with a static <code>parse</code> function (like <a href="https://api.dart.dev/stable/3.11.4/dart-core/int/parse.html" target="_blank" rel="noreferrer">int.parse</a>). These classes will provide the textual representation as their string representation.</p><p>Other classes have no meaningful textual representation that a program will care about. Such classes will typically override <code>toString</code> to provide useful information when inspecting the object, mainly for debugging or logging.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> toString</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">    &#39;Request(method=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">$</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">method</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">, uri=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">$</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">uri</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">, httpVersion=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">$</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">version</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">, headers=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">${</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">headers</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">redactSensitive</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">()}</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">, entity=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">$</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">body</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">)&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span></code></pre></div></details><h3 id="transformheaders" tabindex="-1">transformHeaders() <a class="header-anchor" href="#transformheaders" aria-label="Permalink to &quot;transformHeaders() {#transformheaders}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Request" class="type-link">Request</a> <span class="fn">transformHeaders</span>(<a href="./Headers" class="type-link">Headers</a> <span class="type">Function</span>(<a href="./Headers" class="type-link">Headers</a>) <span class="param">f</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Request</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> transformHeaders</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Headers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Headers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; f) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> copy</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(headers</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> f</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(headers));</span></span></code></pre></div></details><h3 id="withbody" tabindex="-1">withBody() <a class="header-anchor" href="#withbody" aria-label="Permalink to &quot;withBody() {#withbody}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Request" class="type-link">Request</a> <span class="fn">withBody</span>(<a href="./EntityBody" class="type-link">EntityBody</a> <span class="param">body</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Request</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> withBody</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">EntityBody</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> body) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> copy</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(body</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> body);</span></span></code></pre></div></details><h3 id="withemptybody" tabindex="-1">withEmptyBody() <a class="header-anchor" href="#withemptybody" aria-label="Permalink to &quot;withEmptyBody() {#withemptybody}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Request" class="type-link">Request</a> <span class="fn">withEmptyBody</span>()</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Request</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> withEmptyBody</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> withBody</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">EntityBody</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Empty</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details><h3 id="withheaders" tabindex="-1">withHeaders() <a class="header-anchor" href="#withheaders" aria-label="Permalink to &quot;withHeaders() {#withheaders}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Request" class="type-link">Request</a> <span class="fn">withHeaders</span>(<a href="./Headers" class="type-link">Headers</a> <span class="param">headers</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Request</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> withHeaders</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Headers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> headers) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> copy</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(headers</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> headers);</span></span></code></pre></div></details><h3 id="withmethod" tabindex="-1">withMethod() <a class="header-anchor" href="#withmethod" aria-label="Permalink to &quot;withMethod() {#withmethod}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Request" class="type-link">Request</a> <span class="fn">withMethod</span>(<a href="./Method" class="type-link">Method</a> <span class="param">method</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Request</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> withMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Method</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> method) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> copy</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(method</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> method);</span></span></code></pre></div></details><h3 id="withuri" tabindex="-1">withUri() <a class="header-anchor" href="#withuri" aria-label="Permalink to &quot;withUri() {#withuri}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Request" class="type-link">Request</a> <span class="fn">withUri</span>(<span class="type">Uri</span> <span class="param">uri</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Request</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> withUri</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Uri</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> uri) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> copy</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(uri</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> uri);</span></span></code></pre></div></details><h3 id="withversion" tabindex="-1">withVersion() <a class="header-anchor" href="#withversion" aria-label="Permalink to &quot;withVersion() {#withversion}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Request" class="type-link">Request</a> <span class="fn">withVersion</span>(<a href="./HttpVersion" class="type-link">HttpVersion</a> <span class="param">version</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Request</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> withVersion</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">HttpVersion</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> version) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> copy</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(version</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> version);</span></span></code></pre></div></details><h2 id="section-operators" tabindex="-1">Operators <a class="header-anchor" href="#section-operators" aria-label="Permalink to &quot;Operators {#section-operators}&quot;">​</a></h2>', 27)),
    createBaseVNode("h3", _hoisted_19, [
      _cache[61] || (_cache[61] = createTextVNode("operator ==() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[62] || (_cache[62] = createTextVNode()),
      _cache[63] || (_cache[63] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#operator-equals",
        "aria-label": 'Permalink to "operator ==() <Badge type="info" text="inherited" /> {#operator-equals}"'
      }, "​", -1))
    ]),
    _cache[82] || (_cache[82] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator ==</span>(<span class="type">Object</span> <span class="param">other</span>)</code></pre></div><p>The equality operator.</p><p>The default behavior for all <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object-class.html" target="_blank" rel="noreferrer">Object</a>s is to return true if and only if this object and <code>other</code> are the same object.</p><p>Override this method to specify a different equality relation on a class. The overriding method must still be an equivalence relation. That is, it must be:</p><ul><li><p>Total: It must return a boolean for all arguments. It should never throw.</p></li><li><p>Reflexive: For all objects <code>o</code>, <code>o == o</code> must be true.</p></li><li><p>Symmetric: For all objects <code>o1</code> and <code>o2</code>, <code>o1 == o2</code> and <code>o2 == o1</code> must either both be true, or both be false.</p></li><li><p>Transitive: For all objects <code>o1</code>, <code>o2</code>, and <code>o3</code>, if <code>o1 == o2</code> and <code>o2 == o3</code> are true, then <code>o1 == o3</code> must be true.</p></li></ul><p>The method should also be consistent over time, so whether two objects are equal should only change if at least one of the objects was modified.</p><p>If a subclass overrides the equality operator, it should override the <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object/hashCode.html" target="_blank" rel="noreferrer">hashCode</a> method as well to maintain consistency.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> ==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Object</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other);</span></span></code></pre></div></details>', 9))
  ]);
}
const Request = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  Request as default
};
