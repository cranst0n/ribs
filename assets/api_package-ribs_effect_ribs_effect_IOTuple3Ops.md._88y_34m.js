import { r as resolveComponent, o as openBlock, c as createElementBlock, a as createStaticVNode, b as createBaseVNode, d as createTextVNode, e as createVNode, _ as _export_sfc } from "./app.3nghxYYN.js";
const __pageData = JSON.parse('{"title":"IOTuple3Ops<T1, T2, T3>","description":"API documentation for IOTuple3Ops<T1, T2, T3> extension from ribs_effect","frontmatter":{"title":"IOTuple3Ops<T1, T2, T3>","description":"API documentation for IOTuple3Ops<T1, T2, T3> extension from ribs_effect","category":"Extensions","library":"ribs_effect","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_effect_ribs_effect/IOTuple3Ops.md","filePath":"api/package-ribs_effect_ribs_effect/IOTuple3Ops.md"}');
const _sfc_main = { name: "api/package-ribs_effect_ribs_effect/IOTuple3Ops.md" };
const _hoisted_1 = {
  id: "flatmapn",
  tabindex: "-1"
};
const _hoisted_2 = {
  id: "flattapn",
  tabindex: "-1"
};
const _hoisted_3 = {
  id: "mapn",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[9] || (_cache[9] = createStaticVNode('<h1 id="iotuple3ops-t1-t2-t3" tabindex="-1">IOTuple3Ops&lt;T1, T2, T3&gt; <a class="header-anchor" href="#iotuple3ops-t1-t2-t3" aria-label="Permalink to &quot;IOTuple3Ops\\&lt;T1, T2, T3\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">IOTuple3Ops</span>&lt;T1, T2, T3&gt; <span class="kw">on</span> <a href="./IO" class="type-link">IO</a>&lt;<span class="type">Record</span>&gt;</code></pre></div><p>Provides additional functions on an IO of a 3 element tuple.</p><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 4)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("flatMapN() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#flatmapn",
        "aria-label": 'Permalink to "flatMapN() <Badge type="info" text="extension" /> {#flatmapn}"'
      }, "​", -1))
    ]),
    _cache[10] || (_cache[10] = createStaticVNode('<div class="member-signature"><pre><code><a href="./IO" class="type-link">IO</a>&lt;<span class="type">T4</span>&gt; <span class="fn">flatMapN&lt;T4&gt;</span>(<a href="./IO" class="type-link">IO</a>&lt;<span class="type">T4</span>&gt; <span class="type">Function</span>(<span class="type">T1</span>, <span class="type">T2</span>, <span class="type">T3</span>) <span class="param">f</span>)</code></pre></div><p><em>Available on <a href="/ribs/api/package-ribs_effect_ribs_effect/IO.html">IO&lt;A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_effect_ribs_effect/IOTuple3Ops.html">IOTuple3Ops&lt;T1, T2, T3&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T4</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">flatMapN</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T4</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function3</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T2</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T3</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T4</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; f) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> flatMap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(f.tupled);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_2, [
      _cache[3] || (_cache[3] = createTextVNode("flatTapN() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[4] || (_cache[4] = createTextVNode()),
      _cache[5] || (_cache[5] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#flattapn",
        "aria-label": 'Permalink to "flatTapN() <Badge type="info" text="extension" /> {#flattapn}"'
      }, "​", -1))
    ]),
    _cache[11] || (_cache[11] = createStaticVNode('<div class="member-signature"><pre><code><a href="./IO" class="type-link">IO</a>&lt;<span class="type">Record</span>&gt; <span class="fn">flatTapN&lt;T4&gt;</span>(<a href="./IO" class="type-link">IO</a>&lt;<span class="type">T4</span>&gt; <span class="type">Function</span>(<span class="type">T1</span>, <span class="type">T2</span>, <span class="type">T3</span>) <span class="param">f</span>)</code></pre></div><p><em>Available on <a href="/ribs/api/package-ribs_effect_ribs_effect/IO.html">IO&lt;A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_effect_ribs_effect/IOTuple3Ops.html">IOTuple3Ops&lt;T1, T2, T3&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T2</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T3</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">flatTapN</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T4</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function3</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T2</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T3</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T4</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; f) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> flatTap</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(f.tupled);</span></span></code></pre></div></details>', 3)),
    createBaseVNode("h3", _hoisted_3, [
      _cache[6] || (_cache[6] = createTextVNode("mapN() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[7] || (_cache[7] = createTextVNode()),
      _cache[8] || (_cache[8] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#mapn",
        "aria-label": 'Permalink to "mapN() <Badge type="info" text="extension" /> {#mapn}"'
      }, "​", -1))
    ]),
    _cache[12] || (_cache[12] = createStaticVNode('<div class="member-signature"><pre><code><a href="./IO" class="type-link">IO</a>&lt;<span class="type">T4</span>&gt; <span class="fn">mapN&lt;T4&gt;</span>(<span class="type">T4</span> <span class="type">Function</span>(<span class="type">T1</span>, <span class="type">T2</span>, <span class="type">T3</span>) <span class="param">f</span>)</code></pre></div><p><em>Available on <a href="/ribs/api/package-ribs_effect_ribs_effect/IO.html">IO&lt;A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_effect_ribs_effect/IOTuple3Ops.html">IOTuple3Ops&lt;T1, T2, T3&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T4</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">mapN</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T4</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function3</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T2</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T3</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T4</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; f) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;"> map</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(f.tupled);</span></span></code></pre></div></details>', 3))
  ]);
}
const IOTuple3Ops = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  IOTuple3Ops as default
};
