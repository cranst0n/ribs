import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.BtCwkIEr.js";
const __pageData = JSON.parse('{"title":"OptionOps","description":"API documentation for OptionOps<A> extension from ribs_core","frontmatter":{"title":"OptionOps<A>","description":"API documentation for OptionOps<A> extension from ribs_core","category":"Extensions","library":"ribs_core","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_core_ribs_core/OptionOps.md","filePath":"api/package-ribs_core_ribs_core/OptionOps.md"}');
const _sfc_main = { name: "api/package-ribs_core_ribs_core/OptionOps.md" };
const _hoisted_1 = {
  id: "prop-get",
  tabindex: "-1"
};
const _hoisted_2 = {
  id: "prop-getornull",
  tabindex: "-1"
};
const _hoisted_3 = {
  id: "contains",
  tabindex: "-1"
};
const _hoisted_4 = {
  id: "getorelse",
  tabindex: "-1"
};
const _hoisted_5 = {
  id: "orelse",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[17] || (_cache[17] = createStaticVNode('<h1 id="optionops-a" tabindex="-1">OptionOps&lt;A&gt; <a class="header-anchor" href="#optionops-a" aria-label="Permalink to &quot;OptionOps\\&lt;A\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">OptionOps</span>&lt;A&gt; <span class="kw">on</span> <a href="./Option" class="type-link">Option</a>&lt;<span class="type">A</span>&gt;</code></pre></div><h2 id="section-properties" tabindex="-1">Properties <a class="header-anchor" href="#section-properties" aria-label="Permalink to &quot;Properties {#section-properties}&quot;">​</a></h2>', 3)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("get ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[2] || (_cache[2] = createTextVNode()),
      _cache[3] || (_cache[3] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-get",
        "aria-label": 'Permalink to "get <Badge type="info" text="extension" /> <Badge type="tip" text="no setter" /> {#prop-get}"'
      }, "​", -1))
    ]),
    _cache[18] || (_cache[18] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">A</span> <span class="kw">get</span> <span class="fn">get</span></code></pre></div><p>Returns the value if this is a <a href="/ribs/api/package-ribs_core_ribs_core/Some.html">Some</a>, or throws a <a href="https://api.dart.dev/stable/3.11.4/dart-core/StateError-class.html" target="_blank" rel="noreferrer">StateError</a> if this is a <a href="/ribs/api/package-ribs_core_ribs_core/None.html">None</a>.</p><p>This is an unsafe, partial operation. Prefer <a href="/ribs/api/package-ribs_core_ribs_core/OptionOps.html#getorelse">getOrElse</a>, <a href="/ribs/api/package-ribs_core_ribs_core/Option.html#fold">fold</a>, or pattern matching when the <a href="/ribs/api/package-ribs_core_ribs_core/Option.html">Option</a> may be <a href="/ribs/api/package-ribs_core_ribs_core/None.html">None</a>. Use <a href="/ribs/api/package-ribs_core_ribs_core/OptionOps.html#prop-get">get</a> only when you have already proven that this <a href="/ribs/api/package-ribs_core_ribs_core/Option.html">Option</a> is non-empty.</p><p>See also <a href="/ribs/api/package-ribs_core_ribs_core/OptionOps.html#prop-getornull">getOrNull</a> for a nullable alternative, and <a href="/ribs/api/package-ribs_core_ribs_core/OptionOps.html#getorelse">getOrElse</a> for providing a fallback value.</p><p><em>Available on <a href="/ribs/api/package-ribs_core_ribs_core/Option.html">Option&lt;A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_core_ribs_core/OptionOps.html">OptionOps&lt;A&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> =&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> throw</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> StateError</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;None.get&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">), identity);</span></span></code></pre></div></details>', 6)),
    createBaseVNode("h3", _hoisted_2, [
      _cache[4] || (_cache[4] = createTextVNode("getOrNull ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[5] || (_cache[5] = createTextVNode()),
      createVNode(_component_Badge, {
        type: "tip",
        text: "no setter"
      }),
      _cache[6] || (_cache[6] = createTextVNode()),
      _cache[7] || (_cache[7] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#prop-getornull",
        "aria-label": 'Permalink to "getOrNull <Badge type="info" text="extension" /> <Badge type="tip" text="no setter" /> {#prop-getornull}"'
      }, "​", -1))
    ]),
    _cache[19] || (_cache[19] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">A</span>? <span class="kw">get</span> <span class="fn">getOrNull</span></code></pre></div><p>Returns the value if this is a <a href="/ribs/api/package-ribs_core_ribs_core/Some.html">Some</a>, or <code>null</code> if this is a <a href="/ribs/api/package-ribs_core_ribs_core/None.html">None</a>.</p><p>This is equivalent to <a href="/ribs/api/package-ribs_core_ribs_core/Option.html#tonullable">Option.toNullable</a> and is provided as a conventionally named companion to <a href="/ribs/api/package-ribs_core_ribs_core/OptionOps.html#prop-get">get</a>.</p><p><em>Available on <a href="/ribs/api/package-ribs_core_ribs_core/Option.html">Option&lt;A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_core_ribs_core/OptionOps.html">OptionOps&lt;A&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> getOrNull </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> toNullable</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">();</span></span></code></pre></div></details><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 6)),
    createBaseVNode("h3", _hoisted_3, [
      _cache[8] || (_cache[8] = createTextVNode("contains() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[9] || (_cache[9] = createTextVNode()),
      _cache[10] || (_cache[10] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#contains",
        "aria-label": 'Permalink to "contains() <Badge type="info" text="extension" /> {#contains}"'
      }, "​", -1))
    ]),
    _cache[20] || (_cache[20] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">bool</span> <span class="fn">contains</span>(<span class="type">A</span> <span class="param">elem</span>)</code></pre></div><p><em>Available on <a href="/ribs/api/package-ribs_core_ribs_core/Option.html">Option&lt;A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_core_ribs_core/OptionOps.html">OptionOps&lt;A&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">bool</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> contains</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> elem) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> false</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, (value) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> value </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">==</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> elem);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_4, [
      _cache[11] || (_cache[11] = createTextVNode("getOrElse() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[12] || (_cache[12] = createTextVNode()),
      _cache[13] || (_cache[13] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#getorelse",
        "aria-label": 'Permalink to "getOrElse() <Badge type="info" text="extension" /> {#getorelse}"'
      }, "​", -1))
    ]),
    _cache[21] || (_cache[21] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">A</span> <span class="fn">getOrElse</span>(<span class="type">A</span> <span class="type">Function</span>() <span class="param">ifEmpty</span>)</code></pre></div><p>Returns the value if this is a <a href="/ribs/api/package-ribs_core_ribs_core/Some.html">Some</a> or the value returned from evaluating <code>ifEmpty</code>.</p><p><em>Available on <a href="/ribs/api/package-ribs_core_ribs_core/Option.html">Option&lt;A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_core_ribs_core/OptionOps.html">OptionOps&lt;A&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> getOrElse</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; ifEmpty) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(ifEmpty, identity);</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_5, [
      _cache[14] || (_cache[14] = createTextVNode("orElse() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[15] || (_cache[15] = createTextVNode()),
      _cache[16] || (_cache[16] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#orelse",
        "aria-label": 'Permalink to "orElse() <Badge type="info" text="extension" /> {#orelse}"'
      }, "​", -1))
    ]),
    _cache[22] || (_cache[22] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Option" class="type-link">Option</a>&lt;<span class="type">A</span>&gt; <span class="fn">orElse</span>(<a href="./Option" class="type-link">Option</a>&lt;<span class="type">A</span>&gt; <span class="type">Function</span>() <span class="param">orElse</span>)</code></pre></div><p>If this is a <a href="/ribs/api/package-ribs_core_ribs_core/Some.html">Some</a>, this is returned, otherwise the result of evaluating <code>orElse</code> is returned.</p><p><em>Available on <a href="/ribs/api/package-ribs_core_ribs_core/Option.html">Option&lt;A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_core_ribs_core/OptionOps.html">OptionOps&lt;A&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">orElse</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; orElse) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(orElse, (_) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 4))
  ]);
}
const OptionOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  OptionOps as default
};
