import { r as resolveComponent, o as openBlock, c as createElementBlock, b as createBaseVNode, d as createTextVNode, e as createVNode, a as createStaticVNode, _ as _export_sfc } from "./app.DZyhbRKH.js";
const __pageData = JSON.parse('{"title":"PQueue","description":"API documentation for PQueue<A> class from ribs_effect","frontmatter":{"title":"PQueue<A>","description":"API documentation for PQueue<A> class from ribs_effect","category":"Classes","library":"ribs_effect","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_effect_ribs_effect/PQueue.md","filePath":"api/package-ribs_effect_ribs_effect/PQueue.md"}');
const _sfc_main = { name: "api/package-ribs_effect_ribs_effect/PQueue.md" };
const _hoisted_1 = {
  id: "pqueue-a",
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
  id: "nosuchmethod",
  tabindex: "-1"
};
const _hoisted_5 = {
  id: "offer",
  tabindex: "-1"
};
const _hoisted_6 = {
  id: "size",
  tabindex: "-1"
};
const _hoisted_7 = {
  id: "take",
  tabindex: "-1"
};
const _hoisted_8 = {
  id: "tostring",
  tabindex: "-1"
};
const _hoisted_9 = {
  id: "tryoffer",
  tabindex: "-1"
};
const _hoisted_10 = {
  id: "tryoffern",
  tabindex: "-1"
};
const _hoisted_11 = {
  id: "trytake",
  tabindex: "-1"
};
const _hoisted_12 = {
  id: "trytaken",
  tabindex: "-1"
};
const _hoisted_13 = {
  id: "operator-equals",
  tabindex: "-1"
};
const _hoisted_14 = {
  id: "bounded",
  tabindex: "-1"
};
const _hoisted_15 = {
  id: "unbounded",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    createBaseVNode("h1", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("PQueue<A> ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "abstract"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#pqueue-a",
        "aria-label": 'Permalink to "PQueue\\<A\\> <Badge type="info" text="abstract" />"'
      }, "​", -1))
    ]),
    _cache[47] || (_cache[47] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">abstract</span> <span class="kw">class</span> <span class="fn">PQueue</span>&lt;A&gt; <span class="kw">extends</span> <a href="./Queue" class="type-link">Queue</a>&lt;<span class="type">A</span>&gt;</code></pre></div><div class="info custom-block"><p class="custom-block-title">Inheritance</p><p>Object → <a href="/ribs/api/package-ribs_effect_ribs_effect/Queue.html">Queue&lt;A&gt;</a> → <strong>PQueue&lt;A&gt;</strong></p></div><h2 id="section-constructors" tabindex="-1">Constructors <a class="header-anchor" href="#section-constructors" aria-label="Permalink to &quot;Constructors {#section-constructors}&quot;">​</a></h2><h3 id="ctor-pqueue" tabindex="-1">PQueue() <a class="header-anchor" href="#ctor-pqueue" aria-label="Permalink to &quot;PQueue() {#ctor-pqueue}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="fn">PQueue</span>()</code></pre></div><h2 id="section-properties" tabindex="-1">Properties <a class="header-anchor" href="#section-properties" aria-label="Permalink to &quot;Properties {#section-properties}&quot;">​</a></h2>', 6)),
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
    _cache[48] || (_cache[48] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></code></pre></div><p>The hash code for this object.</p><p>A hash code is a single integer which represents the state of the object that affects <a href="/ribs/api/package-ribs_effect_ribs_effect/PQueue.html#operator-equals">operator ==</a> comparisons.</p><p>All objects have hash codes. The default hash code implemented by <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object-class.html" target="_blank" rel="noreferrer">Object</a> represents only the identity of the object, the same way as the default <a href="/ribs/api/package-ribs_effect_ribs_effect/PQueue.html#operator-equals">operator ==</a> implementation only considers objects equal if they are identical (see <a href="https://api.dart.dev/stable/3.11.4/dart-core/identityHashCode.html" target="_blank" rel="noreferrer">identityHashCode</a>).</p><p>If <a href="/ribs/api/package-ribs_effect_ribs_effect/PQueue.html#operator-equals">operator ==</a> is overridden to use the object state instead, the hash code must also be changed to represent that state, otherwise the object cannot be used in hash based data structures like the default <a href="https://api.dart.dev/stable/3.11.4/dart-core/Set-class.html" target="_blank" rel="noreferrer">Set</a> and <a href="https://api.dart.dev/stable/3.11.4/dart-core/Map-class.html" target="_blank" rel="noreferrer">Map</a> implementations.</p><p>Hash codes must be the same for objects that are equal to each other according to <a href="/ribs/api/package-ribs_effect_ribs_effect/PQueue.html#operator-equals">operator ==</a>. The hash code of an object should only change if the object changes in a way that affects equality. There are no further requirements for the hash codes. They need not be consistent between executions of the same program and there are no distribution guarantees.</p><p>Objects that are not equal are allowed to have the same hash code. It is even technically allowed that all instances have the same hash code, but if clashes happen too often, it may reduce the efficiency of hash-based data structures like <a href="https://api.dart.dev/stable/3.11.4/dart-collection/HashSet-class.html" target="_blank" rel="noreferrer">HashSet</a> or <a href="https://api.dart.dev/stable/3.11.4/dart-collection/HashMap-class.html" target="_blank" rel="noreferrer">HashMap</a>.</p><p>If a subclass overrides <a href="/ribs/api/package-ribs_effect_ribs_effect/PQueue.html#prop-hashcode">hashCode</a>, it should override the <a href="/ribs/api/package-ribs_effect_ribs_effect/PQueue.html#operator-equals">operator ==</a> operator as well to maintain consistency.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> hashCode;</span></span></code></pre></div></details>', 10)),
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
    _cache[49] || (_cache[49] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">Type</span> <span class="kw">get</span> <span class="fn">runtimeType</span></code></pre></div><p>A representation of the runtime type of the object.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Type</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> runtimeType;</span></span></code></pre></div></details><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 5)),
    createBaseVNode("h3", _hoisted_4, [
      _cache[11] || (_cache[11] = createTextVNode("noSuchMethod() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[12] || (_cache[12] = createTextVNode()),
      _cache[13] || (_cache[13] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#nosuchmethod",
        "aria-label": 'Permalink to "noSuchMethod() <Badge type="info" text="inherited" /> {#nosuchmethod}"'
      }, "​", -1))
    ]),
    _cache[50] || (_cache[50] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">dynamic</span> <span class="fn">noSuchMethod</span>(<span class="type">Invocation</span> <span class="param">invocation</span>)</code></pre></div><p>Invoked when a nonexistent method or property is accessed.</p><p>A dynamic member invocation can attempt to call a member which doesn&#39;t exist on the receiving object. Example:</p><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">dynamic</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> object </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">object.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">add</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">42</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">); </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">// Statically allowed, run-time error</span></span></code></pre></div><p>This invalid code will invoke the <code>noSuchMethod</code> method of the integer <code>1</code> with an <a href="https://api.dart.dev/stable/3.11.4/dart-core/Invocation-class.html" target="_blank" rel="noreferrer">Invocation</a> representing the <code>.add(42)</code> call and arguments (which then throws).</p><p>Classes can override <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object/noSuchMethod.html" target="_blank" rel="noreferrer">noSuchMethod</a> to provide custom behavior for such invalid dynamic invocations.</p><p>A class with a non-default <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object/noSuchMethod.html" target="_blank" rel="noreferrer">noSuchMethod</a> invocation can also omit implementations for members of its interface. Example:</p><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">class</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MockList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">implements</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> List</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; {</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">  noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Invocation</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> invocation) {</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    log</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(invocation);</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    super</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(invocation); </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">// Will throw.</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  }</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">void</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> main</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() {</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  MockList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">().</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">add</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">42</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div><p>This code has no compile-time warnings or errors even though the <code>MockList</code> class has no concrete implementation of any of the <code>List</code> interface methods. Calls to <code>List</code> methods are forwarded to <code>noSuchMethod</code>, so this code will <code>log</code> an invocation similar to <code>Invocation.method(#add, [42])</code> and then throw.</p><p>If a value is returned from <code>noSuchMethod</code>, it becomes the result of the original invocation. If the value is not of a type that can be returned by the original invocation, a type error occurs at the invocation.</p><p>The default behavior is to throw a <a href="https://api.dart.dev/stable/3.11.4/dart-core/NoSuchMethodError-class.html" target="_blank" rel="noreferrer">NoSuchMethodError</a>.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@pragma</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;vm:entry-point&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@pragma</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;wasm:entry-point&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> dynamic</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Invocation</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> invocation);</span></span></code></pre></div></details>', 13)),
    createBaseVNode("h3", _hoisted_5, [
      _cache[14] || (_cache[14] = createTextVNode("offer() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[15] || (_cache[15] = createTextVNode()),
      _cache[16] || (_cache[16] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#offer",
        "aria-label": 'Permalink to "offer() <Badge type="info" text="inherited" /> {#offer}"'
      }, "​", -1))
    ]),
    _cache[51] || (_cache[51] = createStaticVNode('<div class="member-signature"><pre><code><a href="./IO" class="type-link">IO</a>&lt;<a href="../package-ribs_core_ribs_core/Unit" class="type-link">Unit</a>&gt; <span class="fn">offer</span>(<span class="type">A</span> <span class="param">a</span>)</code></pre></div><p><em>Inherited from Queue.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Unit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">offer</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> a);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_6, [
      _cache[17] || (_cache[17] = createTextVNode("size() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[18] || (_cache[18] = createTextVNode()),
      _cache[19] || (_cache[19] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#size",
        "aria-label": 'Permalink to "size() <Badge type="info" text="inherited" /> {#size}"'
      }, "​", -1))
    ]),
    _cache[52] || (_cache[52] = createStaticVNode('<div class="member-signature"><pre><code><a href="./IO" class="type-link">IO</a>&lt;<span class="type">int</span>&gt; <span class="fn">size</span>()</code></pre></div><p><em>Inherited from Queue.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">size</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">();</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_7, [
      _cache[20] || (_cache[20] = createTextVNode("take() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[21] || (_cache[21] = createTextVNode()),
      _cache[22] || (_cache[22] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#take",
        "aria-label": 'Permalink to "take() <Badge type="info" text="inherited" /> {#take}"'
      }, "​", -1))
    ]),
    _cache[53] || (_cache[53] = createStaticVNode('<div class="member-signature"><pre><code><a href="./IO" class="type-link">IO</a>&lt;<span class="type">A</span>&gt; <span class="fn">take</span>()</code></pre></div><p><em>Inherited from Queue.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">take</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">();</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_8, [
      _cache[23] || (_cache[23] = createTextVNode("toString() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[24] || (_cache[24] = createTextVNode()),
      _cache[25] || (_cache[25] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#tostring",
        "aria-label": 'Permalink to "toString() <Badge type="info" text="inherited" /> {#tostring}"'
      }, "​", -1))
    ]),
    _cache[54] || (_cache[54] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">String</span> <span class="fn">toString</span>()</code></pre></div><p>A string representation of this object.</p><p>Some classes have a default textual representation, often paired with a static <code>parse</code> function (like <a href="https://api.dart.dev/stable/3.11.4/dart-core/int/parse.html" target="_blank" rel="noreferrer">int.parse</a>). These classes will provide the textual representation as their string representation.</p><p>Other classes have no meaningful textual representation that a program will care about. Such classes will typically override <code>toString</code> to provide useful information when inspecting the object, mainly for debugging or logging.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> String</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> toString</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">();</span></span></code></pre></div></details>', 6)),
    createBaseVNode("h3", _hoisted_9, [
      _cache[26] || (_cache[26] = createTextVNode("tryOffer() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[27] || (_cache[27] = createTextVNode()),
      _cache[28] || (_cache[28] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#tryoffer",
        "aria-label": 'Permalink to "tryOffer() <Badge type="info" text="inherited" /> {#tryoffer}"'
      }, "​", -1))
    ]),
    _cache[55] || (_cache[55] = createStaticVNode('<div class="member-signature"><pre><code><a href="./IO" class="type-link">IO</a>&lt;<span class="type">bool</span>&gt; <span class="fn">tryOffer</span>(<span class="type">A</span> <span class="param">a</span>)</code></pre></div><p><em>Inherited from Queue.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">tryOffer</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> a);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_10, [
      _cache[29] || (_cache[29] = createTextVNode("tryOfferN() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[30] || (_cache[30] = createTextVNode()),
      _cache[31] || (_cache[31] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#tryoffern",
        "aria-label": 'Permalink to "tryOfferN() <Badge type="info" text="inherited" /> {#tryoffern}"'
      }, "​", -1))
    ]),
    _cache[56] || (_cache[56] = createStaticVNode('<div class="member-signature"><pre><code><a href="./IO" class="type-link">IO</a>&lt;<a href="../package-ribs_core_ribs_core/IList" class="type-link">IList</a>&lt;<span class="type">A</span>&gt;&gt; <span class="fn">tryOfferN</span>(<a href="../package-ribs_core_ribs_core/IList" class="type-link">IList</a>&lt;<span class="type">A</span>&gt; <span class="param">list</span>)</code></pre></div><p><em>Inherited from Queue.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">tryOfferN</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; list) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> list.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">uncons</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  (hdtl) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> hdtl.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">foldN</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    () </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">pure</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(list),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    (hd, tl) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> tryOffer</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(hd).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">ifM</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> tryOfferN</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(tl), () </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">pure</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(list)),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  ),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_11, [
      _cache[32] || (_cache[32] = createTextVNode("tryTake() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[33] || (_cache[33] = createTextVNode()),
      _cache[34] || (_cache[34] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#trytake",
        "aria-label": 'Permalink to "tryTake() <Badge type="info" text="inherited" /> {#trytake}"'
      }, "​", -1))
    ]),
    _cache[57] || (_cache[57] = createStaticVNode('<div class="member-signature"><pre><code><a href="./IO" class="type-link">IO</a>&lt;<a href="../package-ribs_core_ribs_core/Option" class="type-link">Option</a>&lt;<span class="type">A</span>&gt;&gt; <span class="fn">tryTake</span>()</code></pre></div><p><em>Inherited from Queue.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">tryTake</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">();</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_12, [
      _cache[35] || (_cache[35] = createTextVNode("tryTakeN() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[36] || (_cache[36] = createTextVNode()),
      _cache[37] || (_cache[37] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#trytaken",
        "aria-label": 'Permalink to "tryTakeN() <Badge type="info" text="inherited" /> {#trytaken}"'
      }, "​", -1))
    ]),
    _cache[58] || (_cache[58] = createStaticVNode('<div class="member-signature"><pre><code><a href="./IO" class="type-link">IO</a>&lt;<a href="../package-ribs_core_ribs_core/IList" class="type-link">IList</a>&lt;<span class="type">A</span>&gt;&gt; <span class="fn">tryTakeN</span>(<a href="../package-ribs_core_ribs_core/Option" class="type-link">Option</a>&lt;<span class="type">int</span>&gt; <span class="param">maxN</span>)</code></pre></div><p><em>Inherited from Queue.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">tryTakeN</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; maxN) {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  return</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">defer</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(() {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">    final</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> limit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> maxN.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">getOrElse</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Integer</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.maxValue);</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">    if</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> (limit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">return</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">pure</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">nil</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">());</span></span>\n<span class="line"></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">    var</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> count </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">    var</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> acc </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> nil</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;();</span></span>\n<span class="line"></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">    return</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> tryTake</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">()</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">        .</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">flatMap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((oa) {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">          return</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> oa.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">            () </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">pure</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">false</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">            (a) {</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">              acc </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> acc.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">prepended</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(a);</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">              count</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">++</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">              return</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">pure</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(count </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> limit);</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">            },</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">          );</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">        })</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">        .</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">iterateWhile</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((b) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> b)</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">        .</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">map</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((_) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> acc.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">reverse</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">());</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  });</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div></details><h2 id="section-operators" tabindex="-1">Operators <a class="header-anchor" href="#section-operators" aria-label="Permalink to &quot;Operators {#section-operators}&quot;">​</a></h2>', 4)),
    createBaseVNode("h3", _hoisted_13, [
      _cache[38] || (_cache[38] = createTextVNode("operator ==() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[39] || (_cache[39] = createTextVNode()),
      _cache[40] || (_cache[40] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#operator-equals",
        "aria-label": 'Permalink to "operator ==() <Badge type="info" text="inherited" /> {#operator-equals}"'
      }, "​", -1))
    ]),
    _cache[59] || (_cache[59] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator ==</span>(<span class="type">Object</span> <span class="param">other</span>)</code></pre></div><p>The equality operator.</p><p>The default behavior for all <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object-class.html" target="_blank" rel="noreferrer">Object</a>s is to return true if and only if this object and <code>other</code> are the same object.</p><p>Override this method to specify a different equality relation on a class. The overriding method must still be an equivalence relation. That is, it must be:</p><ul><li><p>Total: It must return a boolean for all arguments. It should never throw.</p></li><li><p>Reflexive: For all objects <code>o</code>, <code>o == o</code> must be true.</p></li><li><p>Symmetric: For all objects <code>o1</code> and <code>o2</code>, <code>o1 == o2</code> and <code>o2 == o1</code> must either both be true, or both be false.</p></li><li><p>Transitive: For all objects <code>o1</code>, <code>o2</code>, and <code>o3</code>, if <code>o1 == o2</code> and <code>o2 == o3</code> are true, then <code>o1 == o3</code> must be true.</p></li></ul><p>The method should also be consistent over time, so whether two objects are equal should only change if at least one of the objects was modified.</p><p>If a subclass overrides the equality operator, it should override the <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object/hashCode.html" target="_blank" rel="noreferrer">hashCode</a> method as well to maintain consistency.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> ==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Object</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other);</span></span></code></pre></div></details><h2 id="section-static-methods" tabindex="-1">Static Methods <a class="header-anchor" href="#section-static-methods" aria-label="Permalink to &quot;Static Methods {#section-static-methods}&quot;">​</a></h2>', 10)),
    createBaseVNode("h3", _hoisted_14, [
      _cache[41] || (_cache[41] = createTextVNode("bounded() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "override"
      }),
      _cache[42] || (_cache[42] = createTextVNode()),
      _cache[43] || (_cache[43] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#bounded",
        "aria-label": 'Permalink to "bounded() <Badge type="info" text="override" /> {#bounded}"'
      }, "​", -1))
    ]),
    _cache[60] || (_cache[60] = createStaticVNode('<div class="member-signature"><pre><code><a href="./IO" class="type-link">IO</a>&lt;<a href="./PQueue" class="type-link">PQueue</a>&lt;<span class="type">A</span>&gt;&gt; <span class="fn">bounded&lt;A&gt;</span>(<a href="../package-ribs_core_ribs_core/Order" class="type-link">Order</a>&lt;<span class="type">A</span>&gt; <span class="param">order</span>, <span class="type">int</span> <span class="param">capacity</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">PQueue</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">bounded</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Order</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; order, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> capacity) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    Ref</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">of</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">_State</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">empty</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(order)).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">map</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((ref) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> _BoundedPQueue</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">._(ref, capacity));</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_15, [
      _cache[44] || (_cache[44] = createTextVNode("unbounded() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "override"
      }),
      _cache[45] || (_cache[45] = createTextVNode()),
      _cache[46] || (_cache[46] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#unbounded",
        "aria-label": 'Permalink to "unbounded() <Badge type="info" text="override" /> {#unbounded}"'
      }, "​", -1))
    ]),
    _cache[61] || (_cache[61] = createStaticVNode('<div class="member-signature"><pre><code><a href="./IO" class="type-link">IO</a>&lt;<a href="./PQueue" class="type-link">PQueue</a>&lt;<span class="type">A</span>&gt;&gt; <span class="fn">unbounded&lt;A&gt;</span>(<a href="../package-ribs_core_ribs_core/Order" class="type-link">Order</a>&lt;<span class="type">A</span>&gt; <span class="param">order</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">PQueue</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">unbounded</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Order</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; order) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> bounded</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(order, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Integer</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.maxValue);</span></span></code></pre></div></details>', 2))
  ]);
}
const PQueue = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  PQueue as default
};
