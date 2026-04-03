import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.CHsuChNA.js";
const __pageData = JSON.parse('{"title":"Function7COps<T0, T1, T2, T3, T4, T5, T6, T7>","description":"API documentation for Function7COps<T0, T1, T2, T3, T4, T5, T6, T7> extension from ribs_core","frontmatter":{"title":"Function7COps<T0, T1, T2, T3, T4, T5, T6, T7>","description":"API documentation for Function7COps<T0, T1, T2, T3, T4, T5, T6, T7> extension from ribs_core","category":"Extensions","library":"ribs_core","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_core_ribs_core/Function7COps.md","filePath":"api/package-ribs_core_ribs_core/Function7COps.md"}');
const _sfc_main = { name: "api/package-ribs_core_ribs_core/Function7COps.md" };
const _hoisted_1 = {
  id: "prop-uncurried",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[4] || (_cache[4] = createStaticVNode('<h1 id="function7cops-t0-t1-t2-t3-t4-t5-t6-t7" tabindex="-1">Function7COps&lt;T0, T1, T2, T3, T4, T5, T6, T7&gt; <a class="header-anchor" href="#function7cops-t0-t1-t2-t3-t4-t5-t6-t7" aria-label="Permalink to &quot;Function7COps\\&lt;T0, T1, T2, T3, T4, T5, T6, T7\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">Function7COps</span>&lt;T0, T1, T2, T3, T4, T5, T6, T7&gt; <span class="kw">on</span> <span class="type">T7</span> <span class="type">Function</span>(<span class="type">T6</span>) <span class="type">Function</span>(<span class="type">T5</span>) <span class="type">Function</span>(<span class="type">T4</span>) <span class="type">Function</span>(<span class="type">T3</span>) <span class="type">Function</span>(<span class="type">T2</span>) <span class="type">Function</span>(<span class="type">T1</span>) <span class="type">Function</span>(<span class="type">T0</span>)</code></pre></div><p>Provides additional functions on curried functions with 7 parameters.</p><h2 id="section-properties" tabindex="-1">Properties <a class="header-anchor" href="#section-properties" aria-label="Permalink to &quot;Properties {#section-properties}&quot;">​</a></h2>', 4)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("uncurried ", -1)),
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
        href: "#prop-uncurried",
        "aria-label": 'Permalink to "uncurried <Badge type="info" text="extension" /> <Badge type="tip" text="no setter" /> {#prop-uncurried}"'
      }, "​", -1))
    ]),
    _cache[5] || (_cache[5] = createStaticVNode('<div class="member-signature"><pre><code><span class="type">T7</span> <span class="type">Function</span>(<span class="type">T0</span>, <span class="type">T1</span>, <span class="type">T2</span>, <span class="type">T3</span>, <span class="type">T4</span>, <span class="type">T5</span>, <span class="type">T6</span>) <span class="kw">get</span> <span class="fn">uncurried</span></code></pre></div><p>Return the uncurried form of this function.</p><p><em>Available on Function7C&lt;T0, T1, T2, T3, T4, T5, T6, T7&gt;, provided by the <a href="/ribs/api/package-ribs_core_ribs_core/Function7COps.html">Function7COps&lt;T0, T1, T2, T3, T4, T5, T6, T7&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function7</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T2</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T3</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T4</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T5</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T6</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T7</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> uncurried </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    (t0, t1, t2, t3, t4, t5, t6) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(t0)(t1)(t2)(t3)(t4)(t5)(t6);</span></span></code></pre></div></details>', 4))
  ]);
}
const Function7COps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  Function7COps as default
};
