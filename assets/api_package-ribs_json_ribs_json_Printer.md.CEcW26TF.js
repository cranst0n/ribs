import { r as resolveComponent, o as openBlock, c as createElementBlock, a as createBaseVNode, b as createTextVNode, d as createVNode, e as createStaticVNode, _ as _export_sfc } from "./app.VM00o6Co.js";
const __pageData = JSON.parse('{"title":"Printer","description":"API documentation for Printer class from ribs_json","frontmatter":{"title":"Printer","description":"API documentation for Printer class from ribs_json","category":"Classes","library":"ribs_json","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_json_ribs_json/Printer.md","filePath":"api/package-ribs_json_ribs_json/Printer.md"}');
const _sfc_main = { name: "api/package-ribs_json_ribs_json/Printer.md" };
const _hoisted_1 = {
  id: "printer",
  tabindex: "-1"
};
const _hoisted_2 = {
  id: "prop-arraycommaleft",
  tabindex: "-1"
};
const _hoisted_3 = {
  id: "prop-arraycommaright",
  tabindex: "-1"
};
const _hoisted_4 = {
  id: "prop-colonleft",
  tabindex: "-1"
};
const _hoisted_5 = {
  id: "prop-colonright",
  tabindex: "-1"
};
const _hoisted_6 = {
  id: "prop-dropnullvalues",
  tabindex: "-1"
};
const _hoisted_7 = {
  id: "prop-escapenonascii",
  tabindex: "-1"
};
const _hoisted_8 = {
  id: "prop-hashcode",
  tabindex: "-1"
};
const _hoisted_9 = {
  id: "prop-indent",
  tabindex: "-1"
};
const _hoisted_10 = {
  id: "prop-lbraceleft",
  tabindex: "-1"
};
const _hoisted_11 = {
  id: "prop-lbraceright",
  tabindex: "-1"
};
const _hoisted_12 = {
  id: "prop-lbracketleft",
  tabindex: "-1"
};
const _hoisted_13 = {
  id: "prop-lbracketright",
  tabindex: "-1"
};
const _hoisted_14 = {
  id: "prop-lrbracketsempty",
  tabindex: "-1"
};
const _hoisted_15 = {
  id: "prop-objectcommaleft",
  tabindex: "-1"
};
const _hoisted_16 = {
  id: "prop-objectcommaright",
  tabindex: "-1"
};
const _hoisted_17 = {
  id: "prop-rbraceleft",
  tabindex: "-1"
};
const _hoisted_18 = {
  id: "prop-rbraceright",
  tabindex: "-1"
};
const _hoisted_19 = {
  id: "prop-rbracketleft",
  tabindex: "-1"
};
const _hoisted_20 = {
  id: "prop-rbracketright",
  tabindex: "-1"
};
const _hoisted_21 = {
  id: "prop-runtimetype",
  tabindex: "-1"
};
const _hoisted_22 = {
  id: "nosuchmethod",
  tabindex: "-1"
};
const _hoisted_23 = {
  id: "tostring",
  tabindex: "-1"
};
const _hoisted_24 = {
  id: "operator-equals",
  tabindex: "-1"
};
const _hoisted_25 = {
  id: "prop-nospaces",
  tabindex: "-1"
};
const _hoisted_26 = {
  id: "prop-spaces2",
  tabindex: "-1"
};
const _hoisted_27 = {
  id: "prop-spaces4",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    createBaseVNode("h1", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("Printer ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "final"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#printer",
        "aria-label": 'Permalink to "Printer <Badge type="info" text="final" />"'
      }, "​", -1))
    ]),
    _cache[83] || (_cache[83] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="kw">class</span> <span class="fn">Printer</span></code></pre></div><h2 id="section-constructors" tabindex="-1">Constructors <a class="header-anchor" href="#section-constructors" aria-label="Permalink to &quot;Constructors {#section-constructors}&quot;">​</a></h2><h3 id="ctor-printer" tabindex="-1">Printer() <a class="header-anchor" href="#ctor-printer" aria-label="Permalink to &quot;Printer() {#ctor-printer}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="fn">Printer</span>({\n  <span class="type">String</span> <span class="param">indent</span> = <span class="str-lit">&#39;&#39;</span>,\n  <span class="type">String</span> <span class="param">lbraceLeft</span> = <span class="str-lit">&#39;&#39;</span>,\n  <span class="type">String</span> <span class="param">lbraceRight</span> = <span class="str-lit">&#39;&#39;</span>,\n  <span class="type">String</span> <span class="param">rbraceLeft</span> = <span class="str-lit">&#39;&#39;</span>,\n  <span class="type">String</span> <span class="param">rbraceRight</span> = <span class="str-lit">&#39;&#39;</span>,\n  <span class="type">String</span> <span class="param">lbracketLeft</span> = <span class="str-lit">&#39;&#39;</span>,\n  <span class="type">String</span> <span class="param">lbracketRight</span> = <span class="str-lit">&#39;&#39;</span>,\n  <span class="type">String</span> <span class="param">rbracketLeft</span> = <span class="str-lit">&#39;&#39;</span>,\n  <span class="type">String</span> <span class="param">rbracketRight</span> = <span class="str-lit">&#39;&#39;</span>,\n  <span class="type">String</span> <span class="param">lrbracketsEmpty</span> = <span class="str-lit">&#39;&#39;</span>,\n  <span class="type">String</span> <span class="param">arrayCommaLeft</span> = <span class="str-lit">&#39;&#39;</span>,\n  <span class="type">String</span> <span class="param">arrayCommaRight</span> = <span class="str-lit">&#39;&#39;</span>,\n  <span class="type">String</span> <span class="param">objectCommaLeft</span> = <span class="str-lit">&#39;&#39;</span>,\n  <span class="type">String</span> <span class="param">objectCommaRight</span> = <span class="str-lit">&#39;&#39;</span>,\n  <span class="type">String</span> <span class="param">colonLeft</span> = <span class="str-lit">&#39;&#39;</span>,\n  <span class="type">String</span> <span class="param">colonRight</span> = <span class="str-lit">&#39;&#39;</span>,\n  <span class="type">bool</span> <span class="param">dropNullValues</span> = <span class="kw">false</span>,\n  <span class="type">bool</span> <span class="param">escapeNonAscii</span> = <span class="kw">false</span>,\n})</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Printer</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">({</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.indent </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.lbraceLeft </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.lbraceRight </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.rbraceLeft </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.rbraceRight </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.lbracketLeft </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.lbracketRight </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.rbracketLeft </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.rbracketRight </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.lrbracketsEmpty </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.arrayCommaLeft </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.arrayCommaRight </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.objectCommaLeft </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.objectCommaRight </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.colonLeft </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.colonRight </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.dropNullValues </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> false</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.escapeNonAscii </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> false</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">});</span></span></code></pre></div></details><h2 id="section-properties" tabindex="-1">Properties <a class="header-anchor" href="#section-properties" aria-label="Permalink to &quot;Properties {#section-properties}&quot;">​</a></h2>', 6)),
    createBaseVNode("h3", _hoisted_2, [
      _cache[3] || (_cache[3] = createTextVNode("arrayCommaLeft ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[4] || (_cache[4] = createTextVNode()),
      _cache[5] || (_cache[5] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-arraycommaleft",
        "aria-label": 'Permalink to "arrayCommaLeft <Badge type="tip" text="final" /> {#prop-arraycommaleft}"'
      }, "​", -1))
    ]),
    _cache[84] || (_cache[84] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="type">String</span> <span class="fn">arrayCommaLeft</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> arrayCommaLeft;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_3, [
      _cache[6] || (_cache[6] = createTextVNode("arrayCommaRight ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[7] || (_cache[7] = createTextVNode()),
      _cache[8] || (_cache[8] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-arraycommaright",
        "aria-label": 'Permalink to "arrayCommaRight <Badge type="tip" text="final" /> {#prop-arraycommaright}"'
      }, "​", -1))
    ]),
    _cache[85] || (_cache[85] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="type">String</span> <span class="fn">arrayCommaRight</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> arrayCommaRight;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_4, [
      _cache[9] || (_cache[9] = createTextVNode("colonLeft ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[10] || (_cache[10] = createTextVNode()),
      _cache[11] || (_cache[11] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-colonleft",
        "aria-label": 'Permalink to "colonLeft <Badge type="tip" text="final" /> {#prop-colonleft}"'
      }, "​", -1))
    ]),
    _cache[86] || (_cache[86] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="type">String</span> <span class="fn">colonLeft</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> colonLeft;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_5, [
      _cache[12] || (_cache[12] = createTextVNode("colonRight ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[13] || (_cache[13] = createTextVNode()),
      _cache[14] || (_cache[14] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-colonright",
        "aria-label": 'Permalink to "colonRight <Badge type="tip" text="final" /> {#prop-colonright}"'
      }, "​", -1))
    ]),
    _cache[87] || (_cache[87] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="type">String</span> <span class="fn">colonRight</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> colonRight;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_6, [
      _cache[15] || (_cache[15] = createTextVNode("dropNullValues ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[16] || (_cache[16] = createTextVNode()),
      _cache[17] || (_cache[17] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-dropnullvalues",
        "aria-label": 'Permalink to "dropNullValues <Badge type="tip" text="final" /> {#prop-dropnullvalues}"'
      }, "​", -1))
    ]),
    _cache[88] || (_cache[88] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="type">bool</span> <span class="fn">dropNullValues</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> bool</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> dropNullValues;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_7, [
      _cache[18] || (_cache[18] = createTextVNode("escapeNonAscii ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[19] || (_cache[19] = createTextVNode()),
      _cache[20] || (_cache[20] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-escapenonascii",
        "aria-label": 'Permalink to "escapeNonAscii <Badge type="tip" text="final" /> {#prop-escapenonascii}"'
      }, "​", -1))
    ]),
    _cache[89] || (_cache[89] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="type">bool</span> <span class="fn">escapeNonAscii</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> bool</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> escapeNonAscii;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_8, [
      _cache[21] || (_cache[21] = createTextVNode("hashCode ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[22] || (_cache[22] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[23] || (_cache[23] = createTextVNode()),
      _cache[24] || (_cache[24] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-hashcode",
        "aria-label": 'Permalink to "hashCode <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-hashcode}"'
      }, "​", -1))
    ]),
    _cache[90] || (_cache[90] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></code></pre></div><p>The hash code for this object.</p><p>A hash code is a single integer which represents the state of the object that affects <a href="/ribs/api/package-ribs_json_ribs_json/Printer.html#operator-equals">operator ==</a> comparisons.</p><p>All objects have hash codes. The default hash code implemented by <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object-class.html" target="_blank" rel="noreferrer">Object</a> represents only the identity of the object, the same way as the default <a href="/ribs/api/package-ribs_json_ribs_json/Printer.html#operator-equals">operator ==</a> implementation only considers objects equal if they are identical (see <a href="https://api.dart.dev/stable/3.11.4/dart-core/identityHashCode.html" target="_blank" rel="noreferrer">identityHashCode</a>).</p><p>If <a href="/ribs/api/package-ribs_json_ribs_json/Printer.html#operator-equals">operator ==</a> is overridden to use the object state instead, the hash code must also be changed to represent that state, otherwise the object cannot be used in hash based data structures like the default <a href="https://api.dart.dev/stable/3.11.4/dart-core/Set-class.html" target="_blank" rel="noreferrer">Set</a> and <a href="https://api.dart.dev/stable/3.11.4/dart-core/Map-class.html" target="_blank" rel="noreferrer">Map</a> implementations.</p><p>Hash codes must be the same for objects that are equal to each other according to <a href="/ribs/api/package-ribs_json_ribs_json/Printer.html#operator-equals">operator ==</a>. The hash code of an object should only change if the object changes in a way that affects equality. There are no further requirements for the hash codes. They need not be consistent between executions of the same program and there are no distribution guarantees.</p><p>Objects that are not equal are allowed to have the same hash code. It is even technically allowed that all instances have the same hash code, but if clashes happen too often, it may reduce the efficiency of hash-based data structures like <a href="https://api.dart.dev/stable/3.11.4/dart-collection/HashSet-class.html" target="_blank" rel="noreferrer">HashSet</a> or <a href="https://api.dart.dev/stable/3.11.4/dart-collection/HashMap-class.html" target="_blank" rel="noreferrer">HashMap</a>.</p><p>If a subclass overrides <a href="/ribs/api/package-ribs_json_ribs_json/Printer.html#prop-hashcode">hashCode</a>, it should override the <a href="/ribs/api/package-ribs_json_ribs_json/Printer.html#operator-equals">operator ==</a> operator as well to maintain consistency.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> hashCode;</span></span></code></pre></div></details>', 10)),
    createBaseVNode("h3", _hoisted_9, [
      _cache[25] || (_cache[25] = createTextVNode("indent ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[26] || (_cache[26] = createTextVNode()),
      _cache[27] || (_cache[27] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-indent",
        "aria-label": 'Permalink to "indent <Badge type="tip" text="final" /> {#prop-indent}"'
      }, "​", -1))
    ]),
    _cache[91] || (_cache[91] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="type">String</span> <span class="fn">indent</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> indent;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_10, [
      _cache[28] || (_cache[28] = createTextVNode("lbraceLeft ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[29] || (_cache[29] = createTextVNode()),
      _cache[30] || (_cache[30] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-lbraceleft",
        "aria-label": 'Permalink to "lbraceLeft <Badge type="tip" text="final" /> {#prop-lbraceleft}"'
      }, "​", -1))
    ]),
    _cache[92] || (_cache[92] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="type">String</span> <span class="fn">lbraceLeft</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> lbraceLeft;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_11, [
      _cache[31] || (_cache[31] = createTextVNode("lbraceRight ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[32] || (_cache[32] = createTextVNode()),
      _cache[33] || (_cache[33] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-lbraceright",
        "aria-label": 'Permalink to "lbraceRight <Badge type="tip" text="final" /> {#prop-lbraceright}"'
      }, "​", -1))
    ]),
    _cache[93] || (_cache[93] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="type">String</span> <span class="fn">lbraceRight</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> lbraceRight;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_12, [
      _cache[34] || (_cache[34] = createTextVNode("lbracketLeft ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[35] || (_cache[35] = createTextVNode()),
      _cache[36] || (_cache[36] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-lbracketleft",
        "aria-label": 'Permalink to "lbracketLeft <Badge type="tip" text="final" /> {#prop-lbracketleft}"'
      }, "​", -1))
    ]),
    _cache[94] || (_cache[94] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="type">String</span> <span class="fn">lbracketLeft</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> lbracketLeft;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_13, [
      _cache[37] || (_cache[37] = createTextVNode("lbracketRight ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[38] || (_cache[38] = createTextVNode()),
      _cache[39] || (_cache[39] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-lbracketright",
        "aria-label": 'Permalink to "lbracketRight <Badge type="tip" text="final" /> {#prop-lbracketright}"'
      }, "​", -1))
    ]),
    _cache[95] || (_cache[95] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="type">String</span> <span class="fn">lbracketRight</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> lbracketRight;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_14, [
      _cache[40] || (_cache[40] = createTextVNode("lrbracketsEmpty ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[41] || (_cache[41] = createTextVNode()),
      _cache[42] || (_cache[42] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-lrbracketsempty",
        "aria-label": 'Permalink to "lrbracketsEmpty <Badge type="tip" text="final" /> {#prop-lrbracketsempty}"'
      }, "​", -1))
    ]),
    _cache[96] || (_cache[96] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="type">String</span> <span class="fn">lrbracketsEmpty</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> lrbracketsEmpty;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_15, [
      _cache[43] || (_cache[43] = createTextVNode("objectCommaLeft ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[44] || (_cache[44] = createTextVNode()),
      _cache[45] || (_cache[45] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-objectcommaleft",
        "aria-label": 'Permalink to "objectCommaLeft <Badge type="tip" text="final" /> {#prop-objectcommaleft}"'
      }, "​", -1))
    ]),
    _cache[97] || (_cache[97] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="type">String</span> <span class="fn">objectCommaLeft</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> objectCommaLeft;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_16, [
      _cache[46] || (_cache[46] = createTextVNode("objectCommaRight ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[47] || (_cache[47] = createTextVNode()),
      _cache[48] || (_cache[48] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-objectcommaright",
        "aria-label": 'Permalink to "objectCommaRight <Badge type="tip" text="final" /> {#prop-objectcommaright}"'
      }, "​", -1))
    ]),
    _cache[98] || (_cache[98] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="type">String</span> <span class="fn">objectCommaRight</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> objectCommaRight;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_17, [
      _cache[49] || (_cache[49] = createTextVNode("rbraceLeft ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[50] || (_cache[50] = createTextVNode()),
      _cache[51] || (_cache[51] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-rbraceleft",
        "aria-label": 'Permalink to "rbraceLeft <Badge type="tip" text="final" /> {#prop-rbraceleft}"'
      }, "​", -1))
    ]),
    _cache[99] || (_cache[99] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="type">String</span> <span class="fn">rbraceLeft</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> rbraceLeft;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_18, [
      _cache[52] || (_cache[52] = createTextVNode("rbraceRight ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[53] || (_cache[53] = createTextVNode()),
      _cache[54] || (_cache[54] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-rbraceright",
        "aria-label": 'Permalink to "rbraceRight <Badge type="tip" text="final" /> {#prop-rbraceright}"'
      }, "​", -1))
    ]),
    _cache[100] || (_cache[100] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="type">String</span> <span class="fn">rbraceRight</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> rbraceRight;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_19, [
      _cache[55] || (_cache[55] = createTextVNode("rbracketLeft ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[56] || (_cache[56] = createTextVNode()),
      _cache[57] || (_cache[57] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-rbracketleft",
        "aria-label": 'Permalink to "rbracketLeft <Badge type="tip" text="final" /> {#prop-rbracketleft}"'
      }, "​", -1))
    ]),
    _cache[101] || (_cache[101] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="type">String</span> <span class="fn">rbracketLeft</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> rbracketLeft;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_20, [
      _cache[58] || (_cache[58] = createTextVNode("rbracketRight ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[59] || (_cache[59] = createTextVNode()),
      _cache[60] || (_cache[60] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-rbracketright",
        "aria-label": 'Permalink to "rbracketRight <Badge type="tip" text="final" /> {#prop-rbracketright}"'
      }, "​", -1))
    ]),
    _cache[102] || (_cache[102] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="type">String</span> <span class="fn">rbracketRight</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> rbracketRight;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_21, [
      _cache[61] || (_cache[61] = createTextVNode("runtimeType ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[62] || (_cache[62] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[63] || (_cache[63] = createTextVNode()),
      _cache[64] || (_cache[64] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-runtimetype",
        "aria-label": 'Permalink to "runtimeType <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-runtimetype}"'
      }, "​", -1))
    ]),
    _cache[103] || (_cache[103] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">Type</span> <span class="kw">get</span> <span class="fn">runtimeType</span></code></pre></div><p>A representation of the runtime type of the object.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Type</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> runtimeType;</span></span></code></pre></div></details><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2><h3 id="copy" tabindex="-1">copy() <a class="header-anchor" href="#copy" aria-label="Permalink to &quot;copy() {#copy}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Printer" class="type-link">Printer</a> <span class="fn">copy</span>({\n  <span class="type">String</span>? <span class="param">indent</span>,\n  <span class="type">String</span>? <span class="param">lbraceLeft</span>,\n  <span class="type">String</span>? <span class="param">lbraceRight</span>,\n  <span class="type">String</span>? <span class="param">rbraceLeft</span>,\n  <span class="type">String</span>? <span class="param">rbraceRight</span>,\n  <span class="type">String</span>? <span class="param">lbracketLeft</span>,\n  <span class="type">String</span>? <span class="param">lbracketRight</span>,\n  <span class="type">String</span>? <span class="param">rbracketLeft</span>,\n  <span class="type">String</span>? <span class="param">rbracketRight</span>,\n  <span class="type">String</span>? <span class="param">lrbracketsEmpty</span>,\n  <span class="type">String</span>? <span class="param">arrayCommaLeft</span>,\n  <span class="type">String</span>? <span class="param">arrayCommaRight</span>,\n  <span class="type">String</span>? <span class="param">objectCommaLeft</span>,\n  <span class="type">String</span>? <span class="param">objectCommaRight</span>,\n  <span class="type">String</span>? <span class="param">colonLeft</span>,\n  <span class="type">String</span>? <span class="param">colonRight</span>,\n  <span class="type">bool</span>? <span class="param">dropNullValues</span>,\n  <span class="type">bool</span>? <span class="param">escapeNonAscii</span>,\n})</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Printer</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> copy</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">({</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  String</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> indent,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  String</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> lbraceLeft,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  String</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> lbraceRight,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  String</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> rbraceLeft,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  String</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> rbraceRight,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  String</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> lbracketLeft,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  String</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> lbracketRight,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  String</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> rbracketLeft,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  String</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> rbracketRight,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  String</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> lrbracketsEmpty,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  String</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> arrayCommaLeft,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  String</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> arrayCommaRight,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  String</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> objectCommaLeft,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  String</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> objectCommaRight,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  String</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> colonLeft,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  String</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> colonRight,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> dropNullValues,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> escapeNonAscii,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Printer</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  indent</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> indent </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.indent,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  lbraceLeft</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> lbraceLeft </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.lbraceLeft,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  lbraceRight</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> lbraceRight </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.lbraceRight,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  rbraceLeft</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> rbraceLeft </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.rbraceLeft,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  rbraceRight</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> rbraceRight </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.rbraceRight,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  lbracketLeft</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> lbracketLeft </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.lbracketLeft,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  lbracketRight</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> lbracketRight </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.lbracketRight,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  rbracketLeft</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> rbracketLeft </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.rbracketLeft,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  rbracketRight</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> rbracketRight </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.rbracketRight,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  lrbracketsEmpty</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> lrbracketsEmpty </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.lrbracketsEmpty,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  arrayCommaLeft</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> arrayCommaLeft </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.arrayCommaLeft,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  arrayCommaRight</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> arrayCommaRight </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.arrayCommaRight,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  objectCommaLeft</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> objectCommaLeft </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.objectCommaLeft,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  objectCommaRight</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> objectCommaRight </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.objectCommaRight,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  colonLeft</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> colonLeft </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.colonLeft,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  colonRight</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> colonRight </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.colonRight,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  dropNullValues</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> dropNullValues </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.dropNullValues,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  escapeNonAscii</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> escapeNonAscii </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.escapeNonAscii,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 8)),
    createBaseVNode("h3", _hoisted_22, [
      _cache[65] || (_cache[65] = createTextVNode("noSuchMethod() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[66] || (_cache[66] = createTextVNode()),
      _cache[67] || (_cache[67] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#nosuchmethod",
        "aria-label": 'Permalink to "noSuchMethod() <Badge type="info" text="inherited" /> {#nosuchmethod}"'
      }, "​", -1))
    ]),
    _cache[104] || (_cache[104] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">dynamic</span> <span class="fn">noSuchMethod</span>(<span class="type">Invocation</span> <span class="param">invocation</span>)</code></pre></div><p>Invoked when a nonexistent method or property is accessed.</p><p>A dynamic member invocation can attempt to call a member which doesn&#39;t exist on the receiving object. Example:</p><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">dynamic</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> object </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">object.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">add</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">42</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">); </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">// Statically allowed, run-time error</span></span></code></pre></div><p>This invalid code will invoke the <code>noSuchMethod</code> method of the integer <code>1</code> with an <a href="https://api.dart.dev/stable/3.11.4/dart-core/Invocation-class.html" target="_blank" rel="noreferrer">Invocation</a> representing the <code>.add(42)</code> call and arguments (which then throws).</p><p>Classes can override <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object/noSuchMethod.html" target="_blank" rel="noreferrer">noSuchMethod</a> to provide custom behavior for such invalid dynamic invocations.</p><p>A class with a non-default <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object/noSuchMethod.html" target="_blank" rel="noreferrer">noSuchMethod</a> invocation can also omit implementations for members of its interface. Example:</p><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">class</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MockList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">implements</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> List</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; {</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">  noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Invocation</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> invocation) {</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    log</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(invocation);</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    super</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(invocation); </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">// Will throw.</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  }</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">void</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> main</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() {</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  MockList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">().</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">add</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">42</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div><p>This code has no compile-time warnings or errors even though the <code>MockList</code> class has no concrete implementation of any of the <code>List</code> interface methods. Calls to <code>List</code> methods are forwarded to <code>noSuchMethod</code>, so this code will <code>log</code> an invocation similar to <code>Invocation.method(#add, [42])</code> and then throw.</p><p>If a value is returned from <code>noSuchMethod</code>, it becomes the result of the original invocation. If the value is not of a type that can be returned by the original invocation, a type error occurs at the invocation.</p><p>The default behavior is to throw a <a href="https://api.dart.dev/stable/3.11.4/dart-core/NoSuchMethodError-class.html" target="_blank" rel="noreferrer">NoSuchMethodError</a>.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@pragma</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;vm:entry-point&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@pragma</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;wasm:entry-point&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> dynamic</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Invocation</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> invocation);</span></span></code></pre></div></details><h3 id="print" tabindex="-1">print() <a class="header-anchor" href="#print" aria-label="Permalink to &quot;print() {#print}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="type">String</span> <span class="fn">print</span>(<a href="./Json" class="type-link">Json</a> <span class="param">json</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> print</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Json</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> json) {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  final</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> folder </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> _PrintFolder</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  json.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">foldWith</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(folder);</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  return</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> folder.buffer.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">toString</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">();</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div></details>', 16)),
    createBaseVNode("h3", _hoisted_23, [
      _cache[68] || (_cache[68] = createTextVNode("toString() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[69] || (_cache[69] = createTextVNode()),
      _cache[70] || (_cache[70] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#tostring",
        "aria-label": 'Permalink to "toString() <Badge type="info" text="inherited" /> {#tostring}"'
      }, "​", -1))
    ]),
    _cache[105] || (_cache[105] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">String</span> <span class="fn">toString</span>()</code></pre></div><p>A string representation of this object.</p><p>Some classes have a default textual representation, often paired with a static <code>parse</code> function (like <a href="https://api.dart.dev/stable/3.11.4/dart-core/int/parse.html" target="_blank" rel="noreferrer">int.parse</a>). These classes will provide the textual representation as their string representation.</p><p>Other classes have no meaningful textual representation that a program will care about. Such classes will typically override <code>toString</code> to provide useful information when inspecting the object, mainly for debugging or logging.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> String</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> toString</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">();</span></span></code></pre></div></details><h2 id="section-operators" tabindex="-1">Operators <a class="header-anchor" href="#section-operators" aria-label="Permalink to &quot;Operators {#section-operators}&quot;">​</a></h2>', 7)),
    createBaseVNode("h3", _hoisted_24, [
      _cache[71] || (_cache[71] = createTextVNode("operator ==() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[72] || (_cache[72] = createTextVNode()),
      _cache[73] || (_cache[73] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#operator-equals",
        "aria-label": 'Permalink to "operator ==() <Badge type="info" text="inherited" /> {#operator-equals}"'
      }, "​", -1))
    ]),
    _cache[106] || (_cache[106] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator ==</span>(<span class="type">Object</span> <span class="param">other</span>)</code></pre></div><p>The equality operator.</p><p>The default behavior for all <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object-class.html" target="_blank" rel="noreferrer">Object</a>s is to return true if and only if this object and <code>other</code> are the same object.</p><p>Override this method to specify a different equality relation on a class. The overriding method must still be an equivalence relation. That is, it must be:</p><ul><li><p>Total: It must return a boolean for all arguments. It should never throw.</p></li><li><p>Reflexive: For all objects <code>o</code>, <code>o == o</code> must be true.</p></li><li><p>Symmetric: For all objects <code>o1</code> and <code>o2</code>, <code>o1 == o2</code> and <code>o2 == o1</code> must either both be true, or both be false.</p></li><li><p>Transitive: For all objects <code>o1</code>, <code>o2</code>, and <code>o3</code>, if <code>o1 == o2</code> and <code>o2 == o3</code> are true, then <code>o1 == o3</code> must be true.</p></li></ul><p>The method should also be consistent over time, so whether two objects are equal should only change if at least one of the objects was modified.</p><p>If a subclass overrides the equality operator, it should override the <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object/hashCode.html" target="_blank" rel="noreferrer">hashCode</a> method as well to maintain consistency.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> ==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Object</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other);</span></span></code></pre></div></details><h2 id="section-static-properties" tabindex="-1">Static Properties <a class="header-anchor" href="#section-static-properties" aria-label="Permalink to &quot;Static Properties {#section-static-properties}&quot;">​</a></h2>', 10)),
    createBaseVNode("h3", _hoisted_25, [
      _cache[74] || (_cache[74] = createTextVNode("noSpaces ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "read / write"
      }),
      _cache[75] || (_cache[75] = createTextVNode()),
      _cache[76] || (_cache[76] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-nospaces",
        "aria-label": 'Permalink to "noSpaces <Badge type="tip" text="read / write" /> {#prop-nospaces}"'
      }, "​", -1))
    ]),
    _cache[107] || (_cache[107] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Printer" class="type-link">Printer</a> <span class="fn">noSpaces</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Printer</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> noSpaces </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Printer</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">();</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_26, [
      _cache[77] || (_cache[77] = createTextVNode("spaces2 ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "read / write"
      }),
      _cache[78] || (_cache[78] = createTextVNode()),
      _cache[79] || (_cache[79] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-spaces2",
        "aria-label": 'Permalink to "spaces2 <Badge type="tip" text="read / write" /> {#prop-spaces2}"'
      }, "​", -1))
    ]),
    _cache[108] || (_cache[108] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Printer" class="type-link">Printer</a> <span class="fn">spaces2</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Printer</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> spaces2 </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> indented</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;  &#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_27, [
      _cache[80] || (_cache[80] = createTextVNode("spaces4 ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "read / write"
      }),
      _cache[81] || (_cache[81] = createTextVNode()),
      _cache[82] || (_cache[82] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-spaces4",
        "aria-label": 'Permalink to "spaces4 <Badge type="tip" text="read / write" /> {#prop-spaces4}"'
      }, "​", -1))
    ]),
    _cache[109] || (_cache[109] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Printer" class="type-link">Printer</a> <span class="fn">spaces4</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Printer</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> spaces4 </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> indented</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;    &#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details><h2 id="section-static-methods" tabindex="-1">Static Methods <a class="header-anchor" href="#section-static-methods" aria-label="Permalink to &quot;Static Methods {#section-static-methods}&quot;">​</a></h2><h3 id="indented" tabindex="-1">indented() <a class="header-anchor" href="#indented" aria-label="Permalink to &quot;indented() {#indented}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Printer" class="type-link">Printer</a> <span class="fn">indented</span>(<span class="type">String</span> <span class="param">indent</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Printer</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> indented</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> indent) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Printer</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  indent</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> indent,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  lbraceRight</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">\\n</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  rbraceLeft</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">\\n</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  lbracketRight</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">\\n</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  rbracketLeft</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">\\n</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  lrbracketsEmpty</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">\\n</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  arrayCommaRight</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">\\n</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  objectCommaRight</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">\\n</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  colonLeft</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39; &#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  colonRight</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39; &#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 6))
  ]);
}
const Printer = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  Printer as default
};
