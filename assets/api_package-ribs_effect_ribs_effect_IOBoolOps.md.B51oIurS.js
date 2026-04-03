import { r as resolveComponent, o as openBlock, c as createElementBlock, a as createStaticVNode, b as createBaseVNode, d as createTextVNode, e as createVNode, _ as _export_sfc } from "./app.CEJqsH3f.js";
const __pageData = JSON.parse('{"title":"IOBoolOps","description":"API documentation for IOBoolOps extension from ribs_effect","frontmatter":{"title":"IOBoolOps","description":"API documentation for IOBoolOps extension from ribs_effect","category":"Extensions","library":"ribs_effect","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_effect_ribs_effect/IOBoolOps.md","filePath":"api/package-ribs_effect_ribs_effect/IOBoolOps.md"}');
const _sfc_main = { name: "api/package-ribs_effect_ribs_effect/IOBoolOps.md" };
const _hoisted_1 = {
  id: "ifm",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[3] || (_cache[3] = createStaticVNode('<h1 id="ioboolops" tabindex="-1">IOBoolOps <a class="header-anchor" href="#ioboolops" aria-label="Permalink to &quot;IOBoolOps&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">IOBoolOps</span> <span class="kw">on</span> <a href="./IO" class="type-link">IO</a>&lt;<span class="type">bool</span>&gt;</code></pre></div><p>Extension providing conditional operators for boolean-yielding <a href="/ribs/api/package-ribs_effect_ribs_effect/IO.html">IO</a>s.</p><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 4)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("ifM() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#ifm",
        "aria-label": 'Permalink to "ifM() <Badge type="info" text="extension" /> {#ifm}"'
      }, "​", -1))
    ]),
    _cache[4] || (_cache[4] = createStaticVNode('<div class="member-signature"><pre><code><a href="./IO" class="type-link">IO</a>&lt;<span class="type">B</span>&gt; <span class="fn">ifM&lt;B&gt;</span>(<a href="./IO" class="type-link">IO</a>&lt;<span class="type">B</span>&gt; <span class="type">Function</span>() <span class="param">ifTrue</span>, <a href="./IO" class="type-link">IO</a>&lt;<span class="type">B</span>&gt; <span class="type">Function</span>() <span class="param">ifFalse</span>)</code></pre></div><p>Evaluates this IO to a boolean. If <code>true</code>, evaluating <code>ifTrue</code>. Otherwise evaluates <code>ifFalse</code>.</p><p><em>Available on <a href="/ribs/api/package-ribs_effect_ribs_effect/IO.html">IO&lt;A&gt;</a>, provided by the <a href="/ribs/api/package-ribs_effect_ribs_effect/IOBoolOps.html">IOBoolOps</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">ifM</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; ifTrue, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Function0</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">IO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">B</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt;&gt; ifFalse) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span></span>\n<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    _ifM</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(ifTrue, ifFalse).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">traced</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&#39;ifM&#39;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span></code></pre></div></details>', 4))
  ]);
}
const IOBoolOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  IOBoolOps as default
};
