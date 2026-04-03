import { r as resolveComponent, o as openBlock, c as createElementBlock, e as createStaticVNode, a as createBaseVNode, b as createTextVNode, d as createVNode, _ as _export_sfc } from "./app.Cs6a8o_o.js";
const __pageData = JSON.parse('{"title":"KeyValueCodecOps","description":"API documentation for KeyValueCodecOps extension from ribs_json","frontmatter":{"title":"KeyValueCodecOps","description":"API documentation for KeyValueCodecOps extension from ribs_json","category":"Extensions","library":"ribs_json","outline":[2,3],"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_json_ribs_json/KeyValueCodecOps.md","filePath":"api/package-ribs_json_ribs_json/KeyValueCodecOps.md"}');
const _sfc_main = { name: "api/package-ribs_json_ribs_json/KeyValueCodecOps.md" };
const _hoisted_1 = {
  id: "as",
  tabindex: "-1"
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_Badge = resolveComponent("Badge");
  return openBlock(), createElementBlock("div", null, [
    _cache[3] || (_cache[3] = createStaticVNode('<h1 id="keyvaluecodecops" tabindex="-1">KeyValueCodecOps <a class="header-anchor" href="#keyvaluecodecops" aria-label="Permalink to &quot;KeyValueCodecOps&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">extension</span> <span class="fn">KeyValueCodecOps</span> <span class="kw">on</span> <span class="type">String</span></code></pre></div><h2 id="section-methods" tabindex="-1">Methods <a class="header-anchor" href="#section-methods" aria-label="Permalink to &quot;Methods {#section-methods}&quot;">​</a></h2>', 3)),
    createBaseVNode("h3", _hoisted_1, [
      _cache[0] || (_cache[0] = createTextVNode("as() ", -1)),
      createVNode(_component_Badge, {
        type: "info",
        text: "extension"
      }),
      _cache[1] || (_cache[1] = createTextVNode()),
      _cache[2] || (_cache[2] = createBaseVNode("a", {
        class: "header-anchor",
        href: "#as",
        "aria-label": 'Permalink to "as() <Badge type="info" text="extension" /> {#as}"'
      }, "​", -1))
    ]),
    _cache[4] || (_cache[4] = createStaticVNode('<div class="member-signature"><pre><code><a href="./KeyValueCodec" class="type-link">KeyValueCodec</a>&lt;<span class="type">A</span>&gt; <span class="fn">as&lt;A&gt;</span>(<a href="./Codec" class="type-link">Codec</a>&lt;<span class="type">A</span>&gt; <span class="param">codec</span>)</code></pre></div><p><em>Available on String, provided by the <a href="/ribs/api/package-ribs_json_ribs_json/KeyValueCodecOps.html">KeyValueCodecOps</a> extension</em></p><details class="details custom-block"><summary>Implementation</summary><div class="language-dart vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">dart</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">KeyValueCodec</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">as&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Codec</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&lt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">A</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">&gt; codec) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=&gt;</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> KeyValueCodec</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">this</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, codec);</span></span></code></pre></div></details>', 3))
  ]);
}
const KeyValueCodecOps = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  KeyValueCodecOps as default
};
