import { r as resolveComponent, o as openBlock, c as createElementBlock, a as createStaticVNode, b as createBaseVNode, d as createTextVNode, e as createVNode, _ as _export_sfc } from "./app.DrJWc9dp.js";
const __pageData = JSON.parse('{"title":"IOTracingOps","description":"API documentation for IOTracingOps<A> extension from ribs_effect","frontmatter":{"title":"IOTracingOps<A>","description":"API documentation for IOTracingOps<A> extension from ribs_effect","category":"Extensions","library":"ribs_effect","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_effect_ribs_effect/IOTracingOps.md","filePath":"api/package-ribs_effect_ribs_effect/IOTracingOps.md"}');
const _sfc_main = { name: "api/package-ribs_effect_ribs_effect/IOTracingOps.md" };
const _hoisted_1 = {
  id: "traced",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[3] || (_cache[3] = createStaticVNode('<h1 id="iotracingops-a" tabindex="-1">IOTracingOps&lt;A&gt; <a class="header-anchor" href="#iotracingops-a" aria-label="Permalink to &quot;IOTracingOps\\&lt;A\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">IOTracingOps</span>&lt;A&gt; <span class="kw">on</span> <a href="./IO" class="type-link">IO</a>&lt;<span class="type">A</span>&gt;</code></pre></div><p>Extension providing the <a href="/ribs/api/package-ribs_effect_ribs_effect/IOTracingOps.html#traced">traced</a> combinator on <a href="/ribs/api/package-ribs_effect_ribs_effect/IO.html">IO</a>.</p><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 4)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("traced() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#traced",
        "aria-label": 'Permalink to "traced() <Badge type="info" text="extension" /> {#traced}"'
      }, "​", -1))
    ]),
    _cache[4] || (_cache[4] = createStaticVNode('<div class="member-signature"><pre><code><a href="./IO" class="type-link">IO</a>&lt;<span class="type">A</span>&gt; <span class="fn">traced</span>(<span class="type">String</span> <span class="param">label</span>, [<span class="type">int</span>? <span class="param">depth</span>])</code></pre></div><p>Annotates this <a href="/ribs/api/package-ribs_effect_ribs_effect/IO.html">IO</a> with a <code>label</code> for tracing purposes.</p><p>When <a href="/ribs/api/package-ribs_effect_ribs_effect/IOTracingConfig.html#prop-tracingenabled">IOTracingConfig.tracingEnabled</a> is <code>true</code>, the label is recorded in the fiber&#39;s trace ring buffer. When tracing is disabled, this is a no-op that returns the original <a href="/ribs/api/package-ribs_effect_ribs_effect/IO.html">IO</a> unchanged.</p><p><code>depth</code> optionally limits how many frames of the captured <a href="https://api.dart.dev/stable/3.11.4/dart-core/StackTrace-class.html" target="_blank" rel="noreferrer">StackTrace</a> are stored.</p><p><em>Available on <a href="/ribs/api/package-ribs_effect_ribs_effect/IO.html">IO&lt;A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_effect_ribs_effect/IOTracingOps.html">IOTracingOps&lt;A&gt;</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">traced</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">String</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> label, [</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">?</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> depth]) {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">  if</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> (</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">!</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IOTracingConfig</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.tracingEnabled) {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">    return</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">;</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  } </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">else</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> {</span></span>\n<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">    return</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> _Traced</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, label, depth);</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">  }</span></span>\n<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div></details>', 6))
  ]);
}
const IOTracingOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  IOTracingOps as default
};
