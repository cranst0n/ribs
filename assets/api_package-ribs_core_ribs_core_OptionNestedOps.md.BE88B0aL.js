import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.Bx1PjHTn.js";
const __pageData = JSON.parse('{"title":"OptionNestedOps","description":"API documentation for OptionNestedOps<A> extension from ribs_core","frontmatter":{"title":"OptionNestedOps<A>","description":"API documentation for OptionNestedOps<A> extension from ribs_core","category":"Extensions","library":"ribs_core","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_core_ribs_core/OptionNestedOps.md","filePath":"api/package-ribs_core_ribs_core/OptionNestedOps.md"}');
const _sfc_main = { name: "api/package-ribs_core_ribs_core/OptionNestedOps.md" };
const _hoisted_1 = {
  id: "flatten",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[3] || (_cache[3] = createStaticVNode('<h1 id="optionnestedops-a" tabindex="-1">OptionNestedOps&lt;A&gt; <a class="header-anchor" href="#optionnestedops-a" aria-label="Permalink to &quot;OptionNestedOps\\&lt;A\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">OptionNestedOps</span>&lt;A&gt; <span class="kw">on</span> <a href="./Option" class="type-link">Option</a>&lt;<a href="./Option" class="type-link">Option</a>&lt;<span class="type">A</span>&gt;&gt;</code></pre></div><p>Additional functions that can be called on a nested <a href="/ribs/api/package-ribs_core_ribs_core/Option.html">Option</a>.</p><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 4)),
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
    _cache[4] || (_cache[4] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Option" class="type-link">Option</a>&lt;<span class="type">A</span>&gt; <span class="fn">flatten</span>()</code></pre></div><p>If this is a <a href="/ribs/api/package-ribs_core_ribs_core/Some.html">Some</a>, the value is returned, otherwise <a href="/ribs/api/package-ribs_core_ribs_core/None.html">None</a> is returned.</p><p><em>Available on <a href="/ribs/api/package-ribs_core_ribs_core/Option.html">Option&lt;A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_core_ribs_core/OptionNestedOps.html">OptionNestedOps&lt;A&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">flatten</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> none</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(), identity);</span></span></code></pre></div></details>', 4))
  ]);
}
const OptionNestedOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  OptionNestedOps as default
};
