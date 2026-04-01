import { r as resolveComponent, o as openBlock, c as createElementBlock, a as createStaticVNode, b as createBaseVNode, d as createTextVNode, e as createVNode, _ as _export_sfc } from "./app.CNM1B9Vv.js";
const __pageData = JSON.parse('{"title":"RillFlattenOps","description":"API documentation for RillFlattenOps<O> extension from ribs_rill","frontmatter":{"title":"RillFlattenOps<O>","description":"API documentation for RillFlattenOps<O> extension from ribs_rill","category":"Extensions","library":"ribs_rill","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_rill_ribs_rill/RillFlattenOps.md","filePath":"api/package-ribs_rill_ribs_rill/RillFlattenOps.md"}');
const _sfc_main = { name: "api/package-ribs_rill_ribs_rill/RillFlattenOps.md" };
const _hoisted_1 = {
  id: "flatten",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[3] || (_cache[3] = createStaticVNode('<h1 id="rillflattenops-o" tabindex="-1">RillFlattenOps&lt;O&gt; <a class="header-anchor" href="#rillflattenops-o" aria-label="Permalink to &quot;RillFlattenOps\\&lt;O\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">RillFlattenOps</span>&lt;O&gt; <span class="kw">on</span> <a href="./Rill" class="type-link">Rill</a>&lt;<a href="./Rill" class="type-link">Rill</a>&lt;<span class="type">O</span>&gt;&gt;</code></pre></div><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 3)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("flatten() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#flatten",
        "aria-label": 'Permalink to "flatten() <Badge type="info" text="extension" /> {#flatten}"'
      }, "​", -1))
    ]),
    _cache[4] || (_cache[4] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Rill" class="type-link">Rill</a>&lt;<span class="type">O</span>&gt; <span class="fn">flatten</span>()</code></pre></div><p><em>Available on <a href="/ribs/api/package-ribs_rill_ribs_rill/Rill.html">Rill&lt;O&gt;</a>, provided by the <a href="/ribs/api/package-ribs_rill_ribs_rill/RillFlattenOps.html">RillFlattenOps&lt;O&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Rill</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">O</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">flatten</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> flatMap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((r) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> r);</span></span></code></pre></div></details>', 3))
  ]);
}
const RillFlattenOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  RillFlattenOps as default
};
