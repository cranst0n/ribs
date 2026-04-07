import { o as openBlock, c as createElementBlock, a as createStaticVNode, _ as _export_sfc } from "./app.CF4CL23f.js";
const __pageData = JSON.parse('{"title":"isSome function","description":"API documentation for the isSome function from ribs_core_test","frontmatter":{"title":"isSome function","description":"API documentation for the isSome function from ribs_core_test","category":"Functions","library":"ribs_core_test","outline":false,"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_core_ribs_core_test/isSome.md","filePath":"api/package-ribs_core_ribs_core_test/isSome.md"}');
const _sfc_main = { name: "api/package-ribs_core_ribs_core_test/isSome.md" };
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return openBlock(), createElementBlock("div", null, [..._cache[0] || (_cache[0] = [
    createStaticVNode('<h1 id="issome" tabindex="-1">isSome <a class="header-anchor" href="#issome" aria-label="Permalink to &quot;isSome&quot;">​</a></h1><div class="member-signature"><pre><code><span class="type">Matcher</span> <span class="fn">isSome</span>([<span class="type">Object</span>? <span class="param">matcher</span>])</code></pre></div><p>Returns a <a href="https://pub.dev/documentation/matcher/0.12.19/matcher/Matcher-class.html" target="_blank" rel="noreferrer">Matcher</a> that matches a <a href="/ribs/api/package-ribs_core_ribs_core/Some.html">Some</a> value.</p><p>If <code>matcher</code> is provided, the matched value inside <a href="/ribs/api/package-ribs_core_ribs_core/Some.html">Some</a> must also satisfy it. If omitted, any <a href="/ribs/api/package-ribs_core_ribs_core/Some.html">Some</a> value matches.</p>', 4)
  ])]);
}
const isSome = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  isSome as default
};
