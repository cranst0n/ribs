import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.DXd3mBB6.js";
const __pageData = JSON.parse('{"title":"NonEmptyIListOptionOps","description":"API documentation for NonEmptyIListOptionOps<A> extension from ribs_core","frontmatter":{"title":"NonEmptyIListOptionOps<A>","description":"API documentation for NonEmptyIListOptionOps<A> extension from ribs_core","category":"Extensions","library":"ribs_core","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_core_ribs_core/NonEmptyIListOptionOps.md","filePath":"api/package-ribs_core_ribs_core/NonEmptyIListOptionOps.md"}');
const _sfc_main = { name: "api/package-ribs_core_ribs_core/NonEmptyIListOptionOps.md" };
const _hoisted_1 = {
  id: "sequence",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[3] || (_cache[3] = createStaticVNode('<h1 id="nonemptyilistoptionops-a" tabindex="-1">NonEmptyIListOptionOps&lt;A&gt; <a class="header-anchor" href="#nonemptyilistoptionops-a" aria-label="Permalink to &quot;NonEmptyIListOptionOps\\&lt;A\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">NonEmptyIListOptionOps</span>&lt;A&gt; <span class="kw">on</span> <a href="./NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<a href="./Option" class="type-link">Option</a>&lt;<span class="type">A</span>&gt;&gt;</code></pre></div><p>Operations avaiable when <a href="/ribs/api/package-ribs_core_ribs_core/IList.html">IList</a> elemention are of type <a href="/ribs/api/package-ribs_core_ribs_core/Option.html">Option</a>.</p><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 4)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("sequence() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#sequence",
        "aria-label": 'Permalink to "sequence() <Badge type="info" text="extension" /> {#sequence}"'
      }, "​", -1))
    ]),
    _cache[4] || (_cache[4] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Option" class="type-link">Option</a>&lt;<a href="./NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">A</span>&gt;&gt; <span class="fn">sequence</span>()</code></pre></div><p>Accumulates all elements in this list as one <a href="/ribs/api/package-ribs_core_ribs_core/Option.html">Option</a>. If any element is a <a href="/ribs/api/package-ribs_core_ribs_core/None.html">None</a>, <a href="/ribs/api/package-ribs_core_ribs_core/None.html">None</a> will be returned. If all elements are <a href="/ribs/api/package-ribs_core_ribs_core/Some.html">Some</a>, then the entire list is returned, wrapped in a <a href="/ribs/api/package-ribs_core_ribs_core/Some.html">Some</a>.</p><p><em>Available on <a href="/ribs/api/package-ribs_core_ribs_core/NonEmptyIList.html">NonEmptyIList&lt;A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_core_ribs_core/NonEmptyIListOptionOps.html">NonEmptyIListOptionOps&lt;A&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">NonEmptyIList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">sequence</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> traverseOption</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(identity);</span></span></code></pre></div></details>', 4))
  ]);
}
const NonEmptyIListOptionOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  NonEmptyIListOptionOps as default
};
