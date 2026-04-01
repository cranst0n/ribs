import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.72D4emFH.js";
const __pageData = JSON.parse('{"title":"Tuple7OptionOps<T1, T2, T3, T4, T5, T6, T7>","description":"API documentation for Tuple7OptionOps<T1, T2, T3, T4, T5, T6, T7> extension from ribs_core","frontmatter":{"title":"Tuple7OptionOps<T1, T2, T3, T4, T5, T6, T7>","description":"API documentation for Tuple7OptionOps<T1, T2, T3, T4, T5, T6, T7> extension from ribs_core","category":"Extensions","library":"ribs_core","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_core_ribs_core/Tuple7OptionOps.md","filePath":"api/package-ribs_core_ribs_core/Tuple7OptionOps.md"}');
const _sfc_main = { name: "api/package-ribs_core_ribs_core/Tuple7OptionOps.md" };
const _hoisted_1 = {
  id: "prop-tupled",
  tabindex: "-1"
};
const _hoisted_2 = {
  id: "mapn",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[7] || (_cache[7] = createStaticVNode('<h1 id="tuple7optionops-t1-t2-t3-t4-t5-t6-t7" tabindex="-1">Tuple7OptionOps&lt;T1, T2, T3, T4, T5, T6, T7&gt; <a class="header-anchor" href="#tuple7optionops-t1-t2-t3-t4-t5-t6-t7" aria-label="Permalink to &quot;Tuple7OptionOps\\&lt;T1, T2, T3, T4, T5, T6, T7\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">Tuple7OptionOps</span>&lt;T1, T2, T3, T4, T5, T6, T7&gt; <span class="kw">on</span> <span class="type">Record</span></code></pre></div><p>Provides additional functions on a tuple of 7 Options.</p><h2 id="section-properties" tabindex="-1">Properties <a class="header-anchor" href="#section-properties" aria-label="Permalink to &quot;Properties {#section-properties}&quot;">​</a></h2>', 4)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("tupled ", -1)),
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
        href: "#prop-tupled",
        "aria-label": 'Permalink to "tupled <Badge type="info" text="extension" /> <Badge type="tip" text="no setter" /> {#prop-tupled}"'
      }, "​", -1))
    ]),
    _cache[8] || (_cache[8] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Option" class="type-link">Option</a>&lt;<span class="type">Record</span>&gt; <span class="kw">get</span> <span class="fn">tupled</span></code></pre></div><p>If <strong>all</strong> items of this tuple are a <a href="/ribs/api/package-ribs_core_ribs_core/Some.html">Some</a>, the respective items are turned into a tuple and returned as a <a href="/ribs/api/package-ribs_core_ribs_core/Some.html">Some</a>. If <strong>any</strong> item is a</p><p><em>Available on Record, provided by the <a href="/ribs/api/package-ribs_core_ribs_core/Tuple7OptionOps.html">Tuple7OptionOps&lt;T1, T2, T3, T4, T5, T6, T7&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T2</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T3</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T4</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T5</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T6</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T7</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">get</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> tupled </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    init.tupled.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">flatMap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((x) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> last.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">map</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(x.appended));</span></span></code></pre></div></details><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 5)),
    createBaseVNode("h3", _hoisted_2, [
      _cache[4] || (_cache[4] = createTextVNode("mapN() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[5] || (_cache[5] = createTextVNode()),
      _cache[6] || (_cache[6] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#mapn",
        "aria-label": 'Permalink to "mapN() <Badge type="info" text="extension" /> {#mapn}"'
      }, "​", -1))
    ]),
    _cache[9] || (_cache[9] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Option" class="type-link">Option</a>&lt;<span class="type">T8</span>&gt; <span class="fn">mapN&lt;T8&gt;</span>(<span class="type">T8</span> <span class="type">Function</span>(<span class="type">T1</span>, <span class="type">T2</span>, <span class="type">T3</span>, <span class="type">T4</span>, <span class="type">T5</span>, <span class="type">T6</span>, <span class="type">T7</span>) <span class="param">fn</span>)</code></pre></div><p>Applies <code>fn</code> to the values of each respective tuple member if all values are a <a href="/ribs/api/package-ribs_core_ribs_core/Some.html">Some</a>. If <strong>any</strong> item is a <a href="/ribs/api/package-ribs_core_ribs_core/None.html">None</a>, <a href="/ribs/api/package-ribs_core_ribs_core/None.html">None</a> will be returned.</p><p><em>Available on Record, provided by the <a href="/ribs/api/package-ribs_core_ribs_core/Tuple7OptionOps.html">Tuple7OptionOps&lt;T1, T2, T3, T4, T5, T6, T7&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T8</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">mapN</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T8</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function7</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T2</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T3</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T4</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T5</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T6</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T7</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T8</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; fn) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> tupled.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">map</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(fn.tupled);</span></span></code></pre></div></details>', 4))
  ]);
}
const Tuple7OptionOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  Tuple7OptionOps as default
};
