import { o as openBlock, c as createElementBlock, e as createStaticVNode, _ as _export_sfc } from "./app.CDkjY1e3.js";
const __pageData = JSON.parse('{"title":"DecodeResult typedef","description":"API documentation for the DecodeResult<A> typedef from ribs_json","frontmatter":{"title":"DecodeResult<A> typedef","description":"API documentation for the DecodeResult<A> typedef from ribs_json","category":"Typedefs","library":"ribs_json","outline":false,"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_json_ribs_json/DecodeResult.md","filePath":"api/package-ribs_json_ribs_json/DecodeResult.md"}');
const _sfc_main = { name: "api/package-ribs_json_ribs_json/DecodeResult.md" };
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return openBlock(), createElementBlock("div", null, [..._cache[0] || (_cache[0] = [
    createStaticVNode('<h1 id="decoderesult-a" tabindex="-1">DecodeResult&lt;A&gt; <a class="header-anchor" href="#decoderesult-a" aria-label="Permalink to &quot;DecodeResult\\&lt;A\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">typedef</span> <span class="fn">DecodeResult&lt;A&gt;</span> = <a href="../package-ribs_core_ribs_core/Either" class="type-link">Either</a>&lt;<a href="./DecodingFailure" class="type-link">DecodingFailure</a>, <span class="type">A</span>&gt;</code></pre></div><p>The result of a <a href="/ribs/api/package-ribs_json_ribs_json/Decoder.html">Decoder</a>: either a <a href="/ribs/api/package-ribs_json_ribs_json/DecodingFailure.html">DecodingFailure</a> or a value of <code>A</code>.</p>', 3)
  ])]);
}
const DecodeResult = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  DecodeResult as default
};
