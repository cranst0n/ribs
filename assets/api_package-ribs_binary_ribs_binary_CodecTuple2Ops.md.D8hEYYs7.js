import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.Bdj1ay2a.js";
const __pageData = JSON.parse('{"title":"CodecTuple2Ops<T0, T1>","description":"API documentation for CodecTuple2Ops<T0, T1> extension from ribs_binary","frontmatter":{"title":"CodecTuple2Ops<T0, T1>","description":"API documentation for CodecTuple2Ops<T0, T1> extension from ribs_binary","category":"Extensions","library":"ribs_binary","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_binary_ribs_binary/CodecTuple2Ops.md","filePath":"api/package-ribs_binary_ribs_binary/CodecTuple2Ops.md"}');
const _sfc_main = { name: "api/package-ribs_binary_ribs_binary/CodecTuple2Ops.md" };
const _hoisted_1 = {
  id: "product",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[3] || (_cache[3] = createStaticVNode('<h1 id="codectuple2ops-t0-t1" tabindex="-1">CodecTuple2Ops&lt;T0, T1&gt; <a class="header-anchor" href="#codectuple2ops-t0-t1" aria-label="Permalink to &quot;CodecTuple2Ops\\&lt;T0, T1\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">CodecTuple2Ops</span>&lt;T0, T1&gt; <span class="kw">on</span> <span class="type">Record</span></code></pre></div><p>Provides a product operation on a 2-tuple of <a href="/ribs/api/package-ribs_binary_ribs_binary/Codec.html">Codec</a>s.</p><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 4)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("product() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#product",
        "aria-label": 'Permalink to "product() <Badge type="info" text="extension" /> {#product}"'
      }, "​", -1))
    ]),
    _cache[4] || (_cache[4] = createStaticVNode('<div class="member-signature"><pre><code><a href="./Codec" class="type-link">Codec</a>&lt;<span class="type">T2</span>&gt; <span class="fn">product&lt;T2&gt;</span>(<span class="type">T2</span> <span class="type">Function</span>(<span class="type">T0</span>, <span class="type">T1</span>) <span class="param">apply</span>, <span class="type">Record</span> <span class="type">Function</span>(<span class="type">T2</span>) <span class="param">tupled</span>)</code></pre></div><p><em>Available on Record, provided by the <a href="/ribs/api/package-ribs_binary_ribs_binary/CodecTuple2Ops.html">CodecTuple2Ops&lt;T0, T1&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Codec</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T2</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">product</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T2</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  Function2</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T2</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; apply,</span></span>\n<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">  Function1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T2</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, (</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">T1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)&gt; tupled,</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> Codec</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">product2</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.$1, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.$2, apply, tupled);</span></span></code></pre></div></details>', 3))
  ]);
}
const CodecTuple2Ops = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  CodecTuple2Ops as default
};
