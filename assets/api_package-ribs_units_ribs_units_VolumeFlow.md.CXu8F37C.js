import { r as resolveComponent, o as openBlock, c as createElementBlock, a as createBaseVNode, b as createTextVNode, d as createVNode, e as createStaticVNode, _ as _export_sfc } from "./app.44rpi9gM.js";
const __pageData = JSON.parse('{"title":"VolumeFlow","description":"API documentation for VolumeFlow class from ribs_units","frontmatter":{"title":"VolumeFlow","description":"API documentation for VolumeFlow class from ribs_units","category":"Classes","library":"ribs_units","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_units_ribs_units/VolumeFlow.md","filePath":"api/package-ribs_units_ribs_units/VolumeFlow.md"}');
const _sfc_main = { name: "api/package-ribs_units_ribs_units/VolumeFlow.md" };
const _hoisted_1 = {
  id: "volumeflow",
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
  id: "prop-tocubicfeetperminute",
  tabindex: "-1"
};
const _hoisted_5 = {
  id: "prop-tocubicfeetpersecond",
  tabindex: "-1"
};
const _hoisted_6 = {
  id: "prop-tocubicmeterspersecond",
  tabindex: "-1"
};
const _hoisted_7 = {
  id: "prop-togallonsperminute",
  tabindex: "-1"
};
const _hoisted_8 = {
  id: "prop-tolitersperhour",
  tabindex: "-1"
};
const _hoisted_9 = {
  id: "prop-tolitersperminute",
  tabindex: "-1"
};
const _hoisted_10 = {
  id: "prop-toliterspersecond",
  tabindex: "-1"
};
const _hoisted_11 = {
  id: "prop-tomicroliterspersecond",
  tabindex: "-1"
};
const _hoisted_12 = {
  id: "prop-tomillilitersperhour",
  tabindex: "-1"
};
const _hoisted_13 = {
  id: "prop-tomillilitersperminute",
  tabindex: "-1"
};
const _hoisted_14 = {
  id: "prop-tomilliliterspersecond",
  tabindex: "-1"
};
const _hoisted_15 = {
  id: "prop-tonanoliterspersecond",
  tabindex: "-1"
};
const _hoisted_16 = {
  id: "prop-unit",
  tabindex: "-1"
};
const _hoisted_17 = {
  id: "prop-value",
  tabindex: "-1"
};
const _hoisted_18 = {
  id: "equivalentto",
  tabindex: "-1"
};
const _hoisted_19 = {
  id: "nosuchmethod",
  tabindex: "-1"
};
const _hoisted_20 = {
  id: "to",
  tabindex: "-1"
};
const _hoisted_21 = {
  id: "tostring",
  tabindex: "-1"
};
const _hoisted_22 = {
  id: "operator-less",
  tabindex: "-1"
};
const _hoisted_23 = {
  id: "operator-less_equal",
  tabindex: "-1"
};
const _hoisted_24 = {
  id: "operator-equals",
  tabindex: "-1"
};
const _hoisted_25 = {
  id: "operator-greater",
  tabindex: "-1"
};
const _hoisted_26 = {
  id: "operator-greater_equal",
  tabindex: "-1"
};
const _hoisted_27 = {
  id: "parse",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    createBaseVNode("h1", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("VolumeFlow ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "final"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#volumeflow",
        "aria-label": 'Permalink to "VolumeFlow <Badge type="info" text="final" />"'
      }, "​", -1))
    ]),
    _cache[85] || (_cache[85] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="kw">class</span> <span class="fn">VolumeFlow</span> <span class="kw">extends</span> <a href="./Quantity" class="type-link">Quantity</a>&lt;<a href="./VolumeFlow" class="type-link">VolumeFlow</a>&gt;</code></pre></div><p>A quantity representing volumetric flow rate (volume per unit time).</p><div class="info custom-block"><p class="custom-block-title">Inheritance</p><p>Object → <a href="/ribs/api/package-ribs_units_ribs_units/Quantity.html">Quantity&lt;A extends Quantity&lt;A&gt;&gt;</a> → <strong>VolumeFlow</strong></p></div><h2 id="section-constructors" tabindex="-1">Constructors <a class="header-anchor" href="#section-constructors" aria-label="Permalink to &quot;Constructors {#section-constructors}&quot;">​</a></h2><h3 id="ctor-volumeflow" tabindex="-1">VolumeFlow() <a class="header-anchor" href="#ctor-volumeflow" aria-label="Permalink to &quot;VolumeFlow() {#ctor-volumeflow}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="fn">VolumeFlow</span>(<span class="type">double</span> <span class="param">value</span>, <a href="./UnitOfMeasure" class="type-link">UnitOfMeasure</a>&lt;<a href="./VolumeFlow" class="type-link">VolumeFlow</a>&gt; <span class="param">unit</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">VolumeFlow</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">super</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.value, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">super</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.unit);</span></span></code></pre></div></details><h2 id="section-properties" tabindex="-1">Properties <a class="header-anchor" href="#section-properties" aria-label="Permalink to &quot;Properties {#section-properties}&quot;">​</a></h2>', 8)),
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
    _cache[86] || (_cache[86] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></code></pre></div><p>The hash code for this object.</p><p>A hash code is a single integer which represents the state of the object that affects <a href="/ribs/api/package-ribs_units_ribs_units/VolumeFlow.html#operator-equals">operator ==</a> comparisons.</p><p>All objects have hash codes. The default hash code implemented by <a href="https://api.dart.dev/stable/3.11.5/dart-core/Object-class.html" target="_blank" rel="noreferrer">Object</a> represents only the identity of the object, the same way as the default <a href="/ribs/api/package-ribs_units_ribs_units/VolumeFlow.html#operator-equals">operator ==</a> implementation only considers objects equal if they are identical (see <a href="https://api.dart.dev/stable/3.11.5/dart-core/identityHashCode.html" target="_blank" rel="noreferrer">identityHashCode</a>).</p><p>If <a href="/ribs/api/package-ribs_units_ribs_units/VolumeFlow.html#operator-equals">operator ==</a> is overridden to use the object state instead, the hash code must also be changed to represent that state, otherwise the object cannot be used in hash based data structures like the default <a href="https://api.dart.dev/stable/3.11.5/dart-core/Set-class.html" target="_blank" rel="noreferrer">Set</a> and <a href="https://api.dart.dev/stable/3.11.5/dart-core/Map-class.html" target="_blank" rel="noreferrer">Map</a> implementations.</p><p>Hash codes must be the same for objects that are equal to each other according to <a href="/ribs/api/package-ribs_units_ribs_units/VolumeFlow.html#operator-equals">operator ==</a>. The hash code of an object should only change if the object changes in a way that affects equality. There are no further requirements for the hash codes. They need not be consistent between executions of the same program and there are no distribution guarantees.</p><p>Objects that are not equal are allowed to have the same hash code. It is even technically allowed that all instances have the same hash code, but if clashes happen too often, it may reduce the efficiency of hash-based data structures like <a href="https://api.dart.dev/stable/3.11.5/dart-collection/HashSet-class.html" target="_blank" rel="noreferrer">HashSet</a> or <a href="https://api.dart.dev/stable/3.11.5/dart-collection/HashMap-class.html" target="_blank" rel="noreferrer">HashMap</a>.</p><p>If a subclass overrides <a href="/ribs/api/package-ribs_units_ribs_units/VolumeFlow.html#prop-hashcode">hashCode</a>, it should override the <a href="/ribs/api/package-ribs_units_ribs_units/VolumeFlow.html#operator-equals">operator ==</a> operator as well to maintain consistency.</p><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> hashCode </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Object</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">hash</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(value, unit);</span></span></code></pre></div></details>', 10)),
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
    _cache[87] || (_cache[87] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">Type</span> <span class="kw">get</span> <span class="fn">runtimeType</span></code></pre></div><p>A representation of the runtime type of the object.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Type</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> runtimeType;</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_4, [
      _cache[11] || (_cache[11] = createTextVNode("toCubicFeetPerMinute ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[12] || (_cache[12] = createTextVNode()),
      _cache[13] || (_cache[13] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tocubicfeetperminute",
        "aria-label": 'Permalink to "toCubicFeetPerMinute <Badge type="tip" text="no setter" /> {#prop-tocubicfeetperminute}"'
      }, "​", -1))
    ]),
    _cache[88] || (_cache[88] = createStaticVNode('<div class="member-signature"><pre><code><a href="./VolumeFlow" class="type-link">VolumeFlow</a> <span class="kw">get</span> <span class="fn">toCubicFeetPerMinute</span></code></pre></div><p>Converts this to cubic feet per minute (ft³/min).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">VolumeFlow</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toCubicFeetPerMinute </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(cubicFeetPerMinute).cubicFeetPerMinute;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_5, [
      _cache[14] || (_cache[14] = createTextVNode("toCubicFeetPerSecond ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[15] || (_cache[15] = createTextVNode()),
      _cache[16] || (_cache[16] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tocubicfeetpersecond",
        "aria-label": 'Permalink to "toCubicFeetPerSecond <Badge type="tip" text="no setter" /> {#prop-tocubicfeetpersecond}"'
      }, "​", -1))
    ]),
    _cache[89] || (_cache[89] = createStaticVNode('<div class="member-signature"><pre><code><a href="./VolumeFlow" class="type-link">VolumeFlow</a> <span class="kw">get</span> <span class="fn">toCubicFeetPerSecond</span></code></pre></div><p>Converts this to cubic feet per second (ft³/s).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">VolumeFlow</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toCubicFeetPerSecond </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(cubicFeetPerSecond).cubicFeetPerSecond;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_6, [
      _cache[17] || (_cache[17] = createTextVNode("toCubicMetersPerSecond ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[18] || (_cache[18] = createTextVNode()),
      _cache[19] || (_cache[19] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tocubicmeterspersecond",
        "aria-label": 'Permalink to "toCubicMetersPerSecond <Badge type="tip" text="no setter" /> {#prop-tocubicmeterspersecond}"'
      }, "​", -1))
    ]),
    _cache[90] || (_cache[90] = createStaticVNode('<div class="member-signature"><pre><code><a href="./VolumeFlow" class="type-link">VolumeFlow</a> <span class="kw">get</span> <span class="fn">toCubicMetersPerSecond</span></code></pre></div><p>Converts this to cubic meters per second (m³/s).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">VolumeFlow</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toCubicMetersPerSecond </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(cubicMetersPerSecond).cubicMetersPerSecond;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_7, [
      _cache[20] || (_cache[20] = createTextVNode("toGallonsPerMinute ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[21] || (_cache[21] = createTextVNode()),
      _cache[22] || (_cache[22] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-togallonsperminute",
        "aria-label": 'Permalink to "toGallonsPerMinute <Badge type="tip" text="no setter" /> {#prop-togallonsperminute}"'
      }, "​", -1))
    ]),
    _cache[91] || (_cache[91] = createStaticVNode('<div class="member-signature"><pre><code><a href="./VolumeFlow" class="type-link">VolumeFlow</a> <span class="kw">get</span> <span class="fn">toGallonsPerMinute</span></code></pre></div><p>Converts this to gallons per minute (gal/min).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">VolumeFlow</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toGallonsPerMinute </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(gallonsPerMinute).gallonsPerMinute;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_8, [
      _cache[23] || (_cache[23] = createTextVNode("toLitersPerHour ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[24] || (_cache[24] = createTextVNode()),
      _cache[25] || (_cache[25] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tolitersperhour",
        "aria-label": 'Permalink to "toLitersPerHour <Badge type="tip" text="no setter" /> {#prop-tolitersperhour}"'
      }, "​", -1))
    ]),
    _cache[92] || (_cache[92] = createStaticVNode('<div class="member-signature"><pre><code><a href="./VolumeFlow" class="type-link">VolumeFlow</a> <span class="kw">get</span> <span class="fn">toLitersPerHour</span></code></pre></div><p>Converts this to liters per hour (L/h).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">VolumeFlow</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toLitersPerHour </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(litersPerHour).litersPerHour;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_9, [
      _cache[26] || (_cache[26] = createTextVNode("toLitersPerMinute ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[27] || (_cache[27] = createTextVNode()),
      _cache[28] || (_cache[28] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tolitersperminute",
        "aria-label": 'Permalink to "toLitersPerMinute <Badge type="tip" text="no setter" /> {#prop-tolitersperminute}"'
      }, "​", -1))
    ]),
    _cache[93] || (_cache[93] = createStaticVNode('<div class="member-signature"><pre><code><a href="./VolumeFlow" class="type-link">VolumeFlow</a> <span class="kw">get</span> <span class="fn">toLitersPerMinute</span></code></pre></div><p>Converts this to liters per minute (L/min).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">VolumeFlow</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toLitersPerMinute </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(litersPerMinute).litersPerMinute;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_10, [
      _cache[29] || (_cache[29] = createTextVNode("toLitersPerSecond ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[30] || (_cache[30] = createTextVNode()),
      _cache[31] || (_cache[31] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-toliterspersecond",
        "aria-label": 'Permalink to "toLitersPerSecond <Badge type="tip" text="no setter" /> {#prop-toliterspersecond}"'
      }, "​", -1))
    ]),
    _cache[94] || (_cache[94] = createStaticVNode('<div class="member-signature"><pre><code><a href="./VolumeFlow" class="type-link">VolumeFlow</a> <span class="kw">get</span> <span class="fn">toLitersPerSecond</span></code></pre></div><p>Converts this to liters per second (L/s).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">VolumeFlow</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toLitersPerSecond </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(litersPerSecond).litersPerSecond;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_11, [
      _cache[32] || (_cache[32] = createTextVNode("toMicrolitersPerSecond ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[33] || (_cache[33] = createTextVNode()),
      _cache[34] || (_cache[34] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tomicroliterspersecond",
        "aria-label": 'Permalink to "toMicrolitersPerSecond <Badge type="tip" text="no setter" /> {#prop-tomicroliterspersecond}"'
      }, "​", -1))
    ]),
    _cache[95] || (_cache[95] = createStaticVNode('<div class="member-signature"><pre><code><a href="./VolumeFlow" class="type-link">VolumeFlow</a> <span class="kw">get</span> <span class="fn">toMicrolitersPerSecond</span></code></pre></div><p>Converts this to microliters per second (µL/s).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">VolumeFlow</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toMicrolitersPerSecond </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(microlitersPerSecond).microlitersPerSecond;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_12, [
      _cache[35] || (_cache[35] = createTextVNode("toMillilitersPerHour ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[36] || (_cache[36] = createTextVNode()),
      _cache[37] || (_cache[37] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tomillilitersperhour",
        "aria-label": 'Permalink to "toMillilitersPerHour <Badge type="tip" text="no setter" /> {#prop-tomillilitersperhour}"'
      }, "​", -1))
    ]),
    _cache[96] || (_cache[96] = createStaticVNode('<div class="member-signature"><pre><code><a href="./VolumeFlow" class="type-link">VolumeFlow</a> <span class="kw">get</span> <span class="fn">toMillilitersPerHour</span></code></pre></div><p>Converts this to milliliters per hour (mL/h).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">VolumeFlow</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toMillilitersPerHour </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(millilitersPerHour).millilitersPerHour;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_13, [
      _cache[38] || (_cache[38] = createTextVNode("toMillilitersPerMinute ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[39] || (_cache[39] = createTextVNode()),
      _cache[40] || (_cache[40] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tomillilitersperminute",
        "aria-label": 'Permalink to "toMillilitersPerMinute <Badge type="tip" text="no setter" /> {#prop-tomillilitersperminute}"'
      }, "​", -1))
    ]),
    _cache[97] || (_cache[97] = createStaticVNode('<div class="member-signature"><pre><code><a href="./VolumeFlow" class="type-link">VolumeFlow</a> <span class="kw">get</span> <span class="fn">toMillilitersPerMinute</span></code></pre></div><p>Converts this to milliliters per minute (mL/min).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">VolumeFlow</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toMillilitersPerMinute </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(millilitersPerMinute).millilitersPerMinute;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_14, [
      _cache[41] || (_cache[41] = createTextVNode("toMillilitersPerSecond ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[42] || (_cache[42] = createTextVNode()),
      _cache[43] || (_cache[43] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tomilliliterspersecond",
        "aria-label": 'Permalink to "toMillilitersPerSecond <Badge type="tip" text="no setter" /> {#prop-tomilliliterspersecond}"'
      }, "​", -1))
    ]),
    _cache[98] || (_cache[98] = createStaticVNode('<div class="member-signature"><pre><code><a href="./VolumeFlow" class="type-link">VolumeFlow</a> <span class="kw">get</span> <span class="fn">toMillilitersPerSecond</span></code></pre></div><p>Converts this to milliliters per second (mL/s).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">VolumeFlow</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toMillilitersPerSecond </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(millilitersPerSecond).millilitersPerSecond;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_15, [
      _cache[44] || (_cache[44] = createTextVNode("toNanolitersPerSecond ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[45] || (_cache[45] = createTextVNode()),
      _cache[46] || (_cache[46] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tonanoliterspersecond",
        "aria-label": 'Permalink to "toNanolitersPerSecond <Badge type="tip" text="no setter" /> {#prop-tonanoliterspersecond}"'
      }, "​", -1))
    ]),
    _cache[99] || (_cache[99] = createStaticVNode('<div class="member-signature"><pre><code><a href="./VolumeFlow" class="type-link">VolumeFlow</a> <span class="kw">get</span> <span class="fn">toNanolitersPerSecond</span></code></pre></div><p>Converts this to nanoliters per second (nL/s).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">VolumeFlow</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toNanolitersPerSecond </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(nanolitersPerSecond).nanolitersPerSecond;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_16, [
      _cache[47] || (_cache[47] = createTextVNode("unit ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[48] || (_cache[48] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[49] || (_cache[49] = createTextVNode()),
      _cache[50] || (_cache[50] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-unit",
        "aria-label": 'Permalink to "unit <Badge type="tip" text="final" /> <Badge type="info" text="inherited" /> {#prop-unit}"'
      }, "​", -1))
    ]),
    _cache[100] || (_cache[100] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <a href="./UnitOfMeasure" class="type-link">UnitOfMeasure</a>&lt;<a href="./VolumeFlow" class="type-link">VolumeFlow</a>&gt; <span class="fn">unit</span></code></pre></div><p>The unit of measure that <a href="/ribs/api/package-ribs_units_ribs_units/Quantity.html#prop-value">value</a> is expressed in.</p><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> UnitOfMeasure</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; unit;</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_17, [
      _cache[51] || (_cache[51] = createTextVNode("value ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[52] || (_cache[52] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[53] || (_cache[53] = createTextVNode()),
      _cache[54] || (_cache[54] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-value",
        "aria-label": 'Permalink to "value <Badge type="tip" text="final" /> <Badge type="info" text="inherited" /> {#prop-value}"'
      }, "​", -1))
    ]),
    _cache[101] || (_cache[101] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="type">double</span> <span class="fn">value</span></code></pre></div><p>The raw numeric value of this quantity expressed in <a href="/ribs/api/package-ribs_units_ribs_units/Quantity.html#prop-unit">unit</a>.</p><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> double</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value;</span></span></code></pre></div></details><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 5)),
    createBaseVNode("h3", _hoisted_18, [
      _cache[55] || (_cache[55] = createTextVNode("equivalentTo() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[56] || (_cache[56] = createTextVNode()),
      _cache[57] || (_cache[57] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#equivalentto",
        "aria-label": 'Permalink to "equivalentTo() <Badge type="info" text="inherited" /> {#equivalentto}"'
      }, "​", -1))
    ]),
    _cache[102] || (_cache[102] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">equivalentTo</span>(<a href="./Quantity" class="type-link">Quantity</a>&lt;<a href="./VolumeFlow" class="type-link">VolumeFlow</a>&gt; <span class="param">other</span>)</code></pre></div><p>Returns true if this quantity represents the same physical magnitude as <code>other</code>, regardless of which unit each is expressed in.</p><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> equivalentTo</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Quantity</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; other) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(unit) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value;</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_19, [
      _cache[58] || (_cache[58] = createTextVNode("noSuchMethod() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[59] || (_cache[59] = createTextVNode()),
      _cache[60] || (_cache[60] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#nosuchmethod",
        "aria-label": 'Permalink to "noSuchMethod() <Badge type="info" text="inherited" /> {#nosuchmethod}"'
      }, "​", -1))
    ]),
    _cache[103] || (_cache[103] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">dynamic</span> <span class="fn">noSuchMethod</span>(<span class="type">Invocation</span> <span class="param">invocation</span>)</code></pre></div><p>Invoked when a nonexistent method or property is accessed.</p><p>A dynamic member invocation can attempt to call a member which doesn&#39;t exist on the receiving object. Example:</p><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">dynamic</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> object </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">object.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">add</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">42</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">); </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">// Statically allowed, run-time error</span></span></code></pre></div><p>This invalid code will invoke the <code>noSuchMethod</code> method of the integer <code>1</code> with an <a href="https://api.dart.dev/stable/3.11.5/dart-core/Invocation-class.html" target="_blank" rel="noreferrer">Invocation</a> representing the <code>.add(42)</code> call and arguments (which then throws).</p><p>Classes can override <a href="https://api.dart.dev/stable/3.11.5/dart-core/Object/noSuchMethod.html" target="_blank" rel="noreferrer">noSuchMethod</a> to provide custom behavior for such invalid dynamic invocations.</p><p>A class with a non-default <a href="https://api.dart.dev/stable/3.11.5/dart-core/Object/noSuchMethod.html" target="_blank" rel="noreferrer">noSuchMethod</a> invocation can also omit implementations for members of its interface. Example:</p><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">class</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MockList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">implements</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> List</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; {</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">  noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Invocation</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> invocation) {</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    log</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(invocation);</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    super</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(invocation); </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">// Will throw.</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  }</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">void</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> main</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() {</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  MockList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">().</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">add</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">42</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div><p>This code has no compile-time warnings or errors even though the <code>MockList</code> class has no concrete implementation of any of the <code>List</code> interface methods. Calls to <code>List</code> methods are forwarded to <code>noSuchMethod</code>, so this code will <code>log</code> an invocation similar to <code>Invocation.method(#add, [42])</code> and then throw.</p><p>If a value is returned from <code>noSuchMethod</code>, it becomes the result of the original invocation. If the value is not of a type that can be returned by the original invocation, a type error occurs at the invocation.</p><p>The default behavior is to throw a <a href="https://api.dart.dev/stable/3.11.5/dart-core/NoSuchMethodError-class.html" target="_blank" rel="noreferrer">NoSuchMethodError</a>.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@pragma</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;vm:entry-point&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@pragma</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;wasm:entry-point&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> dynamic</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Invocation</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> invocation);</span></span></code></pre></div></details>', 13)),
    createBaseVNode("h3", _hoisted_20, [
      _cache[61] || (_cache[61] = createTextVNode("to() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[62] || (_cache[62] = createTextVNode()),
      _cache[63] || (_cache[63] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#to",
        "aria-label": 'Permalink to "to() <Badge type="info" text="inherited" /> {#to}"'
      }, "​", -1))
    ]),
    _cache[104] || (_cache[104] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">double</span> <span class="fn">to</span>(<a href="./UnitOfMeasure" class="type-link">UnitOfMeasure</a>&lt;<a href="./VolumeFlow" class="type-link">VolumeFlow</a>&gt; <span class="param">uom</span>)</code></pre></div><p>Converts this quantity to <code>uom</code> and returns the raw <a href="https://api.dart.dev/stable/3.11.5/dart-core/double-class.html" target="_blank" rel="noreferrer">double</a> value.</p><p>If <code>uom</code> equals <a href="/ribs/api/package-ribs_units_ribs_units/Quantity.html#prop-unit">unit</a>, the current <a href="/ribs/api/package-ribs_units_ribs_units/Quantity.html#prop-value">value</a> is returned unchanged.</p><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">double</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">UnitOfMeasure</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; uom) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> uom </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> unit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> uom.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">convertTo</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(unit.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">convertFrom</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(value));</span></span></code></pre></div></details>', 5)),
    createBaseVNode("h3", _hoisted_21, [
      _cache[64] || (_cache[64] = createTextVNode("toString() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[65] || (_cache[65] = createTextVNode()),
      _cache[66] || (_cache[66] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#tostring",
        "aria-label": 'Permalink to "toString() <Badge type="info" text="inherited" /> {#tostring}"'
      }, "​", -1))
    ]),
    _cache[105] || (_cache[105] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">String</span> <span class="fn">toString</span>()</code></pre></div><p>A string representation of this object.</p><p>Some classes have a default textual representation, often paired with a static <code>parse</code> function (like <a href="https://api.dart.dev/stable/3.11.5/dart-core/int/parse.html" target="_blank" rel="noreferrer">int.parse</a>). These classes will provide the textual representation as their string representation.</p><p>Other classes have no meaningful textual representation that a program will care about. Such classes will typically override <code>toString</code> to provide useful information when inspecting the object, mainly for debugging or logging.</p><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> toString</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">$</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">value</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> ${</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">unit</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">symbol</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">}</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span></code></pre></div></details><h2 id="section-operators" tabindex="-1">Operators <a class="header-anchor" href="#section-operators" aria-label="Permalink to &quot;Operators {#section-operators}&quot;">​</a></h2><h3 id="operator-plus" tabindex="-1">operator +() <a class="header-anchor" href="#operator-plus" aria-label="Permalink to &quot;operator +() {#operator-plus}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./VolumeFlow" class="type-link">VolumeFlow</a> <span class="fn">operator +</span>(<a href="./VolumeFlow" class="type-link">VolumeFlow</a> <span class="param">that</span>)</code></pre></div><p>Returns the sum of this and <code>that</code> in the units of this <a href="/ribs/api/package-ribs_units_ribs_units/VolumeFlow.html">VolumeFlow</a>.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">VolumeFlow</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> +</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">VolumeFlow</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> VolumeFlow</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">+</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(unit), unit);</span></span></code></pre></div></details><h3 id="operator-minus" tabindex="-1">operator -() <a class="header-anchor" href="#operator-minus" aria-label="Permalink to &quot;operator -() {#operator-minus}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./VolumeFlow" class="type-link">VolumeFlow</a> <span class="fn">operator -</span>(<a href="./VolumeFlow" class="type-link">VolumeFlow</a> <span class="param">that</span>)</code></pre></div><p>Returns the difference between this and <code>that</code> in the units of this <a href="/ribs/api/package-ribs_units_ribs_units/VolumeFlow.html">VolumeFlow</a>.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">VolumeFlow</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> -</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">VolumeFlow</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> VolumeFlow</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">-</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(unit), unit);</span></span></code></pre></div></details>', 15)),
    createBaseVNode("h3", _hoisted_22, [
      _cache[67] || (_cache[67] = createTextVNode("operator <() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[68] || (_cache[68] = createTextVNode()),
      _cache[69] || (_cache[69] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#operator-less",
        "aria-label": 'Permalink to "operator \\<() <Badge type="info" text="inherited" /> {#operator-less}"'
      }, "​", -1))
    ]),
    _cache[106] || (_cache[106] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator &lt;</span>(<a href="./VolumeFlow" class="type-link">VolumeFlow</a> <span class="param">that</span>)</code></pre></div><p>Returns true if this quantity is less than <code>that</code>.</p><p><code>that</code> is converted to <a href="/ribs/api/package-ribs_units_ribs_units/Quantity.html#prop-unit">unit</a> before comparing.</p><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> &lt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(unit);</span></span></code></pre></div></details>', 5)),
    createBaseVNode("h3", _hoisted_23, [
      _cache[70] || (_cache[70] = createTextVNode("operator <=() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[71] || (_cache[71] = createTextVNode()),
      _cache[72] || (_cache[72] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#operator-less_equal",
        "aria-label": 'Permalink to "operator \\<=() <Badge type="info" text="inherited" /> {#operator-less_equal}"'
      }, "​", -1))
    ]),
    _cache[107] || (_cache[107] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator &lt;=</span>(<a href="./VolumeFlow" class="type-link">VolumeFlow</a> <span class="param">that</span>)</code></pre></div><p>Returns true if this quantity is less than or equal to <code>that</code>.</p><p><code>that</code> is converted to <a href="/ribs/api/package-ribs_units_ribs_units/Quantity.html#prop-unit">unit</a> before comparing.</p><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> &lt;=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(unit);</span></span></code></pre></div></details>', 5)),
    createBaseVNode("h3", _hoisted_24, [
      _cache[73] || (_cache[73] = createTextVNode("operator ==() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[74] || (_cache[74] = createTextVNode()),
      _cache[75] || (_cache[75] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#operator-equals",
        "aria-label": 'Permalink to "operator ==() <Badge type="info" text="inherited" /> {#operator-equals}"'
      }, "​", -1))
    ]),
    _cache[108] || (_cache[108] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator ==</span>(<span class="type">Object</span> <span class="param">other</span>)</code></pre></div><p>The equality operator.</p><p>The default behavior for all <a href="https://api.dart.dev/stable/3.11.5/dart-core/Object-class.html" target="_blank" rel="noreferrer">Object</a>s is to return true if and only if this object and <code>other</code> are the same object.</p><p>Override this method to specify a different equality relation on a class. The overriding method must still be an equivalence relation. That is, it must be:</p><ul><li><p>Total: It must return a boolean for all arguments. It should never throw.</p></li><li><p>Reflexive: For all objects <code>o</code>, <code>o == o</code> must be true.</p></li><li><p>Symmetric: For all objects <code>o1</code> and <code>o2</code>, <code>o1 == o2</code> and <code>o2 == o1</code> must either both be true, or both be false.</p></li><li><p>Transitive: For all objects <code>o1</code>, <code>o2</code>, and <code>o3</code>, if <code>o1 == o2</code> and <code>o2 == o3</code> are true, then <code>o1 == o3</code> must be true.</p></li></ul><p>The method should also be consistent over time, so whether two objects are equal should only change if at least one of the objects was modified.</p><p>If a subclass overrides the equality operator, it should override the <a href="/ribs/api/package-ribs_units_ribs_units/VolumeFlow.html#prop-hashcode">hashCode</a> method as well to maintain consistency.</p><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> ==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Object</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    identical</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, other) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">||</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    (other </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">is</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Quantity</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&amp;&amp;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other.value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&amp;&amp;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other.unit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> unit);</span></span></code></pre></div></details>', 9)),
    createBaseVNode("h3", _hoisted_25, [
      _cache[76] || (_cache[76] = createTextVNode("operator >() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[77] || (_cache[77] = createTextVNode()),
      _cache[78] || (_cache[78] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#operator-greater",
        "aria-label": 'Permalink to "operator \\>() <Badge type="info" text="inherited" /> {#operator-greater}"'
      }, "​", -1))
    ]),
    _cache[109] || (_cache[109] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator &gt;</span>(<a href="./VolumeFlow" class="type-link">VolumeFlow</a> <span class="param">that</span>)</code></pre></div><p>Returns true if this quantity is greater than <code>that</code>.</p><p><code>that</code> is converted to <a href="/ribs/api/package-ribs_units_ribs_units/Quantity.html#prop-unit">unit</a> before comparing.</p><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> &gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(unit);</span></span></code></pre></div></details>', 5)),
    createBaseVNode("h3", _hoisted_26, [
      _cache[79] || (_cache[79] = createTextVNode("operator >=() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[80] || (_cache[80] = createTextVNode()),
      _cache[81] || (_cache[81] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#operator-greater_equal",
        "aria-label": 'Permalink to "operator \\>=() <Badge type="info" text="inherited" /> {#operator-greater_equal}"'
      }, "​", -1))
    ]),
    _cache[110] || (_cache[110] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator &gt;=</span>(<a href="./VolumeFlow" class="type-link">VolumeFlow</a> <span class="param">that</span>)</code></pre></div><p>Returns true if this quantity is greater than or equal to <code>that</code>.</p><p><code>that</code> is converted to <a href="/ribs/api/package-ribs_units_ribs_units/Quantity.html#prop-unit">unit</a> before comparing.</p><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> &gt;=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(unit);</span></span></code></pre></div></details><h2 id="section-static-methods" tabindex="-1">Static Methods <a class="header-anchor" href="#section-static-methods" aria-label="Permalink to &quot;Static Methods {#section-static-methods}&quot;">​</a></h2>', 6)),
    createBaseVNode("h3", _hoisted_27, [
      _cache[82] || (_cache[82] = createTextVNode("parse() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "override"
      }),
      _cache[83] || (_cache[83] = createTextVNode()),
      _cache[84] || (_cache[84] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#parse",
        "aria-label": 'Permalink to "parse() <Badge type="info" text="override" /> {#parse}"'
      }, "​", -1))
    ]),
    _cache[111] || (_cache[111] = createStaticVNode('<div class="member-signature"><pre><code><a href="../package-ribs_core_ribs_core/Option" class="type-link">Option</a>&lt;<a href="./VolumeFlow" class="type-link">VolumeFlow</a>&gt; <span class="fn">parse</span>(<span class="type">String</span> <span class="param">s</span>)</code></pre></div><p>Parses <code>s</code> into a <a href="/ribs/api/package-ribs_units_ribs_units/VolumeFlow.html">VolumeFlow</a>, returning <a href="/ribs/api/package-ribs_core_ribs_core/None.html">None</a> if parsing fails.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">VolumeFlow</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">parse</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> s) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Quantity</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">parse</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(s, units);</span></span></code></pre></div></details><h2 id="section-constants" tabindex="-1">Constants <a class="header-anchor" href="#section-constants" aria-label="Permalink to &quot;Constants {#section-constants}&quot;">​</a></h2><h3 id="prop-cubicfeetperminute" tabindex="-1">cubicFeetPerMinute <a class="header-anchor" href="#prop-cubicfeetperminute" aria-label="Permalink to &quot;cubicFeetPerMinute {#prop-cubicfeetperminute}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./VolumeFlowUnit" class="type-link">VolumeFlowUnit</a> <span class="fn">cubicFeetPerMinute</span></code></pre></div><p>Unit for cubic feet per minute (ft³/min).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> VolumeFlowUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> cubicFeetPerMinute </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> CubicFeetPerMinute</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-cubicfeetpersecond" tabindex="-1">cubicFeetPerSecond <a class="header-anchor" href="#prop-cubicfeetpersecond" aria-label="Permalink to &quot;cubicFeetPerSecond {#prop-cubicfeetpersecond}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./VolumeFlowUnit" class="type-link">VolumeFlowUnit</a> <span class="fn">cubicFeetPerSecond</span></code></pre></div><p>Unit for cubic feet per second (ft³/s).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> VolumeFlowUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> cubicFeetPerSecond </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> CubicFeetPerSecond</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-cubicmeterspersecond" tabindex="-1">cubicMetersPerSecond <a class="header-anchor" href="#prop-cubicmeterspersecond" aria-label="Permalink to &quot;cubicMetersPerSecond {#prop-cubicmeterspersecond}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./VolumeFlowUnit" class="type-link">VolumeFlowUnit</a> <span class="fn">cubicMetersPerSecond</span></code></pre></div><p>Unit for cubic meters per second (m³/s) — the SI unit of volumetric flow.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> VolumeFlowUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> cubicMetersPerSecond </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> CubicMetersPerSecond</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-gallonsperminute" tabindex="-1">gallonsPerMinute <a class="header-anchor" href="#prop-gallonsperminute" aria-label="Permalink to &quot;gallonsPerMinute {#prop-gallonsperminute}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./VolumeFlowUnit" class="type-link">VolumeFlowUnit</a> <span class="fn">gallonsPerMinute</span></code></pre></div><p>Unit for US gallons per minute (gal/min).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> VolumeFlowUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> gallonsPerMinute </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> GallonsPerMinute</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-litersperhour" tabindex="-1">litersPerHour <a class="header-anchor" href="#prop-litersperhour" aria-label="Permalink to &quot;litersPerHour {#prop-litersperhour}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./VolumeFlowUnit" class="type-link">VolumeFlowUnit</a> <span class="fn">litersPerHour</span></code></pre></div><p>Unit for liters per hour (L/h).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> VolumeFlowUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> litersPerHour </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> LitersPerHour</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-litersperminute" tabindex="-1">litersPerMinute <a class="header-anchor" href="#prop-litersperminute" aria-label="Permalink to &quot;litersPerMinute {#prop-litersperminute}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./VolumeFlowUnit" class="type-link">VolumeFlowUnit</a> <span class="fn">litersPerMinute</span></code></pre></div><p>Unit for liters per minute (L/min).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> VolumeFlowUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> litersPerMinute </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> LitersPerMinute</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-literspersecond" tabindex="-1">litersPerSecond <a class="header-anchor" href="#prop-literspersecond" aria-label="Permalink to &quot;litersPerSecond {#prop-literspersecond}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./VolumeFlowUnit" class="type-link">VolumeFlowUnit</a> <span class="fn">litersPerSecond</span></code></pre></div><p>Unit for liters per second (L/s).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> VolumeFlowUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> litersPerSecond </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> LitersPerSecond</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-microliterspersecond" tabindex="-1">microlitersPerSecond <a class="header-anchor" href="#prop-microliterspersecond" aria-label="Permalink to &quot;microlitersPerSecond {#prop-microliterspersecond}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./VolumeFlowUnit" class="type-link">VolumeFlowUnit</a> <span class="fn">microlitersPerSecond</span></code></pre></div><p>Unit for microliters per second (µL/s).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> VolumeFlowUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> microlitersPerSecond </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MicrolitersPerSecond</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-millilitersperhour" tabindex="-1">millilitersPerHour <a class="header-anchor" href="#prop-millilitersperhour" aria-label="Permalink to &quot;millilitersPerHour {#prop-millilitersperhour}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./VolumeFlowUnit" class="type-link">VolumeFlowUnit</a> <span class="fn">millilitersPerHour</span></code></pre></div><p>Unit for milliliters per hour (mL/h).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> VolumeFlowUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> millilitersPerHour </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MillilitersPerHour</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-millilitersperminute" tabindex="-1">millilitersPerMinute <a class="header-anchor" href="#prop-millilitersperminute" aria-label="Permalink to &quot;millilitersPerMinute {#prop-millilitersperminute}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./VolumeFlowUnit" class="type-link">VolumeFlowUnit</a> <span class="fn">millilitersPerMinute</span></code></pre></div><p>Unit for milliliters per minute (mL/min).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> VolumeFlowUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> millilitersPerMinute </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MillilitersPerMinute</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-milliliterspersecond" tabindex="-1">millilitersPerSecond <a class="header-anchor" href="#prop-milliliterspersecond" aria-label="Permalink to &quot;millilitersPerSecond {#prop-milliliterspersecond}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./VolumeFlowUnit" class="type-link">VolumeFlowUnit</a> <span class="fn">millilitersPerSecond</span></code></pre></div><p>Unit for milliliters per second (mL/s).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> VolumeFlowUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> millilitersPerSecond </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MillilitersPerSecond</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-nanoliterspersecond" tabindex="-1">nanolitersPerSecond <a class="header-anchor" href="#prop-nanoliterspersecond" aria-label="Permalink to &quot;nanolitersPerSecond {#prop-nanoliterspersecond}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./VolumeFlowUnit" class="type-link">VolumeFlowUnit</a> <span class="fn">nanolitersPerSecond</span></code></pre></div><p>Unit for nanoliters per second (nL/s).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> VolumeFlowUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> nanolitersPerSecond </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> NanolitersPerSecond</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-units" tabindex="-1">units <a class="header-anchor" href="#prop-units" aria-label="Permalink to &quot;units {#prop-units}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <span class="type">Set</span>&lt;<a href="./VolumeFlowUnit" class="type-link">VolumeFlowUnit</a>&gt; <span class="fn">units</span></code></pre></div><p>All supported <a href="/ribs/api/package-ribs_units_ribs_units/VolumeFlow.html">VolumeFlow</a> units.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> units </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> {</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  cubicMetersPerSecond,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  cubicFeetPerSecond,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  cubicFeetPerMinute,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  gallonsPerMinute,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  litersPerSecond,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  litersPerMinute,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  litersPerHour,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  nanolitersPerSecond,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  microlitersPerSecond,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  millilitersPerSecond,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  millilitersPerMinute,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  millilitersPerHour,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">};</span></span></code></pre></div></details>', 56))
  ]);
}
const VolumeFlow = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  VolumeFlow as default
};
