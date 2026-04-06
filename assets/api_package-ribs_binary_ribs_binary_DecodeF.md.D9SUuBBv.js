import { o as openBlock, c as createElementBlock, e as createStaticVNode, _ as _export_sfc } from "./app.CTfzATVn.js";
const __pageData = JSON.parse('{"title":"DecodeF typedef","description":"API documentation for the DecodeF<A> typedef from ribs_binary","frontmatter":{"title":"DecodeF<A> typedef","description":"API documentation for the DecodeF<A> typedef from ribs_binary","category":"Typedefs","library":"ribs_binary","outline":false,"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_binary_ribs_binary/DecodeF.md","filePath":"api/package-ribs_binary_ribs_binary/DecodeF.md"}');
const _sfc_main = { name: "api/package-ribs_binary_ribs_binary/DecodeF.md" };
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return openBlock(), createElementBlock("div", null, [..._cache[0] || (_cache[0] = [
    createStaticVNode('<h1 id="decodef-a" tabindex="-1">DecodeF&lt;A&gt; <a class="header-anchor" href="#decodef-a" aria-label="Permalink to &quot;DecodeF\\&lt;A\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">typedef</span> <span class="fn">DecodeF&lt;A&gt;</span> = <a href="../package-ribs_core_ribs_core/Either" class="type-link">Either</a>&lt;<a href="./Err" class="type-link">Err</a>, <a href="./DecodeResult" class="type-link">DecodeResult</a>&lt;<span class="type">A</span>&gt;&gt; <span class="type">Function</span>(<a href="./BitVector" class="type-link">BitVector</a>)</code></pre></div><p>Function type alias that a <a href="/ribs/api/package-ribs_binary_ribs_binary/Decoder.html">Decoder</a> must fulfill.</p>', 3)
  ])]);
}
const DecodeF = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  DecodeF as default
};
