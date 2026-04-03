import { o as openBlock, c as createElementBlock, e as createStaticVNode, _ as _export_sfc } from "./app.C8460Rfc.js";
const __pageData = JSON.parse('{"title":"cast function","description":"API documentation for the cast<A> function from ribs_core","frontmatter":{"title":"cast<A> function","description":"API documentation for the cast<A> function from ribs_core","category":"Functions","library":"ribs_core","outline":false,"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_core_ribs_core/cast.md","filePath":"api/package-ribs_core_ribs_core/cast.md"}');
const _sfc_main = { name: "api/package-ribs_core_ribs_core/cast.md" };
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return openBlock(), createElementBlock("div", null, [..._cache[0] || (_cache[0] = [
    createStaticVNode('<h1 id="cast-a" tabindex="-1">cast&lt;A&gt; <a class="header-anchor" href="#cast-a" aria-label="Permalink to &quot;cast\\&lt;A\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="type">A</span> <span class="fn">cast&lt;A&gt;</span>(<span class="type">dynamic</span> <span class="param">a</span>)</code></pre></div><p>Helper function to cast the given argument to the given type. With the help of type inference, this is usually cleaner to us than: <code>func(value as Type)</code>. You can usually get away with: <code>function(cast(value))</code>.</p>', 3)
  ])]);
}
const cast = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  cast as default
};
