import { o as openBlock, c as createElementBlock, a as createStaticVNode, _ as _export_sfc } from "./app.CF4CL23f.js";
const __pageData = JSON.parse('{"title":"isValid function","description":"API documentation for the isValid function from ribs_core_test","frontmatter":{"title":"isValid function","description":"API documentation for the isValid function from ribs_core_test","category":"Functions","library":"ribs_core_test","outline":false,"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_core_ribs_core_test/isValid.md","filePath":"api/package-ribs_core_ribs_core_test/isValid.md"}');
const _sfc_main = { name: "api/package-ribs_core_ribs_core_test/isValid.md" };
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return openBlock(), createElementBlock("div", null, [..._cache[0] || (_cache[0] = [
    createStaticVNode('<h1 id="isvalid" tabindex="-1">isValid <a class="header-anchor" href="#isvalid" aria-label="Permalink to &quot;isValid&quot;">​</a></h1><div class="member-signature"><pre><code><span class="type">Matcher</span> <span class="fn">isValid</span>([<span class="type">Object</span>? <span class="param">matcher</span>])</code></pre></div><p>Returns a <a href="https://pub.dev/documentation/matcher/0.12.19/matcher/Matcher-class.html" target="_blank" rel="noreferrer">Matcher</a> that matches a <a href="/ribs/api/package-ribs_core_ribs_core/Valid.html">Valid</a> value.</p><p>If <code>matcher</code> is provided, the matched value inside <a href="/ribs/api/package-ribs_core_ribs_core/Valid.html">Valid</a> must also satisfy it. If omitted, any <a href="/ribs/api/package-ribs_core_ribs_core/Valid.html">Valid</a> value matches.</p>', 4)
  ])]);
}
const isValid = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  isValid as default
};
