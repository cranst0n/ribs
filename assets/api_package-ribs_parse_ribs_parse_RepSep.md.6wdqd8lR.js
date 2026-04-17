import { r as resolveComponent, o as openBlock, c as createElementBlock, a as createBaseVNode, b as createTextVNode, d as createVNode, e as createStaticVNode, _ as _export_sfc } from "./app.CoVeL4pB.js";
const __pageData = JSON.parse('{"title":"RepSep","description":"API documentation for RepSep<A> class from ribs_parse","frontmatter":{"title":"RepSep<A>","description":"API documentation for RepSep<A> class from ribs_parse","category":"Classes","library":"ribs_parse","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_parse_ribs_parse/RepSep.md","filePath":"api/package-ribs_parse_ribs_parse/RepSep.md"}');
const _sfc_main = { name: "api/package-ribs_parse_ribs_parse/RepSep.md" };
const _hoisted_1 = {
  id: "repsep-a",
  tabindex: "-1"
};
const _hoisted_2 = {
  id: "prop-backtrack",
  tabindex: "-1"
};
const _hoisted_3 = {
  id: "prop-hashcode",
  tabindex: "-1"
};
const _hoisted_4 = {
  id: "prop-not",
  tabindex: "-1"
};
const _hoisted_5 = {
  id: "prop-opt",
  tabindex: "-1"
};
const _hoisted_6 = {
  id: "prop-p1",
  tabindex: "-1"
};
const _hoisted_7 = {
  id: "prop-peek",
  tabindex: "-1"
};
const _hoisted_8 = {
  id: "prop-runtimetype",
  tabindex: "-1"
};
const _hoisted_9 = {
  id: "prop-sep",
  tabindex: "-1"
};
const _hoisted_10 = {
  id: "prop-soft",
  tabindex: "-1"
};
const _hoisted_11 = {
  id: "prop-string",
  tabindex: "-1"
};
const _hoisted_12 = {
  id: "prop-voided",
  tabindex: "-1"
};
const _hoisted_13 = {
  id: "prop-with1",
  tabindex: "-1"
};
const _hoisted_14 = {
  id: "prop-withstring",
  tabindex: "-1"
};
const _hoisted_15 = {
  id: "as",
  tabindex: "-1"
};
const _hoisted_16 = {
  id: "between",
  tabindex: "-1"
};
const _hoisted_17 = {
  id: "eitheror",
  tabindex: "-1"
};
const _hoisted_18 = {
  id: "filter",
  tabindex: "-1"
};
const _hoisted_19 = {
  id: "flatmap",
  tabindex: "-1"
};
const _hoisted_20 = {
  id: "map",
  tabindex: "-1"
};
const _hoisted_21 = {
  id: "mapfilter",
  tabindex: "-1"
};
const _hoisted_22 = {
  id: "nosuchmethod",
  tabindex: "-1"
};
const _hoisted_23 = {
  id: "orelse",
  tabindex: "-1"
};
const _hoisted_24 = {
  id: "parse",
  tabindex: "-1"
};
const _hoisted_25 = {
  id: "parseall",
  tabindex: "-1"
};
const _hoisted_26 = {
  id: "product",
  tabindex: "-1"
};
const _hoisted_27 = {
  id: "productl",
  tabindex: "-1"
};
const _hoisted_28 = {
  id: "productr",
  tabindex: "-1"
};
const _hoisted_29 = {
  id: "rep",
  tabindex: "-1"
};
const _hoisted_30 = {
  id: "rep0",
  tabindex: "-1"
};
const _hoisted_31 = {
  id: "repas",
  tabindex: "-1"
};
const _hoisted_32 = {
  id: "repas0",
  tabindex: "-1"
};
const _hoisted_33 = {
  id: "repexactlyas",
  tabindex: "-1"
};
const _hoisted_34 = {
  id: "repsep",
  tabindex: "-1"
};
const _hoisted_35 = {
  id: "repsep0",
  tabindex: "-1"
};
const _hoisted_36 = {
  id: "repuntil",
  tabindex: "-1"
};
const _hoisted_37 = {
  id: "repuntil0",
  tabindex: "-1"
};
const _hoisted_38 = {
  id: "repuntilas",
  tabindex: "-1"
};
const _hoisted_39 = {
  id: "repuntilas0",
  tabindex: "-1"
};
const _hoisted_40 = {
  id: "surroundedby",
  tabindex: "-1"
};
const _hoisted_41 = {
  id: "tostring",
  tabindex: "-1"
};
const _hoisted_42 = {
  id: "withcontext",
  tabindex: "-1"
};
const _hoisted_43 = {
  id: "operator-equals",
  tabindex: "-1"
};
const _hoisted_44 = {
  id: "operator-bitwise_or",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    createBaseVNode("h1", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("RepSep<A> ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "final"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#repsep-a",
        "aria-label": 'Permalink to "RepSep\\<A\\> <Badge type="info" text="final" />"'
      }, "​", -1))
    ]),
    _cache[143] || (_cache[143] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <span class="kw">class</span> <span class="fn">RepSep</span>&lt;A&gt; <span class="kw">extends</span> <a href="./Parser" class="type-link">Parser</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;&gt;</code></pre></div><p>A direct, loop-based implementation of <code>repSep</code> (one-or-more with separator).</p><p>Equivalent to the combinator expression <code>p1.product(sep.voided.with1.soft.productR(p1).rep0()).map(...)</code>, but avoids the virtual-dispatch overhead of the intermediate parser objects and the per-iteration allocation from <code>rep0 = OneOf0([Rep, pure(nil)])</code>.</p><p>Semantics preserved: • Sep fails without consuming → clean end of list. • Sep partially consumes then fails → propagate error. • Sep succeeds, p1 fails without consuming → soft-rewind to before sep, clean end of list. • Sep succeeds, p1 partially consumes then fails → propagate error.</p><div class="info custom-block"><p class="custom-block-title">Inheritance</p><p>Object → <a href="/ribs/api/package-ribs_parse_ribs_parse/Parser0.html">Parser0&lt;A&gt;</a> → <a href="/ribs/api/package-ribs_parse_ribs_parse/Parser.html">Parser&lt;A&gt;</a> → <strong>RepSep&lt;A&gt;</strong></p></div><h2 id="section-constructors" tabindex="-1">Constructors <a class="header-anchor" href="#section-constructors" aria-label="Permalink to &quot;Constructors {#section-constructors}&quot;">​</a></h2><h3 id="ctor-repsep" tabindex="-1">RepSep() <a class="header-anchor" href="#ctor-repsep" aria-label="Permalink to &quot;RepSep() {#ctor-repsep}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="fn">RepSep</span>(<a href="./Parser" class="type-link">Parser</a>&lt;<span class="type">A</span>&gt; <span class="param">p1</span>, <a href="./Parser0" class="type-link">Parser0</a>&lt;<span class="type">dynamic</span>&gt; <span class="param">sep</span>)</code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">RepSep</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.p1, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.sep);</span></span></code></pre></div></details><h2 id="section-properties" tabindex="-1">Properties <a class="header-anchor" href="#section-properties" aria-label="Permalink to &quot;Properties {#section-properties}&quot;">​</a></h2>', 10)),
    createBaseVNode("h3", _hoisted_2, [
      _cache[3] || (_cache[3] = createTextVNode("backtrack ", -1)),
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
        href: "#prop-backtrack",
        "aria-label": 'Permalink to "backtrack <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-backtrack}"'
      }, "​", -1))
    ]),
    _cache[144] || (_cache[144] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser" class="type-link">Parser</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;&gt; <span class="kw">get</span> <span class="fn">backtrack</span></code></pre></div><p>Wraps this parser so that it always restores the input offset on failure, enabling the failure to be caught by <a href="/ribs/api/package-ribs_parse_ribs_parse/RepSep.html#orelse">orElse</a> even after partial input has been consumed.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> backtrack </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">backtrack</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_3, [
      _cache[7] || (_cache[7] = createTextVNode("hashCode ", -1)),
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
        href: "#prop-hashcode",
        "aria-label": 'Permalink to "hashCode <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-hashcode}"'
      }, "​", -1))
    ]),
    _cache[145] || (_cache[145] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></code></pre></div><p>The hash code for this object.</p><p>A hash code is a single integer which represents the state of the object that affects <a href="/ribs/api/package-ribs_parse_ribs_parse/RepSep.html#operator-equals">operator ==</a> comparisons.</p><p>All objects have hash codes. The default hash code implemented by <a href="https://api.dart.dev/stable/3.11.5/dart-core/Object-class.html" target="_blank" rel="noreferrer">Object</a> represents only the identity of the object, the same way as the default <a href="/ribs/api/package-ribs_parse_ribs_parse/RepSep.html#operator-equals">operator ==</a> implementation only considers objects equal if they are identical (see <a href="https://api.dart.dev/stable/3.11.5/dart-core/identityHashCode.html" target="_blank" rel="noreferrer">identityHashCode</a>).</p><p>If <a href="/ribs/api/package-ribs_parse_ribs_parse/RepSep.html#operator-equals">operator ==</a> is overridden to use the object state instead, the hash code must also be changed to represent that state, otherwise the object cannot be used in hash based data structures like the default <a href="https://api.dart.dev/stable/3.11.5/dart-core/Set-class.html" target="_blank" rel="noreferrer">Set</a> and <a href="https://api.dart.dev/stable/3.11.5/dart-core/Map-class.html" target="_blank" rel="noreferrer">Map</a> implementations.</p><p>Hash codes must be the same for objects that are equal to each other according to <a href="/ribs/api/package-ribs_parse_ribs_parse/RepSep.html#operator-equals">operator ==</a>. The hash code of an object should only change if the object changes in a way that affects equality. There are no further requirements for the hash codes. They need not be consistent between executions of the same program and there are no distribution guarantees.</p><p>Objects that are not equal are allowed to have the same hash code. It is even technically allowed that all instances have the same hash code, but if clashes happen too often, it may reduce the efficiency of hash-based data structures like <a href="https://api.dart.dev/stable/3.11.5/dart-collection/HashSet-class.html" target="_blank" rel="noreferrer">HashSet</a> or <a href="https://api.dart.dev/stable/3.11.5/dart-collection/HashMap-class.html" target="_blank" rel="noreferrer">HashMap</a>.</p><p>If a subclass overrides <a href="/ribs/api/package-ribs_parse_ribs_parse/RepSep.html#prop-hashcode">hashCode</a>, it should override the <a href="/ribs/api/package-ribs_parse_ribs_parse/RepSep.html#operator-equals">operator ==</a> operator as well to maintain consistency.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> hashCode;</span></span></code></pre></div></details>', 10)),
    createBaseVNode("h3", _hoisted_4, [
      _cache[11] || (_cache[11] = createTextVNode("not ", -1)),
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
        href: "#prop-not",
        "aria-label": 'Permalink to "not <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-not}"'
      }, "​", -1))
    ]),
    _cache[146] || (_cache[146] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser0" class="type-link">Parser0</a>&lt;<a href="../package-ribs_core_ribs_core/Unit" class="type-link">Unit</a>&gt; <span class="kw">get</span> <span class="fn">not</span></code></pre></div><p>A parser that succeeds (consuming no input) only when this parser would fail at the current position, and fails when this parser would succeed.</p><p><em>Inherited from Parser0.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Unit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> not </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">not</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_5, [
      _cache[15] || (_cache[15] = createTextVNode("opt ", -1)),
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
        href: "#prop-opt",
        "aria-label": 'Permalink to "opt <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-opt}"'
      }, "​", -1))
    ]),
    _cache[147] || (_cache[147] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser0" class="type-link">Parser0</a>&lt;<a href="../package-ribs_core_ribs_core/Option" class="type-link">Option</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;&gt;&gt; <span class="kw">get</span> <span class="fn">opt</span></code></pre></div><p>Succeeds with <a href="/ribs/api/package-ribs_core_ribs_core/Some.html">Some</a> of the parsed value, or <a href="/ribs/api/package-ribs_core_ribs_core/None.html">None</a> if this parser fails without consuming input.</p><p><em>Inherited from Parser0.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> opt </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">oneOf0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">ilist</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">([</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">map0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, (a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> a.some), </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">pure</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">none</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;())]));</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_6, [
      _cache[19] || (_cache[19] = createTextVNode("p1 ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[20] || (_cache[20] = createTextVNode()),
      _cache[21] || (_cache[21] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-p1",
        "aria-label": 'Permalink to "p1 <Badge type="tip" text="final" /> {#prop-p1}"'
      }, "​", -1))
    ]),
    _cache[148] || (_cache[148] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <a href="./Parser" class="type-link">Parser</a>&lt;<span class="type">A</span>&gt; <span class="fn">p1</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; p1;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_7, [
      _cache[22] || (_cache[22] = createTextVNode("peek ", -1)),
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
        href: "#prop-peek",
        "aria-label": 'Permalink to "peek <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-peek}"'
      }, "​", -1))
    ]),
    _cache[149] || (_cache[149] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser0" class="type-link">Parser0</a>&lt;<a href="../package-ribs_core_ribs_core/Unit" class="type-link">Unit</a>&gt; <span class="kw">get</span> <span class="fn">peek</span></code></pre></div><p>Succeeds when this parser would succeed at the current position but consumes no input.</p><p><em>Inherited from Parser0.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Unit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> peek </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">peek</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_8, [
      _cache[26] || (_cache[26] = createTextVNode("runtimeType ", -1)),
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
        href: "#prop-runtimetype",
        "aria-label": 'Permalink to "runtimeType <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-runtimetype}"'
      }, "​", -1))
    ]),
    _cache[150] || (_cache[150] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">Type</span> <span class="kw">get</span> <span class="fn">runtimeType</span></code></pre></div><p>A representation of the runtime type of the object.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Type</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> runtimeType;</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_9, [
      _cache[30] || (_cache[30] = createTextVNode("sep ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[31] || (_cache[31] = createTextVNode()),
      _cache[32] || (_cache[32] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-sep",
        "aria-label": 'Permalink to "sep <Badge type="tip" text="final" /> {#prop-sep}"'
      }, "​", -1))
    ]),
    _cache[151] || (_cache[151] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <a href="./Parser0" class="type-link">Parser0</a>&lt;<span class="type">dynamic</span>&gt; <span class="fn">sep</span></code></pre></div><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Parser0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">dynamic</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; sep;</span></span></code></pre></div></details>', 2)),
    createBaseVNode("h3", _hoisted_10, [
      _cache[33] || (_cache[33] = createTextVNode("soft ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[34] || (_cache[34] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[35] || (_cache[35] = createTextVNode()),
      _cache[36] || (_cache[36] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-soft",
        "aria-label": 'Permalink to "soft <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-soft}"'
      }, "​", -1))
    ]),
    _cache[152] || (_cache[152] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Soft" class="type-link">Soft</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;&gt; <span class="kw">get</span> <span class="fn">soft</span></code></pre></div><p>Returns a <a href="/ribs/api/package-ribs_parse_ribs_parse/Soft0.html">Soft0</a> view that uses soft (backtracking) product combinators.</p><p>In a soft product <code>a.soft.product(b)</code>, a failure in <code>b</code> backtracks to before <code>a</code> ran, allowing the failure to be caught by <a href="/ribs/api/package-ribs_parse_ribs_parse/RepSep.html#orelse">orElse</a>.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Soft</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> soft </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Soft</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 5)),
    createBaseVNode("h3", _hoisted_11, [
      _cache[37] || (_cache[37] = createTextVNode("string ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[38] || (_cache[38] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[39] || (_cache[39] = createTextVNode()),
      _cache[40] || (_cache[40] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-string",
        "aria-label": 'Permalink to "string <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-string}"'
      }, "​", -1))
    ]),
    _cache[153] || (_cache[153] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser" class="type-link">Parser</a>&lt;<span class="type">String</span>&gt; <span class="kw">get</span> <span class="fn">string</span></code></pre></div><p>Returns a parser that succeeds with the substring of the input matched by this parser, instead of its original return value.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> string </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">stringP</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_12, [
      _cache[41] || (_cache[41] = createTextVNode("voided ", -1)),
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
        href: "#prop-voided",
        "aria-label": 'Permalink to "voided <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-voided}"'
      }, "​", -1))
    ]),
    _cache[154] || (_cache[154] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser" class="type-link">Parser</a>&lt;<a href="../package-ribs_core_ribs_core/Unit" class="type-link">Unit</a>&gt; <span class="kw">get</span> <span class="fn">voided</span></code></pre></div><p>Returns a parser that runs this parser and discards the result, producing <a href="../package-ribs_core_ribs_core/Unit.html" class="api-link"><code>Unit</code></a>.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Unit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> voided </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">voided</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_13, [
      _cache[45] || (_cache[45] = createTextVNode("with1 ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[46] || (_cache[46] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[47] || (_cache[47] = createTextVNode()),
      _cache[48] || (_cache[48] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-with1",
        "aria-label": 'Permalink to "with1 <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-with1}"'
      }, "​", -1))
    ]),
    _cache[155] || (_cache[155] = createStaticVNode('<div class="member-signature"><pre><code><a href="./With1" class="type-link">With1</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;&gt; <span class="kw">get</span> <span class="fn">with1</span></code></pre></div><p>Promotes this <a href="/ribs/api/package-ribs_parse_ribs_parse/Parser0.html">Parser0</a> so it can be sequenced with a <a href="/ribs/api/package-ribs_parse_ribs_parse/Parser.html">Parser</a> to produce a <a href="/ribs/api/package-ribs_parse_ribs_parse/Parser.html">Parser</a> result.</p><p>All combinators on <a href="/ribs/api/package-ribs_parse_ribs_parse/With1.html">With1</a> return <a href="/ribs/api/package-ribs_parse_ribs_parse/Parser.html">Parser</a> instead of <a href="/ribs/api/package-ribs_parse_ribs_parse/Parser0.html">Parser0</a>, which is useful when at least one side of a product is known to consume input.</p><p><em>Inherited from Parser0.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">With1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> with1 </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> With1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 5)),
    createBaseVNode("h3", _hoisted_14, [
      _cache[49] || (_cache[49] = createTextVNode("withString ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[50] || (_cache[50] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[51] || (_cache[51] = createTextVNode()),
      _cache[52] || (_cache[52] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-withstring",
        "aria-label": 'Permalink to "withString <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-withstring}"'
      }, "​", -1))
    ]),
    _cache[156] || (_cache[156] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser" class="type-link">Parser</a>&lt;<span class="type">Record</span>&gt; <span class="kw">get</span> <span class="fn">withString</span></code></pre></div><p>Returns a parser that produces both the parsed value and the substring of input that was consumed.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> withString </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">withString</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 5)),
    createBaseVNode("h3", _hoisted_15, [
      _cache[53] || (_cache[53] = createTextVNode("as() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[54] || (_cache[54] = createTextVNode()),
      _cache[55] || (_cache[55] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#as",
        "aria-label": 'Permalink to "as() <Badge type="info" text="inherited" /> {#as}"'
      }, "​", -1))
    ]),
    _cache[157] || (_cache[157] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser" class="type-link">Parser</a>&lt;<span class="type">B</span>&gt; <span class="fn">as&lt;B&gt;</span>(<span class="type">B</span> <span class="param">b</span>)</code></pre></div><p>Returns a parser that succeeds with <code>b</code> whenever this parser succeeds, discarding the matched value.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">as&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> b) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">as</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, b);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_16, [
      _cache[56] || (_cache[56] = createTextVNode("between() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[57] || (_cache[57] = createTextVNode()),
      _cache[58] || (_cache[58] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#between",
        "aria-label": 'Permalink to "between() <Badge type="info" text="inherited" /> {#between}"'
      }, "​", -1))
    ]),
    _cache[158] || (_cache[158] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser" class="type-link">Parser</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;&gt; <span class="fn">between</span>(<a href="./Parser0" class="type-link">Parser0</a>&lt;<span class="type">dynamic</span>&gt; <span class="param">b</span>, <a href="./Parser0" class="type-link">Parser0</a>&lt;<span class="type">dynamic</span>&gt; <span class="param">c</span>)</code></pre></div><p>Matches <code>b</code>, then this parser, then <code>c</code>, returning only the result of this parser.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">between</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">dynamic</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; b, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">dynamic</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; c) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    b.voided.with1.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">product</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">product</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(c.voided)).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">map</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((tuple) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> tuple.$2.$1);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_17, [
      _cache[59] || (_cache[59] = createTextVNode("eitherOr() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[60] || (_cache[60] = createTextVNode()),
      _cache[61] || (_cache[61] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#eitheror",
        "aria-label": 'Permalink to "eitherOr() <Badge type="info" text="inherited" /> {#eitheror}"'
      }, "​", -1))
    ]),
    _cache[159] || (_cache[159] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser" class="type-link">Parser</a>&lt;<a href="../package-ribs_core_ribs_core/Either" class="type-link">Either</a>&lt;<span class="type">B</span>, <a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;&gt;&gt; <span class="fn">eitherOr&lt;B&gt;</span>(<a href="./Parser" class="type-link">Parser</a>&lt;<span class="type">B</span>&gt; <span class="param">pb</span>)</code></pre></div><p>Returns a parser that tries <code>pb</code> first; on success wraps its result in <a href="/ribs/api/package-ribs_core_ribs_core/Left.html">Left</a>, otherwise tries this parser and wraps its result in <a href="/ribs/api/package-ribs_core_ribs_core/Right.html">Right</a>.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Either</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">eitherOr</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; pb) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">eitherOr</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, pb);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_18, [
      _cache[62] || (_cache[62] = createTextVNode("filter() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[63] || (_cache[63] = createTextVNode()),
      _cache[64] || (_cache[64] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#filter",
        "aria-label": 'Permalink to "filter() <Badge type="info" text="inherited" /> {#filter}"'
      }, "​", -1))
    ]),
    _cache[160] || (_cache[160] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser" class="type-link">Parser</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;&gt; <span class="fn">filter</span>(<span class="type">bool</span> <span class="type">Function</span>(<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;) <span class="param">p</span>)</code></pre></div><p>Succeeds with the parsed value only when <code>p</code> returns <code>true</code>; fails (without consuming) otherwise.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">filter</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; p) {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  return</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">select</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Unit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    map</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> p</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Right</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Left</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Unit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">())),</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">fail</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  );</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_19, [
      _cache[65] || (_cache[65] = createTextVNode("flatMap() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[66] || (_cache[66] = createTextVNode()),
      _cache[67] || (_cache[67] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#flatmap",
        "aria-label": 'Permalink to "flatMap() <Badge type="info" text="inherited" /> {#flatmap}"'
      }, "​", -1))
    ]),
    _cache[161] || (_cache[161] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser" class="type-link">Parser</a>&lt;<span class="type">B</span>&gt; <span class="fn">flatMap&lt;B&gt;</span>(<a href="./Parser0" class="type-link">Parser0</a>&lt;<span class="type">B</span>&gt; <span class="type">Function</span>(<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;) <span class="param">f</span>)</code></pre></div><p>Sequences this parser with a function that chooses the next parser based on the parsed value.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">flatMap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; f) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">flatMap10</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, f);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_20, [
      _cache[68] || (_cache[68] = createTextVNode("map() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[69] || (_cache[69] = createTextVNode()),
      _cache[70] || (_cache[70] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#map",
        "aria-label": 'Permalink to "map() <Badge type="info" text="inherited" /> {#map}"'
      }, "​", -1))
    ]),
    _cache[162] || (_cache[162] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser" class="type-link">Parser</a>&lt;<span class="type">B</span>&gt; <span class="fn">map&lt;B&gt;</span>(<span class="type">B</span> <span class="type">Function</span>(<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;) <span class="param">f</span>)</code></pre></div><p>Transforms the parsed value with <code>f</code>.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">map</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; f) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">map</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, f);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_21, [
      _cache[71] || (_cache[71] = createTextVNode("mapFilter() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[72] || (_cache[72] = createTextVNode()),
      _cache[73] || (_cache[73] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#mapfilter",
        "aria-label": 'Permalink to "mapFilter() <Badge type="info" text="inherited" /> {#mapfilter}"'
      }, "​", -1))
    ]),
    _cache[163] || (_cache[163] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser" class="type-link">Parser</a>&lt;<span class="type">B</span>&gt; <span class="fn">mapFilter&lt;B&gt;</span>(<a href="../package-ribs_core_ribs_core/Option" class="type-link">Option</a>&lt;<span class="type">B</span>&gt; <span class="type">Function</span>(<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;) <span class="param">f</span>)</code></pre></div><p>Applies <code>f</code> to the parsed value; succeeds with the <a href="/ribs/api/package-ribs_core_ribs_core/Some.html">Some</a> result or fails (without consuming) when <code>f</code> returns <a href="/ribs/api/package-ribs_core_ribs_core/None.html">None</a>.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">mapFilter</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; f) {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  return</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">select</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Unit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    map</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((a) {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">      return</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> f</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(a).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">        () </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Left</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Unit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">()),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">        (b) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Right</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(b),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">      );</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    }),</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">fail</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  );</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_22, [
      _cache[74] || (_cache[74] = createTextVNode("noSuchMethod() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[75] || (_cache[75] = createTextVNode()),
      _cache[76] || (_cache[76] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#nosuchmethod",
        "aria-label": 'Permalink to "noSuchMethod() <Badge type="info" text="inherited" /> {#nosuchmethod}"'
      }, "​", -1))
    ]),
    _cache[164] || (_cache[164] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">dynamic</span> <span class="fn">noSuchMethod</span>(<span class="type">Invocation</span> <span class="param">invocation</span>)</code></pre></div><p>Invoked when a nonexistent method or property is accessed.</p><p>A dynamic member invocation can attempt to call a member which doesn&#39;t exist on the receiving object. Example:</p><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">dynamic</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> object </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">object.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">add</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">42</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">); </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">// Statically allowed, run-time error</span></span></code></pre></div><p>This invalid code will invoke the <code>noSuchMethod</code> method of the integer <code>1</code> with an <a href="https://api.dart.dev/stable/3.11.5/dart-core/Invocation-class.html" target="_blank" rel="noreferrer">Invocation</a> representing the <code>.add(42)</code> call and arguments (which then throws).</p><p>Classes can override <a href="https://api.dart.dev/stable/3.11.5/dart-core/Object/noSuchMethod.html" target="_blank" rel="noreferrer">noSuchMethod</a> to provide custom behavior for such invalid dynamic invocations.</p><p>A class with a non-default <a href="https://api.dart.dev/stable/3.11.5/dart-core/Object/noSuchMethod.html" target="_blank" rel="noreferrer">noSuchMethod</a> invocation can also omit implementations for members of its interface. Example:</p><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">class</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MockList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">implements</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> List</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; {</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">  noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Invocation</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> invocation) {</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    log</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(invocation);</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    super</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(invocation); </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">// Will throw.</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  }</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">void</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> main</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() {</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  MockList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">().</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">add</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">42</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div><p>This code has no compile-time warnings or errors even though the <code>MockList</code> class has no concrete implementation of any of the <code>List</code> interface methods. Calls to <code>List</code> methods are forwarded to <code>noSuchMethod</code>, so this code will <code>log</code> an invocation similar to <code>Invocation.method(#add, [42])</code> and then throw.</p><p>If a value is returned from <code>noSuchMethod</code>, it becomes the result of the original invocation. If the value is not of a type that can be returned by the original invocation, a type error occurs at the invocation.</p><p>The default behavior is to throw a <a href="https://api.dart.dev/stable/3.11.5/dart-core/NoSuchMethodError-class.html" target="_blank" rel="noreferrer">NoSuchMethodError</a>.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@pragma</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;vm:entry-point&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@pragma</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;wasm:entry-point&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> dynamic</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Invocation</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> invocation);</span></span></code></pre></div></details>', 13)),
    createBaseVNode("h3", _hoisted_23, [
      _cache[77] || (_cache[77] = createTextVNode("orElse() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[78] || (_cache[78] = createTextVNode()),
      _cache[79] || (_cache[79] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#orelse",
        "aria-label": 'Permalink to "orElse() <Badge type="info" text="inherited" /> {#orelse}"'
      }, "​", -1))
    ]),
    _cache[165] || (_cache[165] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser" class="type-link">Parser</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;&gt; <span class="fn">orElse</span>(<a href="./Parser" class="type-link">Parser</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;&gt; <span class="param">that</span>)</code></pre></div><p>Tries this parser, then <code>that</code> if this one fails without consuming input.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">orElse</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">oneOf</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">ilist</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">([</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, that]));</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_24, [
      _cache[80] || (_cache[80] = createTextVNode("parse() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[81] || (_cache[81] = createTextVNode()),
      _cache[82] || (_cache[82] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#parse",
        "aria-label": 'Permalink to "parse() <Badge type="info" text="inherited" /> {#parse}"'
      }, "​", -1))
    ]),
    _cache[166] || (_cache[166] = createStaticVNode('<div class="member-signature"><pre><code><a href="../package-ribs_core_ribs_core/Either" class="type-link">Either</a>&lt;<a href="./ParseError" class="type-link">ParseError</a>, <span class="type">Record</span>&gt; <span class="fn">parse</span>(<span class="type">String</span> <span class="param">str</span>)</code></pre></div><p>Runs this parser on <code>str</code> and returns the remaining unparsed input paired with the parsed value, or a <a href="/ribs/api/package-ribs_parse_ribs_parse/ParseError.html">ParseError</a> on failure.</p><p>Unlike <a href="/ribs/api/package-ribs_parse_ribs_parse/Parser0.html#parseall">parseAll</a>, trailing input after a successful match is allowed.</p><p><em>Inherited from Parser0.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Either</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">ParseError</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, (</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">parse</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> str) {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  final</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> state </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> State</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(str);</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  final</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> result </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> _parseMut</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(state);</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  final</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> err </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> state.error;</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  final</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> offset </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> state.offset;</span></span>\n<span class="line"></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  if</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> (err </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> null</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">    return</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Right</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((str.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">substring</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(offset), result</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">!</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">));</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  } </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">else</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">    return</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Left</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">      ParseError</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">        Some</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(str),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">        offset,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">        Expectation</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">unify</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">NonEmptyIList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">unsafe</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(err.value.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">toIList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">())),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">      ),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    );</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  }</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div></details>', 5)),
    createBaseVNode("h3", _hoisted_25, [
      _cache[83] || (_cache[83] = createTextVNode("parseAll() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[84] || (_cache[84] = createTextVNode()),
      _cache[85] || (_cache[85] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#parseall",
        "aria-label": 'Permalink to "parseAll() <Badge type="info" text="inherited" /> {#parseall}"'
      }, "​", -1))
    ]),
    _cache[167] || (_cache[167] = createStaticVNode('<div class="member-signature"><pre><code><a href="../package-ribs_core_ribs_core/Either" class="type-link">Either</a>&lt;<a href="./ParseError" class="type-link">ParseError</a>, <a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;&gt; <span class="fn">parseAll</span>(<span class="type">String</span> <span class="param">str</span>)</code></pre></div><p>Runs this parser on <code>str</code> and requires the entire input to be consumed.</p><p>Returns the parsed value on success, or a <a href="/ribs/api/package-ribs_parse_ribs_parse/ParseError.html">ParseError</a> if the parser fails or if any input remains after a successful match.</p><p><em>Inherited from Parser0.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Either</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">ParseError</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">parseAll</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> str) {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  final</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> state </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> State</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(str);</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  final</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> result </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> _parseMut</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(state);</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  final</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> err </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> state.error;</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  final</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> offset </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> state.offset;</span></span>\n<span class="line"></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  if</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> (err </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> null</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">    if</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> (result </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">!=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> null</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> &amp;&amp;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> offset </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> str.length) {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">      return</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Right</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(result);</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    } </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">else</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">      return</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Left</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">        ParseError</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">          Some</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(str),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">          offset,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">          NonEmptyIList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Expectation</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">endOfString</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(offset, str.length)),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">        ),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">      );</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    }</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  } </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">else</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">    return</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Left</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">      ParseError</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">        Some</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(str),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">        offset,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">        Expectation</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">unify</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">NonEmptyIList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">unsafe</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(err.value.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">toIList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">())),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">      ),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    );</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  }</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div></details>', 5)),
    createBaseVNode("h3", _hoisted_26, [
      _cache[86] || (_cache[86] = createTextVNode("product() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[87] || (_cache[87] = createTextVNode()),
      _cache[88] || (_cache[88] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#product",
        "aria-label": 'Permalink to "product() <Badge type="info" text="inherited" /> {#product}"'
      }, "​", -1))
    ]),
    _cache[168] || (_cache[168] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser" class="type-link">Parser</a>&lt;<span class="type">Record</span>&gt; <span class="fn">product&lt;B&gt;</span>(<a href="./Parser0" class="type-link">Parser0</a>&lt;<span class="type">B</span>&gt; <span class="param">that</span>)</code></pre></div><p>Runs this parser followed by <code>that</code>, returning both results as a tuple.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">product</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">product10</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, that);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_27, [
      _cache[89] || (_cache[89] = createTextVNode("productL() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[90] || (_cache[90] = createTextVNode()),
      _cache[91] || (_cache[91] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#productl",
        "aria-label": 'Permalink to "productL() <Badge type="info" text="inherited" /> {#productl}"'
      }, "​", -1))
    ]),
    _cache[169] || (_cache[169] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser" class="type-link">Parser</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;&gt; <span class="fn">productL&lt;B&gt;</span>(<a href="./Parser0" class="type-link">Parser0</a>&lt;<span class="type">B</span>&gt; <span class="param">that</span>)</code></pre></div><p>Runs this parser followed by <code>that</code>, discarding the result of <code>that</code>.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">productL</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> product</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(that.voided).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">map</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((t) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> t.$1);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_28, [
      _cache[92] || (_cache[92] = createTextVNode("productR() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[93] || (_cache[93] = createTextVNode()),
      _cache[94] || (_cache[94] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#productr",
        "aria-label": 'Permalink to "productR() <Badge type="info" text="inherited" /> {#productr}"'
      }, "​", -1))
    ]),
    _cache[170] || (_cache[170] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser" class="type-link">Parser</a>&lt;<span class="type">B</span>&gt; <span class="fn">productR&lt;B&gt;</span>(<a href="./Parser0" class="type-link">Parser0</a>&lt;<span class="type">B</span>&gt; <span class="param">that</span>)</code></pre></div><p>Runs this parser followed by <code>that</code>, discarding the result of this parser.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">productR</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> voided.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">product</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(that).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">map</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((t) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> t.$2);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_29, [
      _cache[95] || (_cache[95] = createTextVNode("rep() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[96] || (_cache[96] = createTextVNode()),
      _cache[97] || (_cache[97] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#rep",
        "aria-label": 'Permalink to "rep() <Badge type="info" text="inherited" /> {#rep}"'
      }, "​", -1))
    ]),
    _cache[171] || (_cache[171] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser" class="type-link">Parser</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;&gt;&gt; <span class="fn">rep</span>({<span class="type">int</span>? <span class="param">min</span>, <span class="type">int</span>? <span class="param">max</span>})</code></pre></div><p>Repeats this parser one or more times, collecting results into a <a href="/ribs/api/package-ribs_core_ribs_core/NonEmptyIList.html">NonEmptyIList</a>. Pass <code>min</code> (default 1) or <code>max</code> to control the count.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">NonEmptyIList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">rep</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">({</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> min, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> max}) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    repAs</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Accumulator</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">nel</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(), min</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> min, max</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> max);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_30, [
      _cache[98] || (_cache[98] = createTextVNode("rep0() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[99] || (_cache[99] = createTextVNode()),
      _cache[100] || (_cache[100] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#rep0",
        "aria-label": 'Permalink to "rep0() <Badge type="info" text="inherited" /> {#rep0}"'
      }, "​", -1))
    ]),
    _cache[172] || (_cache[172] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser0" class="type-link">Parser0</a>&lt;<a href="../package-ribs_core_ribs_core/IList" class="type-link">IList</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;&gt;&gt; <span class="fn">rep0</span>({<span class="type">int</span>? <span class="param">min</span>, <span class="type">int</span>? <span class="param">max</span>})</code></pre></div><p>Repeats this parser zero or more times, collecting results into an <a href="/ribs/api/package-ribs_core_ribs_core/IList.html">IList</a>. Pass <code>min</code> to require at least that many matches; pass <code>max</code> to cap the number of matches.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">rep0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">({</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> min, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> max}) {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  if</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> (min </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> null</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> ||</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> min </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">    return</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> repAs0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Accumulator0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">ilist</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(), max</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> max);</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  } </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">else</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">    return</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> repAs</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Accumulator0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">ilist</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(), min</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> min, max</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> max);</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  }</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_31, [
      _cache[101] || (_cache[101] = createTextVNode("repAs() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[102] || (_cache[102] = createTextVNode()),
      _cache[103] || (_cache[103] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#repas",
        "aria-label": 'Permalink to "repAs() <Badge type="info" text="inherited" /> {#repas}"'
      }, "​", -1))
    ]),
    _cache[173] || (_cache[173] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser" class="type-link">Parser</a>&lt;<span class="type">B</span>&gt; <span class="fn">repAs&lt;B&gt;</span>(<a href="./Accumulator" class="type-link">Accumulator</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;, <span class="type">B</span>&gt; <span class="param">acc</span>, {<span class="type">int</span>? <span class="param">min</span>, <span class="type">int</span>? <span class="param">max</span>})</code></pre></div><p>Repeats this parser one or more times (or at least <code>min</code> times), accumulating results with <code>acc</code>. Pass <code>max</code> to cap repetitions.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">repAs</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Accumulator</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; acc, {</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> min, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> max}) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">repAs</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, acc, min </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, max</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> max);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_32, [
      _cache[104] || (_cache[104] = createTextVNode("repAs0() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[105] || (_cache[105] = createTextVNode()),
      _cache[106] || (_cache[106] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#repas0",
        "aria-label": 'Permalink to "repAs0() <Badge type="info" text="inherited" /> {#repas0}"'
      }, "​", -1))
    ]),
    _cache[174] || (_cache[174] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser0" class="type-link">Parser0</a>&lt;<span class="type">B</span>&gt; <span class="fn">repAs0&lt;B&gt;</span>(<a href="./Accumulator0" class="type-link">Accumulator0</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;, <span class="type">B</span>&gt; <span class="param">acc</span>, {<span class="type">int</span>? <span class="param">max</span>})</code></pre></div><p>Repeats this parser zero or more times, accumulating results with <code>acc</code>. Pass <code>max</code> to cap the number of repetitions.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">repAs0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Accumulator0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; acc, {</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> max}) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">repAs0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, acc, max</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> max);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_33, [
      _cache[107] || (_cache[107] = createTextVNode("repExactlyAs() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[108] || (_cache[108] = createTextVNode()),
      _cache[109] || (_cache[109] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#repexactlyas",
        "aria-label": 'Permalink to "repExactlyAs() <Badge type="info" text="inherited" /> {#repexactlyas}"'
      }, "​", -1))
    ]),
    _cache[175] || (_cache[175] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser" class="type-link">Parser</a>&lt;<span class="type">B</span>&gt; <span class="fn">repExactlyAs&lt;B&gt;</span>(<span class="type">int</span> <span class="param">times</span>, <a href="./Accumulator" class="type-link">Accumulator</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;, <span class="type">B</span>&gt; <span class="param">acc</span>)</code></pre></div><p>Repeats this parser exactly <code>times</code> times, accumulating with <code>acc</code>.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">repExactlyAs</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> times, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Accumulator</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; acc) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">repExactlyAs</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, times, acc);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_34, [
      _cache[110] || (_cache[110] = createTextVNode("repSep() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[111] || (_cache[111] = createTextVNode()),
      _cache[112] || (_cache[112] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#repsep",
        "aria-label": 'Permalink to "repSep() <Badge type="info" text="inherited" /> {#repsep}"'
      }, "​", -1))
    ]),
    _cache[176] || (_cache[176] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser" class="type-link">Parser</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;&gt;&gt; <span class="fn">repSep</span>(\n  <a href="./Parser0" class="type-link">Parser0</a>&lt;<span class="type">dynamic</span>&gt; <span class="param">sep</span>, {\n  <span class="type">int</span>? <span class="param">min</span>,\n  <span class="type">int</span>? <span class="param">max</span>,\n})</code></pre></div><p>Repeats this parser one or more times with <code>sep</code> between each element, collecting results into a <a href="/ribs/api/package-ribs_core_ribs_core/NonEmptyIList.html">NonEmptyIList</a>. Pass <code>min</code>/<code>max</code> to control count.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">NonEmptyIList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">repSep</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">dynamic</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; sep, {</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> min, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> max}) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">repSep</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, sep, min</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> min </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, max</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> max);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_35, [
      _cache[113] || (_cache[113] = createTextVNode("repSep0() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[114] || (_cache[114] = createTextVNode()),
      _cache[115] || (_cache[115] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#repsep0",
        "aria-label": 'Permalink to "repSep0() <Badge type="info" text="inherited" /> {#repsep0}"'
      }, "​", -1))
    ]),
    _cache[177] || (_cache[177] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser0" class="type-link">Parser0</a>&lt;<a href="../package-ribs_core_ribs_core/IList" class="type-link">IList</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;&gt;&gt; <span class="fn">repSep0</span>(\n  <a href="./Parser0" class="type-link">Parser0</a>&lt;<span class="type">dynamic</span>&gt; <span class="param">sep</span>, {\n  <span class="type">int</span>? <span class="param">min</span>,\n  <span class="type">int</span>? <span class="param">max</span>,\n})</code></pre></div><p>Repeats this parser zero or more times with <code>sep</code> between each element, collecting results into an <a href="/ribs/api/package-ribs_core_ribs_core/IList.html">IList</a>. Pass <code>min</code>/<code>max</code> to control count.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">repSep0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">dynamic</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; sep, {</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> min, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> max}) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">repSep0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, sep, min</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> min </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">??</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, max</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> max);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_36, [
      _cache[116] || (_cache[116] = createTextVNode("repUntil() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[117] || (_cache[117] = createTextVNode()),
      _cache[118] || (_cache[118] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#repuntil",
        "aria-label": 'Permalink to "repUntil() <Badge type="info" text="inherited" /> {#repuntil}"'
      }, "​", -1))
    ]),
    _cache[178] || (_cache[178] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser" class="type-link">Parser</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;&gt;&gt; <span class="fn">repUntil</span>(<a href="./Parser0" class="type-link">Parser0</a>&lt;<span class="type">dynamic</span>&gt; <span class="param">sep</span>)</code></pre></div><p>Repeats this parser one or more times, stopping when <code>sep</code> matches at the current position.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">NonEmptyIList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">repUntil</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">dynamic</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; sep) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">repUntil</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, sep);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_37, [
      _cache[119] || (_cache[119] = createTextVNode("repUntil0() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[120] || (_cache[120] = createTextVNode()),
      _cache[121] || (_cache[121] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#repuntil0",
        "aria-label": 'Permalink to "repUntil0() <Badge type="info" text="inherited" /> {#repuntil0}"'
      }, "​", -1))
    ]),
    _cache[179] || (_cache[179] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser0" class="type-link">Parser0</a>&lt;<a href="../package-ribs_core_ribs_core/IList" class="type-link">IList</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;&gt;&gt; <span class="fn">repUntil0</span>(<a href="./Parser0" class="type-link">Parser0</a>&lt;<span class="type">dynamic</span>&gt; <span class="param">sep</span>)</code></pre></div><p>Repeats this parser zero or more times, stopping when <code>sep</code> matches at the current position.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">repUntil0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">dynamic</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; sep) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">repUntil0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, sep);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_38, [
      _cache[122] || (_cache[122] = createTextVNode("repUntilAs() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[123] || (_cache[123] = createTextVNode()),
      _cache[124] || (_cache[124] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#repuntilas",
        "aria-label": 'Permalink to "repUntilAs() <Badge type="info" text="inherited" /> {#repuntilas}"'
      }, "​", -1))
    ]),
    _cache[180] || (_cache[180] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser" class="type-link">Parser</a>&lt;<span class="type">B</span>&gt; <span class="fn">repUntilAs&lt;B&gt;</span>(\n  <a href="./Parser0" class="type-link">Parser0</a>&lt;<span class="type">dynamic</span>&gt; <span class="param">end</span>,\n  <a href="./Accumulator" class="type-link">Accumulator</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;, <span class="type">B</span>&gt; <span class="param">acc</span>,\n)</code></pre></div><p>Repeats this parser one or more times until <code>end</code> matches, accumulating with <code>acc</code>.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">repUntilAs</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">dynamic</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; end, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Accumulator</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; acc) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">repUntilAs</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, end, acc);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_39, [
      _cache[125] || (_cache[125] = createTextVNode("repUntilAs0() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[126] || (_cache[126] = createTextVNode()),
      _cache[127] || (_cache[127] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#repuntilas0",
        "aria-label": 'Permalink to "repUntilAs0() <Badge type="info" text="inherited" /> {#repuntilas0}"'
      }, "​", -1))
    ]),
    _cache[181] || (_cache[181] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser0" class="type-link">Parser0</a>&lt;<span class="type">B</span>&gt; <span class="fn">repUntilAs0&lt;B&gt;</span>(\n  <a href="./Parser0" class="type-link">Parser0</a>&lt;<span class="type">dynamic</span>&gt; <span class="param">end</span>,\n  <a href="./Accumulator0" class="type-link">Accumulator0</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;, <span class="type">B</span>&gt; <span class="param">acc</span>,\n)</code></pre></div><p>Repeats this parser zero or more times until <code>end</code> matches, accumulating with <code>acc</code>.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">repUntilAs0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">dynamic</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; end, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Accumulator0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; acc) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">repUntilAs0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, end, acc);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_40, [
      _cache[128] || (_cache[128] = createTextVNode("surroundedBy() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[129] || (_cache[129] = createTextVNode()),
      _cache[130] || (_cache[130] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#surroundedby",
        "aria-label": 'Permalink to "surroundedBy() <Badge type="info" text="inherited" /> {#surroundedby}"'
      }, "​", -1))
    ]),
    _cache[182] || (_cache[182] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser0" class="type-link">Parser0</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;&gt; <span class="fn">surroundedBy</span>(<a href="./Parser" class="type-link">Parser</a>&lt;<span class="type">dynamic</span>&gt; <span class="param">b</span>)</code></pre></div><p>Matches <code>b</code>, then this parser, then <code>b</code> again, returning only the result of this parser.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">surroundedBy</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">dynamic</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; b) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> between</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(b, b);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_41, [
      _cache[131] || (_cache[131] = createTextVNode("toString() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[132] || (_cache[132] = createTextVNode()),
      _cache[133] || (_cache[133] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#tostring",
        "aria-label": 'Permalink to "toString() <Badge type="info" text="inherited" /> {#tostring}"'
      }, "​", -1))
    ]),
    _cache[183] || (_cache[183] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">String</span> <span class="fn">toString</span>()</code></pre></div><p>A string representation of this object.</p><p>Some classes have a default textual representation, often paired with a static <code>parse</code> function (like <a href="https://api.dart.dev/stable/3.11.5/dart-core/int/parse.html" target="_blank" rel="noreferrer">int.parse</a>). These classes will provide the textual representation as their string representation.</p><p>Other classes have no meaningful textual representation that a program will care about. Such classes will typically override <code>toString</code> to provide useful information when inspecting the object, mainly for debugging or logging.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> String</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> toString</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">();</span></span></code></pre></div></details>', 6)),
    createBaseVNode("h3", _hoisted_42, [
      _cache[134] || (_cache[134] = createTextVNode("withContext() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[135] || (_cache[135] = createTextVNode()),
      _cache[136] || (_cache[136] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#withcontext",
        "aria-label": 'Permalink to "withContext() <Badge type="info" text="inherited" /> {#withcontext}"'
      }, "​", -1))
    ]),
    _cache[184] || (_cache[184] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser" class="type-link">Parser</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;&gt; <span class="fn">withContext</span>(<span class="type">String</span> <span class="param">str</span>)</code></pre></div><p>Attaches a human-readable context label <code>str</code> to any error produced by this parser, making failure messages easier to diagnose.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">withContext</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> str) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Parsers</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">withContext</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, str);</span></span></code></pre></div></details><h2 id="section-operators" tabindex="-1">Operators <a class="header-anchor" href="#section-operators" aria-label="Permalink to &quot;Operators {#section-operators}&quot;">​</a></h2>', 5)),
    createBaseVNode("h3", _hoisted_43, [
      _cache[137] || (_cache[137] = createTextVNode("operator ==() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[138] || (_cache[138] = createTextVNode()),
      _cache[139] || (_cache[139] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#operator-equals",
        "aria-label": 'Permalink to "operator ==() <Badge type="info" text="inherited" /> {#operator-equals}"'
      }, "​", -1))
    ]),
    _cache[185] || (_cache[185] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator ==</span>(<span class="type">Object</span> <span class="param">other</span>)</code></pre></div><p>The equality operator.</p><p>The default behavior for all <a href="https://api.dart.dev/stable/3.11.5/dart-core/Object-class.html" target="_blank" rel="noreferrer">Object</a>s is to return true if and only if this object and <code>other</code> are the same object.</p><p>Override this method to specify a different equality relation on a class. The overriding method must still be an equivalence relation. That is, it must be:</p><ul><li><p>Total: It must return a boolean for all arguments. It should never throw.</p></li><li><p>Reflexive: For all objects <code>o</code>, <code>o == o</code> must be true.</p></li><li><p>Symmetric: For all objects <code>o1</code> and <code>o2</code>, <code>o1 == o2</code> and <code>o2 == o1</code> must either both be true, or both be false.</p></li><li><p>Transitive: For all objects <code>o1</code>, <code>o2</code>, and <code>o3</code>, if <code>o1 == o2</code> and <code>o2 == o3</code> are true, then <code>o1 == o3</code> must be true.</p></li></ul><p>The method should also be consistent over time, so whether two objects are equal should only change if at least one of the objects was modified.</p><p>If a subclass overrides the equality operator, it should override the <a href="https://api.dart.dev/stable/3.11.5/dart-core/Object/hashCode.html" target="_blank" rel="noreferrer">hashCode</a> method as well to maintain consistency.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> ==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Object</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other);</span></span></code></pre></div></details>', 9)),
    createBaseVNode("h3", _hoisted_44, [
      _cache[140] || (_cache[140] = createTextVNode("operator |() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[141] || (_cache[141] = createTextVNode()),
      _cache[142] || (_cache[142] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#operator-bitwise_or",
        "aria-label": 'Permalink to "operator |() <Badge type="info" text="inherited" /> {#operator-bitwise_or}"'
      }, "​", -1))
    ]),
    _cache[186] || (_cache[186] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Parser" class="type-link">Parser</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;&gt; <span class="fn">operator |</span>(<a href="./Parser" class="type-link">Parser</a>&lt;<a href="../package-ribs_core_ribs_core/NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;&gt; <span class="param">that</span>)</code></pre></div><p>Tries this parser, falling back to <code>that</code> if this one fails without consuming input. Alias for <a href="/ribs/api/package-ribs_parse_ribs_parse/RepSep.html#orelse">orElse</a>.</p><p><em>Inherited from Parser.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> |</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Parser</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; that) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> orElse</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(that);</span></span></code></pre></div></details>', 4))
  ]);
}
const RepSep = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  RepSep as default
};
