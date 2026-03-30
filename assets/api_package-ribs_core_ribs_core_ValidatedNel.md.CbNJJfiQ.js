import { o as openBlock, c as createElementBlock, e as createStaticVNode, _ as _export_sfc } from "./app.CeFRElW4.js";
const __pageData = JSON.parse('{"title":"ValidatedNel<E, A> typedef","description":"API documentation for the ValidatedNel<E, A> typedef from ribs_core","frontmatter":{"title":"ValidatedNel<E, A> typedef","description":"API documentation for the ValidatedNel<E, A> typedef from ribs_core","category":"Typedefs","library":"ribs_core","outline":false,"editLink":false,"prev":false,"next":false},"headers":[],"relativePath":"api/package-ribs_core_ribs_core/ValidatedNel.md","filePath":"api/package-ribs_core_ribs_core/ValidatedNel.md"}');
const _sfc_main = { name: "api/package-ribs_core_ribs_core/ValidatedNel.md" };
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return openBlock(), createElementBlock("div", null, [..._cache[0] || (_cache[0] = [
    createStaticVNode('<h1 id="validatednel-e-a" tabindex="-1">ValidatedNel&lt;E, A&gt; <a class="header-anchor" href="#validatednel-e-a" aria-label="Permalink to &quot;ValidatedNel\\&lt;E, A\\&gt;&quot;">​</a></h1><div class="member-signature"><pre><code><span class="kw">typedef</span> <span class="fn">ValidatedNel&lt;E, A&gt;</span> = <a href="./Validated" class="type-link">Validated</a>&lt;<a href="./NonEmptyIList" class="type-link">NonEmptyIList</a>&lt;<span class="type">E</span>&gt;, <span class="type">A</span>&gt;</code></pre></div><p>Type alias for <a href="/api/package-ribs_core_ribs_core/Validated.html">Validated</a> where the error case is fixed to <a href="./NonEmptyIList.html" class="api-link"><code>NonEmptyIList&lt;E&gt;</code></a>.</p>', 3)
  ])]);
}
const ValidatedNel = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render]]);
export {
  __pageData,
  ValidatedNel as default
};
