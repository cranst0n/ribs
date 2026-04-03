import { r as resolveComponent, o as openBlock, c as createElementBlock, a as createStaticVNode, b as createBaseVNode, d as createTextVNode, e as createVNode, _ as _export_sfc } from "./app.CYnFS2Qb.js";
const __pageData = JSON.parse('{"title":"JoinWithUnitOps","description":"API documentation for JoinWithUnitOps extension from ribs_effect","frontmatter":{"title":"JoinWithUnitOps","description":"API documentation for JoinWithUnitOps extension from ribs_effect","category":"Extensions","library":"ribs_effect","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_effect_ribs_effect/JoinWithUnitOps.md","filePath":"api/package-ribs_effect_ribs_effect/JoinWithUnitOps.md"}');
const _sfc_main = { name: "api/package-ribs_effect_ribs_effect/JoinWithUnitOps.md" };
const _hoisted_1 = {
  id: "joinwithunit",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[3] || (_cache[3] = createStaticVNode('<h1 id="joinwithunitops" tabindex="-1">JoinWithUnitOps <a class="header-anchor" href="#joinwithunitops" aria-label="Permalink to &quot;JoinWithUnitOps&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">JoinWithUnitOps</span> <span class="kw">on</span> <a href="./IOFiber" class="type-link">IOFiber</a>&lt;<a href="../package-ribs_core_ribs_core/Unit" class="type-link">Unit</a>&gt;</code></pre></div><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 3)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("joinWithUnit() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#joinwithunit",
        "aria-label": 'Permalink to "joinWithUnit() <Badge type="info" text="extension" /> {#joinwithunit}"'
      }, "​", -1))
    ]),
    _cache[4] || (_cache[4] = createStaticVNode('<div class="member-signature"><pre><code><a href="./IO" class="type-link">IO</a>&lt;<a href="../package-ribs_core_ribs_core/Unit" class="type-link">Unit</a>&gt; <span class="fn">joinWithUnit</span>()</code></pre></div><p><em>Available on <a href="/ribs/api/package-ribs_effect_ribs_effect/IOFiber.html">IOFiber&lt;A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_effect_ribs_effect/JoinWithUnitOps.html">JoinWithUnitOps</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Unit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">joinWithUnit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> joinWith</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.unit);</span></span></code></pre></div></details>', 3))
  ]);
}
const JoinWithUnitOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  JoinWithUnitOps as default
};
