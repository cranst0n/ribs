import { r as resolveComponent, o as openBlock, c as createElementBlock, a as createBaseVNode, b as createTextVNode, d as createVNode, e as createStaticVNode, _ as _export_sfc } from "./app.D9Lc66jX.js";
const __pageData = JSON.parse('{"title":"Mass","description":"API documentation for Mass class from ribs_units","frontmatter":{"title":"Mass","description":"API documentation for Mass class from ribs_units","category":"Classes","library":"ribs_units","outline":[2,3],"outlineCollapsible":true,"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_units_ribs_units/Mass.md","filePath":"api/package-ribs_units_ribs_units/Mass.md"}');
const _sfc_main = { name: "api/package-ribs_units_ribs_units/Mass.md" };
const _hoisted_1 = {
  id: "mass",
  tabindex: "-1"
};
const _hoisted_2 = {
  id: "prop-hashcode",
  tabindex: "-1"
};
const _hoisted_3 = {
  id: "prop-runtimetype",
  tabindex: "-1"
};
const _hoisted_4 = {
  id: "prop-tocarats",
  tabindex: "-1"
};
const _hoisted_5 = {
  id: "prop-tograms",
  tabindex: "-1"
};
const _hoisted_6 = {
  id: "prop-tokilograms",
  tabindex: "-1"
};
const _hoisted_7 = {
  id: "prop-tokilopounds",
  tabindex: "-1"
};
const _hoisted_8 = {
  id: "prop-tomegapounds",
  tabindex: "-1"
};
const _hoisted_9 = {
  id: "prop-tomicrograms",
  tabindex: "-1"
};
const _hoisted_10 = {
  id: "prop-tomilligrams",
  tabindex: "-1"
};
const _hoisted_11 = {
  id: "prop-tonanograms",
  tabindex: "-1"
};
const _hoisted_12 = {
  id: "prop-toounces",
  tabindex: "-1"
};
const _hoisted_13 = {
  id: "prop-topennyweights",
  tabindex: "-1"
};
const _hoisted_14 = {
  id: "prop-topounds",
  tabindex: "-1"
};
const _hoisted_15 = {
  id: "prop-tostone",
  tabindex: "-1"
};
const _hoisted_16 = {
  id: "prop-totolas",
  tabindex: "-1"
};
const _hoisted_17 = {
  id: "prop-totonnes",
  tabindex: "-1"
};
const _hoisted_18 = {
  id: "prop-totroygrains",
  tabindex: "-1"
};
const _hoisted_19 = {
  id: "prop-totroyounces",
  tabindex: "-1"
};
const _hoisted_20 = {
  id: "prop-totroypounds",
  tabindex: "-1"
};
const _hoisted_21 = {
  id: "prop-unit",
  tabindex: "-1"
};
const _hoisted_22 = {
  id: "prop-value",
  tabindex: "-1"
};
const _hoisted_23 = {
  id: "equivalentto",
  tabindex: "-1"
};
const _hoisted_24 = {
  id: "nosuchmethod",
  tabindex: "-1"
};
const _hoisted_25 = {
  id: "to",
  tabindex: "-1"
};
const _hoisted_26 = {
  id: "tostring",
  tabindex: "-1"
};
const _hoisted_27 = {
  id: "operator-less",
  tabindex: "-1"
};
const _hoisted_28 = {
  id: "operator-less_equal",
  tabindex: "-1"
};
const _hoisted_29 = {
  id: "operator-equals",
  tabindex: "-1"
};
const _hoisted_30 = {
  id: "operator-greater",
  tabindex: "-1"
};
const _hoisted_31 = {
  id: "operator-greater_equal",
  tabindex: "-1"
};
const _hoisted_32 = {
  id: "parse",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    createBaseVNode("h1", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("Mass ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "final"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#mass",
        "aria-label": 'Permalink to "Mass <Badge type="info" text="final" />"'
      }, "​", -1))
    ]),
    _cache[100] || (_cache[100] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="kw">class</span> <span class="fn">Mass</span> <span class="kw">extends</span> <a href="./Quantity" class="type-link">Quantity</a>&lt;<a href="./Mass" class="type-link">Mass</a>&gt;</code></pre></div><div class="info custom-block"><p class="custom-block-title">Inheritance</p><p>Object → <a href="/ribs/api/package-ribs_units_ribs_units/Quantity.html">Quantity&lt;A extends Quantity&lt;A&gt;&gt;</a> → <strong>Mass</strong></p></div><h2 id="section-constructors" tabindex="-1">Constructors <a class="header-anchor" href="#section-constructors" aria-label="Permalink to &quot;Constructors {#section-constructors}&quot;">​</a></h2><h3 id="ctor-mass" tabindex="-1">Mass() <a class="header-anchor" href="#ctor-mass" aria-label="Permalink to &quot;Mass() {#ctor-mass}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="fn">Mass</span>(<span class="type">double</span> <span class="param">value</span>, <a href="./UnitOfMeasure" class="type-link">UnitOfMeasure</a>&lt;<a href="./Mass" class="type-link">Mass</a>&gt; <span class="param">unit</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Mass</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">super</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.value, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">super</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.unit);</span></span></code></pre></div></details><h2 id="section-properties" tabindex="-1">Properties <a class="header-anchor" href="#section-properties" aria-label="Permalink to &quot;Properties {#section-properties}&quot;">​</a></h2>', 7)),
    createBaseVNode("h3", _hoisted_2, [
      _cache[3] || (_cache[3] = createTextVNode("hashCode ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[4] || (_cache[4] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[5] || (_cache[5] = createTextVNode()),
      _cache[6] || (_cache[6] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-hashcode",
        "aria-label": 'Permalink to "hashCode <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-hashcode}"'
      }, "​", -1))
    ]),
    _cache[101] || (_cache[101] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></code></pre></div><p>The hash code for this object.</p><p>A hash code is a single integer which represents the state of the object that affects <a href="/ribs/api/package-ribs_units_ribs_units/Mass.html#operator-equals">operator ==</a> comparisons.</p><p>All objects have hash codes. The default hash code implemented by <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object-class.html" target="_blank" rel="noreferrer">Object</a> represents only the identity of the object, the same way as the default <a href="/ribs/api/package-ribs_units_ribs_units/Mass.html#operator-equals">operator ==</a> implementation only considers objects equal if they are identical (see <a href="https://api.dart.dev/stable/3.11.4/dart-core/identityHashCode.html" target="_blank" rel="noreferrer">identityHashCode</a>).</p><p>If <a href="/ribs/api/package-ribs_units_ribs_units/Mass.html#operator-equals">operator ==</a> is overridden to use the object state instead, the hash code must also be changed to represent that state, otherwise the object cannot be used in hash based data structures like the default <a href="https://api.dart.dev/stable/3.11.4/dart-core/Set-class.html" target="_blank" rel="noreferrer">Set</a> and <a href="https://api.dart.dev/stable/3.11.4/dart-core/Map-class.html" target="_blank" rel="noreferrer">Map</a> implementations.</p><p>Hash codes must be the same for objects that are equal to each other according to <a href="/ribs/api/package-ribs_units_ribs_units/Mass.html#operator-equals">operator ==</a>. The hash code of an object should only change if the object changes in a way that affects equality. There are no further requirements for the hash codes. They need not be consistent between executions of the same program and there are no distribution guarantees.</p><p>Objects that are not equal are allowed to have the same hash code. It is even technically allowed that all instances have the same hash code, but if clashes happen too often, it may reduce the efficiency of hash-based data structures like <a href="https://api.dart.dev/stable/3.11.4/dart-collection/HashSet-class.html" target="_blank" rel="noreferrer">HashSet</a> or <a href="https://api.dart.dev/stable/3.11.4/dart-collection/HashMap-class.html" target="_blank" rel="noreferrer">HashMap</a>.</p><p>If a subclass overrides <a href="/ribs/api/package-ribs_units_ribs_units/Mass.html#prop-hashcode">hashCode</a>, it should override the <a href="/ribs/api/package-ribs_units_ribs_units/Mass.html#operator-equals">operator ==</a> operator as well to maintain consistency.</p><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> hashCode </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Object</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">hash</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(value, unit);</span></span></code></pre></div></details>', 10)),
    createBaseVNode("h3", _hoisted_3, [
      _cache[7] || (_cache[7] = createTextVNode("runtimeType ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[8] || (_cache[8] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[9] || (_cache[9] = createTextVNode()),
      _cache[10] || (_cache[10] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-runtimetype",
        "aria-label": 'Permalink to "runtimeType <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-runtimetype}"'
      }, "​", -1))
    ]),
    _cache[102] || (_cache[102] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">Type</span> <span class="kw">get</span> <span class="fn">runtimeType</span></code></pre></div><p>A representation of the runtime type of the object.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Type</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> runtimeType;</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_4, [
      _cache[11] || (_cache[11] = createTextVNode("toCarats ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[12] || (_cache[12] = createTextVNode()),
      _cache[13] || (_cache[13] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tocarats",
        "aria-label": 'Permalink to "toCarats <Badge type="tip" text="no setter" /> {#prop-tocarats}"'
      }, "​", -1))
    ]),
    _cache[103] || (_cache[103] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Mass" class="type-link">Mass</a> <span class="kw">get</span> <span class="fn">toCarats</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Mass</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toCarats </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(carats).carats;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_5, [
      _cache[14] || (_cache[14] = createTextVNode("toGrams ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[15] || (_cache[15] = createTextVNode()),
      _cache[16] || (_cache[16] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tograms",
        "aria-label": 'Permalink to "toGrams <Badge type="tip" text="no setter" /> {#prop-tograms}"'
      }, "​", -1))
    ]),
    _cache[104] || (_cache[104] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Mass" class="type-link">Mass</a> <span class="kw">get</span> <span class="fn">toGrams</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Mass</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toGrams </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(grams).grams;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_6, [
      _cache[17] || (_cache[17] = createTextVNode("toKilograms ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[18] || (_cache[18] = createTextVNode()),
      _cache[19] || (_cache[19] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tokilograms",
        "aria-label": 'Permalink to "toKilograms <Badge type="tip" text="no setter" /> {#prop-tokilograms}"'
      }, "​", -1))
    ]),
    _cache[105] || (_cache[105] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Mass" class="type-link">Mass</a> <span class="kw">get</span> <span class="fn">toKilograms</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Mass</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toKilograms </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(kilograms).kilograms;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_7, [
      _cache[20] || (_cache[20] = createTextVNode("toKilopounds ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[21] || (_cache[21] = createTextVNode()),
      _cache[22] || (_cache[22] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tokilopounds",
        "aria-label": 'Permalink to "toKilopounds <Badge type="tip" text="no setter" /> {#prop-tokilopounds}"'
      }, "​", -1))
    ]),
    _cache[106] || (_cache[106] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Mass" class="type-link">Mass</a> <span class="kw">get</span> <span class="fn">toKilopounds</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Mass</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toKilopounds </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(kilopounds).kilopounds;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_8, [
      _cache[23] || (_cache[23] = createTextVNode("toMegapounds ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[24] || (_cache[24] = createTextVNode()),
      _cache[25] || (_cache[25] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tomegapounds",
        "aria-label": 'Permalink to "toMegapounds <Badge type="tip" text="no setter" /> {#prop-tomegapounds}"'
      }, "​", -1))
    ]),
    _cache[107] || (_cache[107] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Mass" class="type-link">Mass</a> <span class="kw">get</span> <span class="fn">toMegapounds</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Mass</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toMegapounds </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(megapounds).megapounds;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_9, [
      _cache[26] || (_cache[26] = createTextVNode("toMicrograms ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[27] || (_cache[27] = createTextVNode()),
      _cache[28] || (_cache[28] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tomicrograms",
        "aria-label": 'Permalink to "toMicrograms <Badge type="tip" text="no setter" /> {#prop-tomicrograms}"'
      }, "​", -1))
    ]),
    _cache[108] || (_cache[108] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Mass" class="type-link">Mass</a> <span class="kw">get</span> <span class="fn">toMicrograms</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Mass</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toMicrograms </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(micrograms).micrograms;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_10, [
      _cache[29] || (_cache[29] = createTextVNode("toMilligrams ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[30] || (_cache[30] = createTextVNode()),
      _cache[31] || (_cache[31] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tomilligrams",
        "aria-label": 'Permalink to "toMilligrams <Badge type="tip" text="no setter" /> {#prop-tomilligrams}"'
      }, "​", -1))
    ]),
    _cache[109] || (_cache[109] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Mass" class="type-link">Mass</a> <span class="kw">get</span> <span class="fn">toMilligrams</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Mass</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toMilligrams </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(milligrams).milligrams;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_11, [
      _cache[32] || (_cache[32] = createTextVNode("toNanograms ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[33] || (_cache[33] = createTextVNode()),
      _cache[34] || (_cache[34] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tonanograms",
        "aria-label": 'Permalink to "toNanograms <Badge type="tip" text="no setter" /> {#prop-tonanograms}"'
      }, "​", -1))
    ]),
    _cache[110] || (_cache[110] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Mass" class="type-link">Mass</a> <span class="kw">get</span> <span class="fn">toNanograms</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Mass</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toNanograms </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(nanograms).nanograms;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_12, [
      _cache[35] || (_cache[35] = createTextVNode("toOunces ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[36] || (_cache[36] = createTextVNode()),
      _cache[37] || (_cache[37] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-toounces",
        "aria-label": 'Permalink to "toOunces <Badge type="tip" text="no setter" /> {#prop-toounces}"'
      }, "​", -1))
    ]),
    _cache[111] || (_cache[111] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Mass" class="type-link">Mass</a> <span class="kw">get</span> <span class="fn">toOunces</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Mass</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toOunces </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(ounces).ounces;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_13, [
      _cache[38] || (_cache[38] = createTextVNode("toPennyweights ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[39] || (_cache[39] = createTextVNode()),
      _cache[40] || (_cache[40] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-topennyweights",
        "aria-label": 'Permalink to "toPennyweights <Badge type="tip" text="no setter" /> {#prop-topennyweights}"'
      }, "​", -1))
    ]),
    _cache[112] || (_cache[112] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Mass" class="type-link">Mass</a> <span class="kw">get</span> <span class="fn">toPennyweights</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Mass</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toPennyweights </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(pennyweights).pennyweights;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_14, [
      _cache[41] || (_cache[41] = createTextVNode("toPounds ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[42] || (_cache[42] = createTextVNode()),
      _cache[43] || (_cache[43] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-topounds",
        "aria-label": 'Permalink to "toPounds <Badge type="tip" text="no setter" /> {#prop-topounds}"'
      }, "​", -1))
    ]),
    _cache[113] || (_cache[113] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Mass" class="type-link">Mass</a> <span class="kw">get</span> <span class="fn">toPounds</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Mass</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toPounds </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(pounds).pounds;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_15, [
      _cache[44] || (_cache[44] = createTextVNode("toStone ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[45] || (_cache[45] = createTextVNode()),
      _cache[46] || (_cache[46] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tostone",
        "aria-label": 'Permalink to "toStone <Badge type="tip" text="no setter" /> {#prop-tostone}"'
      }, "​", -1))
    ]),
    _cache[114] || (_cache[114] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Mass" class="type-link">Mass</a> <span class="kw">get</span> <span class="fn">toStone</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Mass</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toStone </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(stone).stone;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_16, [
      _cache[47] || (_cache[47] = createTextVNode("toTolas ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[48] || (_cache[48] = createTextVNode()),
      _cache[49] || (_cache[49] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-totolas",
        "aria-label": 'Permalink to "toTolas <Badge type="tip" text="no setter" /> {#prop-totolas}"'
      }, "​", -1))
    ]),
    _cache[115] || (_cache[115] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Mass" class="type-link">Mass</a> <span class="kw">get</span> <span class="fn">toTolas</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Mass</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toTolas </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(tolas).tolas;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_17, [
      _cache[50] || (_cache[50] = createTextVNode("toTonnes ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[51] || (_cache[51] = createTextVNode()),
      _cache[52] || (_cache[52] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-totonnes",
        "aria-label": 'Permalink to "toTonnes <Badge type="tip" text="no setter" /> {#prop-totonnes}"'
      }, "​", -1))
    ]),
    _cache[116] || (_cache[116] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Mass" class="type-link">Mass</a> <span class="kw">get</span> <span class="fn">toTonnes</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Mass</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toTonnes </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(tonnes).tonnes;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_18, [
      _cache[53] || (_cache[53] = createTextVNode("toTroyGrains ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[54] || (_cache[54] = createTextVNode()),
      _cache[55] || (_cache[55] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-totroygrains",
        "aria-label": 'Permalink to "toTroyGrains <Badge type="tip" text="no setter" /> {#prop-totroygrains}"'
      }, "​", -1))
    ]),
    _cache[117] || (_cache[117] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Mass" class="type-link">Mass</a> <span class="kw">get</span> <span class="fn">toTroyGrains</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Mass</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toTroyGrains </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(troyGrains).troyGrains;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_19, [
      _cache[56] || (_cache[56] = createTextVNode("toTroyOunces ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[57] || (_cache[57] = createTextVNode()),
      _cache[58] || (_cache[58] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-totroyounces",
        "aria-label": 'Permalink to "toTroyOunces <Badge type="tip" text="no setter" /> {#prop-totroyounces}"'
      }, "​", -1))
    ]),
    _cache[118] || (_cache[118] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Mass" class="type-link">Mass</a> <span class="kw">get</span> <span class="fn">toTroyOunces</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Mass</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toTroyOunces </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(troyOunces).troyOunces;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_20, [
      _cache[59] || (_cache[59] = createTextVNode("toTroyPounds ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[60] || (_cache[60] = createTextVNode()),
      _cache[61] || (_cache[61] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-totroypounds",
        "aria-label": 'Permalink to "toTroyPounds <Badge type="tip" text="no setter" /> {#prop-totroypounds}"'
      }, "​", -1))
    ]),
    _cache[119] || (_cache[119] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Mass" class="type-link">Mass</a> <span class="kw">get</span> <span class="fn">toTroyPounds</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Mass</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toTroyPounds </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(troyPounds).troyPounds;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_21, [
      _cache[62] || (_cache[62] = createTextVNode("unit ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[63] || (_cache[63] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[64] || (_cache[64] = createTextVNode()),
      _cache[65] || (_cache[65] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-unit",
        "aria-label": 'Permalink to "unit <Badge type="tip" text="final" /> <Badge type="info" text="inherited" /> {#prop-unit}"'
      }, "​", -1))
    ]),
    _cache[120] || (_cache[120] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <a href="./UnitOfMeasure" class="type-link">UnitOfMeasure</a>&lt;<a href="./Mass" class="type-link">Mass</a>&gt; <span class="fn">unit</span></code></pre></div><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> UnitOfMeasure</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; unit;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_22, [
      _cache[66] || (_cache[66] = createTextVNode("value ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[67] || (_cache[67] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[68] || (_cache[68] = createTextVNode()),
      _cache[69] || (_cache[69] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-value",
        "aria-label": 'Permalink to "value <Badge type="tip" text="final" /> <Badge type="info" text="inherited" /> {#prop-value}"'
      }, "​", -1))
    ]),
    _cache[121] || (_cache[121] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="type">double</span> <span class="fn">value</span></code></pre></div><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> double</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value;</span></span></code></pre></div></details><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 4)),
    createBaseVNode("h3", _hoisted_23, [
      _cache[70] || (_cache[70] = createTextVNode("equivalentTo() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[71] || (_cache[71] = createTextVNode()),
      _cache[72] || (_cache[72] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#equivalentto",
        "aria-label": 'Permalink to "equivalentTo() <Badge type="info" text="inherited" /> {#equivalentto}"'
      }, "​", -1))
    ]),
    _cache[122] || (_cache[122] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">equivalentTo</span>(<a href="./Quantity" class="type-link">Quantity</a>&lt;<a href="./Mass" class="type-link">Mass</a>&gt; <span class="param">other</span>)</code></pre></div><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> equivalentTo</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Quantity</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; other) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(unit) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_24, [
      _cache[73] || (_cache[73] = createTextVNode("noSuchMethod() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[74] || (_cache[74] = createTextVNode()),
      _cache[75] || (_cache[75] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#nosuchmethod",
        "aria-label": 'Permalink to "noSuchMethod() <Badge type="info" text="inherited" /> {#nosuchmethod}"'
      }, "​", -1))
    ]),
    _cache[123] || (_cache[123] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">dynamic</span> <span class="fn">noSuchMethod</span>(<span class="type">Invocation</span> <span class="param">invocation</span>)</code></pre></div><p>Invoked when a nonexistent method or property is accessed.</p><p>A dynamic member invocation can attempt to call a member which doesn&#39;t exist on the receiving object. Example:</p><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">dynamic</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> object </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">object.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">add</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">42</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">); </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">// Statically allowed, run-time error</span></span></code></pre></div><p>This invalid code will invoke the <code>noSuchMethod</code> method of the integer <code>1</code> with an <a href="https://api.dart.dev/stable/3.11.4/dart-core/Invocation-class.html" target="_blank" rel="noreferrer">Invocation</a> representing the <code>.add(42)</code> call and arguments (which then throws).</p><p>Classes can override <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object/noSuchMethod.html" target="_blank" rel="noreferrer">noSuchMethod</a> to provide custom behavior for such invalid dynamic invocations.</p><p>A class with a non-default <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object/noSuchMethod.html" target="_blank" rel="noreferrer">noSuchMethod</a> invocation can also omit implementations for members of its interface. Example:</p><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">class</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MockList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">implements</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> List</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; {</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">  noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Invocation</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> invocation) {</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    log</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(invocation);</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    super</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(invocation); </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">// Will throw.</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  }</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">void</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> main</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() {</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  MockList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">().</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">add</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">42</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div><p>This code has no compile-time warnings or errors even though the <code>MockList</code> class has no concrete implementation of any of the <code>List</code> interface methods. Calls to <code>List</code> methods are forwarded to <code>noSuchMethod</code>, so this code will <code>log</code> an invocation similar to <code>Invocation.method(#add, [42])</code> and then throw.</p><p>If a value is returned from <code>noSuchMethod</code>, it becomes the result of the original invocation. If the value is not of a type that can be returned by the original invocation, a type error occurs at the invocation.</p><p>The default behavior is to throw a <a href="https://api.dart.dev/stable/3.11.4/dart-core/NoSuchMethodError-class.html" target="_blank" rel="noreferrer">NoSuchMethodError</a>.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@pragma</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;vm:entry-point&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@pragma</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;wasm:entry-point&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> dynamic</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Invocation</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> invocation);</span></span></code></pre></div></details>', 13)),
    createBaseVNode("h3", _hoisted_25, [
      _cache[76] || (_cache[76] = createTextVNode("to() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[77] || (_cache[77] = createTextVNode()),
      _cache[78] || (_cache[78] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#to",
        "aria-label": 'Permalink to "to() <Badge type="info" text="inherited" /> {#to}"'
      }, "​", -1))
    ]),
    _cache[124] || (_cache[124] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">double</span> <span class="fn">to</span>(<a href="./UnitOfMeasure" class="type-link">UnitOfMeasure</a>&lt;<a href="./Mass" class="type-link">Mass</a>&gt; <span class="param">uom</span>)</code></pre></div><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">double</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">UnitOfMeasure</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; uom) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> uom </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> unit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> uom.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">convertTo</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(unit.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">convertFrom</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(value));</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_26, [
      _cache[79] || (_cache[79] = createTextVNode("toString() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[80] || (_cache[80] = createTextVNode()),
      _cache[81] || (_cache[81] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#tostring",
        "aria-label": 'Permalink to "toString() <Badge type="info" text="inherited" /> {#tostring}"'
      }, "​", -1))
    ]),
    _cache[125] || (_cache[125] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">String</span> <span class="fn">toString</span>()</code></pre></div><p>A string representation of this object.</p><p>Some classes have a default textual representation, often paired with a static <code>parse</code> function (like <a href="https://api.dart.dev/stable/3.11.4/dart-core/int/parse.html" target="_blank" rel="noreferrer">int.parse</a>). These classes will provide the textual representation as their string representation.</p><p>Other classes have no meaningful textual representation that a program will care about. Such classes will typically override <code>toString</code> to provide useful information when inspecting the object, mainly for debugging or logging.</p><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> toString</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">$</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">value</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> ${</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">unit</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">symbol</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">}</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span></code></pre></div></details><h2 id="section-operators" tabindex="-1">Operators <a class="header-anchor" href="#section-operators" aria-label="Permalink to &quot;Operators {#section-operators}&quot;">​</a></h2><h3 id="operator-multiply" tabindex="-1">operator *() <a class="header-anchor" href="#operator-multiply" aria-label="Permalink to &quot;operator *() {#operator-multiply}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Force" class="type-link">Force</a> <span class="fn">operator *</span>(<a href="./Acceleration" class="type-link">Acceleration</a> <span class="param">that</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Force</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> *</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Acceleration</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    Force</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">newtons</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(toKilograms.value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">*</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that.toMetersPerSecondSquared.value);</span></span></code></pre></div></details><h3 id="operator-plus" tabindex="-1">operator +() <a class="header-anchor" href="#operator-plus" aria-label="Permalink to &quot;operator +() {#operator-plus}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Mass" class="type-link">Mass</a> <span class="fn">operator +</span>(<a href="./Mass" class="type-link">Mass</a> <span class="param">that</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Mass</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> +</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Mass</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Mass</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">+</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(unit), unit);</span></span></code></pre></div></details><h3 id="operator-minus" tabindex="-1">operator -() <a class="header-anchor" href="#operator-minus" aria-label="Permalink to &quot;operator -() {#operator-minus}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Mass" class="type-link">Mass</a> <span class="fn">operator -</span>(<a href="./Mass" class="type-link">Mass</a> <span class="param">that</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Mass</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> -</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Mass</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Mass</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">-</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(unit), unit);</span></span></code></pre></div></details><h3 id="operator-divide" tabindex="-1">operator /() <a class="header-anchor" href="#operator-divide" aria-label="Permalink to &quot;operator /() {#operator-divide}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Density" class="type-link">Density</a> <span class="fn">operator /</span>(<a href="./Volume" class="type-link">Volume</a> <span class="param">that</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Density</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> &amp;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">#</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">47</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Volume</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    Density</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">kilogramsPerCubicMeter</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(toKilograms.value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&amp;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">#</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">47</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">; that.toCubicMeters.value);</span></span></code></pre></div></details>', 19)),
    createBaseVNode("h3", _hoisted_27, [
      _cache[82] || (_cache[82] = createTextVNode("operator <() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[83] || (_cache[83] = createTextVNode()),
      _cache[84] || (_cache[84] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#operator-less",
        "aria-label": 'Permalink to "operator \\<() <Badge type="info" text="inherited" /> {#operator-less}"'
      }, "​", -1))
    ]),
    _cache[126] || (_cache[126] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator &lt;</span>(<a href="./Mass" class="type-link">Mass</a> <span class="param">that</span>)</code></pre></div><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> &lt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(unit);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_28, [
      _cache[85] || (_cache[85] = createTextVNode("operator <=() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[86] || (_cache[86] = createTextVNode()),
      _cache[87] || (_cache[87] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#operator-less_equal",
        "aria-label": 'Permalink to "operator \\<=() <Badge type="info" text="inherited" /> {#operator-less_equal}"'
      }, "​", -1))
    ]),
    _cache[127] || (_cache[127] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator &lt;=</span>(<a href="./Mass" class="type-link">Mass</a> <span class="param">that</span>)</code></pre></div><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> &lt;=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(unit);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_29, [
      _cache[88] || (_cache[88] = createTextVNode("operator ==() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[89] || (_cache[89] = createTextVNode()),
      _cache[90] || (_cache[90] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#operator-equals",
        "aria-label": 'Permalink to "operator ==() <Badge type="info" text="inherited" /> {#operator-equals}"'
      }, "​", -1))
    ]),
    _cache[128] || (_cache[128] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator ==</span>(<span class="type">Object</span> <span class="param">other</span>)</code></pre></div><p>The equality operator.</p><p>The default behavior for all <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object-class.html" target="_blank" rel="noreferrer">Object</a>s is to return true if and only if this object and <code>other</code> are the same object.</p><p>Override this method to specify a different equality relation on a class. The overriding method must still be an equivalence relation. That is, it must be:</p><ul><li><p>Total: It must return a boolean for all arguments. It should never throw.</p></li><li><p>Reflexive: For all objects <code>o</code>, <code>o == o</code> must be true.</p></li><li><p>Symmetric: For all objects <code>o1</code> and <code>o2</code>, <code>o1 == o2</code> and <code>o2 == o1</code> must either both be true, or both be false.</p></li><li><p>Transitive: For all objects <code>o1</code>, <code>o2</code>, and <code>o3</code>, if <code>o1 == o2</code> and <code>o2 == o3</code> are true, then <code>o1 == o3</code> must be true.</p></li></ul><p>The method should also be consistent over time, so whether two objects are equal should only change if at least one of the objects was modified.</p><p>If a subclass overrides the equality operator, it should override the <a href="/ribs/api/package-ribs_units_ribs_units/Mass.html#prop-hashcode">hashCode</a> method as well to maintain consistency.</p><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> ==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Object</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    identical</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, other) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">||</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    (other </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">is</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Quantity</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&amp;&amp;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other.value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&amp;&amp;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other.unit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> unit);</span></span></code></pre></div></details>', 9)),
    createBaseVNode("h3", _hoisted_30, [
      _cache[91] || (_cache[91] = createTextVNode("operator >() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[92] || (_cache[92] = createTextVNode()),
      _cache[93] || (_cache[93] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#operator-greater",
        "aria-label": 'Permalink to "operator \\>() <Badge type="info" text="inherited" /> {#operator-greater}"'
      }, "​", -1))
    ]),
    _cache[129] || (_cache[129] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator &gt;</span>(<a href="./Mass" class="type-link">Mass</a> <span class="param">that</span>)</code></pre></div><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> &gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(unit);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_31, [
      _cache[94] || (_cache[94] = createTextVNode("operator >=() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[95] || (_cache[95] = createTextVNode()),
      _cache[96] || (_cache[96] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#operator-greater_equal",
        "aria-label": 'Permalink to "operator \\>=() <Badge type="info" text="inherited" /> {#operator-greater_equal}"'
      }, "​", -1))
    ]),
    _cache[130] || (_cache[130] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator &gt;=</span>(<a href="./Mass" class="type-link">Mass</a> <span class="param">that</span>)</code></pre></div><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> &gt;=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(unit);</span></span></code></pre></div></details><h2 id="section-static-methods" tabindex="-1">Static Methods <a class="header-anchor" href="#section-static-methods" aria-label="Permalink to &quot;Static Methods {#section-static-methods}&quot;">​</a></h2>', 4)),
    createBaseVNode("h3", _hoisted_32, [
      _cache[97] || (_cache[97] = createTextVNode("parse() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "override"
      }),
      _cache[98] || (_cache[98] = createTextVNode()),
      _cache[99] || (_cache[99] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#parse",
        "aria-label": 'Permalink to "parse() <Badge type="info" text="override" /> {#parse}"'
      }, "​", -1))
    ]),
    _cache[131] || (_cache[131] = createStaticVNode('<div class="member-signature"><pre><code><a href="../package-ribs_core_ribs_core/Option" class="type-link">Option</a>&lt;<a href="./Mass" class="type-link">Mass</a>&gt; <span class="fn">parse</span>(<span class="type">String</span> <span class="param">s</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Mass</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">parse</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> s) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Quantity</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">parse</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(s, units);</span></span></code></pre></div></details><h2 id="section-constants" tabindex="-1">Constants <a class="header-anchor" href="#section-constants" aria-label="Permalink to &quot;Constants {#section-constants}&quot;">​</a></h2><h3 id="prop-carats" tabindex="-1">carats <a class="header-anchor" href="#prop-carats" aria-label="Permalink to &quot;carats {#prop-carats}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./MassUnit" class="type-link">MassUnit</a> <span class="fn">carats</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MassUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> carats </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Carats</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-grams" tabindex="-1">grams <a class="header-anchor" href="#prop-grams" aria-label="Permalink to &quot;grams {#prop-grams}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./MassUnit" class="type-link">MassUnit</a> <span class="fn">grams</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MassUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> grams </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Grams</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-kilograms" tabindex="-1">kilograms <a class="header-anchor" href="#prop-kilograms" aria-label="Permalink to &quot;kilograms {#prop-kilograms}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./MassUnit" class="type-link">MassUnit</a> <span class="fn">kilograms</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MassUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> kilograms </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Kilograms</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-kilopounds" tabindex="-1">kilopounds <a class="header-anchor" href="#prop-kilopounds" aria-label="Permalink to &quot;kilopounds {#prop-kilopounds}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./MassUnit" class="type-link">MassUnit</a> <span class="fn">kilopounds</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MassUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> kilopounds </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Kilopounds</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-megapounds" tabindex="-1">megapounds <a class="header-anchor" href="#prop-megapounds" aria-label="Permalink to &quot;megapounds {#prop-megapounds}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./MassUnit" class="type-link">MassUnit</a> <span class="fn">megapounds</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MassUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> megapounds </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Megapounds</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-micrograms" tabindex="-1">micrograms <a class="header-anchor" href="#prop-micrograms" aria-label="Permalink to &quot;micrograms {#prop-micrograms}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./MassUnit" class="type-link">MassUnit</a> <span class="fn">micrograms</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MassUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> micrograms </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Micrograms</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-milligrams" tabindex="-1">milligrams <a class="header-anchor" href="#prop-milligrams" aria-label="Permalink to &quot;milligrams {#prop-milligrams}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./MassUnit" class="type-link">MassUnit</a> <span class="fn">milligrams</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MassUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> milligrams </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Milligrams</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-nanograms" tabindex="-1">nanograms <a class="header-anchor" href="#prop-nanograms" aria-label="Permalink to &quot;nanograms {#prop-nanograms}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./MassUnit" class="type-link">MassUnit</a> <span class="fn">nanograms</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MassUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> nanograms </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Nanograms</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-ounces" tabindex="-1">ounces <a class="header-anchor" href="#prop-ounces" aria-label="Permalink to &quot;ounces {#prop-ounces}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./MassUnit" class="type-link">MassUnit</a> <span class="fn">ounces</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MassUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> ounces </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Ounces</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-pennyweights" tabindex="-1">pennyweights <a class="header-anchor" href="#prop-pennyweights" aria-label="Permalink to &quot;pennyweights {#prop-pennyweights}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./MassUnit" class="type-link">MassUnit</a> <span class="fn">pennyweights</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MassUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> pennyweights </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Pennyweights</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-pounds" tabindex="-1">pounds <a class="header-anchor" href="#prop-pounds" aria-label="Permalink to &quot;pounds {#prop-pounds}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./MassUnit" class="type-link">MassUnit</a> <span class="fn">pounds</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MassUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> pounds </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Pounds</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-stone" tabindex="-1">stone <a class="header-anchor" href="#prop-stone" aria-label="Permalink to &quot;stone {#prop-stone}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./MassUnit" class="type-link">MassUnit</a> <span class="fn">stone</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MassUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> stone </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Stone</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-tolas" tabindex="-1">tolas <a class="header-anchor" href="#prop-tolas" aria-label="Permalink to &quot;tolas {#prop-tolas}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./MassUnit" class="type-link">MassUnit</a> <span class="fn">tolas</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MassUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> tolas </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Tolas</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-tonnes" tabindex="-1">tonnes <a class="header-anchor" href="#prop-tonnes" aria-label="Permalink to &quot;tonnes {#prop-tonnes}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./MassUnit" class="type-link">MassUnit</a> <span class="fn">tonnes</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MassUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> tonnes </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Tonnes</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-troygrains" tabindex="-1">troyGrains <a class="header-anchor" href="#prop-troygrains" aria-label="Permalink to &quot;troyGrains {#prop-troygrains}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./MassUnit" class="type-link">MassUnit</a> <span class="fn">troyGrains</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MassUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> troyGrains </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> TroyGrains</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-troyounces" tabindex="-1">troyOunces <a class="header-anchor" href="#prop-troyounces" aria-label="Permalink to &quot;troyOunces {#prop-troyounces}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./MassUnit" class="type-link">MassUnit</a> <span class="fn">troyOunces</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MassUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> troyOunces </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> TroyOunces</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-troypounds" tabindex="-1">troyPounds <a class="header-anchor" href="#prop-troypounds" aria-label="Permalink to &quot;troyPounds {#prop-troypounds}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./MassUnit" class="type-link">MassUnit</a> <span class="fn">troyPounds</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MassUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> troyPounds </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> TroyPounds</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-units" tabindex="-1">units <a class="header-anchor" href="#prop-units" aria-label="Permalink to &quot;units {#prop-units}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <span class="type">Set</span>&lt;<a href="./MassUnit" class="type-link">MassUnit</a>&gt; <span class="fn">units</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> units </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> {</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  grams,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  nanograms,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  micrograms,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  milligrams,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  kilograms,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  tonnes,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  ounces,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  pounds,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  kilopounds,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  megapounds,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  stone,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  troyGrains,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  pennyweights,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  troyOunces,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  troyPounds,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  tolas,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  carats,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">};</span></span></code></pre></div></details>', 57))
  ]);
}
const Mass = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  Mass as default
};
