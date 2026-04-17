import { r as resolveComponent, o as openBlock, c as createElementBlock, a as createStaticVNode, b as createBaseVNode, d as createTextVNode, e as createVNode, _ as _export_sfc } from "./app.BXNlnAkM.js";
const __pageData = JSON.parse('{"title":"IOOptionOps","description":"API documentation for IOOptionOps<A> extension from ribs_effect","frontmatter":{"title":"IOOptionOps<A>","description":"API documentation for IOOptionOps<A> extension from ribs_effect","category":"Extensions","library":"ribs_effect","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_effect_ribs_effect/IOOptionOps.md","filePath":"api/package-ribs_effect_ribs_effect/IOOptionOps.md"}');
const _sfc_main = { name: "api/package-ribs_effect_ribs_effect/IOOptionOps.md" };
const _hoisted_1 = {
  id: "traverseio",
  tabindex: "-1"
};
const _hoisted_2 = {
  id: "traverseio_",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[6] || (_cache[6] = createStaticVNode('<h1 id="iooptionops-a" tabindex="-1">IOOptionOps&lt;A&gt; <a class="header-anchor" href="#iooptionops-a" aria-label="Permalink to &quot;IOOptionOps\\&lt;A\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">IOOptionOps</span>&lt;A&gt; <span class="kw">on</span> <a href="../package-ribs_core_ribs_core/Option" class="type-link">Option</a>&lt;<span class="type">A</span>&gt;</code></pre></div><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 3)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("traverseIO() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#traverseio",
        "aria-label": 'Permalink to "traverseIO() <Badge type="info" text="extension" /> {#traverseio}"'
      }, "​", -1))
    ]),
    _cache[7] || (_cache[7] = createStaticVNode('<div class="member-signature"><pre><code><a href="./IO" class="type-link">IO</a>&lt;<a href="../package-ribs_core_ribs_core/Option" class="type-link">Option</a>&lt;<span class="type">B</span>&gt;&gt; <span class="fn">traverseIO&lt;B&gt;</span>(<a href="./IO" class="type-link">IO</a>&lt;<span class="type">B</span>&gt; <span class="type">Function</span>(<span class="type">A</span>) <span class="param">f</span>)</code></pre></div><p>If this is a <a href="/ribs/api/package-ribs_core_ribs_core/Some.html">Some</a>, returns the result of applying <code>f</code> to the value, otherwise an <a href="/ribs/api/package-ribs_effect_ribs_effect/IO.html">IO</a> with a <a href="/ribs/api/package-ribs_core_ribs_core/None.html">None</a> is returned.</p><p><em>Available on <a href="/ribs/api/package-ribs_core_ribs_core/Option.html">Option&lt;A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_effect_ribs_effect/IOOptionOps.html">IOOptionOps&lt;A&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">traverseIO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; f) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">none</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(), (a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> f</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(a).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">map</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Some</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(a)));</span></span></code></pre></div></details>', 4)),
    createBaseVNode("h3", _hoisted_2, [
      _cache[3] || (_cache[3] = createTextVNode("traverseIO_() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[4] || (_cache[4] = createTextVNode()),
      _cache[5] || (_cache[5] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#traverseio_",
        "aria-label": 'Permalink to "traverseIO_() <Badge type="info" text="extension" /> {#traverseio_}"'
      }, "​", -1))
    ]),
    _cache[8] || (_cache[8] = createStaticVNode('<div class="member-signature"><pre><code><a href="./IO" class="type-link">IO</a>&lt;<a href="../package-ribs_core_ribs_core/Unit" class="type-link">Unit</a>&gt; <span class="fn">traverseIO_&lt;B&gt;</span>(<a href="./IO" class="type-link">IO</a>&lt;<span class="type">B</span>&gt; <span class="type">Function</span>(<span class="type">A</span>) <span class="param">f</span>)</code></pre></div><p>Same behavior as <a href="/ribs/api/package-ribs_effect_ribs_effect/IOOptionOps.html#traverseio">traverseIO</a> but the resulting value is discarded.</p><p><em>Available on <a href="/ribs/api/package-ribs_core_ribs_core/Option.html">Option&lt;A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_effect_ribs_effect/IOOptionOps.html">IOOptionOps&lt;A&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Unit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">traverseIO_</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; f) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.unit, (a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> f</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(a).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">map</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((_) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Unit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">()));</span></span></code></pre></div></details>', 4))
  ]);
}
const IOOptionOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  IOOptionOps as default
};
