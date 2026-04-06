import { r as resolveComponent, o as openBlock, c as createElementBlock, a as createStaticVNode, b as createBaseVNode, d as createTextVNode, e as createVNode, _ as _export_sfc } from "./app.DrJWc9dp.js";
const __pageData = JSON.parse('{"title":"OptionIOOps","description":"API documentation for OptionIOOps<A> extension from ribs_effect","frontmatter":{"title":"OptionIOOps<A>","description":"API documentation for OptionIOOps<A> extension from ribs_effect","category":"Extensions","library":"ribs_effect","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_effect_ribs_effect/OptionIOOps.md","filePath":"api/package-ribs_effect_ribs_effect/OptionIOOps.md"}');
const _sfc_main = { name: "api/package-ribs_effect_ribs_effect/OptionIOOps.md" };
const _hoisted_1 = {
  id: "sequence",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[3] || (_cache[3] = createStaticVNode('<h1 id="optionioops-a" tabindex="-1">OptionIOOps&lt;A&gt; <a class="header-anchor" href="#optionioops-a" aria-label="Permalink to &quot;OptionIOOps\\&lt;A\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">OptionIOOps</span>&lt;A&gt; <span class="kw">on</span> <a href="../package-ribs_core_ribs_core/Option" class="type-link">Option</a>&lt;<a href="./IO" class="type-link">IO</a>&lt;<span class="type">A</span>&gt;&gt;</code></pre></div><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 3)),
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
    _cache[4] || (_cache[4] = createStaticVNode('<div class="member-signature"><pre><code><a href="./IO" class="type-link">IO</a>&lt;<a href="../package-ribs_core_ribs_core/Option" class="type-link">Option</a>&lt;<span class="type">A</span>&gt;&gt; <span class="fn">sequence</span>()</code></pre></div><p>Returns an <a href="/ribs/api/package-ribs_effect_ribs_effect/IO.html">IO</a> that will return <a href="/ribs/api/package-ribs_core_ribs_core/None.html">None</a> if this is a <a href="/ribs/api/package-ribs_core_ribs_core/None.html">None</a>, or the evaluation of the <a href="/ribs/api/package-ribs_effect_ribs_effect/IO.html">IO</a> lifted into an <a href="/ribs/api/package-ribs_core_ribs_core/Option.html">Option</a>, specifically a <a href="/ribs/api/package-ribs_core_ribs_core/Some.html">Some</a>.</p><p><em>Available on <a href="/ribs/api/package-ribs_core_ribs_core/Option.html">Option&lt;A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_effect_ribs_effect/OptionIOOps.html">OptionIOOps&lt;A&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">sequence</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> fold</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(() </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">pure</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">none</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">()), (io) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> io.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">map</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((a) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Some</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(a)));</span></span></code></pre></div></details>', 4))
  ]);
}
const OptionIOOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  OptionIOOps as default
};
