import { r as resolveComponent, o as openBlock, c as createElementBlock, a as createBaseVNode, b as createTextVNode, d as createVNode, e as createStaticVNode, _ as _export_sfc } from "./app.CftF-fGI.js";
const __pageData = JSON.parse('{"title":"Temperature","description":"API documentation for Temperature class from ribs_units","frontmatter":{"title":"Temperature","description":"API documentation for Temperature class from ribs_units","category":"Classes","library":"ribs_units","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_units_ribs_units/Temperature.md","filePath":"api/package-ribs_units_ribs_units/Temperature.md"}');
const _sfc_main = { name: "api/package-ribs_units_ribs_units/Temperature.md" };
const _hoisted_1 = {
  id: "temperature",
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
  id: "prop-tocelsius",
  tabindex: "-1"
};
const _hoisted_5 = {
  id: "prop-tocelsiusdegrees",
  tabindex: "-1"
};
const _hoisted_6 = {
  id: "prop-tofahrenheit",
  tabindex: "-1"
};
const _hoisted_7 = {
  id: "prop-tofahrenheitdegrees",
  tabindex: "-1"
};
const _hoisted_8 = {
  id: "prop-tokelvin",
  tabindex: "-1"
};
const _hoisted_9 = {
  id: "prop-tokelvindegrees",
  tabindex: "-1"
};
const _hoisted_10 = {
  id: "prop-torankine",
  tabindex: "-1"
};
const _hoisted_11 = {
  id: "prop-torankinedegrees",
  tabindex: "-1"
};
const _hoisted_12 = {
  id: "prop-unit",
  tabindex: "-1"
};
const _hoisted_13 = {
  id: "prop-value",
  tabindex: "-1"
};
const _hoisted_14 = {
  id: "equivalentto",
  tabindex: "-1"
};
const _hoisted_15 = {
  id: "nosuchmethod",
  tabindex: "-1"
};
const _hoisted_16 = {
  id: "to",
  tabindex: "-1"
};
const _hoisted_17 = {
  id: "tostring",
  tabindex: "-1"
};
const _hoisted_18 = {
  id: "operator-less",
  tabindex: "-1"
};
const _hoisted_19 = {
  id: "operator-less_equal",
  tabindex: "-1"
};
const _hoisted_20 = {
  id: "operator-equals",
  tabindex: "-1"
};
const _hoisted_21 = {
  id: "operator-greater",
  tabindex: "-1"
};
const _hoisted_22 = {
  id: "operator-greater_equal",
  tabindex: "-1"
};
const _hoisted_23 = {
  id: "parse",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    createBaseVNode("h1", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("Temperature ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "final"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#temperature",
        "aria-label": 'Permalink to "Temperature <Badge type="info" text="final" />"'
      }, "​", -1))
    ]),
    _cache[73] || (_cache[73] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="kw">class</span> <span class="fn">Temperature</span> <span class="kw">extends</span> <a href="./Quantity" class="type-link">Quantity</a>&lt;<a href="./Temperature" class="type-link">Temperature</a>&gt;</code></pre></div><p>A quantity representing temperature.</p><p>Unlike most quantities, temperature conversions involve both a scale factor <em>and</em> a zero-point offset (e.g. Celsius and Fahrenheit share a 9:5 ratio but differ by 32° at zero). This class handles both:</p><ul><li><strong>Scale conversions</strong> (<code>toFahrenheit</code>, <code>toCelsius</code>, etc.) adjust for the zero-point offset and are appropriate when converting thermometer readings.</li><li><strong>Degree conversions</strong> (<code>toFahrenheitDegrees</code>, <code>toCelsiusDegrees</code>, etc.) skip the offset and are appropriate when converting a <em>difference</em> between two temperatures (e.g. &quot;5 Celsius degrees warmer&quot;).</li></ul><p>Arithmetic (<code>+</code>, <code>-</code>) operates on degree magnitudes without offset adjustment so that <code>37°C + 1°C == 38°C</code> rather than trying to account for absolute zero.</p><div class="info custom-block"><p class="custom-block-title">Inheritance</p><p>Object → <a href="/ribs/api/package-ribs_units_ribs_units/Quantity.html">Quantity&lt;A extends Quantity&lt;A&gt;&gt;</a> → <strong>Temperature</strong></p></div><h2 id="section-constructors" tabindex="-1">Constructors <a class="header-anchor" href="#section-constructors" aria-label="Permalink to &quot;Constructors {#section-constructors}&quot;">​</a></h2><h3 id="ctor-temperature" tabindex="-1">Temperature() <a class="header-anchor" href="#ctor-temperature" aria-label="Permalink to &quot;Temperature() {#ctor-temperature}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="fn">Temperature</span>(<span class="type">double</span> <span class="param">value</span>, <a href="./UnitOfMeasure" class="type-link">UnitOfMeasure</a>&lt;<a href="./Temperature" class="type-link">Temperature</a>&gt; <span class="param">unit</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Temperature</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">super</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.value, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">super</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.unit);</span></span></code></pre></div></details><h2 id="section-properties" tabindex="-1">Properties <a class="header-anchor" href="#section-properties" aria-label="Permalink to &quot;Properties {#section-properties}&quot;">​</a></h2>', 11)),
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
    _cache[74] || (_cache[74] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></code></pre></div><p>The hash code for this object.</p><p>A hash code is a single integer which represents the state of the object that affects <a href="/ribs/api/package-ribs_units_ribs_units/Temperature.html#operator-equals">operator ==</a> comparisons.</p><p>All objects have hash codes. The default hash code implemented by <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object-class.html" target="_blank" rel="noreferrer">Object</a> represents only the identity of the object, the same way as the default <a href="/ribs/api/package-ribs_units_ribs_units/Temperature.html#operator-equals">operator ==</a> implementation only considers objects equal if they are identical (see <a href="https://api.dart.dev/stable/3.11.4/dart-core/identityHashCode.html" target="_blank" rel="noreferrer">identityHashCode</a>).</p><p>If <a href="/ribs/api/package-ribs_units_ribs_units/Temperature.html#operator-equals">operator ==</a> is overridden to use the object state instead, the hash code must also be changed to represent that state, otherwise the object cannot be used in hash based data structures like the default <a href="https://api.dart.dev/stable/3.11.4/dart-core/Set-class.html" target="_blank" rel="noreferrer">Set</a> and <a href="https://api.dart.dev/stable/3.11.4/dart-core/Map-class.html" target="_blank" rel="noreferrer">Map</a> implementations.</p><p>Hash codes must be the same for objects that are equal to each other according to <a href="/ribs/api/package-ribs_units_ribs_units/Temperature.html#operator-equals">operator ==</a>. The hash code of an object should only change if the object changes in a way that affects equality. There are no further requirements for the hash codes. They need not be consistent between executions of the same program and there are no distribution guarantees.</p><p>Objects that are not equal are allowed to have the same hash code. It is even technically allowed that all instances have the same hash code, but if clashes happen too often, it may reduce the efficiency of hash-based data structures like <a href="https://api.dart.dev/stable/3.11.4/dart-collection/HashSet-class.html" target="_blank" rel="noreferrer">HashSet</a> or <a href="https://api.dart.dev/stable/3.11.4/dart-collection/HashMap-class.html" target="_blank" rel="noreferrer">HashMap</a>.</p><p>If a subclass overrides <a href="/ribs/api/package-ribs_units_ribs_units/Temperature.html#prop-hashcode">hashCode</a>, it should override the <a href="/ribs/api/package-ribs_units_ribs_units/Temperature.html#operator-equals">operator ==</a> operator as well to maintain consistency.</p><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> hashCode </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Object</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">hash</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(value, unit);</span></span></code></pre></div></details>', 10)),
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
    _cache[75] || (_cache[75] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">Type</span> <span class="kw">get</span> <span class="fn">runtimeType</span></code></pre></div><p>A representation of the runtime type of the object.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Type</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> runtimeType;</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_4, [
      _cache[11] || (_cache[11] = createTextVNode("toCelsius ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[12] || (_cache[12] = createTextVNode()),
      _cache[13] || (_cache[13] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tocelsius",
        "aria-label": 'Permalink to "toCelsius <Badge type="tip" text="no setter" /> {#prop-tocelsius}"'
      }, "​", -1))
    ]),
    _cache[76] || (_cache[76] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Temperature" class="type-link">Temperature</a> <span class="kw">get</span> <span class="fn">toCelsius</span></code></pre></div><p>Converts this temperature to the Celsius scale.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Temperature</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toCelsius </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> _convert</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(celcius);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_5, [
      _cache[14] || (_cache[14] = createTextVNode("toCelsiusDegrees ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[15] || (_cache[15] = createTextVNode()),
      _cache[16] || (_cache[16] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tocelsiusdegrees",
        "aria-label": 'Permalink to "toCelsiusDegrees <Badge type="tip" text="no setter" /> {#prop-tocelsiusdegrees}"'
      }, "​", -1))
    ]),
    _cache[77] || (_cache[77] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Temperature" class="type-link">Temperature</a> <span class="kw">get</span> <span class="fn">toCelsiusDegrees</span></code></pre></div><p>Converts this temperature <em>magnitude</em> to Celsius degrees (no offset).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Temperature</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toCelsiusDegrees </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> _convert</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(celcius, withOffset</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> false</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_6, [
      _cache[17] || (_cache[17] = createTextVNode("toFahrenheit ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[18] || (_cache[18] = createTextVNode()),
      _cache[19] || (_cache[19] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tofahrenheit",
        "aria-label": 'Permalink to "toFahrenheit <Badge type="tip" text="no setter" /> {#prop-tofahrenheit}"'
      }, "​", -1))
    ]),
    _cache[78] || (_cache[78] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Temperature" class="type-link">Temperature</a> <span class="kw">get</span> <span class="fn">toFahrenheit</span></code></pre></div><p>Converts this temperature to the Fahrenheit scale.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Temperature</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toFahrenheit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> _convert</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(fahrenheit);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_7, [
      _cache[20] || (_cache[20] = createTextVNode("toFahrenheitDegrees ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[21] || (_cache[21] = createTextVNode()),
      _cache[22] || (_cache[22] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tofahrenheitdegrees",
        "aria-label": 'Permalink to "toFahrenheitDegrees <Badge type="tip" text="no setter" /> {#prop-tofahrenheitdegrees}"'
      }, "​", -1))
    ]),
    _cache[79] || (_cache[79] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Temperature" class="type-link">Temperature</a> <span class="kw">get</span> <span class="fn">toFahrenheitDegrees</span></code></pre></div><p>Converts this temperature <em>magnitude</em> to Fahrenheit degrees (no offset).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Temperature</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toFahrenheitDegrees </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> _convert</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(fahrenheit, withOffset</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> false</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_8, [
      _cache[23] || (_cache[23] = createTextVNode("toKelvin ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[24] || (_cache[24] = createTextVNode()),
      _cache[25] || (_cache[25] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tokelvin",
        "aria-label": 'Permalink to "toKelvin <Badge type="tip" text="no setter" /> {#prop-tokelvin}"'
      }, "​", -1))
    ]),
    _cache[80] || (_cache[80] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Temperature" class="type-link">Temperature</a> <span class="kw">get</span> <span class="fn">toKelvin</span></code></pre></div><p>Converts this temperature to the Kelvin scale.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Temperature</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toKelvin </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> _convert</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(kelvin);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_9, [
      _cache[26] || (_cache[26] = createTextVNode("toKelvinDegrees ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[27] || (_cache[27] = createTextVNode()),
      _cache[28] || (_cache[28] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-tokelvindegrees",
        "aria-label": 'Permalink to "toKelvinDegrees <Badge type="tip" text="no setter" /> {#prop-tokelvindegrees}"'
      }, "​", -1))
    ]),
    _cache[81] || (_cache[81] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Temperature" class="type-link">Temperature</a> <span class="kw">get</span> <span class="fn">toKelvinDegrees</span></code></pre></div><p>Converts this temperature <em>magnitude</em> to Kelvin degrees (no offset).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Temperature</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toKelvinDegrees </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> _convert</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(kelvin, withOffset</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> false</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_10, [
      _cache[29] || (_cache[29] = createTextVNode("toRankine ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[30] || (_cache[30] = createTextVNode()),
      _cache[31] || (_cache[31] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-torankine",
        "aria-label": 'Permalink to "toRankine <Badge type="tip" text="no setter" /> {#prop-torankine}"'
      }, "​", -1))
    ]),
    _cache[82] || (_cache[82] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Temperature" class="type-link">Temperature</a> <span class="kw">get</span> <span class="fn">toRankine</span></code></pre></div><p>Converts this temperature to the Rankine scale.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Temperature</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toRankine </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> _convert</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(rankine);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_11, [
      _cache[32] || (_cache[32] = createTextVNode("toRankineDegrees ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[33] || (_cache[33] = createTextVNode()),
      _cache[34] || (_cache[34] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-torankinedegrees",
        "aria-label": 'Permalink to "toRankineDegrees <Badge type="tip" text="no setter" /> {#prop-torankinedegrees}"'
      }, "​", -1))
    ]),
    _cache[83] || (_cache[83] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Temperature" class="type-link">Temperature</a> <span class="kw">get</span> <span class="fn">toRankineDegrees</span></code></pre></div><p>Converts this temperature <em>magnitude</em> to Rankine degrees (no offset).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Temperature</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> toRankineDegrees </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> _convert</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(rankine, withOffset</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> false</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_12, [
      _cache[35] || (_cache[35] = createTextVNode("unit ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[36] || (_cache[36] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[37] || (_cache[37] = createTextVNode()),
      _cache[38] || (_cache[38] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-unit",
        "aria-label": 'Permalink to "unit <Badge type="tip" text="final" /> <Badge type="info" text="inherited" /> {#prop-unit}"'
      }, "​", -1))
    ]),
    _cache[84] || (_cache[84] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <a href="./UnitOfMeasure" class="type-link">UnitOfMeasure</a>&lt;<a href="./Temperature" class="type-link">Temperature</a>&gt; <span class="fn">unit</span></code></pre></div><p>The unit of measure that <a href="/ribs/api/package-ribs_units_ribs_units/Quantity.html#prop-value">value</a> is expressed in.</p><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> UnitOfMeasure</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; unit;</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_13, [
      _cache[39] || (_cache[39] = createTextVNode("value ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[40] || (_cache[40] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[41] || (_cache[41] = createTextVNode()),
      _cache[42] || (_cache[42] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-value",
        "aria-label": 'Permalink to "value <Badge type="tip" text="final" /> <Badge type="info" text="inherited" /> {#prop-value}"'
      }, "​", -1))
    ]),
    _cache[85] || (_cache[85] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="type">double</span> <span class="fn">value</span></code></pre></div><p>The raw numeric value of this quantity expressed in <a href="/ribs/api/package-ribs_units_ribs_units/Quantity.html#prop-unit">unit</a>.</p><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> double</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value;</span></span></code></pre></div></details><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 5)),
    createBaseVNode("h3", _hoisted_14, [
      _cache[43] || (_cache[43] = createTextVNode("equivalentTo() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[44] || (_cache[44] = createTextVNode()),
      _cache[45] || (_cache[45] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#equivalentto",
        "aria-label": 'Permalink to "equivalentTo() <Badge type="info" text="inherited" /> {#equivalentto}"'
      }, "​", -1))
    ]),
    _cache[86] || (_cache[86] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">equivalentTo</span>(<a href="./Quantity" class="type-link">Quantity</a>&lt;<a href="./Temperature" class="type-link">Temperature</a>&gt; <span class="param">other</span>)</code></pre></div><p>Returns true if this quantity represents the same physical magnitude as <code>other</code>, regardless of which unit each is expressed in.</p><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> equivalentTo</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Quantity</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; other) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(unit) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value;</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_15, [
      _cache[46] || (_cache[46] = createTextVNode("noSuchMethod() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[47] || (_cache[47] = createTextVNode()),
      _cache[48] || (_cache[48] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#nosuchmethod",
        "aria-label": 'Permalink to "noSuchMethod() <Badge type="info" text="inherited" /> {#nosuchmethod}"'
      }, "​", -1))
    ]),
    _cache[87] || (_cache[87] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">dynamic</span> <span class="fn">noSuchMethod</span>(<span class="type">Invocation</span> <span class="param">invocation</span>)</code></pre></div><p>Invoked when a nonexistent method or property is accessed.</p><p>A dynamic member invocation can attempt to call a member which doesn&#39;t exist on the receiving object. Example:</p><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">dynamic</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> object </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">object.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">add</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">42</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">); </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">// Statically allowed, run-time error</span></span></code></pre></div><p>This invalid code will invoke the <code>noSuchMethod</code> method of the integer <code>1</code> with an <a href="https://api.dart.dev/stable/3.11.4/dart-core/Invocation-class.html" target="_blank" rel="noreferrer">Invocation</a> representing the <code>.add(42)</code> call and arguments (which then throws).</p><p>Classes can override <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object/noSuchMethod.html" target="_blank" rel="noreferrer">noSuchMethod</a> to provide custom behavior for such invalid dynamic invocations.</p><p>A class with a non-default <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object/noSuchMethod.html" target="_blank" rel="noreferrer">noSuchMethod</a> invocation can also omit implementations for members of its interface. Example:</p><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">class</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MockList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">implements</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> List</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; {</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">  noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Invocation</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> invocation) {</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    log</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(invocation);</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    super</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(invocation); </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">// Will throw.</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  }</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">void</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> main</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() {</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  MockList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">().</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">add</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">42</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div><p>This code has no compile-time warnings or errors even though the <code>MockList</code> class has no concrete implementation of any of the <code>List</code> interface methods. Calls to <code>List</code> methods are forwarded to <code>noSuchMethod</code>, so this code will <code>log</code> an invocation similar to <code>Invocation.method(#add, [42])</code> and then throw.</p><p>If a value is returned from <code>noSuchMethod</code>, it becomes the result of the original invocation. If the value is not of a type that can be returned by the original invocation, a type error occurs at the invocation.</p><p>The default behavior is to throw a <a href="https://api.dart.dev/stable/3.11.4/dart-core/NoSuchMethodError-class.html" target="_blank" rel="noreferrer">NoSuchMethodError</a>.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@pragma</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;vm:entry-point&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@pragma</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;wasm:entry-point&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> dynamic</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Invocation</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> invocation);</span></span></code></pre></div></details>', 13)),
    createBaseVNode("h3", _hoisted_16, [
      _cache[49] || (_cache[49] = createTextVNode("to() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "override"
      }),
      _cache[50] || (_cache[50] = createTextVNode()),
      _cache[51] || (_cache[51] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#to",
        "aria-label": 'Permalink to "to() <Badge type="info" text="override" /> {#to}"'
      }, "​", -1))
    ]),
    _cache[88] || (_cache[88] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">double</span> <span class="fn">to</span>(<a href="./UnitOfMeasure" class="type-link">UnitOfMeasure</a>&lt;<a href="./Temperature" class="type-link">Temperature</a>&gt; <span class="param">uom</span>)</code></pre></div><p>Converts this quantity to <code>uom</code> and returns the raw <a href="https://api.dart.dev/stable/3.11.4/dart-core/double-class.html" target="_blank" rel="noreferrer">double</a> value.</p><p>If <code>uom</code> equals <a href="/ribs/api/package-ribs_units_ribs_units/Temperature.html#prop-unit">unit</a>, the current <a href="/ribs/api/package-ribs_units_ribs_units/Temperature.html#prop-value">value</a> is returned unchanged.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">double</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">UnitOfMeasure</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Temperature</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; uom) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> _convert</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(uom).value;</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_17, [
      _cache[52] || (_cache[52] = createTextVNode("toString() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "override"
      }),
      _cache[53] || (_cache[53] = createTextVNode()),
      _cache[54] || (_cache[54] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#tostring",
        "aria-label": 'Permalink to "toString() <Badge type="info" text="override" /> {#tostring}"'
      }, "​", -1))
    ]),
    _cache[89] || (_cache[89] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">String</span> <span class="fn">toString</span>()</code></pre></div><p>A string representation of this object.</p><p>Some classes have a default textual representation, often paired with a static <code>parse</code> function (like <a href="https://api.dart.dev/stable/3.11.4/dart-core/int/parse.html" target="_blank" rel="noreferrer">int.parse</a>). These classes will provide the textual representation as their string representation.</p><p>Other classes have no meaningful textual representation that a program will care about. Such classes will typically override <code>toString</code> to provide useful information when inspecting the object, mainly for debugging or logging.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> toString</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    unit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">is</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Kelvin</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> ?</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> super</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">toString</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">${</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">value</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">toStringAsFixed</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">1</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">)}${</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">unit</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">symbol</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">}</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span></code></pre></div></details><h2 id="section-operators" tabindex="-1">Operators <a class="header-anchor" href="#section-operators" aria-label="Permalink to &quot;Operators {#section-operators}&quot;">​</a></h2><h3 id="operator-plus" tabindex="-1">operator +() <a class="header-anchor" href="#operator-plus" aria-label="Permalink to &quot;operator +() {#operator-plus}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Temperature" class="type-link">Temperature</a> <span class="fn">operator +</span>(<a href="./Temperature" class="type-link">Temperature</a> <span class="param">that</span>)</code></pre></div><p>Returns the sum of degree magnitudes in the units of this <a href="/ribs/api/package-ribs_units_ribs_units/Temperature.html">Temperature</a>.</p><p>The addend is converted to <a href="/ribs/api/package-ribs_units_ribs_units/Quantity.html#prop-unit">unit</a> without zero-offset adjustment so that adding temperatures behaves as adding scalar magnitudes.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Temperature</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> +</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Temperature</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    Temperature</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">+</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">_convert</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(unit, withOffset</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> false</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">).value, unit);</span></span></code></pre></div></details><h3 id="operator-minus" tabindex="-1">operator -() <a class="header-anchor" href="#operator-minus" aria-label="Permalink to &quot;operator -() {#operator-minus}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./Temperature" class="type-link">Temperature</a> <span class="fn">operator -</span>(<a href="./Temperature" class="type-link">Temperature</a> <span class="param">that</span>)</code></pre></div><p>Returns the difference of degree magnitudes in the units of this <a href="/ribs/api/package-ribs_units_ribs_units/Temperature.html">Temperature</a>.</p><p>The subtrahend is converted to <a href="/ribs/api/package-ribs_units_ribs_units/Quantity.html#prop-unit">unit</a> without zero-offset adjustment.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Temperature</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> -</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Temperature</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    Temperature</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">-</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">_convert</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(unit, withOffset</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> false</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">).value, unit);</span></span></code></pre></div></details>', 16)),
    createBaseVNode("h3", _hoisted_18, [
      _cache[55] || (_cache[55] = createTextVNode("operator <() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[56] || (_cache[56] = createTextVNode()),
      _cache[57] || (_cache[57] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#operator-less",
        "aria-label": 'Permalink to "operator \\<() <Badge type="info" text="inherited" /> {#operator-less}"'
      }, "​", -1))
    ]),
    _cache[90] || (_cache[90] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator &lt;</span>(<a href="./Temperature" class="type-link">Temperature</a> <span class="param">that</span>)</code></pre></div><p>Returns true if this quantity is less than <code>that</code>.</p><p><code>that</code> is converted to <a href="/ribs/api/package-ribs_units_ribs_units/Quantity.html#prop-unit">unit</a> before comparing.</p><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> &lt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(unit);</span></span></code></pre></div></details>', 5)),
    createBaseVNode("h3", _hoisted_19, [
      _cache[58] || (_cache[58] = createTextVNode("operator <=() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[59] || (_cache[59] = createTextVNode()),
      _cache[60] || (_cache[60] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#operator-less_equal",
        "aria-label": 'Permalink to "operator \\<=() <Badge type="info" text="inherited" /> {#operator-less_equal}"'
      }, "​", -1))
    ]),
    _cache[91] || (_cache[91] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator &lt;=</span>(<a href="./Temperature" class="type-link">Temperature</a> <span class="param">that</span>)</code></pre></div><p>Returns true if this quantity is less than or equal to <code>that</code>.</p><p><code>that</code> is converted to <a href="/ribs/api/package-ribs_units_ribs_units/Quantity.html#prop-unit">unit</a> before comparing.</p><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> &lt;=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(unit);</span></span></code></pre></div></details>', 5)),
    createBaseVNode("h3", _hoisted_20, [
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
    _cache[92] || (_cache[92] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator ==</span>(<span class="type">Object</span> <span class="param">other</span>)</code></pre></div><p>The equality operator.</p><p>The default behavior for all <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object-class.html" target="_blank" rel="noreferrer">Object</a>s is to return true if and only if this object and <code>other</code> are the same object.</p><p>Override this method to specify a different equality relation on a class. The overriding method must still be an equivalence relation. That is, it must be:</p><ul><li><p>Total: It must return a boolean for all arguments. It should never throw.</p></li><li><p>Reflexive: For all objects <code>o</code>, <code>o == o</code> must be true.</p></li><li><p>Symmetric: For all objects <code>o1</code> and <code>o2</code>, <code>o1 == o2</code> and <code>o2 == o1</code> must either both be true, or both be false.</p></li><li><p>Transitive: For all objects <code>o1</code>, <code>o2</code>, and <code>o3</code>, if <code>o1 == o2</code> and <code>o2 == o3</code> are true, then <code>o1 == o3</code> must be true.</p></li></ul><p>The method should also be consistent over time, so whether two objects are equal should only change if at least one of the objects was modified.</p><p>If a subclass overrides the equality operator, it should override the <a href="/ribs/api/package-ribs_units_ribs_units/Temperature.html#prop-hashcode">hashCode</a> method as well to maintain consistency.</p><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> ==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Object</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    identical</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, other) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">||</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    (other </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">is</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Quantity</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&amp;&amp;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other.value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&amp;&amp;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other.unit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> unit);</span></span></code></pre></div></details>', 9)),
    createBaseVNode("h3", _hoisted_21, [
      _cache[64] || (_cache[64] = createTextVNode("operator >() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[65] || (_cache[65] = createTextVNode()),
      _cache[66] || (_cache[66] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#operator-greater",
        "aria-label": 'Permalink to "operator \\>() <Badge type="info" text="inherited" /> {#operator-greater}"'
      }, "​", -1))
    ]),
    _cache[93] || (_cache[93] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator &gt;</span>(<a href="./Temperature" class="type-link">Temperature</a> <span class="param">that</span>)</code></pre></div><p>Returns true if this quantity is greater than <code>that</code>.</p><p><code>that</code> is converted to <a href="/ribs/api/package-ribs_units_ribs_units/Quantity.html#prop-unit">unit</a> before comparing.</p><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> &gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(unit);</span></span></code></pre></div></details>', 5)),
    createBaseVNode("h3", _hoisted_22, [
      _cache[67] || (_cache[67] = createTextVNode("operator >=() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[68] || (_cache[68] = createTextVNode()),
      _cache[69] || (_cache[69] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#operator-greater_equal",
        "aria-label": 'Permalink to "operator \\>=() <Badge type="info" text="inherited" /> {#operator-greater_equal}"'
      }, "​", -1))
    ]),
    _cache[94] || (_cache[94] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator &gt;=</span>(<a href="./Temperature" class="type-link">Temperature</a> <span class="param">that</span>)</code></pre></div><p>Returns true if this quantity is greater than or equal to <code>that</code>.</p><p><code>that</code> is converted to <a href="/ribs/api/package-ribs_units_ribs_units/Quantity.html#prop-unit">unit</a> before comparing.</p><p><em>Inherited from Quantity.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> &gt;=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(unit);</span></span></code></pre></div></details><h2 id="section-static-methods" tabindex="-1">Static Methods <a class="header-anchor" href="#section-static-methods" aria-label="Permalink to &quot;Static Methods {#section-static-methods}&quot;">​</a></h2>', 6)),
    createBaseVNode("h3", _hoisted_23, [
      _cache[70] || (_cache[70] = createTextVNode("parse() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "override"
      }),
      _cache[71] || (_cache[71] = createTextVNode()),
      _cache[72] || (_cache[72] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#parse",
        "aria-label": 'Permalink to "parse() <Badge type="info" text="override" /> {#parse}"'
      }, "​", -1))
    ]),
    _cache[95] || (_cache[95] = createStaticVNode('<div class="member-signature"><pre><code><a href="../package-ribs_core_ribs_core/Option" class="type-link">Option</a>&lt;<a href="./Temperature" class="type-link">Temperature</a>&gt; <span class="fn">parse</span>(<span class="type">String</span> <span class="param">s</span>)</code></pre></div><p>Parses <code>s</code> into a <a href="/ribs/api/package-ribs_units_ribs_units/Temperature.html">Temperature</a>, returning <a href="/ribs/api/package-ribs_core_ribs_core/None.html">None</a> if parsing fails.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Temperature</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">parse</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> s) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Quantity</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">parse</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(s, units);</span></span></code></pre></div></details><h2 id="section-constants" tabindex="-1">Constants <a class="header-anchor" href="#section-constants" aria-label="Permalink to &quot;Constants {#section-constants}&quot;">​</a></h2><h3 id="prop-celcius" tabindex="-1">celcius <a class="header-anchor" href="#prop-celcius" aria-label="Permalink to &quot;celcius {#prop-celcius}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./Celcius" class="type-link">Celcius</a> <span class="fn">celcius</span></code></pre></div><p>Unit for degrees Celsius (°C).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> celcius </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Celcius</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-fahrenheit" tabindex="-1">fahrenheit <a class="header-anchor" href="#prop-fahrenheit" aria-label="Permalink to &quot;fahrenheit {#prop-fahrenheit}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./Fahrenheit" class="type-link">Fahrenheit</a> <span class="fn">fahrenheit</span></code></pre></div><p>Unit for degrees Fahrenheit (°F).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> fahrenheit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Fahrenheit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-kelvin" tabindex="-1">kelvin <a class="header-anchor" href="#prop-kelvin" aria-label="Permalink to &quot;kelvin {#prop-kelvin}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./Kelvin" class="type-link">Kelvin</a> <span class="fn">kelvin</span></code></pre></div><p>Unit for Kelvin (K).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> kelvin </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Kelvin</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-rankine" tabindex="-1">rankine <a class="header-anchor" href="#prop-rankine" aria-label="Permalink to &quot;rankine {#prop-rankine}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <a href="./Rankine" class="type-link">Rankine</a> <span class="fn">rankine</span></code></pre></div><p>Unit for degrees Rankine (°R).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> rankine </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Rankine</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._();</span></span></code></pre></div></details><h3 id="prop-units" tabindex="-1">units <a class="header-anchor" href="#prop-units" aria-label="Permalink to &quot;units {#prop-units}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="kw">const</span> <span class="type">Set</span>&lt;<a href="./TemperatureScale" class="type-link">TemperatureScale</a>&gt; <span class="fn">units</span></code></pre></div><p>All supported <a href="/ribs/api/package-ribs_units_ribs_units/Temperature.html">Temperature</a> units.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> const</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> units </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> {</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  celcius,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  fahrenheit,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  kelvin,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  rankine,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">};</span></span></code></pre></div></details>', 24))
  ]);
}
const Temperature = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  Temperature as default
};
