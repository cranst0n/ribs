import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.BAgRHbGz.js";
const __pageData = JSON.parse('{"title":"ReadWrite","description":"API documentation for ReadWrite<A> class from ribs_sql","frontmatter":{"title":"ReadWrite<A>","description":"API documentation for ReadWrite<A> class from ribs_sql","category":"Classes","library":"ribs_sql","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_sql_ribs_sql/ReadWrite.md","filePath":"api/package-ribs_sql_ribs_sql/ReadWrite.md"}');
const _sfc_main = { name: "api/package-ribs_sql_ribs_sql/ReadWrite.md" };
const _hoisted_1 = {
  id: "prop-gets",
  tabindex: "-1"
};
const _hoisted_2 = {
  id: "prop-hashcode",
  tabindex: "-1"
};
const _hoisted_3 = {
  id: "prop-length",
  tabindex: "-1"
};
const _hoisted_4 = {
  id: "prop-puts",
  tabindex: "-1"
};
const _hoisted_5 = {
  id: "prop-read",
  tabindex: "-1"
};
const _hoisted_6 = {
  id: "prop-runtimetype",
  tabindex: "-1"
};
const _hoisted_7 = {
  id: "prop-write",
  tabindex: "-1"
};
const _hoisted_8 = {
  id: "contramap",
  tabindex: "-1"
};
const _hoisted_9 = {
  id: "emap",
  tabindex: "-1"
};
const _hoisted_10 = {
  id: "encode",
  tabindex: "-1"
};
const _hoisted_11 = {
  id: "map",
  tabindex: "-1"
};
const _hoisted_12 = {
  id: "nosuchmethod",
  tabindex: "-1"
};
const _hoisted_13 = {
  id: "setparameter",
  tabindex: "-1"
};
const _hoisted_14 = {
  id: "tostring",
  tabindex: "-1"
};
const _hoisted_15 = {
  id: "unsafeget",
  tabindex: "-1"
};
const _hoisted_16 = {
  id: "optional-2",
  tabindex: "-1"
};
const _hoisted_17 = {
  id: "optional-3",
  tabindex: "-1"
};
const _hoisted_18 = {
  id: "operator-equals",
  tabindex: "-1"
};
const _hoisted_19 = {
  id: "prop-bigint",
  tabindex: "-1"
};
const _hoisted_20 = {
  id: "prop-blob",
  tabindex: "-1"
};
const _hoisted_21 = {
  id: "prop-boolean",
  tabindex: "-1"
};
const _hoisted_22 = {
  id: "prop-datetime",
  tabindex: "-1"
};
const _hoisted_23 = {
  id: "prop-dubble",
  tabindex: "-1"
};
const _hoisted_24 = {
  id: "prop-integer",
  tabindex: "-1"
};
const _hoisted_25 = {
  id: "prop-json",
  tabindex: "-1"
};
const _hoisted_26 = {
  id: "prop-string",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[83] || (_cache[83] = createStaticVNode('<h1 id="readwrite-a" tabindex="-1">ReadWrite&lt;A&gt; <a class="header-anchor" href="#readwrite-a" aria-label="Permalink to &quot;ReadWrite\\&lt;A\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">class</span> <span class="fn">ReadWrite</span>&lt;A&gt; <span class="kw">extends</span> <a href="./Read" class="type-link">Read</a>&lt;<span class="type">A</span>&gt; <span class="kw">with</span> <a href="./Write" class="type-link">Write</a>&lt;<span class="type">A</span>&gt;</code></pre></div><p>A bidirectional codec that can both read and write values of type <code>A</code>.</p><div class="info custom-block"><p class="custom-block-title">Inheritance</p><p>Object → <a href="/ribs/api/package-ribs_sql_ribs_sql/Read.html">Read&lt;A&gt;</a> → <strong>ReadWrite&lt;A&gt;</strong></p></div><div class="info custom-block"><p class="custom-block-title">Mixed-in types</p><ul><li><a href="/ribs/api/package-ribs_sql_ribs_sql/Write.html">Write&lt;A&gt;</a></li></ul></div><div class="info custom-block"><p class="custom-block-title">Available Extensions</p><ul><li><a href="/ribs/api/package-ribs_sql_ribs_sql/ReadOptionOps.html">ReadOptionOps&lt;A&gt;</a></li><li><a href="/ribs/api/package-ribs_sql_ribs_sql/WriteOptionOps.html">WriteOptionOps&lt;A&gt;</a></li></ul></div><h2 id="section-constructors" tabindex="-1">Constructors <a class="header-anchor" href="#section-constructors" aria-label="Permalink to &quot;Constructors {#section-constructors}&quot;">​</a></h2><h3 id="ctor-readwrite" tabindex="-1">ReadWrite() <a class="header-anchor" href="#ctor-readwrite" aria-label="Permalink to &quot;ReadWrite() {#ctor-readwrite}&quot;">​</a></h3><div class="member-signature"><pre><code><span class="fn">ReadWrite</span>(<a href="./Read" class="type-link">Read</a>&lt;<span class="type">A</span>&gt; <span class="param">read</span>, <a href="./Write" class="type-link">Write</a>&lt;<span class="type">A</span>&gt; <span class="param">write</span>)</code></pre></div><p>Creates a <a href="/ribs/api/package-ribs_sql_ribs_sql/ReadWrite.html">ReadWrite</a> by pairing a <a href="/ribs/api/package-ribs_sql_ribs_sql/Read.html">Read</a> and <a href="/ribs/api/package-ribs_sql_ribs_sql/Write.html">Write</a> codec.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.read, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.write);</span></span></code></pre></div></details><h2 id="section-properties" tabindex="-1">Properties <a class="header-anchor" href="#section-properties" aria-label="Permalink to &quot;Properties {#section-properties}&quot;">​</a></h2>', 12)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("gets ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "override"
      }),
      _cache[2] || (_cache[2] = createTextVNode()),
      _cache[3] || (_cache[3] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-gets",
        "aria-label": 'Permalink to "gets <Badge type="tip" text="no setter" /> <Badge type="info" text="override" /> {#prop-gets}"'
      }, "​", -1))
    ]),
    _cache[84] || (_cache[84] = createStaticVNode('<div class="member-signature"><pre><code><a href="../package-ribs_core_ribs_core/IList" class="type-link">IList</a>&lt;<a href="./Get" class="type-link">Get</a>&lt;<span class="type">dynamic</span>&gt;&gt; <span class="kw">get</span> <span class="fn">gets</span></code></pre></div><p>The individual column <a href="./Get.html" class="api-link"><code>Get</code></a> decoders that make up this <a href="/ribs/api/package-ribs_sql_ribs_sql/Read.html">Read</a>.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">dynamic</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> gets </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> read.gets;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_2, [
      _cache[4] || (_cache[4] = createTextVNode("hashCode ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[5] || (_cache[5] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[6] || (_cache[6] = createTextVNode()),
      _cache[7] || (_cache[7] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-hashcode",
        "aria-label": 'Permalink to "hashCode <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-hashcode}"'
      }, "​", -1))
    ]),
    _cache[85] || (_cache[85] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">int</span> <span class="kw">get</span> <span class="fn">hashCode</span></code></pre></div><p>The hash code for this object.</p><p>A hash code is a single integer which represents the state of the object that affects <a href="/ribs/api/package-ribs_sql_ribs_sql/ReadWrite.html#operator-equals">operator ==</a> comparisons.</p><p>All objects have hash codes. The default hash code implemented by <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object-class.html" target="_blank" rel="noreferrer">Object</a> represents only the identity of the object, the same way as the default <a href="/ribs/api/package-ribs_sql_ribs_sql/ReadWrite.html#operator-equals">operator ==</a> implementation only considers objects equal if they are identical (see <a href="https://api.dart.dev/stable/3.11.4/dart-core/identityHashCode.html" target="_blank" rel="noreferrer">identityHashCode</a>).</p><p>If <a href="/ribs/api/package-ribs_sql_ribs_sql/ReadWrite.html#operator-equals">operator ==</a> is overridden to use the object state instead, the hash code must also be changed to represent that state, otherwise the object cannot be used in hash based data structures like the default <a href="https://api.dart.dev/stable/3.11.4/dart-core/Set-class.html" target="_blank" rel="noreferrer">Set</a> and <a href="https://api.dart.dev/stable/3.11.4/dart-core/Map-class.html" target="_blank" rel="noreferrer">Map</a> implementations.</p><p>Hash codes must be the same for objects that are equal to each other according to <a href="/ribs/api/package-ribs_sql_ribs_sql/ReadWrite.html#operator-equals">operator ==</a>. The hash code of an object should only change if the object changes in a way that affects equality. There are no further requirements for the hash codes. They need not be consistent between executions of the same program and there are no distribution guarantees.</p><p>Objects that are not equal are allowed to have the same hash code. It is even technically allowed that all instances have the same hash code, but if clashes happen too often, it may reduce the efficiency of hash-based data structures like <a href="https://api.dart.dev/stable/3.11.4/dart-collection/HashSet-class.html" target="_blank" rel="noreferrer">HashSet</a> or <a href="https://api.dart.dev/stable/3.11.4/dart-collection/HashMap-class.html" target="_blank" rel="noreferrer">HashMap</a>.</p><p>If a subclass overrides <a href="/ribs/api/package-ribs_sql_ribs_sql/ReadWrite.html#prop-hashcode">hashCode</a>, it should override the <a href="/ribs/api/package-ribs_sql_ribs_sql/ReadWrite.html#operator-equals">operator ==</a> operator as well to maintain consistency.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> hashCode;</span></span></code></pre></div></details>', 10)),
    createBaseVNode("h3", _hoisted_3, [
      _cache[8] || (_cache[8] = createTextVNode("length ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[9] || (_cache[9] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[10] || (_cache[10] = createTextVNode()),
      _cache[11] || (_cache[11] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-length",
        "aria-label": 'Permalink to "length <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-length}"'
      }, "​", -1))
    ]),
    _cache[86] || (_cache[86] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">int</span> <span class="kw">get</span> <span class="fn">length</span></code></pre></div><p>The number of parameter slots occupied by this <a href="/ribs/api/package-ribs_sql_ribs_sql/Write.html">Write</a>.</p><p><em>Inherited from Write.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> length </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> puts.length;</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_4, [
      _cache[12] || (_cache[12] = createTextVNode("puts ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[13] || (_cache[13] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "override"
      }),
      _cache[14] || (_cache[14] = createTextVNode()),
      _cache[15] || (_cache[15] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-puts",
        "aria-label": 'Permalink to "puts <Badge type="tip" text="no setter" /> <Badge type="info" text="override" /> {#prop-puts}"'
      }, "​", -1))
    ]),
    _cache[87] || (_cache[87] = createStaticVNode('<div class="member-signature"><pre><code><a href="../package-ribs_core_ribs_core/IList" class="type-link">IList</a>&lt;<a href="./Put" class="type-link">Put</a>&lt;<span class="type">dynamic</span>&gt;&gt; <span class="kw">get</span> <span class="fn">puts</span></code></pre></div><p>The individual column <a href="./Put.html" class="api-link"><code>Put</code></a> encoders that make up this <a href="/ribs/api/package-ribs_sql_ribs_sql/Write.html">Write</a>.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Put</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">dynamic</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> puts </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> write.puts;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_5, [
      _cache[16] || (_cache[16] = createTextVNode("read ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[17] || (_cache[17] = createTextVNode()),
      _cache[18] || (_cache[18] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-read",
        "aria-label": 'Permalink to "read <Badge type="tip" text="final" /> {#prop-read}"'
      }, "​", -1))
    ]),
    _cache[88] || (_cache[88] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <a href="./Read" class="type-link">Read</a>&lt;<span class="type">A</span>&gt; <span class="fn">read</span></code></pre></div><p>Codec used to read <a href="/ribs/api/package-ribs_sql_ribs_sql/Row.html">Row</a> data into type <code>A</code>.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Read</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; read;</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_6, [
      _cache[19] || (_cache[19] = createTextVNode("runtimeType ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[20] || (_cache[20] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[21] || (_cache[21] = createTextVNode()),
      _cache[22] || (_cache[22] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-runtimetype",
        "aria-label": 'Permalink to "runtimeType <Badge type="tip" text="no setter" /> <Badge type="info" text="inherited" /> {#prop-runtimetype}"'
      }, "​", -1))
    ]),
    _cache[89] || (_cache[89] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">Type</span> <span class="kw">get</span> <span class="fn">runtimeType</span></code></pre></div><p>A representation of the runtime type of the object.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Type</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> runtimeType;</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_7, [
      _cache[23] || (_cache[23] = createTextVNode("write ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[24] || (_cache[24] = createTextVNode()),
      _cache[25] || (_cache[25] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-write",
        "aria-label": 'Permalink to "write <Badge type="tip" text="final" /> {#prop-write}"'
      }, "​", -1))
    ]),
    _cache[90] || (_cache[90] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <a href="./Write" class="type-link">Write</a>&lt;<span class="type">A</span>&gt; <span class="fn">write</span></code></pre></div><p>Codec used to write parameters of type <code>A</code> to a query or update statement.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Write</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; write;</span></span></code></pre></div></details><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 4)),
    createBaseVNode("h3", _hoisted_8, [
      _cache[26] || (_cache[26] = createTextVNode("contramap() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[27] || (_cache[27] = createTextVNode()),
      _cache[28] || (_cache[28] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#contramap",
        "aria-label": 'Permalink to "contramap() <Badge type="info" text="inherited" /> {#contramap}"'
      }, "​", -1))
    ]),
    _cache[91] || (_cache[91] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Write" class="type-link">Write</a>&lt;<span class="type">B</span>&gt; <span class="fn">contramap&lt;B&gt;</span>(<span class="type">A</span> <span class="type">Function</span>(<span class="type">B</span>) <span class="param">f</span>)</code></pre></div><p>Adapts this <a href="/ribs/api/package-ribs_sql_ribs_sql/Write.html">Write</a> to accept a different type <code>B</code> by applying <code>f</code> before encoding.</p><p><em>Inherited from Write.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Write</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">contramap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; f) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Write</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">instance</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  puts,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  (params, n, value) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> setParameter</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(params, n, </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">f</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(value)),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_9, [
      _cache[29] || (_cache[29] = createTextVNode("emap() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[30] || (_cache[30] = createTextVNode()),
      _cache[31] || (_cache[31] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#emap",
        "aria-label": 'Permalink to "emap() <Badge type="info" text="inherited" /> {#emap}"'
      }, "​", -1))
    ]),
    _cache[92] || (_cache[92] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Read" class="type-link">Read</a>&lt;<span class="type">B</span>&gt; <span class="fn">emap&lt;B&gt;</span>(<a href="../package-ribs_core_ribs_core/Either" class="type-link">Either</a>&lt;<span class="type">String</span>, <span class="type">B</span>&gt; <span class="type">Function</span>(<span class="type">A</span>) <span class="param">f</span>)</code></pre></div><p>Transforms the decoded value with <code>f</code>, which may fail with an error message (left) or succeed with a new value (right).</p><p><em>Inherited from Read.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Read</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">emap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Either</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; f) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Read</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">instance</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(gets, (row, n) {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  final</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> a </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> unsafeGet</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(row, n);</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  return</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> f</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(a).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    (err) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> throw</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Exception</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;Invalid value [</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">$</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">a</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">]: </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">$</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">err</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    identity,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  );</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">});</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_10, [
      _cache[32] || (_cache[32] = createTextVNode("encode() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[33] || (_cache[33] = createTextVNode()),
      _cache[34] || (_cache[34] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#encode",
        "aria-label": 'Permalink to "encode() <Badge type="info" text="inherited" /> {#encode}"'
      }, "​", -1))
    ]),
    _cache[93] || (_cache[93] = createStaticVNode('<div class="member-signature"><pre><code><a href="./StatementParameters" class="type-link">StatementParameters</a> <span class="fn">encode</span>(<span class="type">A</span> <span class="param">value</span>)</code></pre></div><p>Encodes <code>value</code> to a <a href="/ribs/api/package-ribs_sql_ribs_sql/StatementParameters.html">StatementParameters</a>.</p><p><em>Inherited from Write.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">StatementParameters</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> encode</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> setParameter</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">StatementParameters</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">empty</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(), </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, value);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_11, [
      _cache[35] || (_cache[35] = createTextVNode("map() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[36] || (_cache[36] = createTextVNode()),
      _cache[37] || (_cache[37] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#map",
        "aria-label": 'Permalink to "map() <Badge type="info" text="inherited" /> {#map}"'
      }, "​", -1))
    ]),
    _cache[94] || (_cache[94] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Read" class="type-link">Read</a>&lt;<span class="type">B</span>&gt; <span class="fn">map&lt;B&gt;</span>(<span class="type">B</span> <span class="type">Function</span>(<span class="type">A</span>) <span class="param">f</span>)</code></pre></div><p>Transforms the decoded value by applying <code>f</code>.</p><p><em>Inherited from Read.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Read</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">map</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; f) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Read</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">instance</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(gets, (row, n) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> f</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">unsafeGet</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(row, n)));</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_12, [
      _cache[38] || (_cache[38] = createTextVNode("noSuchMethod() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[39] || (_cache[39] = createTextVNode()),
      _cache[40] || (_cache[40] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#nosuchmethod",
        "aria-label": 'Permalink to "noSuchMethod() <Badge type="info" text="inherited" /> {#nosuchmethod}"'
      }, "​", -1))
    ]),
    _cache[95] || (_cache[95] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">dynamic</span> <span class="fn">noSuchMethod</span>(<span class="type">Invocation</span> <span class="param">invocation</span>)</code></pre></div><p>Invoked when a nonexistent method or property is accessed.</p><p>A dynamic member invocation can attempt to call a member which doesn&#39;t exist on the receiving object. Example:</p><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">dynamic</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> object </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">object.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">add</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">42</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">); </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">// Statically allowed, run-time error</span></span></code></pre></div><p>This invalid code will invoke the <code>noSuchMethod</code> method of the integer <code>1</code> with an <a href="https://api.dart.dev/stable/3.11.4/dart-core/Invocation-class.html" target="_blank" rel="noreferrer">Invocation</a> representing the <code>.add(42)</code> call and arguments (which then throws).</p><p>Classes can override <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object/noSuchMethod.html" target="_blank" rel="noreferrer">noSuchMethod</a> to provide custom behavior for such invalid dynamic invocations.</p><p>A class with a non-default <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object/noSuchMethod.html" target="_blank" rel="noreferrer">noSuchMethod</a> invocation can also omit implementations for members of its interface. Example:</p><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">class</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> MockList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">implements</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> List</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; {</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">  noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Invocation</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> invocation) {</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    log</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(invocation);</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    super</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(invocation); </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">// Will throw.</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  }</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">void</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> main</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() {</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  MockList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">().</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">add</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">42</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div><p>This code has no compile-time warnings or errors even though the <code>MockList</code> class has no concrete implementation of any of the <code>List</code> interface methods. Calls to <code>List</code> methods are forwarded to <code>noSuchMethod</code>, so this code will <code>log</code> an invocation similar to <code>Invocation.method(#add, [42])</code> and then throw.</p><p>If a value is returned from <code>noSuchMethod</code>, it becomes the result of the original invocation. If the value is not of a type that can be returned by the original invocation, a type error occurs at the invocation.</p><p>The default behavior is to throw a <a href="https://api.dart.dev/stable/3.11.4/dart-core/NoSuchMethodError-class.html" target="_blank" rel="noreferrer">NoSuchMethodError</a>.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@pragma</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;vm:entry-point&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@pragma</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;wasm:entry-point&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> dynamic</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> noSuchMethod</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Invocation</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> invocation);</span></span></code></pre></div></details><h3 id="optional" tabindex="-1">optional() <a class="header-anchor" href="#optional" aria-label="Permalink to &quot;optional() {#optional}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./ReadWrite" class="type-link">ReadWrite</a>&lt;<a href="../package-ribs_core_ribs_core/Option" class="type-link">Option</a>&lt;<span class="type">A</span>&gt;&gt; <span class="fn">optional</span>()</code></pre></div><p>Returns a <a href="/ribs/api/package-ribs_sql_ribs_sql/ReadWrite.html">ReadWrite</a> that treats <code>null</code> columns as <a href="/ribs/api/package-ribs_core_ribs_core/None.html">None</a> and encodes <a href="/ribs/api/package-ribs_core_ribs_core/None.html">None</a> as <code>null</code>.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">optional</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(read.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">optional</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(), write.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">optional</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">());</span></span></code></pre></div></details>', 17)),
    createBaseVNode("h3", _hoisted_13, [
      _cache[41] || (_cache[41] = createTextVNode("setParameter() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "override"
      }),
      _cache[42] || (_cache[42] = createTextVNode()),
      _cache[43] || (_cache[43] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#setparameter",
        "aria-label": 'Permalink to "setParameter() <Badge type="info" text="override" /> {#setparameter}"'
      }, "​", -1))
    ]),
    _cache[96] || (_cache[96] = createStaticVNode('<div class="member-signature"><pre><code><a href="./StatementParameters" class="type-link">StatementParameters</a> <span class="fn">setParameter</span>(<a href="./StatementParameters" class="type-link">StatementParameters</a> <span class="param">params</span>, <span class="type">int</span> <span class="param">n</span>, <span class="type">A</span> <span class="param">a</span>)</code></pre></div><p>Sets the parameter at position <code>n</code> in <code>params</code> to the encoded form of <code>a</code>, returning updated parameters.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">StatementParameters</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> setParameter</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">StatementParameters</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> params, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> n, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    write.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">setParameter</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(params, n, a);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_14, [
      _cache[44] || (_cache[44] = createTextVNode("toString() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[45] || (_cache[45] = createTextVNode()),
      _cache[46] || (_cache[46] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#tostring",
        "aria-label": 'Permalink to "toString() <Badge type="info" text="inherited" /> {#tostring}"'
      }, "​", -1))
    ]),
    _cache[97] || (_cache[97] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">String</span> <span class="fn">toString</span>()</code></pre></div><p>A string representation of this object.</p><p>Some classes have a default textual representation, often paired with a static <code>parse</code> function (like <a href="https://api.dart.dev/stable/3.11.4/dart-core/int/parse.html" target="_blank" rel="noreferrer">int.parse</a>). These classes will provide the textual representation as their string representation.</p><p>Other classes have no meaningful textual representation that a program will care about. Such classes will typically override <code>toString</code> to provide useful information when inspecting the object, mainly for debugging or logging.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> String</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> toString</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">();</span></span></code></pre></div></details>', 6)),
    createBaseVNode("h3", _hoisted_15, [
      _cache[47] || (_cache[47] = createTextVNode("unsafeGet() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "override"
      }),
      _cache[48] || (_cache[48] = createTextVNode()),
      _cache[49] || (_cache[49] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#unsafeget",
        "aria-label": 'Permalink to "unsafeGet() <Badge type="info" text="override" /> {#unsafeget}"'
      }, "​", -1))
    ]),
    _cache[98] || (_cache[98] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">A</span> <span class="fn">unsafeGet</span>(<a href="./Row" class="type-link">Row</a> <span class="param">row</span>, <span class="type">int</span> <span class="param">n</span>)</code></pre></div><p>Extracts a value of type <code>A</code> from <code>row</code> starting at column index <code>n</code>.</p><p>May throw if columns are missing or contain incompatible types.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">@override</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> unsafeGet</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Row</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> row, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> n) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> read.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">unsafeGet</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(row, n);</span></span></code></pre></div></details><h3 id="xemap" tabindex="-1">xemap() <a class="header-anchor" href="#xemap" aria-label="Permalink to &quot;xemap() {#xemap}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./ReadWrite" class="type-link">ReadWrite</a>&lt;<span class="type">B</span>&gt; <span class="fn">xemap&lt;B&gt;</span>(<a href="../package-ribs_core_ribs_core/Either" class="type-link">Either</a>&lt;<span class="type">String</span>, <span class="type">B</span>&gt; <span class="type">Function</span>(<span class="type">A</span>) <span class="param">f</span>, <span class="type">A</span> <span class="type">Function</span>(<span class="type">B</span>) <span class="param">g</span>)</code></pre></div><p>Like <a href="/ribs/api/package-ribs_sql_ribs_sql/ReadWrite.html#xmap">xmap</a>, but the read-side mapping <code>f</code> may fail with an error message (left) or succeed (right).</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">xemap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Either</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; f, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; g) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(read.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">emap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(f), write.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">contramap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(g));</span></span></code></pre></div></details><h3 id="xmap" tabindex="-1">xmap() <a class="header-anchor" href="#xmap" aria-label="Permalink to &quot;xmap() {#xmap}&quot;">​</a></h3><div class="member-signature"><pre><code><a href="./ReadWrite" class="type-link">ReadWrite</a>&lt;<span class="type">B</span>&gt; <span class="fn">xmap&lt;B&gt;</span>(<span class="type">B</span> <span class="type">Function</span>(<span class="type">A</span>) <span class="param">f</span>, <span class="type">A</span> <span class="type">Function</span>(<span class="type">B</span>) <span class="param">g</span>)</code></pre></div><p>Maps the read side with <code>f</code> and contramaps the write side with <code>g</code>, producing a <a href="/ribs/api/package-ribs_sql_ribs_sql/ReadWrite.html">ReadWrite</a> for a different type <code>B</code>.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">xmap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; f, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; g) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(read.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">map</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(f), write.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">contramap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(g));</span></span></code></pre></div></details><h2 id="extension-section-methods" tabindex="-1">Extension Methods <a class="header-anchor" href="#extension-section-methods" aria-label="Permalink to &quot;Extension Methods {#extension-section-methods}&quot;">​</a></h2>', 13)),
    createBaseVNode("h3", _hoisted_16, [
      _cache[50] || (_cache[50] = createTextVNode("optional() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[51] || (_cache[51] = createTextVNode()),
      _cache[52] || (_cache[52] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#optional-2",
        "aria-label": 'Permalink to "optional() <Badge type="info" text="extension" /> {#optional-2}"'
      }, "​", -1))
    ]),
    _cache[99] || (_cache[99] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Read" class="type-link">Read</a>&lt;<a href="../package-ribs_core_ribs_core/Option" class="type-link">Option</a>&lt;<span class="type">A</span>&gt;&gt; <span class="fn">optional</span>()</code></pre></div><p>Returns a <a href="/ribs/api/package-ribs_sql_ribs_sql/Read.html">Read</a> that produces <a href="/ribs/api/package-ribs_core_ribs_core/None.html">None</a> when the column is <code>null</code> or out of range, and <a href="/ribs/api/package-ribs_core_ribs_core/Some.html">Some</a> with the decoded value otherwise.</p><p><em>Available on <a href="/ribs/api/package-ribs_sql_ribs_sql/Read.html">Read&lt;A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_sql_ribs_sql/ReadOptionOps.html">ReadOptionOps&lt;A&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Read</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">optional</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Read</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">instance</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  gets,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  (row, n) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">unless</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    () </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> n </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> row.length </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">||</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> row[n] </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> null</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    () </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> unsafeGet</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(row, n),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  ),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_17, [
      _cache[53] || (_cache[53] = createTextVNode("optional() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[54] || (_cache[54] = createTextVNode()),
      _cache[55] || (_cache[55] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#optional-3",
        "aria-label": 'Permalink to "optional() <Badge type="info" text="extension" /> {#optional-3}"'
      }, "​", -1))
    ]),
    _cache[100] || (_cache[100] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Write" class="type-link">Write</a>&lt;<a href="../package-ribs_core_ribs_core/Option" class="type-link">Option</a>&lt;<span class="type">A</span>&gt;&gt; <span class="fn">optional</span>()</code></pre></div><p>Returns a <a href="/ribs/api/package-ribs_sql_ribs_sql/Write.html">Write</a> that encodes <a href="/ribs/api/package-ribs_core_ribs_core/None.html">None</a> as <code>null</code> and <a href="/ribs/api/package-ribs_core_ribs_core/Some.html">Some</a> with the underlying encoder.</p><p><em>Available on <a href="/ribs/api/package-ribs_sql_ribs_sql/Write.html">Write&lt;A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_sql_ribs_sql/WriteOptionOps.html">WriteOptionOps&lt;A&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Write</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">optional</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Write</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">instance</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  puts,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  (params, n, a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> a.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    () </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> params.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">setParameter</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(n </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">+</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> length </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">-</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> 1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">null</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    (some) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> setParameter</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(params, n, some),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  ),</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details><h2 id="section-operators" tabindex="-1">Operators <a class="header-anchor" href="#section-operators" aria-label="Permalink to &quot;Operators {#section-operators}&quot;">​</a></h2>', 5)),
    createBaseVNode("h3", _hoisted_18, [
      _cache[56] || (_cache[56] = createTextVNode("operator ==() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "inherited"
      }),
      _cache[57] || (_cache[57] = createTextVNode()),
      _cache[58] || (_cache[58] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#operator-equals",
        "aria-label": 'Permalink to "operator ==() <Badge type="info" text="inherited" /> {#operator-equals}"'
      }, "​", -1))
    ]),
    _cache[101] || (_cache[101] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">operator ==</span>(<span class="type">Object</span> <span class="param">other</span>)</code></pre></div><p>The equality operator.</p><p>The default behavior for all <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object-class.html" target="_blank" rel="noreferrer">Object</a>s is to return true if and only if this object and <code>other</code> are the same object.</p><p>Override this method to specify a different equality relation on a class. The overriding method must still be an equivalence relation. That is, it must be:</p><ul><li><p>Total: It must return a boolean for all arguments. It should never throw.</p></li><li><p>Reflexive: For all objects <code>o</code>, <code>o == o</code> must be true.</p></li><li><p>Symmetric: For all objects <code>o1</code> and <code>o2</code>, <code>o1 == o2</code> and <code>o2 == o1</code> must either both be true, or both be false.</p></li><li><p>Transitive: For all objects <code>o1</code>, <code>o2</code>, and <code>o3</code>, if <code>o1 == o2</code> and <code>o2 == o3</code> are true, then <code>o1 == o3</code> must be true.</p></li></ul><p>The method should also be consistent over time, so whether two objects are equal should only change if at least one of the objects was modified.</p><p>If a subclass overrides the equality operator, it should override the <a href="https://api.dart.dev/stable/3.11.4/dart-core/Object/hashCode.html" target="_blank" rel="noreferrer">hashCode</a> method as well to maintain consistency.</p><p><em>Inherited from Object.</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">external</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> bool</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> operator</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> ==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Object</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> other);</span></span></code></pre></div></details><h2 id="section-static-properties" tabindex="-1">Static Properties <a class="header-anchor" href="#section-static-properties" aria-label="Permalink to &quot;Static Properties {#section-static-properties}&quot;">​</a></h2>', 10)),
    createBaseVNode("h3", _hoisted_19, [
      _cache[59] || (_cache[59] = createTextVNode("bigInt ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[60] || (_cache[60] = createTextVNode()),
      _cache[61] || (_cache[61] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-bigint",
        "aria-label": 'Permalink to "bigInt <Badge type="tip" text="final" /> {#prop-bigint}"'
      }, "​", -1))
    ]),
    _cache[102] || (_cache[102] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <a href="./ReadWrite" class="type-link">ReadWrite</a>&lt;<span class="type">BigInt</span>&gt; <span class="fn">bigInt</span></code></pre></div><p>Reads and writes a <a href="https://api.dart.dev/stable/3.11.4/dart-core/BigInt-class.html" target="_blank" rel="noreferrer">BigInt</a> column.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">BigInt</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; bigInt </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Read</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.bigInt, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Write</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.bigInt);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_20, [
      _cache[62] || (_cache[62] = createTextVNode("blob ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[63] || (_cache[63] = createTextVNode()),
      _cache[64] || (_cache[64] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-blob",
        "aria-label": 'Permalink to "blob <Badge type="tip" text="final" /> {#prop-blob}"'
      }, "​", -1))
    ]),
    _cache[103] || (_cache[103] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <a href="./ReadWrite" class="type-link">ReadWrite</a>&lt;<a href="../package-ribs_binary_ribs_binary/ByteVector" class="type-link">ByteVector</a>&gt; <span class="fn">blob</span></code></pre></div><p>Reads and writes a binary blob column.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">ByteVector</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; blob </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Read</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.blob, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Write</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.blob);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_21, [
      _cache[65] || (_cache[65] = createTextVNode("boolean ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[66] || (_cache[66] = createTextVNode()),
      _cache[67] || (_cache[67] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-boolean",
        "aria-label": 'Permalink to "boolean <Badge type="tip" text="final" /> {#prop-boolean}"'
      }, "​", -1))
    ]),
    _cache[104] || (_cache[104] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <a href="./ReadWrite" class="type-link">ReadWrite</a>&lt;<span class="type">bool</span>&gt; <span class="fn">boolean</span></code></pre></div><p>Reads and writes a boolean column.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; boolean </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Read</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.boolean, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Write</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.boolean);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_22, [
      _cache[68] || (_cache[68] = createTextVNode("dateTime ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[69] || (_cache[69] = createTextVNode()),
      _cache[70] || (_cache[70] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-datetime",
        "aria-label": 'Permalink to "dateTime <Badge type="tip" text="final" /> {#prop-datetime}"'
      }, "​", -1))
    ]),
    _cache[105] || (_cache[105] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <a href="./ReadWrite" class="type-link">ReadWrite</a>&lt;<span class="type">DateTime</span>&gt; <span class="fn">dateTime</span></code></pre></div><p>Reads and writes a <a href="https://api.dart.dev/stable/3.11.4/dart-core/DateTime-class.html" target="_blank" rel="noreferrer">DateTime</a> column.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">DateTime</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; dateTime </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Read</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.dateTime, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Write</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.dateTime);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_23, [
      _cache[71] || (_cache[71] = createTextVNode("dubble ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[72] || (_cache[72] = createTextVNode()),
      _cache[73] || (_cache[73] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-dubble",
        "aria-label": 'Permalink to "dubble <Badge type="tip" text="final" /> {#prop-dubble}"'
      }, "​", -1))
    ]),
    _cache[106] || (_cache[106] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <a href="./ReadWrite" class="type-link">ReadWrite</a>&lt;<span class="type">double</span>&gt; <span class="fn">dubble</span></code></pre></div><p>Reads and writes a <a href="https://api.dart.dev/stable/3.11.4/dart-core/double-class.html" target="_blank" rel="noreferrer">double</a> column.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">double</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; dubble </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Read</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.dubble, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Write</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.dubble);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_24, [
      _cache[74] || (_cache[74] = createTextVNode("integer ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[75] || (_cache[75] = createTextVNode()),
      _cache[76] || (_cache[76] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-integer",
        "aria-label": 'Permalink to "integer <Badge type="tip" text="final" /> {#prop-integer}"'
      }, "​", -1))
    ]),
    _cache[107] || (_cache[107] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <a href="./ReadWrite" class="type-link">ReadWrite</a>&lt;<span class="type">int</span>&gt; <span class="fn">integer</span></code></pre></div><p>Reads and writes an <a href="https://api.dart.dev/stable/3.11.4/dart-core/int-class.html" target="_blank" rel="noreferrer">int</a> column.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; integer </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Read</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.integer, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Write</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.integer);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_25, [
      _cache[77] || (_cache[77] = createTextVNode("json ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[78] || (_cache[78] = createTextVNode()),
      _cache[79] || (_cache[79] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-json",
        "aria-label": 'Permalink to "json <Badge type="tip" text="final" /> {#prop-json}"'
      }, "​", -1))
    ]),
    _cache[108] || (_cache[108] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <a href="./ReadWrite" class="type-link">ReadWrite</a>&lt;<a href="../package-ribs_json_ribs_json/Json" class="type-link">Json</a>&gt; <span class="fn">json</span></code></pre></div><p>Reads and writes a <a href="/ribs/api/package-ribs_json_ribs_json/Json.html">Json</a> column.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Json</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; json </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Read</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.json, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Write</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.json);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_26, [
      _cache[80] || (_cache[80] = createTextVNode("string ", -1)),
      createVNode(_component_Badge, {
        type: "tip",
        text: "final"
      }),
      _cache[81] || (_cache[81] = createTextVNode()),
      _cache[82] || (_cache[82] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-string",
        "aria-label": 'Permalink to "string <Badge type="tip" text="final" /> {#prop-string}"'
      }, "​", -1))
    ]),
    _cache[109] || (_cache[109] = createStaticVNode('<div class="member-signature"><pre><code><span class="kw">final</span> <a href="./ReadWrite" class="type-link">ReadWrite</a>&lt;<span class="type">String</span>&gt; <span class="fn">string</span></code></pre></div><p>Reads and writes a <a href="https://api.dart.dev/stable/3.11.4/dart-core/String-class.html" target="_blank" rel="noreferrer">String</a> column.</p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">static</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> final</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; string </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> ReadWrite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Read</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.string, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Write</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.string);</span></span></code></pre></div></details>', 3))
  ]);
}
const ReadWrite = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  ReadWrite as default
};
