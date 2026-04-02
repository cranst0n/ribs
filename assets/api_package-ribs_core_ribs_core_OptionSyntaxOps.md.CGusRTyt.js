import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.Dhs2tkP8.js";
const __pageData = JSON.parse('{"title":"OptionSyntaxOps","description":"API documentation for OptionSyntaxOps<A> extension from ribs_core","frontmatter":{"title":"OptionSyntaxOps<A>","description":"API documentation for OptionSyntaxOps<A> extension from ribs_core","category":"Extensions","library":"ribs_core","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_core_ribs_core/OptionSyntaxOps.md","filePath":"api/package-ribs_core_ribs_core/OptionSyntaxOps.md"}');
const _sfc_main = { name: "api/package-ribs_core_ribs_core/OptionSyntaxOps.md" };
const _hoisted_1 = {
  id: "prop-some",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[4] || (_cache[4] = createStaticVNode('<h1 id="optionsyntaxops-a" tabindex="-1">OptionSyntaxOps&lt;A&gt; <a class="header-anchor" href="#optionsyntaxops-a" aria-label="Permalink to &quot;OptionSyntaxOps\\&lt;A\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">OptionSyntaxOps</span>&lt;A&gt; <span class="kw">on</span> <span class="type">A</span></code></pre></div><h2 id="section-properties" tabindex="-1">Properties <a class="header-anchor" href="#section-properties" aria-label="Permalink to &quot;Properties {#section-properties}&quot;">​</a></h2>', 3)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("some ", -1)),
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
        href: "#prop-some",
        "aria-label": 'Permalink to "some <Badge type="info" text="extension" /> <Badge type="tip" text="no setter" /> {#prop-some}"'
      }, "​", -1))
    ]),
    _cache[5] || (_cache[5] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Option" class="type-link">Option</a>&lt;<span class="type">A</span>&gt; <span class="kw">get</span> <span class="fn">some</span></code></pre></div><p>Lifts this value into an <a href="/ribs/api/package-ribs_core_ribs_core/Option.html">Option</a>, specifically a <a href="/ribs/api/package-ribs_core_ribs_core/Some.html">Some</a>.</p><p><em>Available on A, provided by the <a href="/ribs/api/package-ribs_core_ribs_core/OptionSyntaxOps.html">OptionSyntaxOps&lt;A&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> some </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Some</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 4))
  ]);
}
const OptionSyntaxOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  OptionSyntaxOps as default
};
