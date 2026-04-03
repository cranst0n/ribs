import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.CoQcG2_y.js";
const __pageData = JSON.parse('{"title":"Path","description":"API documentation for Path extension type from ribs_rill_io","frontmatter":{"title":"Path","description":"API documentation for Path extension type from ribs_rill_io","category":"Extension Types","library":"ribs_rill_io","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_rill_io_ribs_rill_io/Path.md","filePath":"api/package-ribs_rill_io_ribs_rill_io/Path.md"}');
const _sfc_main = { name: "api/package-ribs_rill_io_ribs_rill_io/Path.md" };
const _hoisted_1 = {
  id: "prop-absolute",
  tabindex: "-1"
};
const _hoisted_2 = {
  id: "prop-extension",
  tabindex: "-1"
};
const _hoisted_3 = {
  id: "prop-filename",
  tabindex: "-1"
};
const _hoisted_4 = {
  id: "prop-isabsolute",
  tabindex: "-1"
};
const _hoisted_5 = {
  id: "prop-names",
  tabindex: "-1"
};
const _hoisted_6 = {
  id: "prop-normalize",
  tabindex: "-1"
};
const _hoisted_7 = {
  id: "prop-parent",
  tabindex: "-1"
};
const _hoisted_8 = {
  id: "prop-current",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[24] || (_cache[24] = createStaticVNode('<h1 id="path" tabindex="-1">Path <a class="header-anchor" href="#path" aria-label="Permalink to &quot;Path&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension type</span> <span class="fn">Path</span>(<span class="type">String</span>)</code></pre></div><p>A cross-platform filesystem path.</p><p><a href="/ribs/api/package-ribs_rill_io_ribs_rill_io/Path.html">Path</a> wraps a <a href="https://api.dart.dev/stable/3.11.4/dart-core/String-class.html" target="_blank" rel="noreferrer">String</a> and delegates to the <code>path</code> package for platform-aware joining, normalization, and decomposition. All operations that combine or resolve paths produce normalized results.</p><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> config </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Path</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;/etc&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">/</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;app&#39;</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> /</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;config.yaml&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">print</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(config);           </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">// /etc/app/config.yaml</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">print</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(config.fileName);  </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">// config.yaml</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">print</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(config.</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">extension</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">); </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">// .yaml</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">print</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(config.parent);    </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">// Some(/etc/app)</span></span></code></pre></div><h2 id="section-constructors" tabindex="-1">Constructors <a class="header-anchor" href="#section-constructors" aria-label="Permalink to &quot;Constructors {#section-constructors}&quot;">​</a></h2><h3 id="ctor-path" tabindex="-1">Path() <a class="header-anchor" href="#ctor-path" aria-label="Permalink to &quot;Path() {#ctor-path}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="fn">Path</span>(<span class="type">String</span> <span class="param">_repr</span>)</code></pre></div><h2 id="section-properties" tabindex="-1">Properties <a class="header-anchor" href="#section-properties" aria-label="Permalink to &quot;Properties {#section-properties}&quot;">​</a></h2>', 9)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("absolute ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-absolute",
        "aria-label": 'Permalink to "absolute <Badge type="tip" text="no setter" /> {#prop-absolute}"'
      }, "​", -1))
    ]),
    _cache[25] || (_cache[25] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Path" class="type-link">Path</a> <span class="kw">get</span> <span class="fn">absolute</span></code></pre></div><p>Returns the absolute form of this path, resolved against the current working directory if it is relative.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Path</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> absolute </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Path</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(p.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">absolute</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(_repr));</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_2, [
      _cache[3] || (_cache[3] = createTextVNode("extension ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[4] || (_cache[4] = createTextVNode()),
      _cache[5] || (_cache[5] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-extension",
        "aria-label": 'Permalink to "extension <Badge type="tip" text="no setter" /> {#prop-extension}"'
      }, "​", -1))
    ]),
    _cache[26] || (_cache[26] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">String</span> <span class="kw">get</span> <span class="fn">extension</span></code></pre></div><p>The file extension of this path, including the leading dot (e.g. <code>&#39;.dart&#39;</code>). Returns an empty string if there is no extension.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> extension</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> =&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> p.</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">extension</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(_repr);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_3, [
      _cache[6] || (_cache[6] = createTextVNode("fileName ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[7] || (_cache[7] = createTextVNode()),
      _cache[8] || (_cache[8] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-filename",
        "aria-label": 'Permalink to "fileName <Badge type="tip" text="no setter" /> {#prop-filename}"'
      }, "​", -1))
    ]),
    _cache[27] || (_cache[27] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Path" class="type-link">Path</a> <span class="kw">get</span> <span class="fn">fileName</span></code></pre></div><p>The final component of this path (the file or directory name).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Path</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> fileName </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Path</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(p.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">basename</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(_repr));</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_4, [
      _cache[9] || (_cache[9] = createTextVNode("isAbsolute ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[10] || (_cache[10] = createTextVNode()),
      _cache[11] || (_cache[11] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-isabsolute",
        "aria-label": 'Permalink to "isAbsolute <Badge type="tip" text="no setter" /> {#prop-isabsolute}"'
      }, "​", -1))
    ]),
    _cache[28] || (_cache[28] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isAbsolute</span></code></pre></div><p>Whether this path is absolute.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> isAbsolute </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> p.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">isAbsolute</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(_repr);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_5, [
      _cache[12] || (_cache[12] = createTextVNode("names ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[13] || (_cache[13] = createTextVNode()),
      _cache[14] || (_cache[14] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-names",
        "aria-label": 'Permalink to "names <Badge type="tip" text="no setter" /> {#prop-names}"'
      }, "​", -1))
    ]),
    _cache[29] || (_cache[29] = createStaticVNode('<div class="member-signature"><pre><code><a href="../package-ribs_core_ribs_core/IList" class="type-link">IList</a>&lt;<a href="./Path" class="type-link">Path</a>&gt; <span class="kw">get</span> <span class="fn">names</span></code></pre></div><p>Splits this path into its individual components.</p><p>For example, <code>Path(&#39;/home/user/file.txt&#39;).names</code> yields <code>[&#39;/&#39;, &#39;home&#39;, &#39;user&#39;, &#39;file.txt&#39;]</code>.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Path</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> names </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> p.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">split</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(_repr).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">map</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((p) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Path</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(p)).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">toIList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">();</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_6, [
      _cache[15] || (_cache[15] = createTextVNode("normalize ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[16] || (_cache[16] = createTextVNode()),
      _cache[17] || (_cache[17] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-normalize",
        "aria-label": 'Permalink to "normalize <Badge type="tip" text="no setter" /> {#prop-normalize}"'
      }, "​", -1))
    ]),
    _cache[30] || (_cache[30] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Path" class="type-link">Path</a> <span class="kw">get</span> <span class="fn">normalize</span></code></pre></div><p>Returns a normalized copy of this path, resolving <code>.</code> and <code>..</code> segments and removing redundant separators.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Path</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> normalize </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Path</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(p.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">normalize</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(_repr));</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_7, [
      _cache[18] || (_cache[18] = createTextVNode("parent ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[19] || (_cache[19] = createTextVNode()),
      _cache[20] || (_cache[20] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-parent",
        "aria-label": 'Permalink to "parent <Badge type="tip" text="no setter" /> {#prop-parent}"'
      }, "​", -1))
    ]),
    _cache[31] || (_cache[31] = createStaticVNode('<div class="member-signature"><pre><code><a href="../package-ribs_core_ribs_core/Option" class="type-link">Option</a>&lt;<a href="./Path" class="type-link">Path</a>&gt; <span class="kw">get</span> <span class="fn">parent</span></code></pre></div><p>The parent directory of this path, or <a href="/ribs/api/package-ribs_core_ribs_core/None.html">None</a> if this path is already a root (e.g. <code>&#39;/&#39;</code> or <code>&#39;C:\\&#39;</code>).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Path</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> parent </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Some</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Path</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(p.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">dirname</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(_repr))).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">filter</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((p) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> p._repr </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">!=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> _repr);</span></span></code></pre></div></details><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2><h3 id="relativize" tabindex="-1">relativize() <a class="header-anchor" href="#relativize" aria-label="Permalink to &quot;relativize() {#relativize}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Path" class="type-link">Path</a> <span class="fn">relativize</span>(<a href="./Path" class="type-link">Path</a> <span class="param">path</span>)</code></pre></div><p>Computes the relative path from this directory to <code>path</code>.</p><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Path</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;/home/user&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">relativize</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Path</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;/home/user/docs/readme.md&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">))</span></span>\n<span class="line"><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">// =&gt; docs/readme.md</span></span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Path</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> relativize</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Path</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> path) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Path</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(p.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">relative</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(path._repr, from</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> _repr));</span></span></code></pre></div></details><h2 id="section-operators" tabindex="-1">Operators <a class="header-anchor" href="#section-operators" aria-label="Permalink to &quot;Operators {#section-operators}&quot;">​</a></h2><h3 id="operator-plus" tabindex="-1">operator +() <a class="header-anchor" href="#operator-plus" aria-label="Permalink to &quot;operator +() {#operator-plus}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Path" class="type-link">Path</a> <span class="fn">operator +</span>(<a href="./Path" class="type-link">Path</a> <span class="param">path</span>)</code></pre></div><p>Joins this path with <code>path</code>, returning a normalized result.</p><p>Equivalent to <a href="https://pub.dev/documentation/path/1.9.1/path/join.html" target="_blank" rel="noreferrer">p.join</a> followed by <a href="/ribs/api/package-ribs_rill_io_ribs_rill_io/Path.html#prop-normalize">normalize</a>.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Path</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> +</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Path</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> path) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Path</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(p.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">join</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(_repr, path._repr)).normalize;</span></span></code></pre></div></details><h3 id="operator-divide" tabindex="-1">operator /() <a class="header-anchor" href="#operator-divide" aria-label="Permalink to &quot;operator /() {#operator-divide}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Path" class="type-link">Path</a> <span class="fn">operator /</span>(<span class="type">String</span> <span class="param">name</span>)</code></pre></div><p>Appends a single path segment <code>name</code> to this path, returning a normalized result.</p><p>This is a convenient shorthand for joining with a literal string:</p><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Path</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;/home&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">/</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;user&#39;</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> /</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;docs&#39;</span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">  // /home/user/docs</span></span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Path</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> &amp;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">#</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">47</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> name) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Path</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(p.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">join</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(_repr, name)).normalize;</span></span></code></pre></div></details><h2 id="section-static-properties" tabindex="-1">Static Properties <a class="header-anchor" href="#section-static-properties" aria-label="Permalink to &quot;Static Properties {#section-static-properties}&quot;">​</a></h2>', 22)),
    createBaseVNode("h3", _hoisted_8, [
      _cache[21] || (_cache[21] = createTextVNode("current ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[22] || (_cache[22] = createTextVNode()),
      _cache[23] || (_cache[23] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-current",
        "aria-label": 'Permalink to "current <Badge type="tip" text="no setter" /> {#prop-current}"'
      }, "​", -1))
    ]),
    _cache[32] || (_cache[32] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Path" class="type-link">Path</a> <span class="kw">get</span> <span class="fn">current</span></code></pre></div><p>The current working directory of the process.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Path</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> current </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Path</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(p.current);</span></span></code></pre></div></details>', 3))
  ]);
}
const Path = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  Path as default
};
