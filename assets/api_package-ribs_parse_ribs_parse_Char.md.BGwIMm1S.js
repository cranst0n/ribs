import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.CNYu8dAD.js";
const __pageData = JSON.parse('{"title":"Char","description":"API documentation for Char extension type from ribs_parse","frontmatter":{"title":"Char","description":"API documentation for Char extension type from ribs_parse","category":"Extension Types","library":"ribs_parse","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_parse_ribs_parse/Char.md","filePath":"api/package-ribs_parse_ribs_parse/Char.md"}');
const _sfc_main = { name: "api/package-ribs_parse_ribs_parse/Char.md" };
const _hoisted_1 = {
  id: "checked",
  tabindex: "-1"
};
const _hoisted_2 = {
  id: "fromstring",
  tabindex: "-1"
};
const _hoisted_3 = {
  id: "prop-asstring",
  tabindex: "-1"
};
const _hoisted_4 = {
  id: "prop-codeunit",
  tabindex: "-1"
};
const _hoisted_5 = {
  id: "prop-isascii",
  tabindex: "-1"
};
const _hoisted_6 = {
  id: "prop-isdigit",
  tabindex: "-1"
};
const _hoisted_7 = {
  id: "prop-isletter",
  tabindex: "-1"
};
const _hoisted_8 = {
  id: "prop-islowercase",
  tabindex: "-1"
};
const _hoisted_9 = {
  id: "prop-isuppercase",
  tabindex: "-1"
};
const _hoisted_10 = {
  id: "prop-iswhitespace",
  tabindex: "-1"
};
const _hoisted_11 = {
  id: "prop-tolowecase",
  tabindex: "-1"
};
const _hoisted_12 = {
  id: "prop-touppercase",
  tabindex: "-1"
};
const _hoisted_13 = {
  id: "prop-maxvalue",
  tabindex: "-1"
};
const _hoisted_14 = {
  id: "prop-minvalue",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[42] || (_cache[42] = createStaticVNode('<h1 id="char" tabindex="-1">Char <a class="header-anchor" href="#char" aria-label="Permalink to &quot;Char&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension type</span> <span class="fn">Char</span>(<span class="type">int</span>)</code></pre></div><p>A single UTF-16 code unit, represented as a zero-cost extension type over <a href="https://api.dart.dev/stable/3.11.5/dart-core/int-class.html" target="_blank" rel="noreferrer">int</a>.</p><p>Parsers that inspect individual characters receive a <a href="/ribs/api/package-ribs_parse_ribs_parse/Char.html">Char</a> rather than a raw <a href="https://api.dart.dev/stable/3.11.5/dart-core/int-class.html" target="_blank" rel="noreferrer">int</a>, which makes predicate signatures self-documenting and avoids confusion with other integer values.</p><h2 id="section-constructors" tabindex="-1">Constructors <a class="header-anchor" href="#section-constructors" aria-label="Permalink to &quot;Constructors {#section-constructors}&quot;">​</a></h2><h3 id="ctor-char" tabindex="-1">Char() <a class="header-anchor" href="#ctor-char" aria-label="Permalink to &quot;Char() {#ctor-char}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="fn">Char</span>(<span class="type">int</span> <span class="param">codeUnit</span>)</code></pre></div>', 7)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("Char.checked() ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "factory"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#checked",
        "aria-label": 'Permalink to "Char.checked() <Badge type="tip" text="factory" /> {#checked}"'
      }, "​", -1))
    ]),
    _cache[43] || (_cache[43] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">factory</span> <span class="fn">Char.checked</span>(<span class="type">int</span> <span class="param">codeUnit</span>)</code></pre></div><p>Creates a <a href="/ribs/api/package-ribs_parse_ribs_parse/Char.html">Char</a> after validating that <code>codeUnit</code> is in the range <code>[MinValue, MaxValue]</code>, throwing a <a href="https://api.dart.dev/stable/3.11.5/dart-core/RangeError-class.html" target="_blank" rel="noreferrer">RangeError</a> otherwise.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">factory</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Char</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">checked</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> codeUnit) {</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  RangeError</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">checkValueInInterval</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(codeUnit, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">MinValue</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.codeUnit, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">MaxValue</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.codeUnit, </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;codeUnit&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  return</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Char</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(codeUnit);</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_2, [
      _cache[3] || (_cache[3] = createTextVNode("Char.fromString() ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "factory"
      }),
      _cache[4] || (_cache[4] = createTextVNode()),
      _cache[5] || (_cache[5] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#fromstring",
        "aria-label": 'Permalink to "Char.fromString() <Badge type="tip" text="factory" /> {#fromstring}"'
      }, "​", -1))
    ]),
    _cache[44] || (_cache[44] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">factory</span> <span class="fn">Char.fromString</span>(<span class="type">String</span> <span class="param">str</span>)</code></pre></div><p>Creates a <a href="/ribs/api/package-ribs_parse_ribs_parse/Char.html">Char</a> from the first code unit of <code>str</code>.</p><p>Asserts that <code>str</code> contains exactly one code unit.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">factory</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Char</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">fromString</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> str) {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  assert</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(str.length </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;Char.fromString requires single code unit string, found: </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">$</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">str</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  return</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Char</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">checked</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(str.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">codeUnitAt</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">));</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div></details><h2 id="section-properties" tabindex="-1">Properties <a class="header-anchor" href="#section-properties" aria-label="Permalink to &quot;Properties {#section-properties}&quot;">​</a></h2>', 5)),
    createBaseVNode("h3", _hoisted_3, [
      _cache[6] || (_cache[6] = createTextVNode("asString ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[7] || (_cache[7] = createTextVNode()),
      _cache[8] || (_cache[8] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-asstring",
        "aria-label": 'Permalink to "asString <Badge type="tip" text="no setter" /> {#prop-asstring}"'
      }, "​", -1))
    ]),
    _cache[45] || (_cache[45] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">String</span> <span class="kw">get</span> <span class="fn">asString</span></code></pre></div><p>Returns a one-character <a href="https://api.dart.dev/stable/3.11.5/dart-core/String-class.html" target="_blank" rel="noreferrer">String</a> containing this code unit.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> asString </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">fromCharCode</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(codeUnit);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_4, [
      _cache[9] || (_cache[9] = createTextVNode("codeUnit ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[10] || (_cache[10] = createTextVNode()),
      _cache[11] || (_cache[11] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-codeunit",
        "aria-label": 'Permalink to "codeUnit <Badge type="tip" text="final" /> {#prop-codeunit}"'
      }, "​", -1))
    ]),
    _cache[46] || (_cache[46] = createBaseVNode("div", { class: "member-signature" }, [
      createBaseVNode("pre", null, [
        createBaseVNode("code", null, [
          createBaseVNode("span", { class: "kw" }, "final"),
          createTextVNode(),
          createBaseVNode("span", { class: "type" }, "int"),
          createTextVNode(),
          createBaseVNode("span", { class: "fn" }, "codeUnit")
        ])
      ])
    ], -1)),
    createBaseVNode("h3", _hoisted_5, [
      _cache[12] || (_cache[12] = createTextVNode("isAscii ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[13] || (_cache[13] = createTextVNode()),
      _cache[14] || (_cache[14] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-isascii",
        "aria-label": 'Permalink to "isAscii <Badge type="tip" text="no setter" /> {#prop-isascii}"'
      }, "​", -1))
    ]),
    _cache[47] || (_cache[47] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isAscii</span></code></pre></div><p>Whether this character falls in the ASCII range (code unit &lt; 128).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> isAscii </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> codeUnit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 128</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_6, [
      _cache[15] || (_cache[15] = createTextVNode("isDigit ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[16] || (_cache[16] = createTextVNode()),
      _cache[17] || (_cache[17] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-isdigit",
        "aria-label": 'Permalink to "isDigit <Badge type="tip" text="no setter" /> {#prop-isdigit}"'
      }, "​", -1))
    ]),
    _cache[48] || (_cache[48] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isDigit</span></code></pre></div><p>Whether this character is an ASCII decimal digit (<code>0</code>–<code>9</code>).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> isDigit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 0x30</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> &lt;=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> codeUnit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&amp;&amp;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> codeUnit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 0x39</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_7, [
      _cache[18] || (_cache[18] = createTextVNode("isLetter ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[19] || (_cache[19] = createTextVNode()),
      _cache[20] || (_cache[20] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-isletter",
        "aria-label": 'Permalink to "isLetter <Badge type="tip" text="no setter" /> {#prop-isletter}"'
      }, "​", -1))
    ]),
    _cache[49] || (_cache[49] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isLetter</span></code></pre></div><p>Whether this character is a letter (ASCII, Latin Extended, Greek, or CJK).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> isLetter </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> _category</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(codeUnit) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 4</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_8, [
      _cache[21] || (_cache[21] = createTextVNode("isLowerCase ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[22] || (_cache[22] = createTextVNode()),
      _cache[23] || (_cache[23] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-islowercase",
        "aria-label": 'Permalink to "isLowerCase <Badge type="tip" text="no setter" /> {#prop-islowercase}"'
      }, "​", -1))
    ]),
    _cache[50] || (_cache[50] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isLowerCase</span></code></pre></div><p>Whether this character is an ASCII lower-case letter (<code>a</code>–<code>z</code>).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> isLowerCase </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 0x61</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> &lt;=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> codeUnit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&amp;&amp;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> codeUnit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 0x7a</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_9, [
      _cache[24] || (_cache[24] = createTextVNode("isUpperCase ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[25] || (_cache[25] = createTextVNode()),
      _cache[26] || (_cache[26] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-isuppercase",
        "aria-label": 'Permalink to "isUpperCase <Badge type="tip" text="no setter" /> {#prop-isuppercase}"'
      }, "​", -1))
    ]),
    _cache[51] || (_cache[51] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isUpperCase</span></code></pre></div><p>Whether this character is an ASCII upper-case letter (<code>A</code>–<code>Z</code>).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> isUpperCase </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 0x41</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> &lt;=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> codeUnit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&amp;&amp;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> codeUnit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 0x5a</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_10, [
      _cache[27] || (_cache[27] = createTextVNode("isWhitespace ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[28] || (_cache[28] = createTextVNode()),
      _cache[29] || (_cache[29] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-iswhitespace",
        "aria-label": 'Permalink to "isWhitespace <Badge type="tip" text="no setter" /> {#prop-iswhitespace}"'
      }, "​", -1))
    ]),
    _cache[52] || (_cache[52] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isWhitespace</span></code></pre></div><p>Whether this character is ASCII whitespace (space, tab, LF, or CR).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> isWhitespace </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    codeUnit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 0x20</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> ||</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> codeUnit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 0x09</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> ||</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> codeUnit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 0x0a</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> ||</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> codeUnit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 0x0d</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_11, [
      _cache[30] || (_cache[30] = createTextVNode("toLoweCase ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[31] || (_cache[31] = createTextVNode()),
      _cache[32] || (_cache[32] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tolowecase",
        "aria-label": 'Permalink to "toLoweCase <Badge type="tip" text="no setter" /> {#prop-tolowecase}"'
      }, "​", -1))
    ]),
    _cache[53] || (_cache[53] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Char" class="type-link">Char</a> <span class="kw">get</span> <span class="fn">toLoweCase</span></code></pre></div><p>Returns the lower-case equivalent of this character if it is an ASCII upper-case letter; otherwise returns <code>this</code> unchanged.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Char</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toLoweCase </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> isUpperCase </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Char</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(codeUnit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">+</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 32</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_12, [
      _cache[33] || (_cache[33] = createTextVNode("toUpperCase ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[34] || (_cache[34] = createTextVNode()),
      _cache[35] || (_cache[35] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-touppercase",
        "aria-label": 'Permalink to "toUpperCase <Badge type="tip" text="no setter" /> {#prop-touppercase}"'
      }, "​", -1))
    ]),
    _cache[54] || (_cache[54] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Char" class="type-link">Char</a> <span class="kw">get</span> <span class="fn">toUpperCase</span></code></pre></div><p>Returns the upper-case equivalent of this character if it is an ASCII lower-case letter; otherwise returns <code>this</code> unchanged.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Char</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toUpperCase </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> isLowerCase </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Char</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(codeUnit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">-</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 32</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span></code></pre></div></details><h2 id="section-operators" tabindex="-1">Operators <a class="header-anchor" href="#section-operators" aria-label="Permalink to &quot;Operators {#section-operators}&quot;">​</a></h2><h3 id="operator-plus" tabindex="-1">operator +() <a class="header-anchor" href="#operator-plus" aria-label="Permalink to &quot;operator +() {#operator-plus}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Char" class="type-link">Char</a> <span class="fn">operator +</span>(<span class="type">int</span> <span class="param">offset</span>)</code></pre></div><p>Returns a new <a href="/ribs/api/package-ribs_parse_ribs_parse/Char.html">Char</a> whose code unit is <code>(this.codeUnit + offset) &amp; 0xffff</code>.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Char</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> +</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> offset) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Char</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((codeUnit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">+</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> offset) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&amp;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 0xffff</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details><h3 id="operator-minus" tabindex="-1">operator -() <a class="header-anchor" href="#operator-minus" aria-label="Permalink to &quot;operator -() {#operator-minus}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Char" class="type-link">Char</a> <span class="fn">operator -</span>(<span class="type">int</span> <span class="param">offset</span>)</code></pre></div><p>Returns a new <a href="/ribs/api/package-ribs_parse_ribs_parse/Char.html">Char</a> whose code unit is <code>(this.codeUnit - offset) &amp; 0xffff</code>.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Char</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> -</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> offset) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Char</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((codeUnit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">-</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> offset) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&amp;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 0xffff</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details><h3 id="operator-less" tabindex="-1">operator &lt;() <a class="header-anchor" href="#operator-less" aria-label="Permalink to &quot;operator \\&lt;() {#operator-less}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator &lt;</span>(<a href="./Char" class="type-link">Char</a> <span class="param">other</span>)</code></pre></div><p>Whether this character&#39;s code unit is strictly less than <code>other</code>&#39;s.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> &lt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Char</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> codeUnit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other.codeUnit;</span></span></code></pre></div></details><h3 id="operator-less_equal" tabindex="-1">operator &lt;=() <a class="header-anchor" href="#operator-less_equal" aria-label="Permalink to &quot;operator \\&lt;=() {#operator-less_equal}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator &lt;=</span>(<a href="./Char" class="type-link">Char</a> <span class="param">other</span>)</code></pre></div><p>Whether this character&#39;s code unit is less than or equal to <code>other</code>&#39;s.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> &lt;=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Char</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> codeUnit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other.codeUnit;</span></span></code></pre></div></details><h3 id="operator-greater" tabindex="-1">operator &gt;() <a class="header-anchor" href="#operator-greater" aria-label="Permalink to &quot;operator \\&gt;() {#operator-greater}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator &gt;</span>(<a href="./Char" class="type-link">Char</a> <span class="param">other</span>)</code></pre></div><p>Whether this character&#39;s code unit is strictly greater than <code>other</code>&#39;s.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> &gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Char</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> codeUnit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other.codeUnit;</span></span></code></pre></div></details><h3 id="operator-greater_equal" tabindex="-1">operator &gt;=() <a class="header-anchor" href="#operator-greater_equal" aria-label="Permalink to &quot;operator \\&gt;=() {#operator-greater_equal}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator &gt;=</span>(<a href="./Char" class="type-link">Char</a> <span class="param">other</span>)</code></pre></div><p>Whether this character&#39;s code unit is greater than or equal to <code>other</code>&#39;s.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> &gt;=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Char</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> codeUnit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other.codeUnit;</span></span></code></pre></div></details><h2 id="section-static-properties" tabindex="-1">Static Properties <a class="header-anchor" href="#section-static-properties" aria-label="Permalink to &quot;Static Properties {#section-static-properties}&quot;">​</a></h2>', 29)),
    createBaseVNode("h3", _hoisted_13, [
      _cache[36] || (_cache[36] = createTextVNode("MaxValue ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "read / write"
      }),
      _cache[37] || (_cache[37] = createTextVNode()),
      _cache[38] || (_cache[38] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-maxvalue",
        "aria-label": 'Permalink to "MaxValue <Badge type="tip" text="read / write" /> {#prop-maxvalue}"'
      }, "​", -1))
    ]),
    _cache[55] || (_cache[55] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Char" class="type-link">Char</a> <span class="fn">MaxValue</span></code></pre></div><p><strong>getter:</strong></p><p>The largest possible <a href="/ribs/api/package-ribs_parse_ribs_parse/Char.html">Char</a> value (U+FFFF).</p><p><strong>setter:</strong></p><p>The largest possible <a href="/ribs/api/package-ribs_parse_ribs_parse/Char.html">Char</a> value (U+FFFF).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Char</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MaxValue</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> =</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Char</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">0xffff</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 6)),
    createBaseVNode("h3", _hoisted_14, [
      _cache[39] || (_cache[39] = createTextVNode("MinValue ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "read / write"
      }),
      _cache[40] || (_cache[40] = createTextVNode()),
      _cache[41] || (_cache[41] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-minvalue",
        "aria-label": 'Permalink to "MinValue <Badge type="tip" text="read / write" /> {#prop-minvalue}"'
      }, "​", -1))
    ]),
    _cache[56] || (_cache[56] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Char" class="type-link">Char</a> <span class="fn">MinValue</span></code></pre></div><p><strong>getter:</strong></p><p>The smallest possible <a href="/ribs/api/package-ribs_parse_ribs_parse/Char.html">Char</a> value (U+0000).</p><p><strong>setter:</strong></p><p>The smallest possible <a href="/ribs/api/package-ribs_parse_ribs_parse/Char.html">Char</a> value (U+0000).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Char</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MinValue</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> =</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Char</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">0x0000</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 6))
  ]);
}
const Char = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  Char as default
};
