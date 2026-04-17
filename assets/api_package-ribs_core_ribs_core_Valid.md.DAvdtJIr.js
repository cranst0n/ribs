import { r as resolveComponent, o as openBlock, c as createElementBlock, a as createBaseVNode, b as createTextVNode, d as createVNode, e as createStaticVNode, _ as _export_sfc } from "./app.Bo4QfGNf.js";
const __pageData = JSON.parse('{"title":"Valid<E, A>","description":"API documentation for Valid<E, A> class from ribs_core","frontmatter":{"title":"Valid<E, A>","description":"API documentation for Valid<E, A> class from ribs_core","category":"Classes","library":"ribs_core","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_core_ribs_core/Valid.md","filePath":"api/package-ribs_core_ribs_core/Valid.md"}');
const _sfc_main = { name: "api/package-ribs_core_ribs_core/Valid.md" };
const _hoisted_1 = {
  id: "valid-e-a",
  tabindex: "-1"
};
const _hoisted_2 = {
  id: "prop-hashcode",
  tabindex: "-1"
};
const _hoisted_3 = {
  id: "prop-isinvalid",
  tabindex: "-1"
};
const _hoisted_4 = {
  id: "prop-isvalid",
  tabindex: "-1"
};
const _hoisted_5 = {
  id: "prop-runtimetype",
  tabindex: "-1"
};
const _hoisted_6 = {
  id: "prop-value",
  tabindex: "-1"
};
const _hoisted_7 = {
  id: "andthen",
  tabindex: "-1"
};
const _hoisted_8 = {
  id: "bimap",
  tabindex: "-1"
};
const _hoisted_9 = {
  id: "ensure",
  tabindex: "-1"
};
const _hoisted_10 = {
  id: "ensureor",
  tabindex: "-1"
};
const _hoisted_11 = {
  id: "exists",
  tabindex: "-1"
};
const _hoisted_12 = {
  id: "fold",
  tabindex: "-1"
};
const _hoisted_13 = {
  id: "forall",
  tabindex: "-1"
};
const _hoisted_14 = {
  id: "foreach",
  tabindex: "-1"
};
const _hoisted_15 = {
  id: "getorelse",
  tabindex: "-1"
};
const _hoisted_16 = {
  id: "leftmap",
  tabindex: "-1"
};
const _hoisted_17 = {
  id: "map",
  tabindex: "-1"
};
const _hoisted_18 = {
  id: "nosuchmethod",
  tabindex: "-1"
};
const _hoisted_19 = {
  id: "orelse",
  tabindex: "-1"
};
const _hoisted_20 = {
  id: "swap",
  tabindex: "-1"
};
const _hoisted_21 = {
  id: "toeither",
  tabindex: "-1"
};
const _hoisted_22 = {
  id: "toilist",
  tabindex: "-1"
};
const _hoisted_23 = {
  id: "tooption",
  tabindex: "-1"
};
const _hoisted_24 = {
  id: "tostring",
  tabindex: "-1"
};
const _hoisted_25 = {
  id: "tovalidatednel",
  tabindex: "-1"
};
const _hoisted_26 = {
  id: "valueor",
  tabindex: "-1"
};
const _hoisted_27 = {
  id: "ap",
  tabindex: "-1"
};
const _hoisted_28 = {
  id: "flatten",
  tabindex: "-1"
};
const _hoisted_29 = {
  id: "product",
  tabindex: "-1"
};
const _hoisted_30 = {
  id: "operator-equals",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    createBaseVNode("h1", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("Valid<E, A> ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "final"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#valid-e-a",
        "aria-label": 'Permalink to "Valid\\<E, A\\> <Badge type="info" text="final" />"'
      }, "​", -1))
    ]),
    _cache[94] || (_cache[94] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="kw">class</span> <span class="fn">Valid</span>&lt;E, A&gt; <span class="kw">extends</span> <a href="./Validated" class="type-link">Validated</a>&lt;<span class="type">E</span>, <span class="type">A</span>&gt;</code></pre></div><p>A <a href="/ribs/api/package-ribs_core_ribs_core/Validated.html">Validated</a> that represents a successful, or valid value.</p><div class="info custom-block"><p class="custom-block-title">Inheritance</p><p>Object → <a href="/ribs/api/package-ribs_core_ribs_core/Validated.html">Validated&lt;E, A&gt;</a> → <strong>Valid&lt;E, A&gt;</strong></p></div><div class="info custom-block"><p class="custom-block-title">Available Extensions</p><ul><li><a href="/ribs/api/package-ribs_core_ribs_core/ValidatedNelOps.html">ValidatedNelOps&lt;E, A&gt;</a></li><li><a href="/ribs/api/package-ribs_core_ribs_core/ValidatedNestedOps.html">ValidatedNestedOps&lt;E, A&gt;</a></li></ul></div><h2 id="section-constructors" tabindex="-1">Constructors <a class="header-anchor" href="#section-constructors" aria-label="Permalink to &quot;Constructors {#section-constructors}&quot;">​</a></h2><h3 id="ctor-valid" tabindex="-1">Valid() <a class="header-anchor" href="#ctor-valid" aria-label="Permalink to &quot;Valid() {#ctor-valid}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="fn">Valid</span>(<span class="type">A</span> <span class="param">value</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Valid</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.value);</span></span></code></pre></div></details><h2 id="section-properties" tabindex="-1">Properties <a class="header-anchor" href="#section-properties" aria-label="Permalink to &quot;Properties {#section-properties}&quot;">​</a></h2>', 9)),
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
    _cache[95] || (_cache[95] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></code></pre></div><p>The hash code for this object.</p><p>A hash code is a single integer which represents the state of the object that affects <a href="/ribs/api/package-ribs_core_ribs_core/Valid.html#operator-equals">operator ==</a> comparisons.</p><p>All objects have hash codes. The default hash code implemented by <a href="https://api.dart.dev/stable/3.11.5/dart-core/Object-class.html" target="_blank" rel="noreferrer">Object</a> represents only the identity of the object, the same way as the default <a href="/ribs/api/package-ribs_core_ribs_core/Valid.html#operator-equals">operator ==</a> implementation only considers objects equal if they are identical (see <a href="https://api.dart.dev/stable/3.11.5/dart-core/identityHashCode.html" target="_blank" rel="noreferrer">identityHashCode</a>).</p><p>If <a href="/ribs/api/package-ribs_core_ribs_core/Valid.html#operator-equals">operator ==</a> is overridden to use the object state instead, the hash code must also be changed to represent that state, otherwise the object cannot be used in hash based data structures like the default <a href="https://api.dart.dev/stable/3.11.5/dart-core/Set-class.html" target="_blank" rel="noreferrer">Set</a> and <a href="https://api.dart.dev/stable/3.11.5/dart-core/Map-class.html" target="_blank" rel="noreferrer">Map</a> implementations.</p><p>Hash codes must be the same for objects that are equal to each other according to <a href="/ribs/api/package-ribs_core_ribs_core/Valid.html#operator-equals">operator ==</a>. The hash code of an object should only change if the object changes in a way that affects equality. There are no further requirements for the hash codes. They need not be consistent between executions of the same program and there are no distribution guarantees.</p><p>Objects that are not equal are allowed to have the same hash code. It is even technically allowed that all instances have the same hash code, but if clashes happen too often, it may reduce the efficiency of hash-based data structures like <a href="https://api.dart.dev/stable/3.11.5/dart-collection/HashSet-class.html" target="_blank" rel="noreferrer">HashSet</a> or <a href="https://api.dart.dev/stable/3.11.5/dart-collection/HashMap-class.html" target="_blank" rel="noreferrer">HashMap</a>.</p><p>If a subclass overrides <a href="/ribs/api/package-ribs_core_ribs_core/Valid.html#prop-hashcode">hashCode</a>, it should override the <a href="/ribs/api/package-ribs_core_ribs_core/Valid.html#operator-equals">operator ==</a> operator as well to maintain consistency.</p><p><em>Inherited from Validated.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> hashCode </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((e) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> e.hashCode, (a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> a.hashCode);</span></span></code></pre></div></details>', 10)),
    createBaseVNode("h3", _hoisted_3, [
      _cache[7] || (_cache[7] = createTextVNode("isInvalid ", -1)),
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
        href: "#prop-isinvalid",
        "aria-label": 'Permalink to "isInvalid <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-isinvalid}"'
      }, "​", -1))
    ]),
    _cache[96] || (_cache[96] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isInvalid</span></code></pre></div><p>Returns true if this instance is a <a href="/ribs/api/package-ribs_core_ribs_core/Invalid.html">Invalid</a>, otherwise false is returned.</p><p><em>Inherited from Validated.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> isInvalid </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> !</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">isValid;</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_4, [
      _cache[11] || (_cache[11] = createTextVNode("isValid ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[12] || (_cache[12] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[13] || (_cache[13] = createTextVNode()),
      _cache[14] || (_cache[14] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-isvalid",
        "aria-label": 'Permalink to "isValid <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-isvalid}"'
      }, "​", -1))
    ]),
    _cache[97] || (_cache[97] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="kw">get</span> <span class="fn">isValid</span></code></pre></div><p>Returns true if this instance is a <a href="/ribs/api/package-ribs_core_ribs_core/Valid.html">Valid</a>, otherwise false is returned.</p><p><em>Inherited from Validated.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> isValid </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((_) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> false</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, (_) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> true</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_5, [
      _cache[15] || (_cache[15] = createTextVNode("runtimeType ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[16] || (_cache[16] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[17] || (_cache[17] = createTextVNode()),
      _cache[18] || (_cache[18] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-runtimetype",
        "aria-label": 'Permalink to "runtimeType <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-runtimetype}"'
      }, "​", -1))
    ]),
    _cache[98] || (_cache[98] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">Type</span> <span class="kw">get</span> <span class="fn">runtimeType</span></code></pre></div><p>A representation of the runtime type of the object.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Type</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> runtimeType;</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_6, [
      _cache[19] || (_cache[19] = createTextVNode("value ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[20] || (_cache[20] = createTextVNode()),
      _cache[21] || (_cache[21] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-value",
        "aria-label": 'Permalink to "value <Badge type="tip" text="final" /> {#prop-value}"'
      }, "​", -1))
    ]),
    _cache[99] || (_cache[99] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="type">A</span> <span class="fn">value</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value;</span></span></code></pre></div></details><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 3)),
    createBaseVNode("h3", _hoisted_7, [
      _cache[22] || (_cache[22] = createTextVNode("andThen() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[23] || (_cache[23] = createTextVNode()),
      _cache[24] || (_cache[24] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#andthen",
        "aria-label": 'Permalink to "andThen() <Badge type="info" text="inherited" /> {#andthen}"'
      }, "​", -1))
    ]),
    _cache[100] || (_cache[100] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Validated" class="type-link">Validated</a>&lt;<span class="type">E</span>, <span class="type">B</span>&gt; <span class="fn">andThen&lt;B&gt;</span>(<a href="./Validated" class="type-link">Validated</a>&lt;<span class="type">E</span>, <span class="type">B</span>&gt; <span class="type">Function</span>(<span class="type">A</span>) <span class="param">f</span>)</code></pre></div><p>Creates a new Validated by applying <code>f</code> if this is a <a href="/ribs/api/package-ribs_core_ribs_core/Valid.html">Valid</a>, otherwise returns the error value.</p><p><em>Inherited from Validated.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Validated</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">andThen</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Validated</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; f) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Validated</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.invalid, f);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_8, [
      _cache[25] || (_cache[25] = createTextVNode("bimap() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[26] || (_cache[26] = createTextVNode()),
      _cache[27] || (_cache[27] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#bimap",
        "aria-label": 'Permalink to "bimap() <Badge type="info" text="inherited" /> {#bimap}"'
      }, "​", -1))
    ]),
    _cache[101] || (_cache[101] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Validated" class="type-link">Validated</a>&lt;<span class="type">EE</span>, <span class="type">AA</span>&gt; <span class="fn">bimap&lt;EE, AA&gt;</span>(<span class="type">EE</span> <span class="type">Function</span>(<span class="type">E</span>) <span class="param">fe</span>, <span class="type">AA</span> <span class="type">Function</span>(<span class="type">A</span>) <span class="param">fa</span>)</code></pre></div><p>Returns a new Validated by applying <code>fe</code> or <code>fa</code> depending on if this instance is an <a href="/ribs/api/package-ribs_core_ribs_core/Invalid.html">Invalid</a> or <a href="/ribs/api/package-ribs_core_ribs_core/Valid.html">Valid</a> respectively.</p><p><em>Inherited from Validated.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Validated</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">EE</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">AA</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">bimap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">EE</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">AA</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">EE</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; fe, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">AA</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; fa) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((e) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fe</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(e).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">invalid</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(), (a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fa</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(a).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">valid</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">());</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_9, [
      _cache[28] || (_cache[28] = createTextVNode("ensure() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[29] || (_cache[29] = createTextVNode()),
      _cache[30] || (_cache[30] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#ensure",
        "aria-label": 'Permalink to "ensure() <Badge type="info" text="inherited" /> {#ensure}"'
      }, "​", -1))
    ]),
    _cache[102] || (_cache[102] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Validated" class="type-link">Validated</a>&lt;<span class="type">E</span>, <span class="type">A</span>&gt; <span class="fn">ensure</span>(<span class="type">bool</span> <span class="type">Function</span>(<span class="type">A</span>) <span class="param">p</span>, <span class="type">E</span> <span class="type">Function</span>() <span class="param">onFailure</span>)</code></pre></div><p>Tests if the valid value (if any) passes the given predicate <code>p</code>. If it fails, a new <a href="/ribs/api/package-ribs_core_ribs_core/Invalid.html">Invalid</a> with a value of <code>onFailure</code> is returned, otherwise this instance is returned.</p><p><em>Inherited from Validated.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Validated</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">ensure</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; p, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; onFailure) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, (a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> p</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> :</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Validated</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">invalid</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">onFailure</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">()));</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_10, [
      _cache[31] || (_cache[31] = createTextVNode("ensureOr() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[32] || (_cache[32] = createTextVNode()),
      _cache[33] || (_cache[33] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#ensureor",
        "aria-label": 'Permalink to "ensureOr() <Badge type="info" text="inherited" /> {#ensureor}"'
      }, "​", -1))
    ]),
    _cache[103] || (_cache[103] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Validated" class="type-link">Validated</a>&lt;<span class="type">E</span>, <span class="type">A</span>&gt; <span class="fn">ensureOr</span>(<span class="type">bool</span> <span class="type">Function</span>(<span class="type">A</span>) <span class="param">p</span>, <span class="type">E</span> <span class="type">Function</span>(<span class="type">A</span>) <span class="param">onFailure</span>)</code></pre></div><p>Tests if the valid value (if any) passes the given predicate <code>p</code>. If it fails, a new <a href="/ribs/api/package-ribs_core_ribs_core/Invalid.html">Invalid</a> with a value of <code>onFailure</code> is returned, otherwise this instance is returned.</p><p><em>Inherited from Validated.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Validated</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">ensureOr</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; p, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; onFailure) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, (a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> p</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> :</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Validated</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">invalid</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">onFailure</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(a)));</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_11, [
      _cache[34] || (_cache[34] = createTextVNode("exists() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[35] || (_cache[35] = createTextVNode()),
      _cache[36] || (_cache[36] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#exists",
        "aria-label": 'Permalink to "exists() <Badge type="info" text="inherited" /> {#exists}"'
      }, "​", -1))
    ]),
    _cache[104] || (_cache[104] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">exists</span>(<span class="type">bool</span> <span class="type">Function</span>(<span class="type">A</span>) <span class="param">p</span>)</code></pre></div><p>Returns true if this instance has a valid value to passes the given predicate <code>p</code>.</p><p><em>Inherited from Validated.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> exists</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; p) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((_) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> false</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, p);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_12, [
      _cache[37] || (_cache[37] = createTextVNode("fold() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "override"
      }),
      _cache[38] || (_cache[38] = createTextVNode()),
      _cache[39] || (_cache[39] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#fold",
        "aria-label": 'Permalink to "fold() <Badge type="info" text="override" /> {#fold}"'
      }, "​", -1))
    ]),
    _cache[105] || (_cache[105] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">B</span> <span class="fn">fold&lt;B&gt;</span>(<span class="type">B</span> <span class="type">Function</span>(<span class="type">E</span>) <span class="param">fe</span>, <span class="type">B</span> <span class="type">Function</span>(<span class="type">A</span>) <span class="param">fa</span>)</code></pre></div><p>Returns the result of applying <code>fe</code> if this is an instance of <a href="/ribs/api/package-ribs_core_ribs_core/Invalid.html">Invalid</a>, otherwise the result of applying <code>fa</code> to this <a href="/ribs/api/package-ribs_core_ribs_core/Valid.html">Valid</a>.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; fe, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; fa) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fa</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(value);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_13, [
      _cache[40] || (_cache[40] = createTextVNode("forall() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[41] || (_cache[41] = createTextVNode()),
      _cache[42] || (_cache[42] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#forall",
        "aria-label": 'Permalink to "forall() <Badge type="info" text="inherited" /> {#forall}"'
      }, "​", -1))
    ]),
    _cache[106] || (_cache[106] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">forall</span>(<span class="type">bool</span> <span class="type">Function</span>(<span class="type">A</span>) <span class="param">p</span>)</code></pre></div><p>Returns true if this instance has a valid value to passes the given predicate <code>p</code>.</p><p><em>Inherited from Validated.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> forall</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; p) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((_) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> true</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, p);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_14, [
      _cache[43] || (_cache[43] = createTextVNode("foreach() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[44] || (_cache[44] = createTextVNode()),
      _cache[45] || (_cache[45] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#foreach",
        "aria-label": 'Permalink to "foreach() <Badge type="info" text="inherited" /> {#foreach}"'
      }, "​", -1))
    ]),
    _cache[107] || (_cache[107] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">void</span> <span class="fn">foreach</span>(<span class="type">void</span> <span class="type">Function</span>(<span class="type">A</span>) <span class="param">f</span>)</code></pre></div><p>Applies the given side-effet <code>f</code> for every valid value this instance represents.</p><p><em>Inherited from Validated.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">void</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> foreach</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">void</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; f) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((_) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Unit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(), f);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_15, [
      _cache[46] || (_cache[46] = createTextVNode("getOrElse() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[47] || (_cache[47] = createTextVNode()),
      _cache[48] || (_cache[48] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#getorelse",
        "aria-label": 'Permalink to "getOrElse() <Badge type="info" text="inherited" /> {#getorelse}"'
      }, "​", -1))
    ]),
    _cache[108] || (_cache[108] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">A</span> <span class="fn">getOrElse</span>(<span class="type">A</span> <span class="type">Function</span>() <span class="param">orElse</span>)</code></pre></div><p>Returns the value of this instance if it is a <a href="/ribs/api/package-ribs_core_ribs_core/Valid.html">Valid</a>, otherwise returns the result of evaluating <code>orElse</code>.</p><p><em>Inherited from Validated.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> getOrElse</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; orElse) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((_) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> orElse</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(), identity);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_16, [
      _cache[49] || (_cache[49] = createTextVNode("leftMap() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[50] || (_cache[50] = createTextVNode()),
      _cache[51] || (_cache[51] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#leftmap",
        "aria-label": 'Permalink to "leftMap() <Badge type="info" text="inherited" /> {#leftmap}"'
      }, "​", -1))
    ]),
    _cache[109] || (_cache[109] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Validated" class="type-link">Validated</a>&lt;<span class="type">EE</span>, <span class="type">A</span>&gt; <span class="fn">leftMap&lt;EE&gt;</span>(<span class="type">EE</span> <span class="type">Function</span>(<span class="type">E</span>) <span class="param">f</span>)</code></pre></div><p>Returns a new validated by applying <code>f</code> to the value of this instance if it is an <a href="/ribs/api/package-ribs_core_ribs_core/Invalid.html">Invalid</a>.</p><p><em>Inherited from Validated.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Validated</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">EE</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">leftMap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">EE</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">EE</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; f) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((e) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> f</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(e).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">invalid</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(), (a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> a.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">valid</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">());</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_17, [
      _cache[52] || (_cache[52] = createTextVNode("map() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[53] || (_cache[53] = createTextVNode()),
      _cache[54] || (_cache[54] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#map",
        "aria-label": 'Permalink to "map() <Badge type="info" text="inherited" /> {#map}"'
      }, "​", -1))
    ]),
    _cache[110] || (_cache[110] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Validated" class="type-link">Validated</a>&lt;<span class="type">E</span>, <span class="type">B</span>&gt; <span class="fn">map&lt;B&gt;</span>(<span class="type">B</span> <span class="type">Function</span>(<span class="type">A</span>) <span class="param">f</span>)</code></pre></div><p>Returns a new validated by applying <code>f</code> to the value of this instance if it is a <a href="/ribs/api/package-ribs_core_ribs_core/Valid.html">Valid</a>.</p><p><em>Inherited from Validated.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Validated</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">map</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; f) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((e) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> e.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">invalid</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(), (a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> f</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(a).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">valid</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">());</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_18, [
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
    _cache[111] || (_cache[111] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">dynamic</span> <span class="fn">noSuchMethod</span>(<span class="type">Invocation</span> <span class="param">invocation</span>)</code></pre></div><p>Invoked when a nonexistent method or property is accessed.</p><p>A dynamic member invocation can attempt to call a member which doesn&#39;t exist on the receiving object. Example:</p><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">dynamic</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> object </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">object.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">add</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">42</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">); </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">// Statically allowed, run-time error</span></span></code></pre></div><p>This invalid code will invoke the <code>noSuchMethod</code> method of the integer <code>1</code> with an <a href="https://api.dart.dev/stable/3.11.5/dart-core/Invocation-class.html" target="_blank" rel="noreferrer">Invocation</a> representing the <code>.add(42)</code> call and arguments (which then throws).</p><p>Classes can override <a href="https://api.dart.dev/stable/3.11.5/dart-core/Object/noSuchMethod.html" target="_blank" rel="noreferrer">noSuchMethod</a> to provide custom behavior for such invalid dynamic invocations.</p><p>A class with a non-default <a href="https://api.dart.dev/stable/3.11.5/dart-core/Object/noSuchMethod.html" target="_blank" rel="noreferrer">noSuchMethod</a> invocation can also omit implementations for members of its interface. Example:</p><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">class</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MockList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">implements</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> List</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; {</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">  noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Invocation</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> invocation) {</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    log</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(invocation);</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    super</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(invocation); </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">// Will throw.</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  }</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">void</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> main</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() {</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  MockList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">().</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">add</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">42</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div><p>This code has no compile-time warnings or errors even though the <code>MockList</code> class has no concrete implementation of any of the <code>List</code> interface methods. Calls to <code>List</code> methods are forwarded to <code>noSuchMethod</code>, so this code will <code>log</code> an invocation similar to <code>Invocation.method(#add, [42])</code> and then throw.</p><p>If a value is returned from <code>noSuchMethod</code>, it becomes the result of the original invocation. If the value is not of a type that can be returned by the original invocation, a type error occurs at the invocation.</p><p>The default behavior is to throw a <a href="https://api.dart.dev/stable/3.11.5/dart-core/NoSuchMethodError-class.html" target="_blank" rel="noreferrer">NoSuchMethodError</a>.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@pragma</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;vm:entry-point&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@pragma</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;wasm:entry-point&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> dynamic</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Invocation</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> invocation);</span></span></code></pre></div></details>', 13)),
    createBaseVNode("h3", _hoisted_19, [
      _cache[58] || (_cache[58] = createTextVNode("orElse() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[59] || (_cache[59] = createTextVNode()),
      _cache[60] || (_cache[60] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#orelse",
        "aria-label": 'Permalink to "orElse() <Badge type="info" text="inherited" /> {#orelse}"'
      }, "​", -1))
    ]),
    _cache[112] || (_cache[112] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Validated" class="type-link">Validated</a>&lt;<span class="type">E</span>, <span class="type">A</span>&gt; <span class="fn">orElse</span>(<a href="./Validated" class="type-link">Validated</a>&lt;<span class="type">E</span>, <span class="type">A</span>&gt; <span class="type">Function</span>() <span class="param">orElse</span>)</code></pre></div><p>If this instance is a <a href="/ribs/api/package-ribs_core_ribs_core/Valid.html">Valid</a>, this is returned. Otherwise, the result of evaluating <code>orElse</code> is returned.</p><p><em>Inherited from Validated.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Validated</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">orElse</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Validated</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; orElse) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((_) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> orElse</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(), (_) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_20, [
      _cache[61] || (_cache[61] = createTextVNode("swap() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[62] || (_cache[62] = createTextVNode()),
      _cache[63] || (_cache[63] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#swap",
        "aria-label": 'Permalink to "swap() <Badge type="info" text="inherited" /> {#swap}"'
      }, "​", -1))
    ]),
    _cache[113] || (_cache[113] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Validated" class="type-link">Validated</a>&lt;<span class="type">A</span>, <span class="type">E</span>&gt; <span class="fn">swap</span>()</code></pre></div><p>Returns a new Validated where the invalid and valid types are swapped.</p><p><em>Inherited from Validated.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Validated</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">swap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((e) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> e.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">valid</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(), (a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> a.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">invalid</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">());</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_21, [
      _cache[64] || (_cache[64] = createTextVNode("toEither() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[65] || (_cache[65] = createTextVNode()),
      _cache[66] || (_cache[66] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#toeither",
        "aria-label": 'Permalink to "toEither() <Badge type="info" text="inherited" /> {#toeither}"'
      }, "​", -1))
    ]),
    _cache[114] || (_cache[114] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Either" class="type-link">Either</a>&lt;<span class="type">E</span>, <span class="type">A</span>&gt; <span class="fn">toEither</span>()</code></pre></div><p>Returns a new <a href="/ribs/api/package-ribs_core_ribs_core/Either.html">Either</a> where the left and right types correspond to the invalid and valid types respectively.</p><p><em>Inherited from Validated.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Either</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">toEither</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((e) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> e.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">asLeft</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(), (a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> a.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">asRight</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">());</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_22, [
      _cache[67] || (_cache[67] = createTextVNode("toIList() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[68] || (_cache[68] = createTextVNode()),
      _cache[69] || (_cache[69] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#toilist",
        "aria-label": 'Permalink to "toIList() <Badge type="info" text="inherited" /> {#toilist}"'
      }, "​", -1))
    ]),
    _cache[115] || (_cache[115] = createStaticVNode('<div class="member-signature"><pre><code><a href="./IList" class="type-link">IList</a>&lt;<span class="type">A</span>&gt; <span class="fn">toIList</span>()</code></pre></div><p>Returns a new <a href="/ribs/api/package-ribs_core_ribs_core/IList.html">IList</a> with the valid value of this instance, if any. If this instance is <a href="/ribs/api/package-ribs_core_ribs_core/Invalid.html">Invalid</a>, an empty <a href="/ribs/api/package-ribs_core_ribs_core/IList.html">IList</a> is returned.</p><p><em>Inherited from Validated.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">toIList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((_) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> nil</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(), (a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> IList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">fromDart</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">([a]));</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_23, [
      _cache[70] || (_cache[70] = createTextVNode("toOption() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[71] || (_cache[71] = createTextVNode()),
      _cache[72] || (_cache[72] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#tooption",
        "aria-label": 'Permalink to "toOption() <Badge type="info" text="inherited" /> {#tooption}"'
      }, "​", -1))
    ]),
    _cache[116] || (_cache[116] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Option" class="type-link">Option</a>&lt;<span class="type">A</span>&gt; <span class="fn">toOption</span>()</code></pre></div><p>Returns <a href="/ribs/api/package-ribs_core_ribs_core/None.html">None</a> if this instance is an <a href="/ribs/api/package-ribs_core_ribs_core/Invalid.html">Invalid</a>, otherwise a <a href="/ribs/api/package-ribs_core_ribs_core/Some.html">Some</a> with the valid value.</p><p><em>Inherited from Validated.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">toOption</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((_) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> none</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(), (a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Some</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(a));</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_24, [
      _cache[73] || (_cache[73] = createTextVNode("toString() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[74] || (_cache[74] = createTextVNode()),
      _cache[75] || (_cache[75] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#tostring",
        "aria-label": 'Permalink to "toString() <Badge type="info" text="inherited" /> {#tostring}"'
      }, "​", -1))
    ]),
    _cache[117] || (_cache[117] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">String</span> <span class="fn">toString</span>()</code></pre></div><p>A string representation of this object.</p><p>Some classes have a default textual representation, often paired with a static <code>parse</code> function (like <a href="https://api.dart.dev/stable/3.11.5/dart-core/int/parse.html" target="_blank" rel="noreferrer">int.parse</a>). These classes will provide the textual representation as their string representation.</p><p>Other classes have no meaningful textual representation that a program will care about. Such classes will typically override <code>toString</code> to provide useful information when inspecting the object, mainly for debugging or logging.</p><p><em>Inherited from Validated.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> toString</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;Invalid(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">$</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">a</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">)&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, (b) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;"> &#39;Valid(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">$</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">b</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">)&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 6)),
    createBaseVNode("h3", _hoisted_25, [
      _cache[76] || (_cache[76] = createTextVNode("toValidatedNel() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[77] || (_cache[77] = createTextVNode()),
      _cache[78] || (_cache[78] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#tovalidatednel",
        "aria-label": 'Permalink to "toValidatedNel() <Badge type="info" text="inherited" /> {#tovalidatednel}"'
      }, "​", -1))
    ]),
    _cache[118] || (_cache[118] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Validated" class="type-link">ValidatedNel</a>&lt;<a href="./NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">E</span>&gt;, <span class="type">A</span>&gt; <span class="fn">toValidatedNel</span>()</code></pre></div><p>Converts this instance to a <a href="/ribs/api/package-ribs_core_ribs_core/ValidatedNel.html">ValidatedNel</a>.</p><p><em>Inherited from Validated.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">ValidatedNel</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">toValidatedNel</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Validated</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.invalidNel, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Validated</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.validNel);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_26, [
      _cache[79] || (_cache[79] = createTextVNode("valueOr() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[80] || (_cache[80] = createTextVNode()),
      _cache[81] || (_cache[81] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#valueor",
        "aria-label": 'Permalink to "valueOr() <Badge type="info" text="inherited" /> {#valueor}"'
      }, "​", -1))
    ]),
    _cache[119] || (_cache[119] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">A</span> <span class="fn">valueOr</span>(<span class="type">A</span> <span class="type">Function</span>(<span class="type">E</span>) <span class="param">f</span>)</code></pre></div><p>Alias for <a href="/ribs/api/package-ribs_core_ribs_core/Validated.html#fold">fold</a>.</p><p><em>Inherited from Validated.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> valueOr</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; f) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(f, identity);</span></span></code></pre></div></details><h2 id="extension-section-methods" tabindex="-1">Extension Methods <a class="header-anchor" href="#extension-section-methods" aria-label="Permalink to &quot;Extension Methods {#extension-section-methods}&quot;">​</a></h2>', 5)),
    createBaseVNode("h3", _hoisted_27, [
      _cache[82] || (_cache[82] = createTextVNode("ap() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[83] || (_cache[83] = createTextVNode()),
      _cache[84] || (_cache[84] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#ap",
        "aria-label": 'Permalink to "ap() <Badge type="info" text="extension" /> {#ap}"'
      }, "​", -1))
    ]),
    _cache[120] || (_cache[120] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Validated" class="type-link">ValidatedNel</a>&lt;<a href="./NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">E</span>&gt;, <span class="type">B</span>&gt; <span class="fn">ap&lt;B&gt;</span>(\n  <a href="./Validated" class="type-link">ValidatedNel</a>&lt;<a href="./NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">E</span>&gt;, <span class="type">B</span> <span class="type">Function</span>(<span class="type">A</span>)&gt; <span class="param">f</span>,\n)</code></pre></div><p>Applies <code>f</code> to this value if both instance are <a href="/ribs/api/package-ribs_core_ribs_core/Valid.html">Valid</a>. Otherwise returns the error if either is <a href="/ribs/api/package-ribs_core_ribs_core/Invalid.html">Invalid</a> or the accumulation of errors if both are <a href="/ribs/api/package-ribs_core_ribs_core/Invalid.html">Invalid</a>.</p><p><em>Available on <a href="/ribs/api/package-ribs_core_ribs_core/Validated.html">Validated&lt;E, A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_core_ribs_core/ValidatedNelOps.html">ValidatedNelOps&lt;E, A&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">ValidatedNel</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">ap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">ValidatedNel</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; f) {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  return</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    (e) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> f.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">      (ef) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> e.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">concatNel</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(ef).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">invalid</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">      (af) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> e.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">invalid</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    ),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    (a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> f.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">      (ef) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> ef.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">invalid</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">      (af) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> af</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(a).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">validNel</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    ),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  );</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_28, [
      _cache[85] || (_cache[85] = createTextVNode("flatten() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[86] || (_cache[86] = createTextVNode()),
      _cache[87] || (_cache[87] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#flatten",
        "aria-label": 'Permalink to "flatten() <Badge type="info" text="extension" /> {#flatten}"'
      }, "​", -1))
    ]),
    _cache[121] || (_cache[121] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Validated" class="type-link">Validated</a>&lt;<span class="type">E</span>, <span class="type">A</span>&gt; <span class="fn">flatten</span>()</code></pre></div><p>Extracts the nested <a href="/ribs/api/package-ribs_core_ribs_core/Validated.html">Validated</a> via <a href="/ribs/api/package-ribs_core_ribs_core/Validated.html#fold">fold</a>.</p><p><em>Available on <a href="/ribs/api/package-ribs_core_ribs_core/Validated.html">Validated&lt;E, A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_core_ribs_core/ValidatedNestedOps.html">ValidatedNestedOps&lt;E, A&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Validated</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">flatten</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  (e) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> e.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">invalid</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  (va) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> va.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    (e) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> e.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">invalid</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    (a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> a.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">valid</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  ),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_29, [
      _cache[88] || (_cache[88] = createTextVNode("product() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[89] || (_cache[89] = createTextVNode()),
      _cache[90] || (_cache[90] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#product",
        "aria-label": 'Permalink to "product() <Badge type="info" text="extension" /> {#product}"'
      }, "​", -1))
    ]),
    _cache[122] || (_cache[122] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Validated" class="type-link">ValidatedNel</a>&lt;<a href="./NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">E</span>&gt;, <span class="type">Record</span>&gt; <span class="fn">product&lt;B&gt;</span>(\n  <a href="./Validated" class="type-link">ValidatedNel</a>&lt;<a href="./NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">E</span>&gt;, <span class="type">B</span>&gt; <span class="param">that</span>,\n)</code></pre></div><p>Returns the product (tuple) of this validation and <code>that</code> if both instances are <a href="/ribs/api/package-ribs_core_ribs_core/Valid.html">Valid</a>. Otherwise returns the error if either is <a href="/ribs/api/package-ribs_core_ribs_core/Invalid.html">Invalid</a> or the accumulation of errors if both are <a href="/ribs/api/package-ribs_core_ribs_core/Invalid.html">Invalid</a>.</p><p><em>Available on <a href="/ribs/api/package-ribs_core_ribs_core/Validated.html">Validated&lt;E, A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_core_ribs_core/ValidatedNelOps.html">ValidatedNelOps&lt;E, A&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">ValidatedNel</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, (</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">product</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">ValidatedNel</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; that) {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  return</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    (e) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">      (ef) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> e.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">concatNel</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(ef).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">invalid</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">      (af) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> e.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">invalid</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    ),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    (a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> that.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">      (ef) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> ef.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">invalid</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">      (af) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> (a, af).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">validNel</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    ),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  );</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div></details><h2 id="section-operators" tabindex="-1">Operators <a class="header-anchor" href="#section-operators" aria-label="Permalink to &quot;Operators {#section-operators}&quot;">​</a></h2>', 5)),
    createBaseVNode("h3", _hoisted_30, [
      _cache[91] || (_cache[91] = createTextVNode("operator ==() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[92] || (_cache[92] = createTextVNode()),
      _cache[93] || (_cache[93] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#operator-equals",
        "aria-label": 'Permalink to "operator ==() <Badge type="info" text="inherited" /> {#operator-equals}"'
      }, "​", -1))
    ]),
    _cache[123] || (_cache[123] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator ==</span>(<span class="type">Object</span> <span class="param">other</span>)</code></pre></div><p>The equality operator.</p><p>The default behavior for all <a href="https://api.dart.dev/stable/3.11.5/dart-core/Object-class.html" target="_blank" rel="noreferrer">Object</a>s is to return true if and only if this object and <code>other</code> are the same object.</p><p>Override this method to specify a different equality relation on a class. The overriding method must still be an equivalence relation. That is, it must be:</p><ul><li><p>Total: It must return a boolean for all arguments. It should never throw.</p></li><li><p>Reflexive: For all objects <code>o</code>, <code>o == o</code> must be true.</p></li><li><p>Symmetric: For all objects <code>o1</code> and <code>o2</code>, <code>o1 == o2</code> and <code>o2 == o1</code> must either both be true, or both be false.</p></li><li><p>Transitive: For all objects <code>o1</code>, <code>o2</code>, and <code>o3</code>, if <code>o1 == o2</code> and <code>o2 == o3</code> are true, then <code>o1 == o3</code> must be true.</p></li></ul><p>The method should also be consistent over time, so whether two objects are equal should only change if at least one of the objects was modified.</p><p>If a subclass overrides the equality operator, it should override the <a href="/ribs/api/package-ribs_core_ribs_core/Valid.html#prop-hashcode">hashCode</a> method as well to maintain consistency.</p><p><em>Inherited from Validated.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> ==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Object</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  (e) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">is</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Invalid</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&amp;&amp;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other.value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> e,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  (a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">is</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Valid</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">E</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&amp;&amp;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other.value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> a,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 9))
  ]);
}
const Valid = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  Valid as default
};
