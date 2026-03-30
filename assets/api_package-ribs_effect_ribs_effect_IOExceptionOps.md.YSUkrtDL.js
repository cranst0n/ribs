import { r as resolveComponent, o as openBlock, c as createElementBlock, a as createStaticVNode, b as createBaseVNode, d as createTextVNode, e as createVNode, _ as _export_sfc } from "./app.witY5Abm.js";
const __pageData = JSON.parse('{"title":"IOExceptionOps","description":"API documentation for IOExceptionOps<A> extension from ribs_effect","frontmatter":{"title":"IOExceptionOps<A>","description":"API documentation for IOExceptionOps<A> extension from ribs_effect","category":"Extensions","library":"ribs_effect","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_effect_ribs_effect/IOExceptionOps.md","filePath":"api/package-ribs_effect_ribs_effect/IOExceptionOps.md"}');
const _sfc_main = { name: "api/package-ribs_effect_ribs_effect/IOExceptionOps.md" };
const _hoisted_1 = {
  id: "rethrowerror",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[3] || (_cache[3] = createStaticVNode('<h1 id="ioexceptionops-a" tabindex="-1">IOExceptionOps&lt;A&gt; <a class="header-anchor" href="#ioexceptionops-a" aria-label="Permalink to &quot;IOExceptionOps\\&lt;A\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">IOExceptionOps</span>&lt;A&gt; <span class="kw">on</span> <a href="./IO" class="type-link">IO</a>&lt;<a href="../package-ribs_core_ribs_core/Either" class="type-link">Either</a>&lt;<span class="type">Object</span>, <span class="type">A</span>&gt;&gt;</code></pre></div><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 3)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("rethrowError() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#rethrowerror",
        "aria-label": 'Permalink to "rethrowError() <Badge type="info" text="extension" /> {#rethrowerror}"'
      }, "​", -1))
    ]),
    _cache[4] || (_cache[4] = createStaticVNode('<div class="member-signature"><pre><code><a href="./IO" class="type-link">IO</a>&lt;<span class="type">A</span>&gt; <span class="fn">rethrowError</span>()</code></pre></div><p>Inverse of <a href="/api/package-ribs_effect_ribs_effect/IO.html#attempt">IO.attempt</a>.</p><p><em>Available on <a href="/api/package-ribs_effect_ribs_effect/IO.html">IO&lt;A&gt;</a>, provided by the <a href="/api/package-ribs_effect_ribs_effect/IOExceptionOps.html">IOExceptionOps&lt;A&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">rethrowError</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> _rethrowError</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">().</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">traced</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;rethrowError&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 4))
  ]);
}
const IOExceptionOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  IOExceptionOps as default
};
